Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934769AbaKMVdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:33:06 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:49745 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934667AbaKMVbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:31:41 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org (open list:VIRTIO CONSOLE
	DR...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 52/56] drivers/char/virtio: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:29 +0100
Message-Id: <1415913813-362-53-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from virtio character driver when the splice-family
of syscalls is not supported by the system (i.e. CONFIG_SYSCALL_SPLICE is
undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 drivers/char/virtio_console.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index b585b47..de5e2cb 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -870,6 +870,7 @@ struct sg_list {
 	struct scatterlist *sg;
 };
 
+#ifdef CONFIG_SYSCALL_SPLICE
 static int pipe_to_sg(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 			struct splice_desc *sd)
 {
@@ -976,6 +977,7 @@ error_out:
 	pipe_unlock(pipe);
 	return ret;
 }
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 static unsigned int port_fops_poll(struct file *filp, poll_table *wait)
 {
@@ -1109,7 +1111,7 @@ static const struct file_operations port_fops = {
 	.open  = port_fops_open,
 	.read  = port_fops_read,
 	.write = port_fops_write,
-	.splice_write = port_fops_splice_write,
+	SPLICE_WRITE_INIT(port_fops_splice_write)
 	.poll  = port_fops_poll,
 	.release = port_fops_release,
 	.fasync = port_fops_fasync,
-- 
1.9.1

