Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab3DXGrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:47:35 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53965 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab3DXGre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:47:34 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <galak@kernel.crashing.org>
CC: <linux-usb@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 1/1] USB/EHCI: work for different PHY_CLK_VALID detecting order
Date: Wed, 24 Apr 2013 14:47:35 +0800
Message-ID: <1366786055-14671-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to different controller issue of PHY_CLK_VALID in ULPI mode,
in some cases, after set PHY_CLK_SEL, we should set
USB_CTRL_USB_EN before checking PHY_CLK_VALID, otherwise
PHY_CLK_VALID doesn't work.

But in other cases USB_CTRL_USB_EN is already set previously and
PHY_CLK_VALID is not valid once USB_CTRL_USB_EN is set. But
since PHY_CLK_VALID is w1c, we can force clear USB_CTRL_USB_EN
firstly after set PHY_CLK_SEL, then PHY_CLK_VALID status can
be kept even we re-set USB_CTRL_USB_EN.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 drivers/usb/host/ehci-fsl.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index d81d2fc..57f2aa0 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -234,11 +234,20 @@ static int ehci_fsl_setup_phy(struct usb_hcd *hcd,
 			/* controller version 1.6 or above */
 			setbits32(non_ehci + FSL_SOC_USB_CTRL,
 					ULPI_PHY_CLK_SEL);
+
 			/*
-			 * Due to controller issue of PHY_CLK_VALID in ULPI
-			 * mode, we set USB_CTRL_USB_EN before checking
-			 * PHY_CLK_VALID, otherwise PHY_CLK_VALID doesn't work.
+			 * Due to different controller issue of PHY_CLK_VALID
+			 * in ULPI mode, in some cases we should set
+			 * USB_CTRL_USB_EN before checking PHY_CLK_VALID,
+			 * otherwise PHY_CLK_VALID doesn't work.
+			 *
+			 * But in other cases USB_CTRL_USB_EN is already set
+			 * and PHY_CLK_VALID is not valid once USB_CTRL_USB_EN
+			 * is set. But since PHY_CLK_VALID is w1c, we can force
+			 * clear USB_CTRL_USB_EN firstly then PHY_CLK_VALID
+			 * status can be kept even we re-set USB_CTRL_USB_EN.
 			 */
+			clrbits32(non_ehci + FSL_SOC_USB_CTRL, USB_CTRL_USB_EN);
 			clrsetbits_be32(non_ehci + FSL_SOC_USB_CTRL,
 					UTMI_PHY_EN, USB_CTRL_USB_EN);
 		}
-- 
1.7.9.5

