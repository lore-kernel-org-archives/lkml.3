Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbaGQRNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:13:46 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:51762 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733AbaGQRNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:13:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, balbi@ti.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        peter.griffin+familyguy@linaro.org
Subject: [RFC PATCH] usb: dwc3: core: allow vendor drivers to check probe status
Date: Thu, 17 Jul 2014 18:13:33 +0100
Message-Id: <1405617213-27360-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides mechanism for subordinate devices to check
whether the DWC3 core probed successfully or otherwise.  Useful
if PHYs are required to configure controllers, but aren't yet
available.  The DWC3 core driver will defer probe if PHYs are
unavailable, however subordinate DWC3 drivers currently do not
have any visibility or means to check status - until now.

Another way to do this would be to *_phy_get*(), but if every
driver did this it would create a high level of code
duplication.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/usb/dwc3/core.c | 12 ++++++++++++
 drivers/usb/dwc3/core.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index eb69eb9..171ca52 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -47,6 +47,14 @@
 
 /* -------------------------------------------------------------------------- */
 
+static bool is_enabled = false;
+
+int dwc3_is_enabled(void)
+{
+	return is_enabled;
+}
+EXPORT_SYMBOL(dwc3_is_enabled);
+
 void dwc3_set_mode(struct dwc3 *dwc, u32 mode)
 {
 	u32 reg;
@@ -757,6 +765,8 @@ static int dwc3_probe(struct platform_device *pdev)
 
 	pm_runtime_allow(dev);
 
+	is_enabled = true;
+
 	return 0;
 
 err3:
@@ -786,6 +796,8 @@ static int dwc3_remove(struct platform_device *pdev)
 {
 	struct dwc3	*dwc = platform_get_drvdata(pdev);
 
+	is_enabled = false;
+
 	usb_phy_set_suspend(dwc->usb2_phy, 1);
 	usb_phy_set_suspend(dwc->usb3_phy, 1);
 	phy_power_off(dwc->usb2_generic_phy);
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 57332e3..94dee86 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -906,6 +906,7 @@ struct dwc3_gadget_ep_cmd_params {
 /* prototypes */
 void dwc3_set_mode(struct dwc3 *dwc, u32 mode);
 int dwc3_gadget_resize_tx_fifos(struct dwc3 *dwc);
+int dwc3_is_enabled(void);
 
 #if IS_ENABLED(CONFIG_USB_DWC3_HOST) || IS_ENABLED(CONFIG_USB_DWC3_DUAL_ROLE)
 int dwc3_host_init(struct dwc3 *dwc);
-- 
1.8.3.2

