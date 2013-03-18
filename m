Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab3CRK52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:57:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59155 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3CRK5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:57:23 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: [PATCH 2/2] arm: mach-omap2: prevent UART console idle on suspend while using "no_console_suspend"
Date: Mon, 18 Mar 2013 16:27:13 +0530
Message-ID: <1363604233-11295-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With dt boot on omap5, uart wakeup after suspend is non functional while using
"no_console_suspend" in the bootargs. With "no_console_suspend" used, od->flags
should be ORed with "OMAP_DEVICE_NO_IDLE_ON_SUSPEND", thereby not allowing the console
to idle in the suspend path. For non-dt case, this was taken care by platform data.

Tested on omap5430evm, omap4430sdp.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Rajendra nayak <rnayak@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 arch/arm/mach-omap2/omap_device.c |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index e065daa..ed3404c 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -88,6 +88,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/notifier.h>
+#include <linux/platform_data/serial-omap.h>
 
 #include "omap_device.h"
 #include "omap_hwmod.h"
@@ -96,6 +97,11 @@
 #define USE_WAKEUP_LAT			0
 #define IGNORE_WAKEUP_LAT		1
 
+#define MAX_UART_HWMOD_NAME_LEN         16
+
+static u8 no_console_suspend;
+static u8 console_uart_num;
+
 static int omap_early_device_register(struct platform_device *pdev);
 
 static struct omap_device_pm_latency omap_default_latency[] = {
@@ -307,6 +313,12 @@ static void _add_hwmod_clocks_clkdev(struct omap_device *od,
 		_add_clkdev(od, oh->opt_clks[i].role, oh->opt_clks[i].clk);
 }
 
+static char *cmdline_find_option(char *str)
+{
+	extern char *saved_command_line;
+
+	return strstr(saved_command_line, str);
+}
 
 /**
  * omap_device_build_from_dt - build an omap_device with multiple hwmods
@@ -331,6 +343,7 @@ static int omap_device_build_from_dt(struct platform_device *pdev)
 	struct device_node *node = pdev->dev.of_node;
 	const char *oh_name;
 	int oh_cnt, i, ret = 0;
+	static u8 console_uart_id;
 
 	oh_cnt = of_property_count_strings(node, "ti,hwmods");
 	if (!oh_cnt || IS_ERR_VALUE(oh_cnt)) {
@@ -372,7 +385,13 @@ static int omap_device_build_from_dt(struct platform_device *pdev)
 			r->name = dev_name(&pdev->dev);
 	}
 
-	if (of_get_property(node, "ti,no_idle_on_suspend", NULL))
+	if (no_console_suspend && !strncmp(oh->name, "uart", 4)) {
+		if (console_uart_num == console_uart_id)
+			omap_device_disable_idle_on_suspend(pdev);
+		else
+			console_uart_id++;
+	}
+	else if (of_get_property(node, "ti,no_idle_on_suspend", NULL))
 		omap_device_disable_idle_on_suspend(pdev);
 
 	pdev->dev.pm_domain = &omap_device_pm_domain;
@@ -1256,7 +1275,21 @@ static struct notifier_block platform_nb = {
 
 static int __init omap_device_init(void)
 {
+	int i;
+	char uart_name[MAX_UART_HWMOD_NAME_LEN];
+
 	bus_register_notifier(&platform_bus_type, &platform_nb);
+
+	if (cmdline_find_option("no_console_suspend")) {
+		no_console_suspend = true;
+		for (i = 0; i < OMAP_MAX_HSUART_PORTS; i++) {
+			snprintf(uart_name, MAX_UART_HWMOD_NAME_LEN,
+				"%s%d", OMAP_SERIAL_NAME, i);
+			if (cmdline_find_option(uart_name))
+				console_uart_num = i;
+		}
+	}
+
 	return 0;
 }
 core_initcall(omap_device_init);
-- 
1.7.1

