Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3HKQlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:41:19 -0400
Received: from ring0.de ([91.143.88.219]:44614 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab3HKQkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:40:39 -0400
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: ring0.de]
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Sebastian Reichel <sre@ring0.de>
Subject: [PATCH 3/3] ARM: OMAP2+: Add SSI driver configuration
Date: Sun, 11 Aug 2013 18:17:57 +0200
Message-Id: <1376237877-1740-3-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376237877-1740-1-git-send-email-sre@debian.org>
References: <1376237628-1077-1-git-send-email-sre@debian.org>
 <1376237877-1740-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Reichel <sre@ring0.de>

This patch configures and activates the OMAP SSI driver on the RX-51.
---
 arch/arm/mach-omap2/Makefile                 |    4 ++
 arch/arm/mach-omap2/board-rx51-peripherals.c |   10 +++-
 arch/arm/mach-omap2/ssi.c                    |   82 ++++++++++++++++++++++++++
 3 files changed, 95 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-omap2/ssi.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index d4f6715..ace860d 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -222,6 +222,10 @@ ifneq ($(CONFIG_DRM_OMAP),)
 obj-y					+= drm.o
 endif
 
+# Synchronous Serial Interface (SSI)
+omap-ssi-$(CONFIG_OMAP_SSI)		:= ssi.o
+obj-y					+= $(omap-ssi-m) $(omap-ssi-y)
+
 # Specific board support
 obj-$(CONFIG_MACH_OMAP_GENERIC)		+= board-generic.o
 obj-$(CONFIG_MACH_OMAP_H4)		+= board-h4.o
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 9c2dd10..e2ca155 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -27,6 +27,7 @@
 #include <linux/power/isp1704_charger.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/mtd-onenand-omap2.h>
+#include <linux/platform_data/hsi-omap-ssi.h>
 
 #include <asm/system_info.h>
 
@@ -73,6 +74,8 @@
 #define LIS302_IRQ1_GPIO 181
 #define LIS302_IRQ2_GPIO 180  /* Not yet in use */
 
+#define RX51_CAWAKE_GPIO 151
+
 /* List all SPI devices here. Note that the list/probe order seems to matter! */
 enum {
 	RX51_SPI_WL1251,
@@ -265,6 +268,11 @@ static struct spi_board_info rx51_peripherals_spi_board_info[] __initdata = {
 	},
 };
 
+static struct omap_ssi_board_config ssi_board_config = {
+	.num_ports = 1,
+	.cawake_gpio = { RX51_CAWAKE_GPIO },
+};
+
 static struct platform_device rx51_battery_device = {
 	.name	= "rx51-battery",
 	.id	= -1,
@@ -1295,7 +1303,7 @@ void __init rx51_peripherals_init(void)
 	if (partition)
 		omap_hsmmc_init(mmc);
 
+	omap_ssi_config(&ssi_board_config);
 	rx51_charger_init();
 	rx51_init_twl4030_hwmon();
 }
-
diff --git a/arch/arm/mach-omap2/ssi.c b/arch/arm/mach-omap2/ssi.c
new file mode 100644
index 0000000..a9d6eee
--- /dev/null
+++ b/arch/arm/mach-omap2/ssi.c
@@ -0,0 +1,82 @@
+/*
+ * linux/arch/arm/mach-omap2/ssi.c
+ *
+ * Copyright (C) 2010 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/hsi-omap-ssi.h>
+#include "omap_hwmod.h"
+#include "omap_device.h"
+#include "omap-pm.h"
+
+static struct omap_ssi_platform_data ssi_pdata = {
+	.num_ports      = SSI_NUM_PORTS,
+	.cawake_gpio    = {0},
+	.get_dev_context_loss_count  = omap_pm_get_dev_context_loss_count,
+};
+
+int __init omap_ssi_config(struct omap_ssi_board_config *ssi_config)
+{
+	unsigned int port, offset, cawake_gpio;
+	int err;
+
+	ssi_pdata.num_ports = ssi_config->num_ports;
+
+	for (port = 0, offset = 7; port < ssi_config->num_ports; port++, offset += 5) {
+		cawake_gpio = ssi_config->cawake_gpio[port];
+		if (!cawake_gpio)
+			continue; /* Nothing to do */
+		err = gpio_request(cawake_gpio, "cawake");
+		if (err < 0)
+			goto rback;
+		gpio_direction_input(cawake_gpio);
+
+		ssi_pdata.cawake_gpio[port] = ssi_config->cawake_gpio[port];
+	}
+
+	return 0;
+
+rback:
+	pr_err("omap-ssi: Request cawake (gpio%d) failed\n", cawake_gpio);
+	while (port > 0)
+		gpio_free(ssi_config->cawake_gpio[--port]);
+
+	return err;
+}
+
+static int __init omap_ssi_init(void)
+{
+	struct omap_hwmod *oh;
+	struct platform_device *pdev;
+
+	oh = omap_hwmod_lookup("ssi");
+	if (!oh)
+		return -EINVAL;
+
+	pdev = omap_device_build("omap_ssi", 0, oh, &ssi_pdata, sizeof(struct omap_ssi_platform_data));
+	WARN(IS_ERR(pdev), "Can't build omap_device for omap_ssi\n");
+
+	return 0;
+}
+subsys_initcall(omap_ssi_init);
-- 
1.7.10.4

