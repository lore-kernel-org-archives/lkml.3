Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3K3DwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 22:52:07 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:38838 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab3K3DwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 22:52:03 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH 2/3 v3] usb: chipidea: Fix Internal error: : 808 [#1] ARM related to STS flag
Date: Sat, 30 Nov 2013 11:51:53 +0800
Message-Id: <1385783513-22502-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb: chipidea: Fix Internal error: : 808 [#1] ARM related to STS flag

* init the sts flag to 0 (missed)
* Set PORTCS_STS only if VUSB_HS_PHY_TYPE > 1
  otherwise the register is ReadOnly
* Set/Reset correct BIT(28)/BIT(29) for STS

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
---
 drivers/usb/chipidea/core.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 5075407..2c634c1 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -243,7 +243,7 @@ static int hw_device_init(struct ci_hdrc *ci, void __iomem *base)
 
 static void hw_phymode_configure(struct ci_hdrc *ci)
 {
-	u32 portsc, lpm, sts;
+	u32 portsc, lpm, sts = 0;
 
 	switch (ci->platdata->phy_mode) {
 	case USBPHY_INTERFACE_MODE_UTMI:
@@ -273,10 +273,24 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
 
 	if (ci->hw_bank.lpm) {
 		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
-		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
+		if ( sts )
+			hw_write(ci, OP_DEVLC, DEVLC_STS, BIT(28));
+		else
+			hw_write(ci, OP_DEVLC, DEVLC_STS, ~BIT(28));
 	} else {
 		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
-		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
+		if (((portsc >> 30) & 0x3) > 1) {
+			if (sts) {
+				hw_write(ci, OP_PORTSC, PORTSC_STS, BIT(29));
+			}
+			else {
+				portsc = (ioread32(ci->hw_bank.regmap[OP_PORTSC])
+						& PORTSC_STS);
+				if (portsc)
+					hw_write(ci, OP_PORTSC, PORTSC_STS,
+							~BIT(29));
+			}
+		}
 	}
 }
 
-- 
1.7.10.4

