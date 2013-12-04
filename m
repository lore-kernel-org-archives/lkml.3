Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3LDB4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:56:44 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:51215 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab3LDB4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:56:37 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: peter.chen@freescale.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH 2/3 v5] Fix Internal error: : 808 [#1] ARM related to STS flag
Date: Wed,  4 Dec 2013 09:56:18 +0800
Message-Id: <1386122179-4158-2-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386122179-4158-1-git-send-email-chris.ruehl@gtsys.com.hk>
References: <1386122179-4158-1-git-send-email-chris.ruehl@gtsys.com.hk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix Internal error: : 808 [#1] ARM related to STS flag

* init the sts flag to 0 (missed)
* fix write the real bit not sts value
* Set PORTCS_STS and DEVLC_STS only if sts = 1
 (prefered solution by Mr. Peter Chen, Maintainer of ChipIdea subsystem)

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
---
 drivers/usb/chipidea/core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 9a5ef20..2834801 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -243,7 +243,7 @@ static int hw_device_init(struct ci_hdrc *ci, void __iomem *base)
 
 static void hw_phymode_configure(struct ci_hdrc *ci)
 {
-	u32 portsc, lpm, sts;
+	u32 portsc, lpm, sts = 0;
 
 	switch (ci->platdata->phy_mode) {
 	case USBPHY_INTERFACE_MODE_UTMI:
@@ -273,10 +273,12 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
 
 	if (ci->hw_bank.lpm) {
 		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
-		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
+		if (sts)
+			hw_write(ci, OP_DEVLC, DEVLC_STS, DEVLC_STS);
 	} else {
 		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
-		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
+		if (sts)
+			hw_write(ci, OP_PORTSC, PORTSC_STS, PORTSC_STS);
 	}
 }
 
-- 
1.7.10.4

