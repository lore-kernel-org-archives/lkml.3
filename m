Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbaGDBQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 21:16:25 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:44263 "EHLO
	script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbaGDBPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 21:15:25 -0400
X-DKIM: Courier DKIM Filter v0.50+pk-2014-03-23 mail.cs.helsinki.fi Fri, 04 Jul 2014 04:09:52 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v2 3/4] USB: EHCI: tegra: Fix probe order issue leading to broken USB
Date: Fri,  4 Jul 2014 04:09:38 +0300
Message-Id: <1404436179-10745-4-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404436179-10745-1-git-send-email-ttynkkynen@nvidia.com>
References: <1404436179-10745-1-git-send-email-ttynkkynen@nvidia.com>
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
first controller again. As the UTMI registers are related to the PHY,
the PHY driver should probably reset the Tegra controllers instead,
but since old device trees only have reset phandles in the EHCI nodes,
do it here, which means a bit of device tree groveling. Those old DTs
also won't get the reset fix from this commit, so we'll dev_warn() them,
but the driver will still keep probing successfully.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
v2 changes: assume we can find the usb1 reset from the PHY DT node,
            don't fail if it's not found but just issue a warning
 drivers/usb/host/ehci-tegra.c |   62 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 5590567..f495775 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -46,6 +46,7 @@
 #define DRV_NAME "tegra-ehci"
 
 static struct hc_driver __read_mostly tegra_ehci_hc_driver;
+static bool usb1_reset_attempted;
 
 struct tegra_ehci_soc_config {
 	bool has_hostpc;
@@ -60,6 +61,61 @@ struct tegra_ehci_hcd {
 	enum tegra_usb_phy_port_speed port_speed;
 };
 
+/*
+ * The 1st USB controller contains some UTMI pad registers that are global for
+ * all the controllers on the chip. Those registers are also cleared when
+ * reset is asserted to the 1st controller. This means that the 1st controller
+ * can only be reset when no other controlled has finished probing. So we'll
+ * reset the 1st controller before doing any other setup on any of the
+ * controllers, and then never again.
+ *
+ * Since this is a PHY issue, the Tegra PHY driver should probably be doing
+ * the resetting of the USB controllers. But to keep compatibility with old
+ * device trees that don't have reset phandles in the PHYs, do it here.
+ * Those old DTs will be vulnerable to total USB breakage if the 1st EHCI
+ * device isn't the first one to finish probing, so warn them.
+ */
+static int tegra_reset_usb_controller(struct platform_device *pdev)
+{
+	struct device_node *phy_np;
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+	struct tegra_ehci_hcd *tegra =
+		(struct tegra_ehci_hcd *)hcd_to_ehci(hcd)->priv;
+
+	phy_np = of_parse_phandle(pdev->dev.of_node, "nvidia,phy", 0);
+	if (!phy_np)
+		return -ENOENT;
+
+	if (!usb1_reset_attempted) {
+		struct reset_control *usb1_reset;
+
+		usb1_reset = of_reset_control_get(phy_np, "usb");
+		if (IS_ERR(usb1_reset)) {
+			dev_warn(&pdev->dev,
+				 "can't get utmi-pads reset from the PHY\n");
+			dev_warn(&pdev->dev,
+				 "continuing, but please update your DT\n");
+		} else {
+			reset_control_assert(usb1_reset);
+			udelay(1);
+			reset_control_deassert(usb1_reset);
+		}
+
+		reset_control_put(usb1_reset);
+		usb1_reset_attempted = true;
+	}
+
+	if (!of_property_read_bool(phy_np, "nvidia,has-utmi-pad-registers")) {
+		reset_control_assert(tegra->rst);
+		udelay(1);
+		reset_control_deassert(tegra->rst);
+	}
+
+	of_node_put(phy_np);
+
+	return 0;
+}
+
 static int tegra_ehci_internal_port_reset(
 	struct ehci_hcd	*ehci,
 	u32 __iomem	*portsc_reg
@@ -389,9 +445,9 @@ static int tegra_ehci_probe(struct platform_device *pdev)
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
-- 
1.7.9.5

