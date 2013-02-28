Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab3B1Gij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 01:38:39 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1705 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab3B1Gig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 01:38:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 27 Feb 2013 22:33:08 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] usb: host: tegra: Reset Tegra USB controller before init
Date: Thu, 28 Feb 2013 12:06:58 +0530
Message-ID: <1362033418-7332-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To clear any configurations made by U-Boot on Tegra USB controller,
reset it before init in probe.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
When U-Boot configures a Tegra USB controller in device mode and if the EHCI
driver of kernel tries to set it to HOST mode, message "irq 52: nobody cared"
appears and IRQ gets disabled.

This issue was initially reported with: http://marc.info/?l=linux-tegra&m=136110175423601&w=2

To avoid such issues, due to configurations made by U-Boot driver, reset the
Tegra USB controller, before configuring it by kernel.


 drivers/usb/host/ehci-tegra.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 568aecc..83d190a 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -28,6 +28,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/usb/ehci_def.h>
 #include <linux/usb/tegra_usb_phy.h>
+#include <linux/clk/tegra.h>
 
 #define TEGRA_USB_BASE			0xC5000000
 #define TEGRA_USB2_BASE			0xC5004000
@@ -691,6 +692,10 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	if (err)
 		goto fail_clk;
 
+	tegra_periph_reset_assert(tegra->clk);
+	udelay(1);
+	tegra_periph_reset_deassert(tegra->clk);
+
 	tegra->needs_double_reset = of_property_read_bool(pdev->dev.of_node,
 		"nvidia,needs-double-reset");
 
-- 
1.7.0.4

