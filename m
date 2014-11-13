Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934796AbaKMVd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:33:57 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45511 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934393AbaKMVbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:31:40 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 51/56] drivers/char/mem: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:28 +0100
Message-Id: <1415913813-362-52-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from mem character driver when the splice-family of
syscalls is not supported by the system (i.e. CONFIG_SYSCALL_SPLICE is
undefined).

add/remove: 0/2 grow/shrink: 0/0 up/down: 0/-28 (-28)
function                                     old     new   delta
pipe_to_null                                   4       -      -4
splice_write_null                             24       -     -24

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 drivers/char/mem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 917403f..420d651 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -610,6 +610,7 @@ static ssize_t aio_write_null(struct kiocb *iocb, const struct iovec *iov,
 	return iov_length(iov, nr_segs);
 }
 
+#ifdef CONFIG_SYSCALL_SPLICE
 static int pipe_to_null(struct pipe_inode_info *info, struct pipe_buffer *buf,
 			struct splice_desc *sd)
 {
@@ -621,6 +622,7 @@ static ssize_t splice_write_null(struct pipe_inode_info *pipe, struct file *out,
 {
 	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
 }
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 static ssize_t read_zero(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
@@ -769,7 +771,7 @@ static const struct file_operations null_fops = {
 	.write		= write_null,
 	.aio_read	= aio_read_null,
 	.aio_write	= aio_write_null,
-	.splice_write	= splice_write_null,
+	SPLICE_WRITE_INIT(splice_write_null)
 };
 
 #ifdef CONFIG_DEVPORT
-- 
1.9.1

