Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab3LBTb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:31:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab3LBTTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:19:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3.12 196/212] media: lirc_zilog: Dont use dynamic static allocation
Date: Mon,  2 Dec 2013 11:16:27 -0800
Message-Id: <20131202191310.859519122@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit ac5b4b6bf0c84c48d7e2e3fce22e35b04282ba76 upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
ompilation complains about it on some archs:
	drivers/staging/media/lirc/lirc_zilog.c:967:1: warning: 'read' uses dynamic stack allocation [enabled by default]
Instead, let's enforce a limit for the buffer to be 64. That should
be more than enough.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/lirc/lirc_zilog.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -61,6 +61,9 @@
 #include <media/lirc_dev.h>
 #include <media/lirc.h>
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 struct IR;
 
 struct IR_rx {
@@ -941,7 +944,14 @@ static ssize_t read(struct file *filep,
 			schedule();
 			set_current_state(TASK_INTERRUPTIBLE);
 		} else {
-			unsigned char buf[rbuf->chunk_size];
+			unsigned char buf[MAX_XFER_SIZE];
+
+			if (rbuf->chunk_size > sizeof(buf)) {
+				zilog_error("chunk_size is too big (%d)!\n",
+					    rbuf->chunk_size);
+				ret = -EINVAL;
+				break;
+			}
 			m = lirc_buffer_read(rbuf, buf);
 			if (m == rbuf->chunk_size) {
 				ret = copy_to_user((void *)outbuf+written, buf,


