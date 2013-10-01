Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab3JAVqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:46:32 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:45499 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3JAVmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:42:19 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/15] sysfs: remove sysfs_buffer->needs_read_fill
Date: Tue,  1 Oct 2013 17:41:56 -0400
Message-Id: <1380663729-18243-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380663729-18243-1-git-send-email-tj@kernel.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->needs_read_fill is used to implement the following behaviors.

1. Ensure buffer filling on the first read.
2. Force buffer filling after a write.
3. Force buffer filling after a successful poll.

However, #2 and #3 don't really work as sysfs doesn't reset file
position.  While the read buffer would be refilled, the next read
would continue from the position after the last read or write,
requiring an explicit seek to the start for it to be useful, which
makes ->needs_read_fill superflous as read buffer is always refilled
if f_pos == 0.

Update sysfs_read_file() to test buffer->page for #1 instead and
remove ->needs_read_fill.  While this changes behavior in extreme
corner cases - e.g. re-reading a sysfs file after seeking to non-zero
position after a write or poll, it's highly unlikely to lead to actual
breakage.  This change is to prepare for using seq_file in the read
path.

While at it, reformat a comment in fill_write_buffer().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay@vrfy.org>
---
 fs/sysfs/file.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 81e3f72..e2fafc0 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -47,7 +47,6 @@ struct sysfs_buffer {
 	char			*page;
 	const struct sysfs_ops	*ops;
 	struct mutex		mutex;
-	int			needs_read_fill;
 	int			event;
 	struct list_head	list;
 };
@@ -95,12 +94,10 @@ static int fill_read_buffer(struct dentry *dentry, struct sysfs_buffer *buffer)
 		/* Try to struggle along */
 		count = PAGE_SIZE - 1;
 	}
-	if (count >= 0) {
-		buffer->needs_read_fill = 0;
+	if (count >= 0)
 		buffer->count = count;
-	} else {
+	else
 		ret = count;
-	}
 	return ret;
 }
 
@@ -130,7 +127,11 @@ sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	ssize_t retval = 0;
 
 	mutex_lock(&buffer->mutex);
-	if (buffer->needs_read_fill || *ppos == 0) {
+	/*
+	 * Fill on zero offset and the first read so that silly things like
+	 * "dd bs=1 skip=N" can work on sysfs files.
+	 */
+	if (*ppos == 0 || !buffer->page) {
 		retval = fill_read_buffer(file->f_path.dentry, buffer);
 		if (retval)
 			goto out;
@@ -166,14 +167,15 @@ static int fill_write_buffer(struct sysfs_buffer *buffer,
 	if (count >= PAGE_SIZE)
 		count = PAGE_SIZE - 1;
 	error = copy_from_user(buffer->page, buf, count);
-	buffer->needs_read_fill = 1;
-	/* if buf is assumed to contain a string, terminate it by \0,
-	   so e.g. sscanf() can scan the string easily */
+
+	/*
+	 * If buf is assumed to contain a string, terminate it by \0, so
+	 * e.g. sscanf() can scan the string easily.
+	 */
 	buffer->page[count] = 0;
 	return error ? -EFAULT : count;
 }
 
-
 /**
  *	flush_write_buffer - push buffer to kobject.
  *	@dentry:	dentry to the attribute
@@ -368,7 +370,6 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 		goto err_out;
 
 	mutex_init(&buffer->mutex);
-	buffer->needs_read_fill = 1;
 	buffer->ops = ops;
 	file->private_data = buffer;
 
@@ -435,7 +436,6 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 	return DEFAULT_POLLMASK;
 
  trigger:
-	buffer->needs_read_fill = 1;
 	return DEFAULT_POLLMASK|POLLERR|POLLPRI;
 }
 
-- 
1.8.3.1

