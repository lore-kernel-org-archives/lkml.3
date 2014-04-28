Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707AbaD1PYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:24:39 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:50435 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756639AbaD1PYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:24:35 -0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH] fsl-usb: do not test for PHY_CLK_VALID bit on controller version 1.6
Date: Mon, 28 Apr 2014 19:23:44 +0400
Message-Id: <1398698624-14391-1-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per reference manuals of Freescale P1020 and P2020 SoCs, USB controller
present in these SoCs has bit 17 of USBx_CONTROL register marked as
Reserved - there is no PHY_CLK_VALID bit there.

Testing for this bit in ehci_fsl_setup_phy() behaves differently on two
P1020RDB boards available here - on one board test passes and fsl-usb
init succeeds, but on other board test fails, causing fsl-usb init to
fail.

This patch changes ehci_fsl_setup_phy() not to test PHY_CLK_VALID on
controller version 1.6 that (per manual) does not have this bit.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/usb/host/ehci-fsl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index 6f2c8d3..cf2734b 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -248,7 +248,8 @@ static int ehci_fsl_setup_phy(struct usb_hcd *hcd,
 		break;
 	}
 
-	if (pdata->have_sysif_regs && pdata->controller_ver &&
+	if (pdata->have_sysif_regs &&
+	    pdata->controller_ver > FSL_USB_VER_1_6 &&
 	    (phy_mode == FSL_USB2_PHY_ULPI)) {
 		/* check PHY_CLK_VALID to get phy clk valid */
 		if (!(spin_event_timeout(in_be32(non_ehci + FSL_SOC_USB_CTRL) &
-- 
1.7.10.4

