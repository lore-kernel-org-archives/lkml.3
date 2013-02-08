Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005Ab3BHHbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:31:01 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19350 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946058Ab3BHHaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:30:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 07 Feb 2013 23:30:21 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: <arnd@arndb.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] ARM: tegra: Restore USB/PCIE info in new DT board file
Date: Fri, 8 Feb 2013 09:29:34 +0200
Message-ID: <1360308574-19658-5-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com>
References: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainly for the compatibility for the existing driver.
This would be removed once new USB/PCIE DT supports come.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/tegra.c |   92 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 90 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index 62ae39a..82fea64 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -23,6 +23,8 @@
 #include <linux/of_fdt.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/platform_data/tegra_usb.h>
+#include <linux/usb/tegra_usb_phy.h>
 
 #include <asm/mach/arch.h>
 
@@ -30,9 +32,63 @@
 #include "common.h"
 #include "iomap.h"
 
+#ifdef USB_EHCI_TEGRA
+static struct tegra_ulpi_config tegra_ehci2_ulpi_phy_config = {
+	.reset_gpio = -1,
+	.clk = "cdev2",
+};
+
+static struct tegra_ehci_platform_data tegra_ehci_pdata[] = {
+	{
+		.operating_mode = TEGRA_USB_OTG,
+		.power_down_on_bus_suspend = 1,
+		.vbus_gpio = -1,
+	},
+	{
+		.operating_mode = TEGRA_USB_HOST,
+		.power_down_on_bus_suspend = 1,
+		.vbus_gpio = -1,
+		.phy_config = &tegra_ehci2_ulpi_phy_config,
+	},
+	{
+		.operating_mode = TEGRA_USB_HOST,
+		.power_down_on_bus_suspend = 1,
+		.vbus_gpio = -1,
+	},
+};
+
 static struct of_dev_auxdata tegra_auxdata_lookup[] __initdata = {
-	{},
+	OF_DEV_AUXDATA("nvidia,tegra20-ehci", 0xc5000000, "tegra-ehci.0", &tegra_ehci_pdata[0]),
+	OF_DEV_AUXDATA("nvidia,tegra20-ehci", 0xc5004000, "tegra-ehci.1", &tegra_ehci_pdata[1]),
+	OF_DEV_AUXDATA("nvidia,tegra20-ehci", 0xC5008000, "tegra-ehci.2", &tegra_ehci_pdata[2]),
+	{}
 };
+#else
+#define tegra_auxdata_lookup	NULL
+#endif
+
+#if defined(CONFIG_TEGRA_PCI) && defined(CONFIG_ARCH_TEGRA_2x_SOC)
+static void __init trimslice_init(void)
+{
+	int err;
+
+	err = tegra_pcie_init(true, true);
+	if (err)
+		pr_err("%s failed: %d\n", __func__, err);
+}
+static void __init harmony_init(void)
+{
+	harmony_pcie_init();
+}
+static void __init paz00_init(void)
+{
+	tegra_paz00_wifikill_init();
+}
+#else
+#define trimslice_init	NULL
+#define harmony_init	NULL
+#define paz00_init	NULL
+#endif
 
 static void __init tegra_dt_init(void)
 {
@@ -40,6 +96,38 @@ static void __init tegra_dt_init(void)
 			     tegra_auxdata_lookup, NULL);
 }
 
+static void __init tegra_dt_init_late(void)
+{
+	int i;
+	struct {
+		const char *name;
+		void (*init)(void);
+	} board[] = {
+		{
+			.name = "compulab,trimslice",
+			.init = trimslice_init,
+		},
+		{
+			.name = "nvidia,harmony",
+			.init = harmony_init,
+		},
+		{
+			.name = "compal,paz00",
+			.init = paz00_init
+		},
+	};
+
+	tegra_init_late();
+
+	for (i = 0; i < ARRAY_SIZE(board); i++) {
+		if (of_machine_is_compatible(board[i].name)) {
+			if (board[i].init)
+				board[i].init();
+			break;
+		}
+	}
+}
+
 static const char * const tegra_dt_board_compat[] = {
 	"nvidia,tegra20",
 	"nvidia,tegra30",
@@ -54,7 +142,7 @@ DT_MACHINE_START(TEGRA_DT, "NVIDIA Tegra SoC (Flattened Device Tree)")
 	.init_irq	= tegra_dt_init_irq,
 	.init_time	= clocksource_of_init,
 	.init_machine	= tegra_dt_init,
-	.init_late	= tegra_init_late,
+	.init_late	= tegra_dt_init_late,
 	.restart	= tegra_assert_system_reset,
 	.dt_compat	= tegra_dt_board_compat,
 MACHINE_END
-- 
1.7.9.5

