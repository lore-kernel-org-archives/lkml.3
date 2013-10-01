Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3JAVmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:42:33 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:33272 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab3JAVm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:42:29 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/15] sysfs: skip bin_buffer->buffer while reading
Date: Tue,  1 Oct 2013 17:42:03 -0400
Message-Id: <1380663729-18243-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380663729-18243-1-git-send-email-tj@kernel.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After b31ca3f5dfc ("sysfs: fix deadlock"), bin read() first writes
data to bb->buffer and bounces it to a transient kernel buffer which
is then copied out to userland.  The double bouncing doesn't add
anything.  Let's just use the transient buffer directly.

While at it, rename @temp to @buf for clarity.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/bin.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index d49e6ca..d2142c0 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -72,7 +72,7 @@ read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 	int size = file_inode(file)->i_size;
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
-	char *temp;
+	char *buf;
 
 	if (!bytes)
 		return 0;
@@ -84,23 +84,18 @@ read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 			count = size - offs;
 	}
 
-	temp = kmalloc(count, GFP_KERNEL);
-	if (!temp)
+	buf = kmalloc(count, GFP_KERNEL);
+	if (!buf)
 		return -ENOMEM;
 
 	mutex_lock(&bb->mutex);
+	count = fill_read(file, buf, offs, count);
+	mutex_unlock(&bb->mutex);
 
-	count = fill_read(file, bb->buffer, offs, count);
-	if (count < 0) {
-		mutex_unlock(&bb->mutex);
+	if (count < 0)
 		goto out_free;
-	}
-
-	memcpy(temp, bb->buffer, count);
 
-	mutex_unlock(&bb->mutex);
-
-	if (copy_to_user(userbuf, temp, count)) {
+	if (copy_to_user(userbuf, buf, count)) {
 		count = -EFAULT;
 		goto out_free;
 	}
@@ -110,7 +105,7 @@ read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 	*off = offs + count;
 
  out_free:
-	kfree(temp);
+	kfree(buf);
 	return count;
 }
 
-- 
1.8.3.1

