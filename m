Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810Ab3JJQCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:02:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52830 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab3JJPrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:47:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ramneek Mehresh <ramneek.mehresh@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 073/104] fsl/usb: Resolve PHY_CLK_VLD instability issue for ULPI phy
Date: Thu, 10 Oct 2013 08:42:01 -0700
Message-Id: <1381419752-29733-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramneek Mehresh <ramneek.mehresh@freescale.com>

commit ad1260e9fbf768d6bed227d9604ebee76a84aae3 upstream.

For controller versions greater than 1.6, setting ULPI_PHY_CLK_SEL
bit when USB_EN bit is already set causes instability issues with
PHY_CLK_VLD bit. So USB_EN is set only for IP controller version
below 1.6 before setting ULPI_PHY_CLK_SEL bit

Signed-off-by: Ramneek Mehresh <ramneek.mehresh@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ehci-fsl.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index d81d2fc..512f117 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -130,7 +130,7 @@ static int usb_hcd_fsl_probe(const struct hc_driver *driver,
 	}
 
 	/* Enable USB controller, 83xx or 8536 */
-	if (pdata->have_sysif_regs)
+	if (pdata->have_sysif_regs && pdata->controller_ver < FSL_USB_VER_1_6)
 		setbits32(hcd->regs + FSL_SOC_USB_CTRL, 0x4);
 
 	/* Don't need to set host mode here. It will be done by tdi_reset() */
@@ -232,15 +232,9 @@ static int ehci_fsl_setup_phy(struct usb_hcd *hcd,
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
-- 
1.8.1.2

