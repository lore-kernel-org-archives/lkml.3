Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaHOMw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 08:52:57 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:65302 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaHOMwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 08:52:53 -0400
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
Subject: [RFC v2 3/3] memory: tegra124-emc: Add EMC driver
Date: Fri, 15 Aug 2014 14:52:09 +0200
Message-Id: <1408107129-29516-4-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408107129-29516-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1408107129-29516-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sets the EMC clock rate based on the bandwidth requirements registered by
memory clients through the PM_QOS_MEMORY_BANDWIDTH class.

Note: this is not a proper driver for a external memory controller. Its only
purpose is to illustrate how such a driver would set the frequency of the
external memory clock based on the bandwidth requirements of memory clients.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/memory/Kconfig        |   8 +++
 drivers/memory/Makefile       |   1 +
 drivers/memory/tegra124-emc.c | 115 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+)
 create mode 100644 drivers/memory/tegra124-emc.c

diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index c59e9c9..48fa0dd 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -61,6 +61,14 @@ config TEGRA30_MC
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
 config FSL_IFC
 	bool
 	depends on FSL_SOC
diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
index 71160a2..0b7290b 100644
--- a/drivers/memory/Makefile
+++ b/drivers/memory/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
 obj-$(CONFIG_MVEBU_DEVBUS)	+= mvebu-devbus.o
 obj-$(CONFIG_TEGRA20_MC)	+= tegra20-mc.o
 obj-$(CONFIG_TEGRA30_MC)	+= tegra30-mc.o
+obj-$(CONFIG_TEGRA124_EMC)	+= tegra124-emc.o
diff --git a/drivers/memory/tegra124-emc.c b/drivers/memory/tegra124-emc.c
new file mode 100644
index 0000000..53a34bd
--- /dev/null
+++ b/drivers/memory/tegra124-emc.c
@@ -0,0 +1,115 @@
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/clk.h>
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
+static unsigned long tegra124_emc_bw_to_freq_req(unsigned long bw)
+{
+	return (bw + BYTES_PER_EMC_CLOCK - 1) / BYTES_PER_EMC_CLOCK;
+}
+
+static void tegra124_emc_update_rate(struct tegra124_emc *emc, unsigned long total_bandwidth)
+{
+	struct clk *emc_master;
+	unsigned long freq;
+
+	emc_master = clk_get_parent(emc->clk);
+	freq = tegra124_emc_bw_to_freq_req(total_bandwidth) * 1000;
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
+	freq = tegra124_emc_bw_to_freq_req(total_bandwidth) * 1000;
+
+	clk_set_floor_rate(emc->clk, freq);
+}
+
+int memory_bw_notify(struct notifier_block *nb, unsigned long total_bw, void *dummy)
+{
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
+	emc->clk = clk_get(&pdev->dev, "emc");
+	if (IS_ERR(emc->clk)) {
+		devm_kfree(&pdev->dev, emc);
+		dev_err(&pdev->dev, "Can not find EMC clock\n");
+		return -EINVAL;
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

