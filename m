Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3HUFra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 01:47:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37650 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab3HUFrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 01:47:25 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kyungmin.park@samsung.com>, <balbi@ti.com>,
        <kishon@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <stern@rowland.harvard.edu>,
        <broonie@kernel.org>, <tomasz.figa@gmail.com>, <arnd@arndb.de>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <swarren@nvidia.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux@arm.linux.org.uk>
Subject: [PATCH v11 2/8] usb: phy: omap-usb2: use the new generic PHY framework
Date: Wed, 21 Aug 2013 11:16:07 +0530
Message-ID: <1377063973-22044-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1377063973-22044-1-git-send-email-kishon@ti.com>
References: <1377063973-22044-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used the generic PHY framework API to create the PHY. Now the power off and
power on are done in omap_usb_power_off and omap_usb_power_on respectively.
The omap-usb2 driver is also moved to driver/phy.

However using the old USB PHY library cannot be completely removed
because OTG is intertwined with PHY and moving to the new framework
will break OTG. Once we have a separate OTG state machine, we
can get rid of the USB PHY library.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/phy/Kconfig                   |   12 +++++++++
 drivers/phy/Makefile                  |    1 +
 drivers/{usb => }/phy/phy-omap-usb2.c |   45 ++++++++++++++++++++++++++++++---
 drivers/usb/phy/Kconfig               |   10 --------
 drivers/usb/phy/Makefile              |    1 -
 5 files changed, 54 insertions(+), 15 deletions(-)
 rename drivers/{usb => }/phy/phy-omap-usb2.c (88%)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 349bef2..38c3477 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -15,4 +15,16 @@ config GENERIC_PHY
 	  phy users can obtain reference to the PHY. All the users of this
 	  framework should select this config.
 
+config OMAP_USB2
+	tristate "OMAP USB2 PHY Driver"
+	depends on ARCH_OMAP2PLUS
+	select GENERIC_PHY
+	select USB_PHY
+	select OMAP_CONTROL_USB
+	help
+	  Enable this to support the transceiver that is part of SOC. This
+	  driver takes care of all the PHY functionality apart from comparator.
+	  The USB OTG controller communicates with the comparator using this
+	  driver.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 9e9560f..ed5b088 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
+obj-$(CONFIG_OMAP_USB2)		+= phy-omap-usb2.o
diff --git a/drivers/usb/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
similarity index 88%
rename from drivers/usb/phy/phy-omap-usb2.c
rename to drivers/phy/phy-omap-usb2.c
index 844ab68..25e0f3c 100644
--- a/drivers/usb/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -28,6 +28,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/delay.h>
 #include <linux/usb/omap_control_usb.h>
+#include <linux/phy/phy.h>
 
 /**
  * omap_usb2_set_comparator - links the comparator present in the sytem with
@@ -119,10 +120,36 @@ static int omap_usb2_suspend(struct usb_phy *x, int suspend)
 	return 0;
 }
 
+static int omap_usb_power_off(struct phy *x)
+{
+	struct omap_usb *phy = phy_get_drvdata(x);
+
+	omap_control_usb_phy_power(phy->control_dev, 0);
+
+	return 0;
+}
+
+static int omap_usb_power_on(struct phy *x)
+{
+	struct omap_usb *phy = phy_get_drvdata(x);
+
+	omap_control_usb_phy_power(phy->control_dev, 1);
+
+	return 0;
+}
+
+static struct phy_ops ops = {
+	.power_on	= omap_usb_power_on,
+	.power_off	= omap_usb_power_off,
+	.owner		= THIS_MODULE,
+};
+
 static int omap_usb2_probe(struct platform_device *pdev)
 {
 	struct omap_usb			*phy;
+	struct phy			*generic_phy;
 	struct usb_otg			*otg;
+	struct phy_provider		*phy_provider;
 
 	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
 	if (!phy) {
@@ -144,6 +171,11 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	phy->phy.otg		= otg;
 	phy->phy.type		= USB_PHY_TYPE_USB2;
 
+	phy_provider = devm_of_phy_provider_register(phy->dev,
+			of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
 	phy->control_dev = omap_get_control_dev();
 	if (IS_ERR(phy->control_dev)) {
 		dev_dbg(&pdev->dev, "Failed to get control device\n");
@@ -159,6 +191,15 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	otg->start_srp		= omap_usb_start_srp;
 	otg->phy		= &phy->phy;
 
+	platform_set_drvdata(pdev, phy);
+	pm_runtime_enable(phy->dev);
+
+	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
+	if (IS_ERR(generic_phy))
+		return PTR_ERR(generic_phy);
+
+	phy_set_drvdata(generic_phy, phy);
+
 	phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
 	if (IS_ERR(phy->wkupclk)) {
 		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
@@ -174,10 +215,6 @@ static int omap_usb2_probe(struct platform_device *pdev)
 
 	usb_add_phy_dev(&phy->phy);
 
-	platform_set_drvdata(pdev, phy);
-
-	pm_runtime_enable(phy->dev);
-
 	return 0;
 }
 
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 3622fff..7813238 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -72,16 +72,6 @@ config OMAP_CONTROL_USB
 	  power on the USB2 PHY is present in OMAP4 and OMAP5. OMAP5 has an
 	  additional register to power on USB3 PHY.
 
-config OMAP_USB2
-	tristate "OMAP USB2 PHY Driver"
-	depends on ARCH_OMAP2PLUS
-	select OMAP_CONTROL_USB
-	help
-	  Enable this to support the transceiver that is part of SOC. This
-	  driver takes care of all the PHY functionality apart from comparator.
-	  The USB OTG controller communicates with the comparator using this
-	  driver.
-
 config OMAP_USB3
 	tristate "OMAP USB3 PHY Driver"
 	select OMAP_CONTROL_USB
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index 070eca3..56d2b03 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -16,7 +16,6 @@ obj-$(CONFIG_ISP1301_OMAP)		+= phy-isp1301-omap.o
 obj-$(CONFIG_MV_U3D_PHY)		+= phy-mv-u3d-usb.o
 obj-$(CONFIG_NOP_USB_XCEIV)		+= phy-nop.o
 obj-$(CONFIG_OMAP_CONTROL_USB)		+= phy-omap-control.o
-obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_OMAP_USB3)			+= phy-omap-usb3.o
 obj-$(CONFIG_SAMSUNG_USBPHY)		+= phy-samsung-usb.o
 obj-$(CONFIG_SAMSUNG_USB2PHY)		+= phy-samsung-usb2.o
-- 
1.7.10.4

