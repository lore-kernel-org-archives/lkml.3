Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3GJAei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 20:34:38 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:47710 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab3GJAeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 20:34:36 -0400
From: Julius Werner <jwerner@chromium.org>
To: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Praveen Paneri <p.paneri@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] usb: phy: samsung-usb2: Toggle HSIC GPIO from device tree
Date: Tue,  9 Jul 2013 17:34:15 -0700
Message-Id: <1373416455-30358-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for a new 'samsung,hsic-reset-gpio' in the
device tree, which will be interpreted as an active-low reset pin during
PHY initialization when it exists. Useful for intergrated HSIC devices
like an SMSC 3503 hub. It is necessary to add this directly to the PHY
initialization to get the timing right, since resetting a HSIC device
after it has already been enumerated can confuse the USB stack.

Also fixes PHY semaphore code to make sure we always go through the
setup at least once, even if it was already turned on (e.g. by
firmware), and changes a spinlock to a mutex to allow sleeping in the
critical section.

Change-Id: Ieecac52c27daa7a17a7ed3b2863ddba3aeb8d16f
Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 .../devicetree/bindings/usb/samsung-usbphy.txt     | 10 ++++++
 drivers/usb/phy/phy-samsung-usb.c                  | 17 ++++++++++
 drivers/usb/phy/phy-samsung-usb.h                  |  7 ++--
 drivers/usb/phy/phy-samsung-usb2.c                 | 38 ++++++++++------------
 drivers/usb/phy/phy-samsung-usb3.c                 | 12 +++----
 5 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
index 33fd354..82e2e16 100644
--- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
+++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
@@ -31,6 +31,12 @@ Optional properties:
 - ranges: allows valid translation between child's address space and parent's
 	  address space.
 
+- samsung,hsic-reset-gpio: an active low GPIO pin that resets a device
+			connected to the HSIC port. Useful for things like
+			an on-board SMSC3503 hub.
+- pinctrl-0: Pin control group containing the HSIC reset GPIO pin.
+- pinctrl-names: Should contain only one value - "default".
+
 - The child node 'usbphy-sys' to the node 'usbphy' is for the system controller
   interface for usb-phy. It should provide the following information required by
   usb-phy controller to control phy.
@@ -56,6 +62,10 @@ Example:
 		clocks = <&clock 2>, <&clock 305>;
 		clock-names = "xusbxti", "otg";
 
