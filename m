Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab3LBUft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:35:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab3LBTO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3.10 150/173] media: tuner-xc2028: Dont use dynamic static allocation
Date: Mon,  2 Dec 2013 11:12:13 -0800
Message-Id: <20131202191200.570380348@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/tuners/tuner-xc2028.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

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
@@ -547,7 +550,10 @@ static int load_firmware(struct dvb_fron
 {
 	struct xc2028_data *priv = fe->tuner_priv;
 	int                pos, rc;
-	unsigned char      *p, *endp, buf[priv->ctrl.max_len];
+	unsigned char      *p, *endp, buf[MAX_XFER_SIZE];
+
+	if (priv->ctrl.max_len > sizeof(buf))
+		priv->ctrl.max_len = sizeof(buf);
 
 	tuner_dbg("%s called\n", __func__);
 


