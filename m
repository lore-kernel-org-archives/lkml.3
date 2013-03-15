Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab3COPQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:16:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40403 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab3COPQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:16:56 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 02/23] ARM: OMAP2+: omap-usb-host: Add usbhs_init_phys()
Date: Fri, 15 Mar 2013 17:16:23 +0200
Message-ID: <1363360604-21368-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363360604-21368-1-git-send-email-rogerq@ti.com>
References: <1363360604-21368-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helper allows board support code to add the PHY's
VCC and RESET regulators which are GPIO controlled.

It also links the "vcc" and "reset" supplies to the
PHY's device ID that is supplied in the struct usbhs_phy_data
argument.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/usb-host.c |  138 +++++++++++++++++++++++++++++++++++++++-
 arch/arm/mach-omap2/usb.h      |    9 +++
 2 files changed, 145 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
index 5706bdc..e788fe5 100644
--- a/arch/arm/mach-omap2/usb-host.c
+++ b/arch/arm/mach-omap2/usb-host.c
@@ -22,8 +22,11 @@
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
 
 #include "soc.h"
 #include "omap_device.h"
@@ -526,3 +529,134 @@ void __init usbhs_init(struct usbhs_omap_platform_data *pdata)
 }
 
 #endif
+
+static const char *reset_supply = "reset";
+static const char *vcc_supply = "vcc";
+
+/* Template for PHY regulators */
+static struct regulator_consumer_supply hsusb_reg_supplies[] = {
+	{ /* .supply & .dev_name filled later */ },
+};
+
+static struct regulator_init_data hsusb_reg_data = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
+	.consumer_supplies	= hsusb_reg_supplies,
+	.num_consumer_supplies	= ARRAY_SIZE(hsusb_reg_supplies),
+};
+
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
+static struct platform_device_info hsusb_reg_pdev_info = {
+	.name	= "reg-fixed-voltage",
+	.id	= PLATFORM_DEVID_AUTO,
+};
+
+int usbhs_init_phys(struct usbhs_phy_data *phy, int num_phys)
+{
+	struct regulator_consumer_supply *supplies;
+	struct regulator_init_data *reg_data;
+	struct fixed_voltage_config *config;
+	char *supply_name;
+	int i;
+
+	for (i = 0; i < num_phys; i++) {
+
+		if (!phy->phy_id || !phy->port) {
+			pr_info("%s: Invalid phy_id or port\n", __func__);
+			continue;
+		}
+
+		if (!gpio_is_valid(phy->reset_gpio))
+			goto check_vcc;
+
+		supplies = kmemdup(hsusb_reg_supplies,
+			    ARRAY_SIZE(hsusb_reg_supplies) *
+			    sizeof(struct regulator_consumer_supply),
+			    GFP_KERNEL);
+		if (!supplies)
+			return -ENOMEM;
+
+		supplies->supply = reset_supply;
+		supplies->dev_name = phy->phy_id;
+
+		reg_data = kmemdup(&hsusb_reg_data, sizeof(hsusb_reg_data),
+							GFP_KERNEL);
+		if (!reg_data)
+			return -ENOMEM;
+
+		reg_data->consumer_supplies = supplies;
+
+		config = kmemdup(&hsusb_reg_config, sizeof(hsusb_reg_config),
+							GFP_KERNEL);
+		if (!config)
+			return -ENOMEM;
+
+		supply_name = kmalloc(14, GFP_KERNEL);
+		if (!supply_name)
+			return -ENOMEM;
+
+		scnprintf(supply_name, 13, "hsusb%d_reset", phy->port);
+		config->supply_name = supply_name;
+		config->gpio = phy->reset_gpio;
+		config->init_data = reg_data;
+
+		hsusb_reg_pdev_info.data = config;
+		hsusb_reg_pdev_info.size_data = sizeof(hsusb_reg_config);
+		platform_device_register_full(&hsusb_reg_pdev_info);
+
+check_vcc:
+		if (!gpio_is_valid(phy->vcc_gpio))
+			goto next;
+
+		supplies = kmemdup(hsusb_reg_supplies,
+			    ARRAY_SIZE(hsusb_reg_supplies) *
+			    sizeof(struct regulator_consumer_supply),
+			    GFP_KERNEL);
+		if (!supplies)
+			return -ENOMEM;
+
+		supplies->supply = vcc_supply;
+		supplies->dev_name = phy->phy_id;
+
+		reg_data = kmemdup(&hsusb_reg_data, sizeof(hsusb_reg_data),
+							GFP_KERNEL);
+		if (!reg_data)
+			return -ENOMEM;
+
+		reg_data->consumer_supplies = supplies;
+
+		config = kmemdup(&hsusb_reg_config, sizeof(hsusb_reg_config),
+							GFP_KERNEL);
+		if (!config)
+			return -ENOMEM;
+
+		supply_name = kmalloc(14, GFP_KERNEL);
+		if (!supply_name)
+			return -ENOMEM;
+
+		scnprintf(supply_name, 13, "hsusb%d_vcc", phy->port);
+		config->supply_name = supply_name;
+		config->gpio = phy->vcc_gpio;
+		config->enable_high = phy->vcc_polarity;
+		config->init_data = reg_data;
+
+		hsusb_reg_pdev_info.data = config;
+		hsusb_reg_pdev_info.size_data = sizeof(hsusb_reg_config);
+		platform_device_register_full(&hsusb_reg_pdev_info);
+
+next:
+		phy++;
+	}
+
+	return 0;
+}
diff --git a/arch/arm/mach-omap2/usb.h b/arch/arm/mach-omap2/usb.h
index 3319f5c..4c21863 100644
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
+	char *phy_id;
+};
+
 extern void usb_musb_init(struct omap_musb_board_data *board_data);
 extern void usbhs_init(struct usbhs_omap_platform_data *pdata);
+extern int usbhs_init_phys(struct usbhs_phy_data *phy, int num_phys);
 
 extern void am35x_musb_reset(void);
 extern void am35x_musb_phy_power(u8 on);
-- 
1.7.4.1

