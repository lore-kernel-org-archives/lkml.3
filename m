Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab3JCETW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:19:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab3JCETU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:19:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ramneek Mehresh <ramneek.mehresh@freescale.com>
Subject: [ 36/57] fsl/usb: Resolve PHY_CLK_VLD instability issue for ULPI phy
Date: Wed,  2 Oct 2013 21:09:02 -0700
Message-Id: <20131003040639.070563155@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramneek Mehresh <ramneek.mehresh@freescale.com>

commit ad1260e9fbf768d6bed227d9604ebee76a84aae3 upstream.

For controller versions greater than 1.6, setting ULPI_PHY_CLK_SEL
bit when USB_EN bit is already set causes instability issues with
PHY_CLK_VLD bit. So USB_EN is set only for IP controller version
below 1.6 before setting ULPI_PHY_CLK_SEL bit

Signed-off-by: Ramneek Mehresh <ramneek.mehresh@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-fsl.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -130,7 +130,7 @@ static int usb_hcd_fsl_probe(const struc
 	}
 
 	/* Enable USB controller, 83xx or 8536 */
-	if (pdata->have_sysif_regs)
+	if (pdata->have_sysif_regs && pdata->controller_ver < FSL_USB_VER_1_6)
 		setbits32(hcd->regs + FSL_SOC_USB_CTRL, 0x4);
 
 	/* Don't need to set host mode here. It will be done by tdi_reset() */
@@ -232,15 +232,9 @@ static int ehci_fsl_setup_phy(struct usb
 	case FSL_USB2_PHY_ULPI:
 		if (pdata->have_sysif_regs && pdata->controller_ver) {
 			/* controller version 1.6 or above */
+			clrbits32(non_ehci + FSL_SOC_USB_CTRL, UTMI_PHY_EN);
 			setbits32(non_ehci + FSL_SOC_USB_CTRL,
-					ULPI_PHY_CLK_SEL);
-			/*
-			 * Due to controller issue of PHY_CLK_VALID in ULPI
-			 * mode, we set USB_CTRL_USB_EN before checking
-			 * PHY_CLK_VALID, otherwise PHY_CLK_VALID doesn't work.
-			 */
-			clrsetbits_be32(non_ehci + FSL_SOC_USB_CTRL,
-					UTMI_PHY_EN, USB_CTRL_USB_EN);
+				ULPI_PHY_CLK_SEL | USB_CTRL_USB_EN);
 		}
 		portsc |= PORT_PTS_ULPI;
 		break;


