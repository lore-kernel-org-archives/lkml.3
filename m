Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaFPNf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:35:57 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56977 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaFPNfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:35:54 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [RFC PATCH 1/4] memory: tegra124-emc: Add EMC driver
Date: Mon, 16 Jun 2014 15:35:10 +0200
Message-Id: <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds functionality for registering memory bandwidth needs and setting
the EMC clock rate based on that.

Also adds API for setting floor and ceiling frequency rates.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 .../bindings/arm/tegra/nvidia,tegra124-emc.txt     |  26 ++++
 drivers/memory/Kconfig                             |   8 +
 drivers/memory/Makefile                            |   1 +
 drivers/memory/tegra124-emc.c                      | 173 +++++++++++++++++++++
 include/linux/platform_data/tegra_emc.h            |  23 +++
 5 files changed, 231 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/tegra/nvidia,tegra124-emc.txt
 create mode 100644 drivers/memory/tegra124-emc.c

diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra124-emc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra124-emc.txt
new file mode 100644
index 0000000..88e6a55
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra124-emc.txt
@@ -0,0 +1,26 @@
+Tegra124 External Memory Controller
+
+Properties:
+- compatible : Should contain "nvidia,tegra124-emc".
+- reg : Should contain the register range of the device
+- #address-cells : Should be 1
+- #size-cells : Should be 0
+- nvidia,mc : phandle to the mc bus connected to EMC.
+- clocks : phandle to EMC, EMC shared bus override, and all parent clocks.
+- clock-names : name of each clock.
+- nvidia,pmc : phandle to the PMC syscon node.
+- max-clock-frequency : optional, specifies the maximum EMC rate in kHz.
+
+Child device nodes describe the memory settings for different configurations and
+clock rates.
+
+Example:
+
+	memory-controller@7001b000 {
+		compatible = "nvidia,tegra124-emc";
+		reg = <0x7001b000 0x1000>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&tegra_car TEGRA124_CLK_EMC>;
+		clock-names = "emc";
+	};
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
index 0000000..b7a54a5
--- /dev/null
+++ b/drivers/memory/tegra124-emc.c
@@ -0,0 +1,173 @@
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
+#include <linux/of_platform.h>
+#include <linux/platform_data/tegra_emc.h>
+
+#define DRV_NAME "tegra124-emc"
+#define EMC_FREQ_CUTOFF_USE_130_PERCENT	100000000
+#define EMC_FREQ_CUTOFF_USE_140_PERCENT	50000000
+#define BYTES_PER_EMC_CLOCK 16
+
+struct tegra124_emc {
+	struct clk *clk;
+	unsigned long bandwidth_requests[TEGRA_EMC_CONSUMER_LAST];
+	unsigned long floor_freq;
+	unsigned long ceiling_freq;
+	/*
+	 * Cannot use a mutex here because the ACTMON driver would set a floor
+	 * frequency from an IRQ handler.
+	 */
+	spinlock_t spinlock;
+};
+
+static struct platform_device *emc_pdev;
+
+static unsigned long tegra124_emc_bw_to_freq_req(unsigned long bw)
+{
+	return (bw + BYTES_PER_EMC_CLOCK - 1) / BYTES_PER_EMC_CLOCK;
+}
+
+static void tegra124_emc_update_rate(struct tegra124_emc *emc)
+{
+	int i;
+	struct clk *emc_master;
+	unsigned long total_bandwidth = 0;
+	unsigned long freq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&emc->spinlock, flags);
+
+	for (i = 0; i < TEGRA_EMC_CONSUMER_LAST; i++)
+		total_bandwidth += emc->bandwidth_requests[i];
+
+	emc_master = clk_get_parent(emc->clk);
+	freq = tegra124_emc_bw_to_freq_req(total_bandwidth) * 1000;
+	freq = clk_round_rate(emc_master, freq);
+
+	/* XXX: Add safety margins for DVFS */
+
+	if (freq < EMC_FREQ_CUTOFF_USE_140_PERCENT)
+		total_bandwidth += 4 * total_bandwidth / 10;
+	else if (freq < EMC_FREQ_CUTOFF_USE_130_PERCENT)
+		total_bandwidth += 3 * total_bandwidth / 10;
+	else
+		total_bandwidth += total_bandwidth / 10;
+
+	freq = tegra124_emc_bw_to_freq_req(total_bandwidth) * 1000;
+	freq = max(freq, emc->floor_freq);
+	freq = min(freq, emc->ceiling_freq);
+
+	spin_unlock_irqrestore(&emc->spinlock, flags);
+
+
+	clk_set_rate(emc->clk, freq);
+}
+
+int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned long rate)
+{
+	struct tegra124_emc *emc = platform_get_drvdata(emc_pdev);
+	unsigned long flags;
+
+	if (consumer >= TEGRA_EMC_CONSUMER_LAST) {
+		dev_err(&emc_pdev->dev, "Invalid EMC consumer ID (%u)\n", consumer);
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&emc->spinlock, flags);
+	emc->bandwidth_requests[consumer] = rate;
+	spin_unlock_irqrestore(&emc->spinlock, flags);
+
+	tegra124_emc_update_rate(emc);
+
+	return 0;
+}
+
+void tegra124_emc_set_floor(unsigned long freq)
+{
+	struct tegra124_emc *emc = platform_get_drvdata(emc_pdev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&emc->spinlock, flags);
+	emc->floor_freq = freq;
+	spin_unlock_irqrestore(&emc->spinlock, flags);
+
+	tegra124_emc_update_rate(emc);
+}
+
+void tegra124_emc_set_ceiling(unsigned long freq)
+{
+	struct tegra124_emc *emc = platform_get_drvdata(emc_pdev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&emc->spinlock, flags);
+	emc->ceiling_freq = freq;
+	spin_unlock_irqrestore(&emc->spinlock, flags);
+
+	tegra124_emc_update_rate(emc);
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
+	emc->ceiling_freq = ULONG_MAX;
+
+	emc->clk = devm_clk_get(&pdev->dev, "emc");
+	if (IS_ERR(emc->clk)) {
+		devm_kfree(&pdev->dev, emc);
+		dev_err(&pdev->dev, "Can not find EMC clock\n");
+		return -EINVAL;
+	}
+
+	spin_lock_init(&emc->spinlock);
+
+	platform_set_drvdata(emc_pdev, emc);
+
+	return 0;
+}
+
+static struct of_device_id tegra124_emc_of_match[] = {
+	{ .compatible = "nvidia,tegra124-emc", },
+	{ },
+};
+
+static struct platform_driver tegra124_emc_driver = {
+	.driver         = {
+		.name   = DRV_NAME,
+		.owner  = THIS_MODULE,
+		.of_match_table = tegra124_emc_of_match,
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
diff --git a/include/linux/platform_data/tegra_emc.h b/include/linux/platform_data/tegra_emc.h
index df67505..2967964 100644
--- a/include/linux/platform_data/tegra_emc.h
+++ b/include/linux/platform_data/tegra_emc.h
@@ -31,4 +31,27 @@ struct tegra_emc_pdata {
 	struct tegra_emc_table *tables;
 };
 
+enum {
+	TEGRA_EMC_CONSUMER_DISP1 = 0,
+	TEGRA_EMC_CONSUMER_DISP2,
+	TEGRA_EMC_CONSUMER_MSENC,
+	TEGRA_EMC_CONSUMER_CAMERA,
+	TEGRA_EMC_CONSUMER_AVP,
+	TEGRA_EMC_CONSUMER_ISO,
+	TEGRA_EMC_CONSUMER_LAST
+};
+
+#ifdef CONFIG_TEGRA124_EMC
+int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned long rate);
+void tegra124_emc_set_floor(unsigned long freq);
+void tegra124_emc_set_ceiling(unsigned long freq);
+#else
+int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned long rate)
+{ return -ENODEV; }
+void tegra124_emc_set_floor(unsigned long freq)
+{ return; }
+void tegra124_emc_set_ceiling(unsigned long freq)
+{ return; }
+#endif
+
 #endif
-- 
1.9.3

