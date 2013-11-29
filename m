Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3K2CN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 21:13:29 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:50295 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab3K2CNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 21:13:22 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH 2/3] usb: chipidea: Fix Internal error: : 808 [#1] ARM related to STS flag
Date: Fri, 29 Nov 2013 10:07:49 +0800
Message-Id: <1385690869-32266-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* init the sts flag to 0 (missed)
* set the sts flag only if not 0

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
---
 drivers/usb/chipidea/core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 5075407..1a6010e 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -245,6 +245,8 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
 {
 	u32 portsc, lpm, sts;
 
+	sts = 0;
+
 	switch (ci->platdata->phy_mode) {
 	case USBPHY_INTERFACE_MODE_UTMI:
 		portsc = PORTSC_PTS(PTS_UTMI);
@@ -273,10 +275,12 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
 
 	if (ci->hw_bank.lpm) {
 		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
-		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
+		if (sts)
+			hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
 	} else {
 		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
-		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
+		if ( sts )
+			hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
 	}
 }
 
-- 
1.7.10.4

