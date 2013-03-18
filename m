Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3CRNWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:22:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37803 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3CRNWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:22:16 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: [PATCH/Resend 2/2] arm: mach-omap2: prevent UART console idle on suspend while using "no_console_suspend"
Date: Mon, 18 Mar 2013 18:52:04 +0530
Message-ID: <1363612924-349-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With dt boot, uart wakeup after suspend is non functional on omap4/5 while using
"no_console_suspend" in the bootargs. With "no_console_suspend" used, od->flags
should be ORed with "OMAP_DEVICE_NO_IDLE_ON_SUSPEND", thereby not allowing the console
to idle in the suspend path. For non-dt case, this was taken care by platform data.

Tested on omap5430evm, omap4430sdp.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Rajendra nayak <rnayak@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 arch/arm/mach-omap2/omap_device.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index 381be7a..71f5a73 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -35,11 +35,17 @@
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/notifier.h>
+#include <linux/platform_data/serial-omap.h>
 
 #include "soc.h"
 #include "omap_device.h"
 #include "omap_hwmod.h"
 
+#define MAX_UART_HWMOD_NAME_LEN         16
+
+static u8 no_console_suspend;
+static u8 console_uart_num;
+
 /* Private functions */
 
 static void _add_clkdev(struct omap_device *od, const char *clk_alias,
@@ -108,6 +114,12 @@ static void _add_hwmod_clocks_clkdev(struct omap_device *od,
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
@@ -129,6 +141,7 @@ static int omap_device_build_from_dt(struct platform_device *pdev)
 	struct device_node *node = pdev->dev.of_node;
 	const char *oh_name;
 	int oh_cnt, i, ret = 0;
+	static u8 console_uart_id;
 
 	oh_cnt = of_property_count_strings(node, "ti,hwmods");
 	if (!oh_cnt || IS_ERR_VALUE(oh_cnt)) {
@@ -170,7 +183,12 @@ static int omap_device_build_from_dt(struct platform_device *pdev)
 			r->name = dev_name(&pdev->dev);
 	}
 
-	if (of_get_property(node, "ti,no_idle_on_suspend", NULL))
+	if (no_console_suspend && !strncmp(oh->name, "uart", 4)) {
+		if (console_uart_num == console_uart_id)
+			omap_device_disable_idle_on_suspend(pdev);
+		else
+			console_uart_id++;
+	} else if (of_get_property(node, "ti,no_idle_on_suspend", NULL))
 		omap_device_disable_idle_on_suspend(pdev);
 
 	pdev->dev.pm_domain = &omap_device_pm_domain;
@@ -838,7 +856,21 @@ static struct notifier_block platform_nb = {
 
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
 omap_core_initcall(omap_device_init);
-- 
1.7.1

