Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbaGAVJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:09:07 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3866 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbaGAVJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:09:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 01 Jul 2014 14:02:32 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Felipe Balbi <balbi@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, <linux-usb@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tuomas.tynkkynen@iki.fi>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 2/3] USB: EHCI: tegra: Fix probe order issue leading to broken USB
Date: Wed, 2 Jul 2014 00:08:42 +0300
Message-ID: <1404248923-21086-3-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404248923-21086-1-git-send-email-ttynkkynen@nvidia.com>
References: <1404248923-21086-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra USB complex has a particularly annoying misdesign: some of the
UTMI pad configuration registers are global for all the 3 USB controllers
on the chip, but those registers are located in the first controller's
register space and will be cleared when the reset to the first
controller is asserted. Currently, this means that if the 1st controller
were to finish probing after the 2nd or 3rd controller, USB would not
work at all.

Fix this situation by always resetting the 1st controller before doing
any other setup to any of the controllers, and then never ever reset the
first controller again.

The really ugly part is that the EHCI controllers don't have a reset
control phandle to the 1st controller, so we have to do some device tree
groveling to find the phandle to the 1st controller.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/usb/host/ehci-tegra.c | 111 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 108 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 5590567..e3f362b 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -24,6 +24,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
 #include <linux/platform_device.h>
@@ -46,6 +47,7 @@
 #define DRV_NAME "tegra-ehci"
 
 static struct hc_driver __read_mostly tegra_ehci_hc_driver;
+static struct device_node *usb1_ehci_node;
 
 struct tegra_ehci_soc_config {
 	bool has_hostpc;
@@ -60,6 +62,108 @@ struct tegra_ehci_hcd {
 	enum tegra_usb_phy_port_speed port_speed;
 };
 
+/*
+ * The 1st USB controller contains some PHY registers that are global for
+ * all the controllers on the chip. Those registers are also cleared when
+ * reset is asserted to the 1st controller. This means that the 1st controller
+ * can only be reset when no other controlled has finished probing. So we'll
+ * reset the 1st controller before doing any other setup on any of the
+ * controllers, and then never again.
+ *
+ * Sadly, the EHCI device tree nodes don't have the phandle to the first USB
+ * controller, so in order not to break the DT ABI, this hack is required to
+ * locate it.
+ */
+static struct device_node *tegra_find_usb1_node(struct platform_device *pdev)
+{
+	int err;
+	int num = 0;
+	const char *compatible;
+	struct device_node *np, *lowest_node = NULL;
+	u64 lowest_addr = U64_MAX;
+
+	/*
+	 * Find the node that has the same compatible string as &pdev->dev
+	 * and has the lowest register address.
+	 */
+	of_property_read_string(pdev->dev.of_node, "compatible",
+				&compatible);
+
+	for_each_compatible_node(np, NULL, compatible) {
+		u64 sz, address;
+		const __be32 *addr_cells;
+
+		addr_cells = of_get_address(np, 0, &sz, NULL);
+		if (!addr_cells) {
+			dev_err(&pdev->dev, "found EHCI node with no address");
+			of_node_put(np);
+			goto failed;
+		}
+
+		address = of_read_number(addr_cells, of_n_addr_cells(np));
+		if (address < lowest_addr) {
+			of_node_put(lowest_node);
+			lowest_node = np;
+			lowest_addr = address;
+		} else {
+			of_node_put(np);
+		}
+		num++;
+	}
+
+	if (num != 3) {
+		dev_err(&pdev->dev, "couldn't locate all 3 EHCI nodes");
+		err = -ENODEV;
+		goto failed;
+	}
+
+	return lowest_node;
+
+failed:
+	of_node_put(lowest_node);
+
+	return ERR_PTR(err);
+}
+
+static int tegra_reset_usb_controller(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+	struct tegra_ehci_hcd *tegra =
+		(struct tegra_ehci_hcd *)hcd_to_ehci(hcd)->priv;
+
+	if (!usb1_ehci_node) {
+		struct device_node *np;
+		struct reset_control *usb1_reset;
+
+		np = tegra_find_usb1_node(pdev);
+		if (!np)
+			return -ENODEV;
+
+		usb1_reset = of_reset_control_get(np, "usb");
+		if (IS_ERR(usb1_reset)) {
+			dev_err(&pdev->dev,
+				"couldn't get reset for 1st USB controller");
+			of_node_put(np);
+			return PTR_ERR(usb1_reset);
+		}
+
+		reset_control_assert(usb1_reset);
+		udelay(1);
+		reset_control_deassert(usb1_reset);
+
+		reset_control_put(usb1_reset);
+		usb1_ehci_node = np;
+	}
+
+	if (pdev->dev.of_node != usb1_ehci_node) {
+		reset_control_assert(tegra->rst);
+		udelay(1);
+		reset_control_deassert(tegra->rst);
+	}
+
+	return 0;
+}
+
 static int tegra_ehci_internal_port_reset(
 	struct ehci_hcd	*ehci,
 	u32 __iomem	*portsc_reg
@@ -389,9 +493,9 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	if (err)
 		goto cleanup_hcd_create;
 
-	reset_control_assert(tegra->rst);
-	udelay(1);
-	reset_control_deassert(tegra->rst);
+	err = tegra_reset_usb_controller(pdev);
+	if (err)
+		goto cleanup_clk_en;
 
 	u_phy = devm_usb_get_phy_by_phandle(&pdev->dev, "nvidia,phy", 0);
 	if (IS_ERR(u_phy)) {
@@ -560,6 +664,7 @@ module_init(ehci_tegra_init);
 
 static void __exit ehci_tegra_cleanup(void)
 {
+	of_node_put(usb1_ehci_node);
 	platform_driver_unregister(&tegra_ehci_driver);
 }
 module_exit(ehci_tegra_cleanup);
-- 
1.8.1.5

