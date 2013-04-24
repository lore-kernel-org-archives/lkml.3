Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3DXCzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:55:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:42641 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3DXCzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:55:14 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <galak@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] usb: ehci-fsl: set INCR8 mode only on MPC512x
Date: Wed, 24 Apr 2013 10:55:10 +0800
Message-ID: <1366772110-9620-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 761bbcb7, "usb: ehci-fsl: set INCR8 mode for system bus interface
on MPC512x", introduced to fix one MPC5121e (M36P) Errata by setting
INCR8 mode for system bus interface on MPC512x, but we should make sure
this is only valid for MPC512x like other parts of this commit. Otherwise
this would issue other platforms as abnormal without this similar Errata.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 drivers/usb/host/ehci-fsl.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index d81d2fc..f4f2a7b 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -509,7 +509,15 @@ static int ehci_fsl_mpc512x_drv_resume(struct device *dev)
 	ehci_writel(ehci, ISIPHYCTRL_PXE | ISIPHYCTRL_PHYE,
 		    hcd->regs + FSL_SOC_USB_ISIPHYCTRL);
 
-	ehci_writel(ehci, SBUSCFG_INCR8, hcd->regs + FSL_SOC_USB_SBUSCFG);
+	if (of_device_is_compatible(dev->parent->of_node,
+				    "fsl,mpc5121-usb2-dr")) {
+		/*
+		 * set SBUSCFG:AHBBRST so that control msgs don't
+		 * fail when doing heavy PATA writes.
+		 */
+		ehci_writel(ehci, SBUSCFG_INCR8,
+			    hcd->regs + FSL_SOC_USB_SBUSCFG);
+	}
 
 	/* restore EHCI registers */
 	ehci_writel(ehci, pdata->pm_command, &ehci->regs->command);
-- 
1.7.9.5

