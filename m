Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab3LFNgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:36:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44336 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161672Ab3LFNDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 163/272] [media] mxl111sf: Don't use dynamic static allocation
Date: Fri,  6 Dec 2013 12:57:32 +0000
Message-Id: <1386334761-25517-164-git-send-email-luis.henriques@canonical.com>
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

commit c98300a0e8cf160aaea60bc05d2cd156a7666173 upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/usb/dvb-usb-v2/mxl111sf.c:74:1: warning: 'mxl111sf_ctrl_msg' uses dynamic stack allocation [enabled by default]
Instead, let's enforce a limit for the buffer to be the max size of
a control URB payload data (64 bytes).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index e97964e..2627553 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -23,6 +23,9 @@
 #include "lgdt3305.h"
 #include "lg2160.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 int dvb_usb_mxl111sf_debug;
 module_param_named(debug, dvb_usb_mxl111sf_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level "
@@ -57,7 +60,12 @@ int mxl111sf_ctrl_msg(struct dvb_usb_device *d,
 {
 	int wo = (rbuf == NULL || rlen == 0); /* write-only */
 	int ret;
-	u8 sndbuf[1+wlen];
+	u8 sndbuf[MAX_XFER_SIZE];
+
+	if (1 + wlen > sizeof(sndbuf)) {
+		pr_warn("%s: len=%d is too big!\n", __func__, wlen);
+		return -EOPNOTSUPP;
+	}
 
 	pr_debug("%s(wlen = %d, rlen = %d)\n", __func__, wlen, rlen);
 
-- 
1.8.3.2

