Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160996Ab3LFND0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:03:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44376 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161698Ab3LFNDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 173/272] [media] tuner-xc2028: Don't use dynamic static allocation
Date: Fri,  6 Dec 2013 12:57:42 +0000
Message-Id: <1386334761-25517-174-git-send-email-luis.henriques@canonical.com>
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

commit 56ac033725ec93a45170caf3979eb2b1211a59a8 upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/tuners/tuner-xc2028.c:651:1: warning: 'load_firmware' uses dynamic stack allocation [enabled by default]
Instead, let's enforce a limit for the buffer.
In the specific case of this driver, the maximum limit is 80, used only
on tm6000 driver. This limit is due to the size of the USB control URBs.
Ok, it would be theoretically possible to use a bigger size on PCI
devices, but the firmware load time is already good enough. Anyway,
if some usage requires more, it is just a matter of also increasing
the buffer size at load_firmware().

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/tuners/tuner-xc2028.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 878d2c4..9771cd8 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -24,6 +24,9 @@
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  80
+
 /* Registers (Write-only) */
 #define XREG_INIT         0x00
 #define XREG_RF_FREQ      0x02
@@ -547,7 +550,10 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 {
 	struct xc2028_data *priv = fe->tuner_priv;
 	int                pos, rc;
-	unsigned char      *p, *endp, buf[priv->ctrl.max_len];
+	unsigned char      *p, *endp, buf[MAX_XFER_SIZE];
+
+	if (priv->ctrl.max_len > sizeof(buf))
+		priv->ctrl.max_len = sizeof(buf);
 
 	tuner_dbg("%s called\n", __func__);
 
-- 
1.8.3.2

