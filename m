Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab3HLNH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:07:26 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14739 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab3HLNHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:07:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 12 Aug 2013 06:07:18 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v3 6/6] usb: host: tegra: Tegra30 support
Date: Mon, 12 Aug 2013 16:06:54 +0300
Message-ID: <1376312814-18992-7-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376312814-18992-1-git-send-email-ttynkkynen@nvidia.com>
References: <1376312814-18992-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra30 EHCI controller is mostly compatible with the Tegra20
controller, except Tegra30 includes the HOSTPC register extension.
The has_hostpc capability bit must be set in the ehci_hcd structure if
the controller has such extensions. The new tegra_ehci_soc_config
structure is added to describe the differences between the SoCs.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
v3: Removed useless cast
 drivers/usb/host/ehci-tegra.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index db8031f..78fa76d 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -25,6 +25,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/of_gpio.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
@@ -50,6 +51,10 @@
 
 static struct hc_driver __read_mostly tegra_ehci_hc_driver;
 
+struct tegra_ehci_soc_config {
+	bool has_hostpc;
+};
+
 static int (*orig_hub_control)(struct usb_hcd *hcd,
 				u16 typeReq, u16 wValue, u16 wIndex,
 				char *buf, u16 wLength);
@@ -320,8 +325,24 @@ static void tegra_ehci_unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
 	free_dma_aligned_buffer(urb);
 }
 
+static const struct tegra_ehci_soc_config tegra30_soc_config = {
+	.has_hostpc = true,
+};
+
+static const struct tegra_ehci_soc_config tegra20_soc_config = {
+	.has_hostpc = false,
+};
+
+static struct of_device_id tegra_ehci_of_match[] = {
+	{ .compatible = "nvidia,tegra30-ehci", .data = &tegra30_soc_config },
+	{ .compatible = "nvidia,tegra20-ehci", .data = &tegra20_soc_config },
+	{ },
+};
+
 static int tegra_ehci_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *match;
+	const struct tegra_ehci_soc_config *soc_config;
 	struct resource *res;
 	struct usb_hcd *hcd;
 	struct ehci_hcd *ehci;
@@ -330,6 +351,13 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	int irq;
 	struct usb_phy *u_phy;
 
+	match = of_match_device(tegra_ehci_of_match, &pdev->dev);
+	if (!match) {
+		dev_err(&pdev->dev, "Error: No device match found\n");
+		return -ENODEV;
+	}
+	soc_config = match->data;
+
 	/* Right now device-tree probed devices don't get dma_mask set.
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we have dma capability bindings this can go away.
@@ -391,6 +419,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 		goto cleanup_clk_en;
 	}
 	ehci->caps = hcd->regs + 0x100;
+	ehci->has_hostpc = soc_config->has_hostpc;
 
 	err = usb_phy_init(hcd->phy);
 	if (err) {
@@ -468,11 +497,6 @@ static void tegra_ehci_hcd_shutdown(struct platform_device *pdev)
 		hcd->driver->shutdown(hcd);
 }
 
-static struct of_device_id tegra_ehci_of_match[] = {
-	{ .compatible = "nvidia,tegra20-ehci", },
-	{ },
-};
-
 static struct platform_driver tegra_ehci_driver = {
 	.probe		= tegra_ehci_probe,
 	.remove		= tegra_ehci_remove,
-- 
1.8.1.5

