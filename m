Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbaA1Xe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:34:29 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:57758 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbaA1XdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:33:06 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/9] kernfs: implement kernfs_ops->atomic_write_len
Date: Tue, 28 Jan 2014 18:32:48 -0500
Message-Id: <1390951971-15671-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951971-15671-1-git-send-email-tj@kernel.org>
References: <1390951971-15671-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A write to a kernfs_node is buffered through a kernel buffer.  Writes
<= PAGE_SIZE are performed atomically, while larger ones are executed
in PAGE_SIZE chunks.  While this is enough for sysfs, cgroup which is
scheduled to be converted to use kernfs needs a bit more control over
it.

This patch adds kernfs_ops->atomic_write_len.  If not set (zero), the
behavior stays the same.  If set, writes upto the size are executed
atomically and larger writes are rejected with -E2BIG.

A different implementation strategy would be allowing configuring
chunking size while making the original write size available to the
write method; however, such strategy, while being more complicated,
doesn't really buy anything.  If the write implementation has to
handle chunking, the specific chunk size shouldn't matter all that
much.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/file.c       | 49 +++++++++++++++++++++++++++++++------------------
 include/linux/kernfs.h |  8 ++++++--
 2 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 10a8c91..ddcb471 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -252,19 +252,9 @@ static ssize_t kernfs_fop_write(struct file *file, const char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
 	struct kernfs_open_file *of = kernfs_of(file);
-	ssize_t len = min_t(size_t, count, PAGE_SIZE);
 	const struct kernfs_ops *ops;
-	char *buf;
-
-	buf = kmalloc(len + 1, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	if (copy_from_user(buf, user_buf, len)) {
-		len = -EFAULT;
-		goto out_free;
-	}
-	buf[len] = '\0';	/* guarantee string termination */
+	char *buf = NULL;
+	ssize_t len;
 
 	/*
 	 * @of->mutex nests outside active ref and is just to ensure that
@@ -273,22 +263,45 @@ static ssize_t kernfs_fop_write(struct file *file, const char __user *user_buf,
 	mutex_lock(&of->mutex);
 	if (!kernfs_get_active(of->kn)) {
 		mutex_unlock(&of->mutex);
-		len = -ENODEV;
-		goto out_free;
+		return -ENODEV;
 	}
 
 	ops = kernfs_ops(of->kn);
-	if (ops->write)
-		len = ops->write(of, buf, len, *ppos);
-	else
+	if (!ops->write) {
 		len = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (ops->atomic_write_len) {
+		len = count;
+		if (len > ops->atomic_write_len) {
+			len = -E2BIG;
+			goto out_unlock;
+		}
+	} else {
+		len = min_t(size_t, count, PAGE_SIZE);
+	}
+
+	buf = kmalloc(len + 1, GFP_KERNEL);
+	if (!buf) {
+		len = -ENOMEM;
+		goto out_unlock;
+	}
 
+	if (copy_from_user(buf, user_buf, len)) {
+		len = -EFAULT;
+		goto out_unlock;
+	}
+	buf[len] = '\0';	/* guarantee string termination */
+
+	len = ops->write(of, buf, len, *ppos);
+out_unlock:
 	kernfs_put_active(of->kn);
 	mutex_unlock(&of->mutex);
 
 	if (len > 0)
 		*ppos += len;
-out_free:
+
 	kfree(buf);
 	return len;
 }
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 4520c86..47f5235 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -178,9 +178,13 @@ struct kernfs_ops {
 			loff_t off);
 
 	/*
-	 * write() is bounced through kernel buffer and a write larger than
-	 * PAGE_SIZE results in partial operation of PAGE_SIZE.
+	 * write() is bounced through kernel buffer.  If atomic_write_len
+	 * is not set, a write larger than PAGE_SIZE results in partial
+	 * operations of PAGE_SIZE chunks.  If atomic_write_len is set,
+	 * writes upto the specified size are executed atomically but
+	 * larger ones are rejected with -E2BIG.
 	 */
+	size_t atomic_write_len;
 	ssize_t (*write)(struct kernfs_open_file *of, char *buf, size_t bytes,
 			 loff_t off);
 
-- 
1.8.5.3