+		samsung,hsic-reset-gpio = <&gpx2 4 1>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&hsic_reset>;
+
 		usbphy-sys {
 			/* USB device and host PHY_CONTROL registers */
 			reg = <0x10020704 0x8>;
diff --git a/drivers/usb/phy/phy-samsung-usb.c b/drivers/usb/phy/phy-samsung-usb.c
index ac025ca..23f1d70 100644
--- a/drivers/usb/phy/phy-samsung-usb.c
+++ b/drivers/usb/phy/phy-samsung-usb.c
@@ -27,6 +27,7 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/of_gpio.h>
 #include <linux/usb/samsung_usb_phy.h>
 
 #include "phy-samsung-usb.h"
@@ -58,6 +59,22 @@ int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
 	if (sphy->sysreg == NULL)
 		dev_warn(sphy->dev, "Can't get usb-phy sysreg cfg register\n");
 
+	/*
+	 * Some boards have a separate active-low reset GPIO for their HSIC USB
+	 * devices. If they don't, this will just stay at an invalid value and
+	 * the init code will ignore it.
+	 */
+	sphy->hsic_reset_gpio = of_get_named_gpio(sphy->dev->of_node,
+						"samsung,hsic-reset-gpio", 0);
+	if (gpio_is_valid(sphy->hsic_reset_gpio)) {
+		if (devm_gpio_request_one(sphy->dev, sphy->hsic_reset_gpio,
+				GPIOF_OUT_INIT_LOW, "samsung_hsic_reset")) {
+			dev_err(sphy->dev, "can't request hsic reset gpio %d\n",
+				sphy->hsic_reset_gpio);
+			sphy->hsic_reset_gpio = -EINVAL;
+		}
+	}
+
 	of_node_put(usbphy_sys);
 
 	return 0;
diff --git a/drivers/usb/phy/phy-samsung-usb.h b/drivers/usb/phy/phy-samsung-usb.h
index 68771bf..0703878 100644
--- a/drivers/usb/phy/phy-samsung-usb.h
+++ b/drivers/usb/phy/phy-samsung-usb.h
@@ -16,6 +16,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/mutex.h>
 #include <linux/usb/phy.h>
 
 /* Register definitions */
@@ -301,7 +302,8 @@ struct samsung_usbphy_drvdata {
  * @phy_type: Samsung SoCs specific phy types:	#HOST
  *						#DEVICE
  * @phy_usage: usage count for phy
- * @lock: lock for phy operations
+ * @mutex: mutex for phy operations (usb2phy must sleep, so no spinlock!)
+ * @hsic_reset_gpio: Active low GPIO that resets connected HSIC device
  */
 struct samsung_usbphy {
 	struct usb_phy	phy;
@@ -315,7 +317,8 @@ struct samsung_usbphy {
 	const struct samsung_usbphy_drvdata *drv_data;
 	enum samsung_usb_phy_type phy_type;
 	atomic_t	phy_usage;
-	spinlock_t	lock;
+	struct mutex	mutex;
+	int		hsic_reset_gpio;
 };
 
 #define phy_to_sphy(x)		container_of((x), struct samsung_usbphy, phy)
diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
index 1011c16..2db2113 100644
--- a/drivers/usb/phy/phy-samsung-usb2.c
+++ b/drivers/usb/phy/phy-samsung-usb2.c
@@ -24,6 +24,7 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/gpio.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/usb/otg.h>
@@ -43,15 +44,6 @@ static int samsung_usbphy_set_host(struct usb_otg *otg, struct usb_bus *host)
 	return 0;
 }
 
-static bool exynos5_phyhost_is_on(void __iomem *regs)
-{
-	u32 reg;
-
-	reg = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
-
-	return !(reg & HOST_CTRL0_SIDDQ);
-}
-
 static void samsung_exynos5_usb2phy_enable(struct samsung_usbphy *sphy)
 {
 	void __iomem *regs = sphy->regs;
@@ -68,10 +60,8 @@ static void samsung_exynos5_usb2phy_enable(struct samsung_usbphy *sphy)
 	 * the last consumer to disable it.
 	 */
 
-	atomic_inc(&sphy->phy_usage);
-
-	if (exynos5_phyhost_is_on(regs)) {
-		dev_info(sphy->dev, "Already power on PHY\n");
+	if (atomic_inc_return(&sphy->phy_usage) != 1) {
+		dev_info(sphy->dev, "USB PHY already initialized\n");
 		return;
 	}
 
@@ -132,6 +122,13 @@ static void samsung_exynos5_usb2phy_enable(struct samsung_usbphy *sphy)
 	writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
 
 	/* HSIC phy configuration */
+	if (gpio_is_valid(sphy->hsic_reset_gpio)) {
+		gpio_set_value(sphy->hsic_reset_gpio, 0);
+		udelay(100);  /* Keep reset as active/low for 100us */
+		gpio_set_value(sphy->hsic_reset_gpio, 1);
+		usleep_range(4000, 10000);  /* wait for device init */
+	}
+
 	phyhsic = (HSIC_CTRL_REFCLKDIV_12 |
 			HSIC_CTRL_REFCLKSEL |
 			HSIC_CTRL_PHYSWRST);
@@ -220,6 +217,9 @@ static void samsung_exynos5_usb2phy_disable(struct samsung_usbphy *sphy)
 	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
 	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
 
+	if (gpio_is_valid(sphy->hsic_reset_gpio))
+		gpio_set_value(sphy->hsic_reset_gpio, 0);
+
 	phyhost = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
 	phyhost |= (HOST_CTRL0_SIDDQ |
 			HOST_CTRL0_FORCESUSPEND |
@@ -267,7 +267,6 @@ static int samsung_usb2phy_init(struct usb_phy *phy)
 {
 	struct samsung_usbphy *sphy;
 	struct usb_bus *host = NULL;
-	unsigned long flags;
 	int ret = 0;
 
 	sphy = phy_to_sphy(phy);
@@ -281,7 +280,7 @@ static int samsung_usb2phy_init(struct usb_phy *phy)
 		return ret;
 	}
 
-	spin_lock_irqsave(&sphy->lock, flags);
+	mutex_lock(&sphy->mutex);
 
 	if (host) {
 		/* setting default phy-type for USB 2.0 */
@@ -304,7 +303,7 @@ static int samsung_usb2phy_init(struct usb_phy *phy)
 	/* Initialize usb phy registers */
 	sphy->drv_data->phy_enable(sphy);
 
-	spin_unlock_irqrestore(&sphy->lock, flags);
+	mutex_unlock(&sphy->mutex);
 
 	/* Disable the phy clock */
 	clk_disable_unprepare(sphy->clk);
@@ -319,7 +318,6 @@ static void samsung_usb2phy_shutdown(struct usb_phy *phy)
 {
 	struct samsung_usbphy *sphy;
 	struct usb_bus *host = NULL;
-	unsigned long flags;
 
 	sphy = phy_to_sphy(phy);
 
@@ -330,7 +328,7 @@ static void samsung_usb2phy_shutdown(struct usb_phy *phy)
 		return;
 	}
 
-	spin_lock_irqsave(&sphy->lock, flags);
+	mutex_lock(&sphy->mutex);
 
 	if (host) {
 		/* setting default phy-type for USB 2.0 */
@@ -350,7 +348,7 @@ static void samsung_usb2phy_shutdown(struct usb_phy *phy)
 	else if (sphy->drv_data->set_isolation)
 		sphy->drv_data->set_isolation(sphy, true);
 
-	spin_unlock_irqrestore(&sphy->lock, flags);
+	mutex_unlock(&sphy->mutex);
 
 	clk_disable_unprepare(sphy->clk);
 }
@@ -422,7 +420,7 @@ static int samsung_usb2phy_probe(struct platform_device *pdev)
 	sphy->phy.otg->phy	= &sphy->phy;
 	sphy->phy.otg->set_host = samsung_usbphy_set_host;
 
-	spin_lock_init(&sphy->lock);
+	mutex_init(&sphy->mutex);
 
 	platform_set_drvdata(pdev, sphy);
 
diff --git a/drivers/usb/phy/phy-samsung-usb3.c b/drivers/usb/phy/phy-samsung-usb3.c
index 300e0cf..6ec3f08 100644
--- a/drivers/usb/phy/phy-samsung-usb3.c
+++ b/drivers/usb/phy/phy-samsung-usb3.c
@@ -164,7 +164,6 @@ static void samsung_exynos5_usb3phy_disable(struct samsung_usbphy *sphy)
 static int samsung_usb3phy_init(struct usb_phy *phy)
 {
 	struct samsung_usbphy *sphy;
-	unsigned long flags;
 	int ret = 0;
 
 	sphy = phy_to_sphy(phy);
@@ -176,7 +175,7 @@ static int samsung_usb3phy_init(struct usb_phy *phy)
 		return ret;
 	}
 
-	spin_lock_irqsave(&sphy->lock, flags);
+	mutex_lock(&sphy->mutex);
 
 	/* setting default phy-type for USB 3.0 */
 	samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
@@ -188,7 +187,7 @@ static int samsung_usb3phy_init(struct usb_phy *phy)
 	/* Initialize usb phy registers */
 	sphy->drv_data->phy_enable(sphy);
 
-	spin_unlock_irqrestore(&sphy->lock, flags);
+	mutex_unlock(&sphy->mutex);
 
 	/* Disable the phy clock */
 	clk_disable_unprepare(sphy->clk);
@@ -202,7 +201,6 @@ static int samsung_usb3phy_init(struct usb_phy *phy)
 static void samsung_usb3phy_shutdown(struct usb_phy *phy)
 {
 	struct samsung_usbphy *sphy;
-	unsigned long flags;
 
 	sphy = phy_to_sphy(phy);
 
@@ -211,7 +209,7 @@ static void samsung_usb3phy_shutdown(struct usb_phy *phy)
 		return;
 	}
 
-	spin_lock_irqsave(&sphy->lock, flags);
+	mutex_lock(&sphy->mutex);
 
 	/* setting default phy-type for USB 3.0 */
 	samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
@@ -223,7 +221,7 @@ static void samsung_usb3phy_shutdown(struct usb_phy *phy)
 	if (sphy->drv_data->set_isolation)
 		sphy->drv_data->set_isolation(sphy, true);
 
-	spin_unlock_irqrestore(&sphy->lock, flags);
+	mutex_unlock(&sphy->mutex);
 
 	clk_disable_unprepare(sphy->clk);
 }
@@ -279,7 +277,7 @@ static int samsung_usb3phy_probe(struct platform_device *pdev)
 	if (sphy->ref_clk_freq < 0)
 		return -EINVAL;
 
-	spin_lock_init(&sphy->lock);
+	mutex_init(&sphy->mutex);
 
 	platform_set_drvdata(pdev, sphy);
 
-- 
1.7.12.4

