Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458Ab3CTPqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:46:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54219 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab3CTPqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:46:15 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 02/21] ARM: OMAP2+: omap-usb-host: Add usbhs_init_phys()
Date: Wed, 20 Mar 2013 17:44:41 +0200
Message-ID: <1363794300-31526-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363794300-31526-1-git-send-email-rogerq@ti.com>
References: <1363794300-31526-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helper allows board support code to add the PHY's
VCC and RESET regulators which are GPIO controlled as well
as the NOP PHY device.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/usb-host.c |  160 +++++++++++++++++++++++++++++++++++++++-
 arch/arm/mach-omap2/usb.h      |    9 ++
 2 files changed, 167 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
index 5706bdc..aa27d7f 100644
--- a/arch/arm/mach-omap2/usb-host.c
+++ b/arch/arm/mach-omap2/usb-host.c
@@ -22,8 +22,12 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
-
-#include <asm/io.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
+#include <linux/string.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/usb/phy.h>
 
 #include "soc.h"
 #include "omap_device.h"
@@ -526,3 +530,155 @@ void __init usbhs_init(struct usbhs_omap_platform_data *pdata)
 }
 
 #endif
+
+/* Template for PHY regulators */
+static struct fixed_voltage_config hsusb_reg_config = {
+	/* .supply_name filled later */
+	.microvolts = 3300000,
+	.gpio = -1,		/* updated later */
+	.startup_delay = 70000, /* 70msec */
+	.enable_high = 1,	/* updated later */
+	.enabled_at_boot = 0,	/* keep in RESET */
+	/* .init_data filled later */
+};
+
+static const char *nop_name = "nop_usb_xceiv"; /* NOP PHY driver */
+static const char *reg_name = "reg-fixed-voltage"; /* Regulator driver */
+
+/**
+ * usbhs_add_regulator - Add a gpio based fixed voltage regulator device
+ * @name: name for the regulator
+ * @dev_id: device id of the device this regulator supplies power to
+ * @dev_supply: supply name that the device expects
+ * @gpio: GPIO number
+ * @polarity: 1 - Active high, 0 - Active low
+ */
+static int usbhs_add_regulator(char *name, char *dev_id, char *dev_supply,
+						int gpio, int polarity)
+{
+	struct regulator_consumer_supply *supplies;
+	struct regulator_init_data *reg_data;
+	struct fixed_voltage_config *config;
+	struct platform_device *pdev;
+	int ret;
+
+	supplies = kzalloc(sizeof(*supplies), GFP_KERNEL);
+	if (!supplies)
+		return -ENOMEM;
+
+	supplies->supply = dev_supply;
+	supplies->dev_name = dev_id;
+
+	reg_data = kzalloc(sizeof(*reg_data), GFP_KERNEL);
+	if (!reg_data)
+		return -ENOMEM;
+
+	reg_data->constraints.valid_ops_mask = REGULATOR_CHANGE_STATUS;
+	reg_data->consumer_supplies = supplies;
+	reg_data->num_consumer_supplies = 1;
+
+	config = kmemdup(&hsusb_reg_config, sizeof(hsusb_reg_config),
+			GFP_KERNEL);
+	if (!config)
+		return -ENOMEM;
+
+	config->supply_name = name;
+	config->gpio = gpio;
+	config->enable_high = polarity;
+	config->init_data = reg_data;
+
+	/* create a regulator device */
+	pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
+	if (!pdev)
+		return -ENOMEM;
+
+	pdev->id = PLATFORM_DEVID_AUTO;
+	pdev->name = reg_name;
+	pdev->dev.platform_data = config;
+
+	ret = platform_device_register(pdev);
+	if (ret)
+		pr_err("%s: Failed registering regulator %s for %s\n",
+				__func__, name, dev_id);
+
+	return ret;
+}
+
+int usbhs_init_phys(struct usbhs_phy_data *phy, int num_phys)
+{
+	char *rail_name;
+	int i, len;
+	struct platform_device *pdev;
+	char *phy_id;
+
+	/* the phy_id will be something like "nop_usb_xceiv.1" */
+	len = strlen(nop_name) + 3; /* 3 -> ".1" and NULL terminator */
+
+	for (i = 0; i < num_phys; i++) {
+
+		if (!phy->port) {
+			pr_err("%s: Invalid port 0. Must start from 1\n",
+						__func__);
+			continue;
+		}
+
+		/* do we need a NOP PHY device ? */
+		if (!gpio_is_valid(phy->reset_gpio) &&
+			!gpio_is_valid(phy->vcc_gpio))
+			continue;
+
+		/* create a NOP PHY device */
+		pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
+		if (!pdev)
+			return -ENOMEM;
+
+		pdev->id = phy->port;
+		pdev->name = nop_name;
+		pdev->dev.platform_data = phy->platform_data;
+
+		phy_id = kmalloc(len, GFP_KERNEL);
+		if (!phy_id)
+			return -ENOMEM;
+
+		scnprintf(phy_id, len, "nop_usb_xceiv.%d\n",
+					pdev->id);
+
+		if (platform_device_register(pdev)) {
+			pr_err("%s: Failed to register device %s\n",
+				__func__,  phy_id);
+			continue;
+		}
+
+		usb_bind_phy("ehci-omap.0", phy->port - 1, phy_id);
+
+		/* Do we need RESET regulator ? */
+		if (gpio_is_valid(phy->reset_gpio)) {
+
+			rail_name = kmalloc(13, GFP_KERNEL);
+			if (!rail_name)
+				return -ENOMEM;
+
+			scnprintf(rail_name, 13, "hsusb%d_reset", phy->port);
+
+			usbhs_add_regulator(rail_name, phy_id, "reset",
+						phy->reset_gpio, 1);
+		}
+
+		/* Do we need VCC regulator ? */
+		if (gpio_is_valid(phy->vcc_gpio)) {
+
+			rail_name = kmalloc(13, GFP_KERNEL);
+			if (!rail_name)
+				return -ENOMEM;
+
+			scnprintf(rail_name, 13, "hsusb%d_vcc", phy->port);
+
+			usbhs_add_regulator(rail_name, phy_id, "vcc",
+					phy->vcc_gpio, phy->vcc_polarity);
+		}
+
+		phy++;
+	}
+
+	return 0;
+}
diff --git a/arch/arm/mach-omap2/usb.h b/arch/arm/mach-omap2/usb.h
index 3319f5c..e7261eb 100644
--- a/arch/arm/mach-omap2/usb.h
+++ b/arch/arm/mach-omap2/usb.h
@@ -53,8 +53,17 @@
 #define USBPHY_OTGSESSEND_EN	(1 << 20)
 #define USBPHY_DATA_POLARITY	(1 << 23)
 
+struct usbhs_phy_data {
+	int port;		/* 1 indexed port number */
+	int reset_gpio;
+	int vcc_gpio;
+	bool vcc_polarity;	/* 1 active high, 0 active low */
+	void *platform_data;
+};
+
 extern void usb_musb_init(struct omap_musb_board_data *board_data);
 extern void usbhs_init(struct usbhs_omap_platform_data *pdata);
+extern int usbhs_init_phys(struct usbhs_phy_data *phy, int num_phys);
 
 extern void am35x_musb_reset(void);
 extern void am35x_musb_phy_power(u8 on);
-- 
1.7.4.1

