Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3JXPuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:50:18 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:50570 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab3JXPuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:50:16 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 25/34] sysfs, kernfs: add kernfs_ops->seq_{start|next|stop}()
Date: Thu, 24 Oct 2013 11:49:31 -0400
Message-Id: <1382629780-10006-26-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382629780-10006-1-git-send-email-tj@kernel.org>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs_ops currently only supports single_open() behavior which is
pretty restrictive.  Add optional callbacks ->seq_{start|next|stop}()
which, when implemented, are invoked for seq_file traversal.  This
allows full seq_file functionality for kernfs users.  This currently
doesn't have any user and doesn't change any behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c        | 23 +++++++++++++++++++----
 include/linux/kernfs.h |  9 +++++++--
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index fa4d63d..89134fc 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -146,6 +146,7 @@ static ssize_t sysfs_kf_bin_read(struct sysfs_open_file *of, char *buf,
 static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
 {
 	struct sysfs_open_file *of = sf->private;
+	const struct kernfs_ops *ops;
 
 	/*
 	 * @of->mutex nests outside active ref and is just to ensure that
@@ -157,19 +158,33 @@ static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
 		return ERR_PTR(-ENODEV);
 	}
 
-	/* the same behavior as single_open() */
-	return NULL + !*ppos;
+	ops = kernfs_ops(of->sd);
+	if (ops->seq_start)
+		return ops->seq_start(sf, ppos);
+	else
+		return NULL + !*ppos;	/* the same behavior as single_open() */
 }
 
 static void *kernfs_seq_next(struct seq_file *sf, void *v, loff_t *ppos)
 {
-	++*ppos;
-	return NULL;
+	struct sysfs_open_file *of = sf->private;
+	const struct kernfs_ops *ops = kernfs_ops(of->sd);
+
+	if (ops->seq_next) {
+		return ops->seq_next(sf, v, ppos);
+	} else {
+		++*ppos;
+		return NULL;
+	}
 }
 
 static void kernfs_seq_stop(struct seq_file *sf, void *v)
 {
 	struct sysfs_open_file *of = sf->private;
+	const struct kernfs_ops *ops = kernfs_ops(of->sd);
+
+	if (ops->seq_stop)
+		ops->seq_stop(sf, v);
 
 	sysfs_put_active(of->sd);
 	mutex_unlock(&of->mutex);
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index a1b94b7..222040c 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -36,8 +36,9 @@ struct kernfs_ops {
 	/*
 	 * Read is handled by either seq_file or raw_read().
 	 *
-	 * If seq_show() is present, seq_file path is active.  The behavior
-	 * is equivalent to single_open().  @sf->private points to the
+	 * If seq_show() is present, seq_file path is active.  Other seq
+	 * operations are optional and if not implemented, the behavior is
+	 * equivalent to single_open().  @sf->private points to the
 	 * associated sysfs_open_file.
 	 *
 	 * read() is bounced through kernel buffer and a read larger than
@@ -45,6 +46,10 @@ struct kernfs_ops {
 	 */
 	int (*seq_show)(struct seq_file *sf, void *v);
 
+	void *(*seq_start)(struct seq_file *sf, loff_t *ppos);
+	void *(*seq_next)(struct seq_file *sf, void *v, loff_t *ppos);
+	void (*seq_stop)(struct seq_file *sf, void *v);
+
 	ssize_t (*read)(struct sysfs_open_file *of, char *buf, size_t bytes,
 			loff_t off);
 
-- 
1.8.3.1

