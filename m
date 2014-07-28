Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaG1PA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:00:28 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:51048 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaG1O5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:57:55 -0400
From: Stefan Agner <stefan@agner.ch>
To: peter.chen@freescale.com, s.hauer@pengutronix.de, shawn.guo@freescale.com
Cc: b35083@freescale.com, jingchang.lu@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 3/7] usb: phy: mxs: Add VF610 USB PHY support
Date: Mon, 28 Jul 2014 16:57:29 +0200
Message-Id: <acb7c055ded38c74291d0f0d8d2fdca54a8b95f8.1406558450.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <cover.1406558450.git.stefan@agner.ch>
References: <cover.1406558450.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the USB PHY in Vybrid VF610. We assume that
the disconnection without VBUS is also needed for Vybrid.

Tests showed, without MXS_PHY_NEED_IP_FIX, enumeration of devices
behind a USB Hub fails with errors:

[  215.163507] usb usb1-port1: cannot reset (err = -32)
[  215.170498] usb usb1-port1: cannot reset (err = -32)
[  215.185120] usb usb1-port1: cannot reset (err = -32)
[  215.191345] usb usb1-port1: cannot reset (err = -32)
[  215.202487] usb usb1-port1: cannot reset (err = -32)
[  215.207718] usb usb1-port1: Cannot enable. Maybe the USB cable is bad?
[  215.219317] usb usb1-port1: unable to enumerate USB device

Hence we also enable the MXS_PHY_NEED_IP_FIX flag.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 Documentation/devicetree/bindings/usb/mxs-phy.txt | 1 +
 drivers/usb/phy/phy-mxs-usb.c                     | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/mxs-phy.txt b/Documentation/devicetree/bindings/usb/mxs-phy.txt
index cef181a..fe3eed8 100644
--- a/Documentation/devicetree/bindings/usb/mxs-phy.txt
+++ b/Documentation/devicetree/bindings/usb/mxs-phy.txt
@@ -5,6 +5,7 @@ Required properties:
 	* "fsl,imx23-usbphy" for imx23 and imx28
 	* "fsl,imx6q-usbphy" for imx6dq and imx6dl
 	* "fsl,imx6sl-usbphy" for imx6sl
+	* "fsl,vf610-usbphy" for Vybrid vf610
   "fsl,imx23-usbphy" is still a fallback for other strings
 - reg: Should contain registers location and length
 - interrupts: Should contain phy interrupt
diff --git a/drivers/usb/phy/phy-mxs-usb.c b/drivers/usb/phy/phy-mxs-usb.c
index c42bdf0..8c2f23b 100644
--- a/drivers/usb/phy/phy-mxs-usb.c
+++ b/drivers/usb/phy/phy-mxs-usb.c
@@ -125,10 +125,16 @@ static const struct mxs_phy_data imx6sl_phy_data = {
 		MXS_PHY_NEED_IP_FIX,
 };
 
+static const struct mxs_phy_data vf610_phy_data = {
+	.flags = MXS_PHY_DISCONNECT_LINE_WITHOUT_VBUS |
+		MXS_PHY_NEED_IP_FIX,
+};
+
 static const struct of_device_id mxs_phy_dt_ids[] = {
 	{ .compatible = "fsl,imx6sl-usbphy", .data = &imx6sl_phy_data, },
 	{ .compatible = "fsl,imx6q-usbphy", .data = &imx6q_phy_data, },
 	{ .compatible = "fsl,imx23-usbphy", .data = &imx23_phy_data, },
+	{ .compatible = "fsl,vf610-usbphy", .data = &vf610_phy_data, },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, mxs_phy_dt_ids);
-- 
2.0.2

