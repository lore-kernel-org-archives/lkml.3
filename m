Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263Ab3CUQgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:36:21 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:51380 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934209Ab3CUQgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:11 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org
Cc: Zach Brown <zab@redhat.com>, Kent Overstreet <koverstreet@google.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 05/33] char: add aio_{read,write} to /dev/{null,zero}
Date: Thu, 21 Mar 2013 09:35:26 -0700
Message-Id: <1363883754-27966-6-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363883754-27966-1-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@redhat.com>

These are handy for measuring the cost of the aio infrastructure with
operations that do very little and complete immediately.

Signed-off-by: Zach Brown <zab@redhat.com>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/char/mem.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 2c644af..e49265f 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -627,6 +627,18 @@ static ssize_t write_null(struct file *file, const char __user *buf,
 	return count;
 }
 
+static ssize_t aio_read_null(struct kiocb *iocb, const struct iovec *iov,
+			     unsigned long nr_segs, loff_t pos)
+{
+	return 0;
+}
+
+static ssize_t aio_write_null(struct kiocb *iocb, const struct iovec *iov,
+			      unsigned long nr_segs, loff_t pos)
+{
+	return iov_length(iov, nr_segs);
+}
+
 static int pipe_to_null(struct pipe_inode_info *info, struct pipe_buffer *buf,
 			struct splice_desc *sd)
 {
@@ -670,6 +682,24 @@ static ssize_t read_zero(struct file *file, char __user *buf,
 	return written ? written : -EFAULT;
 }
 
+static ssize_t aio_read_zero(struct kiocb *iocb, const struct iovec *iov,
+			     unsigned long nr_segs, loff_t pos)
+{
+	size_t written = 0;
+	unsigned long i;
+	ssize_t ret;
+
+	for (i = 0; i < nr_segs; i++) {
+		ret = read_zero(iocb->ki_filp, iov[i].iov_base, iov[i].iov_len,
+				&pos);
+		if (ret < 0)
+			break;
+		written += ret;
+	}
+
+	return written ? written : -EFAULT;
+}
+
 static int mmap_zero(struct file *file, struct vm_area_struct *vma)
 {
 #ifndef CONFIG_MMU
@@ -738,6 +768,7 @@ static int open_port(struct inode *inode, struct file *filp)
 #define full_lseek      null_lseek
 #define write_zero	write_null
 #define read_full       read_zero
+#define aio_write_zero	aio_write_null
 #define open_mem	open_port
 #define open_kmem	open_mem
 #define open_oldmem	open_mem
@@ -766,6 +797,8 @@ static const struct file_operations null_fops = {
 	.llseek		= null_lseek,
 	.read		= read_null,
 	.write		= write_null,
+	.aio_read	= aio_read_null,
+	.aio_write	= aio_write_null,
 	.splice_write	= splice_write_null,
 };
 
@@ -782,6 +815,8 @@ static const struct file_operations zero_fops = {
 	.llseek		= zero_lseek,
 	.read		= read_zero,
 	.write		= write_zero,
+	.aio_read	= aio_read_zero,
+	.aio_write	= aio_write_zero,
 	.mmap		= mmap_zero,
 };
 
-- 
1.8.1.3

