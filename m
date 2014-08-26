Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbaHZNNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:13:01 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60199 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbaHZNM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:12:56 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Terje=20Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v4 3/3] memory: tegra124-emc: Add EMC driver
Date: Tue, 26 Aug 2014 15:12:08 +0200
Message-Id: <1409058728-13347-4-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409058728-13347-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1409058728-13347-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sets the EMC clock rate based on the bandwidth requirements registered by
memory clients through the PM_QOS_MEMORY_BANDWIDTH class.

Note: this is just an example and not a proper driver for a external memory
controller. Its only purpose is to illustrate how such a driver would set the
frequency of the external memory clock based on the bandwidth requirements of
memory clients.

---

v4: * Add hack so the driver gets actually registered.
    * Use the tegra-clk-debug dev_id to query the EMC clock
    * Get units right and use types consistently
---
 arch/arm/mach-tegra/tegra.c   |  10 ++++
 drivers/memory/Kconfig        |   9 ++++
 drivers/memory/Makefile       |   1 +
 drivers/memory/tegra124-emc.c | 117 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 137 insertions(+)
 create mode 100644 drivers/memory/tegra124-emc.c

diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index 5ef5173..099d8e7f 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -70,6 +70,11 @@ u32 tegra_uart_config[3] = {
 	0,
 };
 
+static struct platform_device tegra_emc = {
+	.name	= "tegra124-emc",
+	.id	= -1,
+};
+
 static void __init tegra_init_early(void)
 {
 	of_register_trusted_foundations();
@@ -112,6 +117,11 @@ static void __init tegra_dt_init(void)
 	parent = soc_device_to_device(soc_dev);
 
 	/*
+	 * HACK: register a platform device to probe the driver
+	 */
+	platform_device_register(&tegra_emc);
+
+	/*
 	 * Finished with the static registrations now; fill in the missing
 	 * devices
 	 */
diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index fab81a1..2088b2b 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -61,6 +61,15 @@ config TEGRA30_MC
 	  analysis, especially for IOMMU/SMMU(System Memory Management
 	  Unit) module.
 
+config TEGRA124_EMC
+	tristate "Tegra124 External Memory Controller (EMC) driver"
+	default y
+	depends on ARCH_TEGRA_124_SOC
+	help
+	  This driver is for the External Memory Controller (EMC) module
+	  available in Tegra124 SoCs.
+
+
 config FSL_CORENET_CF
 	tristate "Freescale CoreNet Error Reporting"
 	depends on FSL_SOC_BOOKE
diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
index 4055c47..0a6d117 100644
--- a/drivers/memory/Makefile
+++ b/drivers/memory/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
 obj-$(CONFIG_MVEBU_DEVBUS)	+= mvebu-devbus.o
 obj-$(CONFIG_TEGRA20_MC)	+= tegra20-mc.o
 obj-$(CONFIG_TEGRA30_MC)	+= tegra30-mc.o
+obj-$(CONFIG_TEGRA124_EMC)	+= tegra124-emc.o
diff --git a/drivers/memory/tegra124-emc.c b/drivers/memory/tegra124-emc.c
new file mode 100644
index 0000000..a290ad5
--- /dev/null
+++ b/drivers/memory/tegra124-emc.c
@@ -0,0 +1,117 @@
+/*
+ * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/clk.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_qos.h>
+
+#define DRV_NAME "tegra124-emc"
+#define EMC_FREQ_CUTOFF_USE_130_PERCENT	100000000
+#define EMC_FREQ_CUTOFF_USE_140_PERCENT	50000000
+#define BYTES_PER_EMC_CLOCK 16
+
+struct tegra124_emc {
+	struct clk *clk;
+	struct notifier_block memory_bw_notifier;
+};
+
+static struct platform_device *emc_pdev;
+
+static unsigned long tegra124_emc_bw_to_freq_req(s32 bw)
+{
+	return (bw * 8 + BYTES_PER_EMC_CLOCK - 1) / BYTES_PER_EMC_CLOCK;
+}
+
+static void tegra124_emc_update_rate(struct tegra124_emc *emc, s32 total_bandwidth)
+{
+	struct clk *emc_master;
+	unsigned long freq;
+
+	emc_master = clk_get_parent(emc->clk);
+	freq = tegra124_emc_bw_to_freq_req(total_bandwidth * 1024);
+	freq = clk_round_rate(emc_master, freq);
+
+	/* Depending on frequency value, the amount of bandwidth usage % of
+	 * total we should use is different. Thus we should request a multiple of
+	 * original bandwidth on this.  Use 1.4 for < 50MHz, 1.3 for < 100MHz,
+	 * else 1.1 */
+	if (freq < EMC_FREQ_CUTOFF_USE_140_PERCENT)
+		total_bandwidth += 4 * total_bandwidth / 10; /* 1.4 */
+	else if (freq < EMC_FREQ_CUTOFF_USE_130_PERCENT)
+		total_bandwidth += 3 * total_bandwidth / 10; /* 1.3 */
+	else
+		total_bandwidth += total_bandwidth / 10; /* 1.1 */
+
+	freq = tegra124_emc_bw_to_freq_req(total_bandwidth * 1024);
+
+	clk_set_floor_rate(emc->clk, freq);
+}
+
+int memory_bw_notify(struct notifier_block *nb, unsigned long data, void *dummy)
+{
+	s32 total_bw = (s32) data;
+	struct tegra124_emc *emc =
+		container_of(nb, struct tegra124_emc,
+			     memory_bw_notifier);
+
+	tegra124_emc_update_rate(emc, total_bw);
+
+	return NOTIFY_OK;
+}
+
+static int tegra124_emc_probe(struct platform_device *pdev)
+{
+	struct tegra124_emc *emc;
+
+	emc_pdev = pdev;
+
+	emc = devm_kzalloc(&pdev->dev, sizeof(*emc), GFP_KERNEL);
+	if (emc == NULL) {
+		dev_err(&pdev->dev, "Failed to allocate private memory\n");
+		return -ENOMEM;
+	}
+
+	emc->clk = clk_get_sys("tegra-clk-debug", "emc");
+	if (IS_ERR(emc->clk)) {
+		devm_kfree(&pdev->dev, emc);
+		dev_err(&pdev->dev, "Can not find EMC clock\n");
+		return -EPROBE_DEFER;
+	}
+
+	platform_set_drvdata(emc_pdev, emc);
+
+	emc->memory_bw_notifier.notifier_call = memory_bw_notify;
+	pm_qos_add_notifier(PM_QOS_MEMORY_BANDWIDTH, &emc->memory_bw_notifier);
+
+	return 0;
+}
+
+static struct platform_driver tegra124_emc_driver = {
+	.driver         = {
+		.name   = DRV_NAME,
+		.owner  = THIS_MODULE,
+	},
+	.probe          = tegra124_emc_probe,
+};
+
+module_platform_driver(tegra124_emc_driver);
+
+MODULE_AUTHOR("Tomeu Vizoso <tomeu.vizoso@collabora.com>");
+MODULE_DESCRIPTION("Tegra124 EMC driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.9.3

