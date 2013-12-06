Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162694Ab3LFNdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:33:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44372 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161720Ab3LFNDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 172/272] [media] lirc_zilog: Don't use dynamic static allocation
Date: Fri,  6 Dec 2013 12:57:41 +0000
Message-Id: <1386334761-25517-173-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 11d5338..0feeaad 100644
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
@@ -941,7 +944,14 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
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
-- 
1.8.3.2

