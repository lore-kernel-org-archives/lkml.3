Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab3FYGAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 02:00:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60513 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab3FYF76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 01:59:58 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <kishon@ti.com>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <sylvester.nawrocki@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <akpm@linux-foundation.org>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <benoit.cousson@linaro.org>, <mchehab@redhat.com>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <rnayak@ti.com>, <shawn.guo@linaro.org>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>, <balajitk@ti.com>,
        <george.cherian@ti.com>
Subject: [PATCH v8 2/8] usb: phy: omap-usb2: use the new generic PHY framework
Date: Tue, 25 Jun 2013 11:28:40 +0530
Message-ID: <1372139926-3719-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372139926-3719-1-git-send-email-kishon@ti.com>
References: <1372139926-3719-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used the generic PHY framework API to create the PHY. Now the power off and
power on are done in omap_usb_power_off and omap_usb_power_on respectively.

However using the old USB PHY library cannot be completely removed
because OTG is intertwined with PHY and moving to the new framework
will break OTG. Once we have a separate OTG state machine, we
can get rid of the USB PHY library.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/usb/phy/Kconfig         |    1 +
 drivers/usb/phy/phy-omap-usb2.c |   43 +++++++++++++++++++++++++++++++++++----
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 7ef3eb8..5caeafd 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -69,6 +69,7 @@ config OMAP_CONTROL_USB
 config OMAP_USB2
 	tristate "OMAP USB2 PHY Driver"
 	depends on ARCH_OMAP2PLUS
+	depends on GENERIC_PHY
 	select OMAP_CONTROL_USB
 	help
 	  Enable this to support the transceiver that is part of SOC. This
diff --git a/drivers/usb/phy/phy-omap-usb2.c b/drivers/usb/phy/phy-omap-usb2.c
index 844ab68..ecdf1ac 100644
--- a/drivers/usb/phy/phy-omap-usb2.c
+++ b/drivers/usb/phy/phy-omap-usb2.c
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
+	struct omap_usb *phy = dev_get_drvdata(&x->dev);
+
+	omap_control_usb_phy_power(phy->control_dev, 0);
+
+	return 0;
+}
+
+static int omap_usb_power_on(struct phy *x)
+{
+	struct omap_usb *phy = dev_get_drvdata(&x->dev);
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
@@ -159,6 +191,13 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	otg->start_srp		= omap_usb_start_srp;
 	otg->phy		= &phy->phy;
 
+	platform_set_drvdata(pdev, phy);
+	pm_runtime_enable(phy->dev);
+
+	generic_phy = devm_phy_create(phy->dev, 0, &ops, "omap-usb2", phy);
+	if (IS_ERR(generic_phy))
+		return PTR_ERR(generic_phy);
+
 	phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
 	if (IS_ERR(phy->wkupclk)) {
 		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
@@ -174,10 +213,6 @@ static int omap_usb2_probe(struct platform_device *pdev)
 
 	usb_add_phy_dev(&phy->phy);
 
-	platform_set_drvdata(pdev, phy);
-
-	pm_runtime_enable(phy->dev);
-
 	return 0;
 }
 
-- 
1.7.10.4

