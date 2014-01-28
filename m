Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaA1Xie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:38:34 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15505 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbaA1Xib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:38:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 28 Jan 2014 15:37:11 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Danny Huang <dahuang@nvidia.com>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH v3 3/6] misc: fuse: Add efuse driver for Tegra
Date: Wed, 29 Jan 2014 01:36:13 +0200
Message-ID: <1390952176-30402-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement fuse driver for Tegra20, Tegra30, Tegra114 and Tegra124.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 Documentation/ABI/testing/sysfs-driver-tegra-fuse |    8 +
 drivers/misc/fuse/Makefile                        |    1 +
 drivers/misc/fuse/tegra/Makefile                  |    7 +
 drivers/misc/fuse/tegra/fuse-tegra.c              |  228 ++++++++++++++++
 drivers/misc/fuse/tegra/fuse-tegra20.c            |  136 ++++++++++
 drivers/misc/fuse/tegra/fuse-tegra30.c            |  178 +++++++++++++
 drivers/misc/fuse/tegra/fuse.h                    |   82 ++++++
 drivers/misc/fuse/tegra/tegra114_speedo.c         |  110 ++++++++
 drivers/misc/fuse/tegra/tegra124_speedo.c         |  164 ++++++++++++
 drivers/misc/fuse/tegra/tegra20_speedo.c          |  110 ++++++++
 drivers/misc/fuse/tegra/tegra30_speedo.c          |  294 +++++++++++++++++++++
 11 files changed, 1318 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-tegra-fuse
 create mode 100644 drivers/misc/fuse/Makefile
 create mode 100644 drivers/misc/fuse/tegra/Makefile
 create mode 100644 drivers/misc/fuse/tegra/fuse-tegra.c
 create mode 100644 drivers/misc/fuse/tegra/fuse-tegra20.c
 create mode 100644 drivers/misc/fuse/tegra/fuse-tegra30.c
 create mode 100644 drivers/misc/fuse/tegra/fuse.h
 create mode 100644 drivers/misc/fuse/tegra/tegra114_speedo.c
 create mode 100644 drivers/misc/fuse/tegra/tegra124_speedo.c
 create mode 100644 drivers/misc/fuse/tegra/tegra20_speedo.c
 create mode 100644 drivers/misc/fuse/tegra/tegra30_speedo.c

diff --git a/Documentation/ABI/testing/sysfs-driver-tegra-fuse b/Documentation/ABI/testing/sysfs-driver-tegra-fuse
new file mode 100644
index 0000000..3b5e1ea
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-tegra-fuse
@@ -0,0 +1,8 @@
+What:		/sys/devices/*/<our-device>/fuse
+Date:		December 2013
+Contact:	Peter De Schrijver <pdeschrijver@nvidia.com>
+Description:	read-only access to the efuses on Tegra20, Tegra30, Tegra114
+		and Tegra124 SoC's from NVIDIA. The efuses contain write once
+		data programmed at the factory.
+Users:		any user space application which wants to read the efuses on
+		Tegra SoC's
diff --git a/drivers/misc/fuse/Makefile b/drivers/misc/fuse/Makefile
new file mode 100644
index 0000000..0679c4f
--- /dev/null
+++ b/drivers/misc/fuse/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
diff --git a/drivers/misc/fuse/tegra/Makefile b/drivers/misc/fuse/tegra/Makefile
new file mode 100644
index 0000000..42829b3
--- /dev/null
+++ b/drivers/misc/fuse/tegra/Makefile
@@ -0,0 +1,7 @@
+obj-y					+= fuse-tegra.o
+obj-y					+= fuse-tegra30.o
+obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= fuse-tegra20.o
+obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra20_speedo.o
+obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= tegra30_speedo.o
+obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= tegra114_speedo.o
+obj-$(CONFIG_ARCH_TEGRA_124_SOC)	+= tegra124_speedo.o
diff --git a/drivers/misc/fuse/tegra/fuse-tegra.c b/drivers/misc/fuse/tegra/fuse-tegra.c
new file mode 100644
index 0000000..aeecbcd
--- /dev/null
+++ b/drivers/misc/fuse/tegra/fuse-tegra.c
@@ -0,0 +1,228 @@
+/*
+ * Copyright (c) 2013-2014, NVIDIA CORPORATION.  All rights reserved.
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
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/kobject.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+#include <linux/tegra-soc.h>
+
+#include "fuse.h"
+
+int tegra_chip_id;
+enum tegra_revision tegra_revision;
+
+/*
+ * The BCT to use at boot is specified by board straps that can be read
+ * through a APB misc register and decoded. 2 bits, i.e. 4 possible BCTs.
+ */
+int tegra_bct_strapping;
+
+#define TEGRA_STRAP_OPT		0x8
+#define TEGRA_RAM_ID_SHIFT	4
+#define TEGRA_RAM_ID_MASK	3
+
+static u32 (*fuse_readl)(const unsigned int offset);
+static int fuse_size;
+static void __iomem *fuse_base;
+static void __iomem *apbmisc_base;
+static void __iomem *car_base;
+
+static const char *tegra_revision_name[TEGRA_REVISION_MAX] = {
+	[TEGRA_REVISION_UNKNOWN] = "unknown",
+	[TEGRA_REVISION_A01]     = "A01",
+	[TEGRA_REVISION_A02]     = "A02",
+	[TEGRA_REVISION_A03]     = "A03",
+	[TEGRA_REVISION_A03p]    = "A03 prime",
+	[TEGRA_REVISION_A04]     = "A04",
+};
+
+static u8 fuse_readb(const unsigned int offset)
+{
+	u32 val;
+
+	val = fuse_readl(round_down(offset, 4));
+	val >>= (offset % 4) * 8;
+	val &= 0xff;
+
+	return val;
+}
+
+static ssize_t fuse_read(struct file *fd, struct kobject *kobj,
+			struct bin_attribute *attr, char *buf,
+			loff_t pos, size_t size)
+{
+	int i;
+
+	if (pos < 0 || pos >= fuse_size)
+		return 0;
+
+	if (size > fuse_size - pos)
+		size = fuse_size - pos;
+
+	for (i = 0; i < size; i++)
+		buf[i] = fuse_readb(pos + i);
+
+	return i;
+}
+
+static struct bin_attribute fuse_bin_attr = {
+	.attr = { .name = "fuse", .mode = S_IRUGO, },
+	.read = fuse_read,
+};
+
+static const struct of_device_id tegra_fuse_match[] __initconst = {
+	{ .compatible = "nvidia,tegra20-efuse", },
+	{ .compatible = "nvidia,tegra30-efuse", },
+	{ .compatible = "nvidia,tegra114-efuse", },
+	{ .compatible = "nvidia,tegra124-efuse", },
+	{},
+};
+
+static const struct of_device_id car_match[] __initconst = {
+	{ .compatible = "nvidia,tegra20-car", },
+	{ .compatible = "nvidia,tegra30-car", },
+	{ .compatible = "nvidia,tegra114-car", },
+	{ .compatible = "nvidia,tegra124-car", },
+	{},
+};
+
+static void tegra_read_bct_strapping(void)
+{
+	tegra_bct_strapping = readl_relaxed(apbmisc_base +
+					    TEGRA_STRAP_OPT);
+	tegra_bct_strapping >>= TEGRA_RAM_ID_SHIFT;
+	tegra_bct_strapping &= TEGRA_RAM_ID_MASK;
+}
+
+static void tegra_get_revision(u32 id)
+{
+	u32 minor_rev = (id >> 16) & 0xf;
+
+	switch (minor_rev) {
+	case 1:
+		tegra_revision = TEGRA_REVISION_A01;
+		break;
+	case 2:
+		tegra_revision = TEGRA_REVISION_A02;
+		break;
+	case 3:
+		if (tegra_chip_id == TEGRA20 &&
+			(tegra20_spare_fuse_early(18, fuse_base) ||
+			 tegra20_spare_fuse_early(19, fuse_base)))
+			tegra_revision = TEGRA_REVISION_A03p;
+		else
+			tegra_revision = TEGRA_REVISION_A03;
+		break;
+	case 4:
+		tegra_revision = TEGRA_REVISION_A04;
+		break;
+	default:
+		tegra_revision = TEGRA_REVISION_UNKNOWN;
+	}
+}
+
+u32 tegra_read_straps(void)
+{
+	return readl(apbmisc_base + TEGRA_STRAP_OPT);
+}
+
+u32 tegra_read_chipid(void)
+{
+	return readl_relaxed(apbmisc_base + 0x804);
+}
+
+int tegra_fuse_create_sysfs(struct device *dev, int size,
+		     u32 (*readl)(const unsigned int offset),
+		     struct tegra_sku_info *sku_info)
+{
+	int err;
+
+	if (fuse_size)
+		return -ENODEV;
+
+	fuse_bin_attr.size = size;
+	fuse_bin_attr.read = fuse_read;
+
+	fuse_size = size;
+	fuse_readl = readl;
+
+	err = device_create_bin_file(dev, &fuse_bin_attr);
+	if (err)
+		return err;
+
+	dev_info(dev,
+		"Tegra Revision: %s SKU: %d CPU Process: %d Core Process: %d\n",
+		tegra_revision_name[sku_info->revision],
+		sku_info->sku_id, sku_info->cpu_process_id,
+		sku_info->core_process_id);
+
+	return 0;
+}
+
+void __init tegra_init_fuse(void)
+{
+	struct device_node *np;
+	u32 id, reg;
+
+	np = of_find_matching_node(NULL, tegra_fuse_match);
+	fuse_base = of_iomap(np, 0);
+	if (!fuse_base) {
+		pr_err("ioremap tegra fuse failed\n");
+		return;
+	}
+
+	apbmisc_base = of_iomap(np, 1);
+	if (!apbmisc_base) {
+		pr_err("ioremap tegra apbmisc failed\n");
+		iounmap(fuse_base);
+		return;
+	}
+
+	np = of_find_matching_node(NULL, car_match);
+	car_base = of_iomap(np, 0);
+	if (!car_base) {
+		pr_err("ioremap tegra car failed\n");
+		iounmap(fuse_base);
+		iounmap(apbmisc_base);
+		return;
+	}
+
+	reg = readl_relaxed(car_base + 0x48);
+	reg |= 1 << 28;
+	writel(reg, car_base + 0x48);
+
+	/*
+	 * Enable FUSE clock. This needs to be hardcoded because the clock
+	 * subsystem is not active during early boot.
+	 */
+	reg = readl(car_base + 0x14);
+	reg |= 1 << 7;
+	writel(reg, car_base + 0x14);
+
+	iounmap(car_base);
+
+	id = tegra_read_chipid();
+	tegra_chip_id = (id >> 8) & 0xff;
+
+	tegra_read_bct_strapping();
+
+	tegra_get_revision(id);
+}
diff --git a/drivers/misc/fuse/tegra/fuse-tegra20.c b/drivers/misc/fuse/tegra/fuse-tegra20.c
new file mode 100644
index 0000000..45bdfb8
--- /dev/null
+++ b/drivers/misc/fuse/tegra/fuse-tegra20.c
@@ -0,0 +1,136 @@
+/*
+ * Copyright (c) 2013-2014, NVIDIA CORPORATION.  All rights reserved.
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
+ *
+ * Based on drivers/misc/eeprom/sunxi_sid.c
+ */
+
+#include <linux/device.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/kobject.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/random.h>
+#include <linux/tegra-soc.h>
+
+#include "fuse.h"
+
+#define FUSE_BEGIN	0x100
+#define FUSE_SIZE	0x1f8
+#define FUSE_SKU_INFO	0x10
+#define FUSE_UID_LOW	0x08
+#define FUSE_UID_HIGH	0x0c
+
+static phys_addr_t fuse_phys;
+static struct clk *fuse_clk;
+static struct tegra_sku_info sku_info;
+
+static u32 tegra20_fuse_readl(const unsigned int offset)
+{
+	int ret;
+	u32 val;
+
+	clk_prepare_enable(fuse_clk);
+
+	ret = tegra_apb_readl_using_dma(fuse_phys + FUSE_BEGIN + offset, &val);
+
+	clk_disable_unprepare(fuse_clk);
+
+	return (ret < 0) ? 0 : val;
+}
+
+static void tegra20_fuse_add_randomness(void)
+{
+	u32 randomness[7];
+
+	randomness[0] = tegra20_fuse_readl(FUSE_SKU_INFO);
+	randomness[1] = tegra_read_straps();
+	randomness[2] = tegra_read_chipid();
+	randomness[3] = sku_info.cpu_process_id << 16;
+	randomness[3] |= sku_info.core_process_id;
+	randomness[4] = sku_info.cpu_speedo_id << 16 | sku_info.soc_speedo_id;
+	randomness[5] = tegra20_fuse_readl(FUSE_UID_LOW);
+	randomness[6] = tegra20_fuse_readl(FUSE_UID_HIGH);
+
+	add_device_randomness(randomness, sizeof(randomness));
+}
+
+bool tegra20_spare_fuse(int spare_bit)
+{
+	u32 offset = spare_bit * 4 + 0x100;
+
+	return tegra20_fuse_readl(offset) & 1;
+}
+
+bool tegra20_spare_fuse_early(int spare_bit, void *fuse_base)
+{
+	u32 offset = spare_bit * 4 + 0x100;
+
+	return readl_relaxed(fuse_base + FUSE_BEGIN + offset);
+}
+
+static const struct of_device_id tegra20_fuse_of_match[] = {
+	{ .compatible = "nvidia,tegra20-efuse" },
+	{},
+}
+MODULE_DEVICE_TABLE(of, tegra20_fuse_of_match);
+
+static int tegra20_fuse_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+
+	fuse_clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(fuse_clk)) {
+		dev_err(&pdev->dev, "missing clock");
+		return PTR_ERR(fuse_clk);
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
+	fuse_phys = res->start;
+
+	sku_info.revision = tegra_revision;
+	tegra20_init_speedo_data(&sku_info, &pdev->dev);
+	dev_dbg(&pdev->dev, "Soc Speedo ID %d", sku_info.soc_speedo_id);
+
+	tegra20_fuse_add_randomness();
+
+	if (tegra_fuse_create_sysfs(&pdev->dev, FUSE_SIZE, tegra20_fuse_readl,
+			     &sku_info))
+		return -ENODEV;
+
+	dev_dbg(&pdev->dev, "loaded\n");
+
+	return 0;
+}
+
+static struct platform_driver tegra20_fuse_driver = {
+	.probe = tegra20_fuse_probe,
+	.driver = {
+		.name = "tegra20_fuse",
+		.owner = THIS_MODULE,
+		.of_match_table = tegra20_fuse_of_match,
+	}
+};
+
+static int __init tegra20_fuse_init(void)
+{
+	return platform_driver_register(&tegra20_fuse_driver);
+}
+postcore_initcall(tegra20_fuse_init);
diff --git a/drivers/misc/fuse/tegra/fuse-tegra30.c b/drivers/misc/fuse/tegra/fuse-tegra30.c
new file mode 100644
index 0000000..6133b77
--- /dev/null
+++ b/drivers/misc/fuse/tegra/fuse-tegra30.c
@@ -0,0 +1,178 @@
+/*
+ * Copyright (c) 2013-2014, NVIDIA CORPORATION.  All rights reserved.
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
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/random.h>
+#include <linux/tegra-soc.h>
+
+#include "fuse.h"
+
+#define FUSE_BEGIN	0x100
+
+#define FUSE_SKU_INFO		0x10
+
+/* Tegra30 and later */
+#define FUSE_VENDOR_CODE	0x100
+#define FUSE_FAB_CODE		0x104
+#define FUSE_LOT_CODE_0		0x108
+#define FUSE_LOT_CODE_1		0x10c
+#define FUSE_WAFER_ID		0x110
+#define FUSE_X_COORDINATE	0x114
+#define FUSE_Y_COORDINATE	0x118
+
+#define FUSE_HAS_REVISION_INFO	BIT(0)
+
+struct tegra_fuse_info {
+	int	size;
+	int	spare_bit;
+	void	(*init_speedo_data)(struct tegra_sku_info *sku_info,
+				    struct device *dev);
+};
+
+static void __iomem *fuse_base;
+static struct clk *fuse_clk;
+static struct tegra_fuse_info *fuse_info;
+static struct tegra_sku_info sku_info;
+
+u32 tegra30_fuse_readl(const unsigned int offset)
+{
+	u32 val;
+
+	clk_prepare_enable(fuse_clk);
+
+	val = readl_relaxed(fuse_base + FUSE_BEGIN + offset);
+
+	clk_disable_unprepare(fuse_clk);
+
+	return val;
+}
+
+bool tegra30_spare_fuse(int spare_bit)
+{
+	u32 offset = fuse_info->spare_bit + spare_bit * 4;
+
+	return tegra30_fuse_readl(offset) & 1;
+}
+
+static void tegra30_fuse_add_randomness(void)
+{
+	u32 randomness[12];
+
+	randomness[0] = tegra30_fuse_readl(FUSE_SKU_INFO);
+	randomness[1] = tegra_read_straps();
+	randomness[2] = tegra_read_chipid();
+	randomness[3] = sku_info.cpu_process_id << 16;
+	randomness[3] |= sku_info.core_process_id;
+	randomness[4] = sku_info.cpu_speedo_id << 16;
+	randomness[4] |= sku_info.soc_speedo_id;
+	randomness[5] = tegra30_fuse_readl(FUSE_VENDOR_CODE);
+	randomness[6] = tegra30_fuse_readl(FUSE_FAB_CODE);
+	randomness[7] = tegra30_fuse_readl(FUSE_LOT_CODE_0);
+	randomness[8] = tegra30_fuse_readl(FUSE_LOT_CODE_1);
+	randomness[9] = tegra30_fuse_readl(FUSE_WAFER_ID);
+	randomness[10] = tegra30_fuse_readl(FUSE_X_COORDINATE);
+	randomness[11] = tegra30_fuse_readl(FUSE_Y_COORDINATE);
+
+	add_device_randomness(randomness, sizeof(randomness));
+}
+
+static struct tegra_fuse_info tegra30_info = {
+	.size			= 0x2a4,
+	.spare_bit		= 0x144,
+	.init_speedo_data	= tegra30_init_speedo_data,
+};
+
+static struct tegra_fuse_info tegra114_info = {
+	.size			= 0x2a0,
+	.init_speedo_data	= tegra114_init_speedo_data,
+};
+
+static struct tegra_fuse_info tegra124_info = {
+	.size			= 0x300,
+	.init_speedo_data	= tegra124_init_speedo_data,
+};
+
+static const struct of_device_id tegra30_fuse_of_match[] = {
+	{ .compatible = "nvidia,tegra30-efuse", .data = &tegra30_info },
+	{ .compatible = "nvidia,tegra114-efuse", .data = &tegra114_info },
+	{ .compatible = "nvidia,tegra124-efuse", .data = &tegra124_info },
+	{},
+};
+
+static int tegra30_fuse_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *of_dev_id;
+	struct resource *res;
+
+	of_dev_id = of_match_device(tegra30_fuse_of_match, &pdev->dev);
+	if (!of_dev_id)
+		return -ENODEV;
+	fuse_info = (struct tegra_fuse_info *)of_dev_id->data;
+
+	fuse_clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(fuse_clk)) {
+		dev_err(&pdev->dev, "missing clock");
+		return PTR_ERR(fuse_clk);
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	fuse_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(fuse_base)) {
+		dev_err(&pdev->dev, "unable to map base address");
+		return PTR_ERR(fuse_base);
+	}
+
+	sku_info.revision = tegra_revision;
+	fuse_info->init_speedo_data(&sku_info, &pdev->dev);
+	dev_dbg(&pdev->dev, "CPU Speedo ID %d, Soc Speedo ID %d",
+		sku_info.cpu_speedo_id, sku_info.soc_speedo_id);
+
+	tegra30_fuse_add_randomness();
+
+	platform_set_drvdata(pdev, NULL);
+
+	if (tegra_fuse_create_sysfs(&pdev->dev, fuse_info->size,
+				    tegra30_fuse_readl, &sku_info))
+		return -ENODEV;
+
+	dev_dbg(&pdev->dev, "loaded\n");
+
+	return 0;
+}
+
+static struct platform_driver tegra30_fuse_driver = {
+	.probe = tegra30_fuse_probe,
+	.driver = {
+		.name = "tegra_fuse",
+		.owner = THIS_MODULE,
+		.of_match_table = tegra30_fuse_of_match,
+	}
+};
+
+static int __init tegra30_fuse_init(void)
+{
+	return platform_driver_register(&tegra30_fuse_driver);
+}
+postcore_initcall(tegra30_fuse_init);
+
diff --git a/drivers/misc/fuse/tegra/fuse.h b/drivers/misc/fuse/tegra/fuse.h
new file mode 100644
index 0000000..0baf82b
--- /dev/null
+++ b/drivers/misc/fuse/tegra/fuse.h
@@ -0,0 +1,82 @@
+/*
+ * Copyright (C) 2010 Google, Inc.
+ * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Author:
+ *	Colin Cross <ccross@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __DRIVERS_MISC_TEGRA_FUSE_H
+#define __DRIVERS_MISC_TEGRA_FUSE_H
+
+struct tegra_sku_info {
+	int sku_id;
+	int cpu_process_id;
+	int cpu_speedo_id;
+	int cpu_speedo_value;
+	int cpu_iddq_value;
+	int core_process_id;
+	int soc_speedo_id;
+	int gpu_speedo_id;
+	int gpu_process_id;
+	int gpu_speedo_value;
+	enum tegra_revision revision;
+};
+
+int tegra_fuse_create_sysfs(struct device *dev, int size,
+		     u32 (*readl)(const unsigned int offset),
+		     struct tegra_sku_info *sku_info);
+
+bool tegra30_spare_fuse(int bit);
+u32 tegra30_fuse_readl(const unsigned int offset);
+
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+void tegra20_init_speedo_data(struct tegra_sku_info *sku_info,
+			      struct device *dev);
+bool tegra20_spare_fuse(int bit);
+bool tegra20_spare_fuse_early(int spare_bit, void *fuse_base);
+#else
+static inline void tegra20_init_speedo_data(struct tegra_sku_info *sku_info,
+					    struct device *dev) {}
+static inline bool tegra20_spare_fuse(int bit) { return false; }
+static inline bool tegra20_spare_fuse_early(int spare_bit, void *fuse_base)
+{
+			return false;
+}
+#endif
+
+#ifdef CONFIG_ARCH_TEGRA_3x_SOC
+void tegra30_init_speedo_data(struct tegra_sku_info *sku_info,
+			      struct device *dev);
+#else
+static inline void tegra30_init_speedo_data(struct tegra_sku_info *sku_info,
+					    struct device *dev) {}
+#endif
+
+#ifdef CONFIG_ARCH_TEGRA_114_SOC
+void tegra114_init_speedo_data(struct tegra_sku_info *sku_info,
+			       struct device *dev);
+#else
+static inline void tegra114_init_speedo_data(struct tegra_sku_info *sku_info,
+					     struct device *dev) {}
+#endif
+
+#ifdef CONFIG_ARCH_TEGRA_124_SOC
+void tegra124_init_speedo_data(struct tegra_sku_info *sku_info,
+			       struct device *dev);
+#else
+static inline void tegra124_init_speedo_data(struct tegra_sku_info *sku_info,
+					     struct device *dev) {}
+#endif
+
+#endif
diff --git a/drivers/misc/fuse/tegra/tegra114_speedo.c b/drivers/misc/fuse/tegra/tegra114_speedo.c
new file mode 100644
index 0000000..7be8ba5
--- /dev/null
+++ b/drivers/misc/fuse/tegra/tegra114_speedo.c
@@ -0,0 +1,110 @@
+/*
+ * Copyright (c) 2013-2014, NVIDIA CORPORATION.  All rights reserved.
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
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/bug.h>
+#include <linux/tegra-soc.h>
+
+#include "fuse.h"
+
+#define CORE_PROCESS_CORNERS_NUM	2
+#define CPU_PROCESS_CORNERS_NUM		2
+
+enum {
+	THRESHOLD_INDEX_0,
+	THRESHOLD_INDEX_1,
+	THRESHOLD_INDEX_COUNT,
+};
+
+static const u32 core_process_speedos[][CORE_PROCESS_CORNERS_NUM] = {
+	{1123,     UINT_MAX},
+	{0,        UINT_MAX},
+};
+
+static const u32 cpu_process_speedos[][CPU_PROCESS_CORNERS_NUM] = {
+	{1695,     UINT_MAX},
+	{0,        UINT_MAX},
+};
+
+static void rev_sku_to_speedo_ids(struct tegra_sku_info *sku_info,
+				  int *threshold, struct device *dev)
+{
+	u32 tmp;
+	u32 sku = sku_info->sku_id;
+	enum tegra_revision rev = sku_info->revision;
+
+	switch (sku) {
+	case 0x00:
+	case 0x10:
+	case 0x05:
+	case 0x06:
+		sku_info->cpu_speedo_id = 1;
+		sku_info->soc_speedo_id = 0;
+		*threshold = THRESHOLD_INDEX_0;
+		break;
+
+	case 0x03:
+	case 0x04:
+		sku_info->cpu_speedo_id = 2;
+		sku_info->soc_speedo_id = 1;
+		*threshold = THRESHOLD_INDEX_1;
+		break;
+
+	default:
+		dev_err(dev, "Unknown SKU %d\n", sku);
+		sku_info->cpu_speedo_id = 0;
+		sku_info->soc_speedo_id = 0;
+		*threshold = THRESHOLD_INDEX_0;
+		break;
+	}
+
+	if (rev == TEGRA_REVISION_A01) {
+		tmp = tegra30_fuse_readl(0x270) << 1;
+		tmp |= tegra30_fuse_readl(0x26c);
+		if (!tmp)
+			sku_info->cpu_speedo_id = 0;
+	}
+}
+
+void tegra114_init_speedo_data(struct tegra_sku_info *sku_info,
+			       struct device *dev)
+{
+	u32 cpu_speedo_val;
+	u32 core_speedo_val;
+	int threshold;
+	int i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(cpu_process_speedos) !=
+			THRESHOLD_INDEX_COUNT);
+	BUILD_BUG_ON(ARRAY_SIZE(core_process_speedos) !=
+			THRESHOLD_INDEX_COUNT);
+
+	rev_sku_to_speedo_ids(sku_info, &threshold, dev);
+
+	cpu_speedo_val = tegra30_fuse_readl(0x12c) + 1024;
+	core_speedo_val = tegra30_fuse_readl(0x134);
+
+	for (i = 0; i < CPU_PROCESS_CORNERS_NUM; i++)
+		if (cpu_speedo_val < cpu_process_speedos[threshold][i])
+			break;
+	sku_info->cpu_process_id = i;
+
+	for (i = 0; i < CORE_PROCESS_CORNERS_NUM; i++)
+		if (core_speedo_val < core_process_speedos[threshold][i])
+			break;
+	sku_info->core_process_id = i;
+}
diff --git a/drivers/misc/fuse/tegra/tegra124_speedo.c b/drivers/misc/fuse/tegra/tegra124_speedo.c
new file mode 100644
index 0000000..70edb2d
--- /dev/null
+++ b/drivers/misc/fuse/tegra/tegra124_speedo.c
@@ -0,0 +1,164 @@
+/*
+ * Copyright (c) 2013-2014, NVIDIA CORPORATION.  All rights reserved.
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
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/bug.h>
+#include <linux/tegra-soc.h>
+
+#include "fuse.h"
+
+#define CPU_PROCESS_CORNERS_NUM	2
+#define GPU_PROCESS_CORNERS_NUM	2
+#define CORE_PROCESS_CORNERS_NUM	2
+
+#define FUSE_CPU_SPEEDO_0	0x14
+#define FUSE_CPU_SPEEDO_1	0x2c
+#define FUSE_CPU_SPEEDO_2	0x30
+#define FUSE_SOC_SPEEDO_0	0x34
+#define FUSE_SOC_SPEEDO_1	0x38
+#define FUSE_SOC_SPEEDO_2	0x3c
+#define FUSE_CPU_IDDQ		0x18
+#define FUSE_SOC_IDDQ		0x40
+#define FUSE_GPU_IDDQ		0x128
+#define FUSE_FT_REV		0x28
+
+enum {
+	THRESHOLD_INDEX_0,
+	THRESHOLD_INDEX_1,
+	THRESHOLD_INDEX_COUNT,
+};
+
+static int cpu_speedo_0_value;
+static int cpu_speedo_1_value;
+static int soc_speedo_0_value;
+static int soc_speedo_1_value;
+static int soc_speedo_2_value;
+static int cpu_iddq_value;
+static int gpu_iddq_value;
+static int soc_iddq_value;
+
+static const u32 cpu_process_speedos[][CPU_PROCESS_CORNERS_NUM] = {
+	{2190,	UINT_MAX},
+	{0,	UINT_MAX},
+};
+
+static const u32 gpu_process_speedos[][GPU_PROCESS_CORNERS_NUM] = {
+	{1965,	UINT_MAX},
+	{0,	UINT_MAX},
+};
+
+static const u32 core_process_speedos[][CORE_PROCESS_CORNERS_NUM] = {
+	{2101,	UINT_MAX},
+	{0,	UINT_MAX},
+};
+
+static void rev_sku_to_speedo_ids(struct tegra_sku_info *sku_info,
+				  int *threshold, struct device *dev)
+{
+	int sku = sku_info->sku_id;
+
+	/* Assign to default */
+	sku_info->cpu_speedo_id = 0;
+	sku_info->soc_speedo_id = 0;
+	sku_info->gpu_speedo_id = 0;
+	*threshold = THRESHOLD_INDEX_0;
+
+	switch (sku) {
+	case 0x00: /* Eng sku */
+	case 0x0F:
+		/* Using the default */
+		break;
+
+	case 0x81:
+	case 0x83:
+		sku_info->cpu_speedo_id = 2;
+		break;
+
+	case 0x07:
+		sku_info->cpu_speedo_id = 1;
+		sku_info->soc_speedo_id = 1;
+		sku_info->gpu_speedo_id = 1;
+		*threshold = THRESHOLD_INDEX_1;
+		break;
+
+	default:
+		dev_err(dev, "Unknown SKU %d\n", sku);
+		/* Using the default for the error case */
+		break;
+	}
+}
+
+void tegra124_init_speedo_data(struct tegra_sku_info *sku_info,
+			       struct device *dev)
+{
+	int i;
+	int threshold;
+
+	BUILD_BUG_ON(ARRAY_SIZE(cpu_process_speedos) !=
+			THRESHOLD_INDEX_COUNT);
+	BUILD_BUG_ON(ARRAY_SIZE(gpu_process_speedos) !=
+			THRESHOLD_INDEX_COUNT);
+	BUILD_BUG_ON(ARRAY_SIZE(core_process_speedos) !=
+			THRESHOLD_INDEX_COUNT);
+
+	cpu_speedo_0_value = tegra30_fuse_readl(FUSE_CPU_SPEEDO_0);
+	cpu_speedo_1_value = tegra30_fuse_readl(FUSE_CPU_SPEEDO_1);
+
+	/* GPU Speedo is stored in CPU_SPEEDO_2 */
+	sku_info->gpu_speedo_value = tegra30_fuse_readl(FUSE_CPU_SPEEDO_2);
+
+	soc_speedo_0_value = tegra30_fuse_readl(FUSE_SOC_SPEEDO_0);
+	soc_speedo_1_value = tegra30_fuse_readl(FUSE_SOC_SPEEDO_1);
+	soc_speedo_2_value = tegra30_fuse_readl(FUSE_SOC_SPEEDO_2);
+
+	cpu_iddq_value = tegra30_fuse_readl(FUSE_CPU_IDDQ);
+	soc_iddq_value = tegra30_fuse_readl(FUSE_SOC_IDDQ);
+	gpu_iddq_value = tegra30_fuse_readl(FUSE_GPU_IDDQ);
+
+	sku_info->cpu_speedo_value = cpu_speedo_0_value;
+
+	if (sku_info->cpu_speedo_value == 0) {
+		dev_warn(dev, "Warning: Speedo value not fused.\n");
+		WARN_ON(1);
+		return;
+	}
+
+	rev_sku_to_speedo_ids(sku_info, &threshold, dev);
+
+	sku_info->cpu_iddq_value = tegra30_fuse_readl(FUSE_CPU_IDDQ);
+
+	for (i = 0; i < GPU_PROCESS_CORNERS_NUM; i++)
+		if (sku_info->gpu_speedo_value <
+			gpu_process_speedos[threshold][i])
+			break;
+	sku_info->gpu_process_id = i;
+
+	for (i = 0; i < CPU_PROCESS_CORNERS_NUM; i++)
+		if (sku_info->cpu_speedo_value <
+			cpu_process_speedos[threshold][i])
+				break;
+	sku_info->cpu_process_id = i;
+
+	for (i = 0; i < CORE_PROCESS_CORNERS_NUM; i++)
+		if (soc_speedo_0_value <
+			core_process_speedos[threshold][i])
+			break;
+	sku_info->core_process_id = i;
+
+	dev_dbg(dev, "GPU Speedo ID=%d, Speedo Value=%d\n",
+			sku_info->gpu_speedo_id, sku_info->gpu_speedo_value);
+}
diff --git a/drivers/misc/fuse/tegra/tegra20_speedo.c b/drivers/misc/fuse/tegra/tegra20_speedo.c
new file mode 100644
index 0000000..af8e86a
--- /dev/null
+++ b/drivers/misc/fuse/tegra/tegra20_speedo.c
@@ -0,0 +1,110 @@
+/*
+ * Copyright (c) 2012-2014, NVIDIA CORPORATION.  All rights reserved.
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
+#include <linux/device.h>
+#include <linux/bug.h>
+#include <linux/tegra-soc.h>
+
+#include "fuse.h"
+
+#define CPU_SPEEDO_LSBIT		20
+#define CPU_SPEEDO_MSBIT		29
+#define CPU_SPEEDO_REDUND_LSBIT		30
+#define CPU_SPEEDO_REDUND_MSBIT		39
+#define CPU_SPEEDO_REDUND_OFFS	(CPU_SPEEDO_REDUND_MSBIT - CPU_SPEEDO_MSBIT)
+
+#define CORE_SPEEDO_LSBIT		40
+#define CORE_SPEEDO_MSBIT		47
+#define CORE_SPEEDO_REDUND_LSBIT	48
+#define CORE_SPEEDO_REDUND_MSBIT	55
+#define CORE_SPEEDO_REDUND_OFFS	(CORE_SPEEDO_REDUND_MSBIT - CORE_SPEEDO_MSBIT)
+
+#define SPEEDO_MULT			4
+
+#define PROCESS_CORNERS_NUM		4
+
+#define SPEEDO_ID_SELECT_0(rev)		((rev) <= 2)
+#define SPEEDO_ID_SELECT_1(sku)		\
+	(((sku) != 20) && ((sku) != 23) && ((sku) != 24) && \
+	 ((sku) != 27) && ((sku) != 28))
+
+enum {
+	SPEEDO_ID_0,
+	SPEEDO_ID_1,
+	SPEEDO_ID_2,
+	SPEEDO_ID_COUNT,
+};
+
+static const u32 cpu_process_speedos[][PROCESS_CORNERS_NUM] = {
+	{315, 366, 420, UINT_MAX},
+	{303, 368, 419, UINT_MAX},
+	{316, 331, 383, UINT_MAX},
+};
+
+static const u32 core_process_speedos[][PROCESS_CORNERS_NUM] = {
+	{165, 195, 224, UINT_MAX},
+	{165, 195, 224, UINT_MAX},
+	{165, 195, 224, UINT_MAX},
+};
+
+void tegra20_init_speedo_data(struct tegra_sku_info *sku_info,
+			      struct device *dev)
+{
+	u32 reg;
+	u32 val;
+	int i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(cpu_process_speedos) != SPEEDO_ID_COUNT);
+	BUILD_BUG_ON(ARRAY_SIZE(core_process_speedos) != SPEEDO_ID_COUNT);
+
+	if (SPEEDO_ID_SELECT_0(sku_info->revision))
+		sku_info->soc_speedo_id = SPEEDO_ID_0;
+	else if (SPEEDO_ID_SELECT_1(sku_info->sku_id))
+		sku_info->soc_speedo_id = SPEEDO_ID_1;
+	else
+		sku_info->soc_speedo_id = SPEEDO_ID_2;
+
+	val = 0;
+	for (i = CPU_SPEEDO_MSBIT; i >= CPU_SPEEDO_LSBIT; i--) {
+		reg = tegra20_spare_fuse(i) |
+			tegra20_spare_fuse(i + CPU_SPEEDO_REDUND_OFFS);
+		val = (val << 1) | (reg & 0x1);
+	}
+	val = val * SPEEDO_MULT;
+	dev_dbg(dev, "CPU speedo value %u\n", val);
+
+	for (i = 0; i < (PROCESS_CORNERS_NUM - 1); i++) {
+		if (val <= cpu_process_speedos[sku_info->soc_speedo_id][i])
+			break;
+	}
+	sku_info->cpu_process_id = i;
+
+	val = 0;
+	for (i = CORE_SPEEDO_MSBIT; i >= CORE_SPEEDO_LSBIT; i--) {
+		reg = tegra20_spare_fuse(i) |
+			tegra20_spare_fuse(i + CORE_SPEEDO_REDUND_OFFS);
+		val = (val << 1) | (reg & 0x1);
+	}
+	val = val * SPEEDO_MULT;
+	dev_dbg(dev, "Core speedo value %u\n", val);
+
+	for (i = 0; i < (PROCESS_CORNERS_NUM - 1); i++) {
+		if (val <= core_process_speedos[sku_info->soc_speedo_id][i])
+			break;
+	}
+	sku_info->core_process_id = i;
+}
diff --git a/drivers/misc/fuse/tegra/tegra30_speedo.c b/drivers/misc/fuse/tegra/tegra30_speedo.c
new file mode 100644
index 0000000..11cf0cd
--- /dev/null
+++ b/drivers/misc/fuse/tegra/tegra30_speedo.c
@@ -0,0 +1,294 @@
+/*
+ * Copyright (c) 2012-2014, NVIDIA CORPORATION.  All rights reserved.
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
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/bug.h>
+#include <linux/tegra-soc.h>
+
+#include "fuse.h"
+
+#define CORE_PROCESS_CORNERS_NUM	1
+#define CPU_PROCESS_CORNERS_NUM		6
+
+#define FUSE_SPEEDO_CALIB_0	0x14
+#define FUSE_PACKAGE_INFO	0XFC
+#define FUSE_TEST_PROG_VER	0X28
+
+#define G_SPEEDO_BIT_MINUS1	58
+#define G_SPEEDO_BIT_MINUS1_R	59
+#define G_SPEEDO_BIT_MINUS2	60
+#define G_SPEEDO_BIT_MINUS2_R	61
+#define LP_SPEEDO_BIT_MINUS1	62
+#define LP_SPEEDO_BIT_MINUS1_R	63
+#define LP_SPEEDO_BIT_MINUS2	64
+#define LP_SPEEDO_BIT_MINUS2_R	65
+
+enum {
+	THRESHOLD_INDEX_0,
+	THRESHOLD_INDEX_1,
+	THRESHOLD_INDEX_2,
+	THRESHOLD_INDEX_3,
+	THRESHOLD_INDEX_4,
+	THRESHOLD_INDEX_5,
+	THRESHOLD_INDEX_6,
+	THRESHOLD_INDEX_7,
+	THRESHOLD_INDEX_8,
+	THRESHOLD_INDEX_9,
+	THRESHOLD_INDEX_10,
+	THRESHOLD_INDEX_11,
+	THRESHOLD_INDEX_COUNT,
+};
+
+static const u32 core_process_speedos[][CORE_PROCESS_CORNERS_NUM] = {
+	{180},
+	{170},
+	{195},
+	{180},
+	{168},
+	{192},
+	{180},
+	{170},
+	{195},
+	{180},
+	{180},
+	{180},
+};
+
+static const u32 cpu_process_speedos[][CPU_PROCESS_CORNERS_NUM] = {
+	{306, 338, 360, 376, UINT_MAX},
+	{295, 336, 358, 375, UINT_MAX},
+	{325, 325, 358, 375, UINT_MAX},
+	{325, 325, 358, 375, UINT_MAX},
+	{292, 324, 348, 364, UINT_MAX},
+	{324, 324, 348, 364, UINT_MAX},
+	{324, 324, 348, 364, UINT_MAX},
+	{295, 336, 358, 375, UINT_MAX},
+	{358, 358, 358, 358, 397, UINT_MAX},
+	{364, 364, 364, 364, 397, UINT_MAX},
+	{295, 336, 358, 375, 391, UINT_MAX},
+	{295, 336, 358, 375, 391, UINT_MAX},
+};
+
+static int threshold_index;
+static int package_id;
+
+static void fuse_speedo_calib(u32 *speedo_g, u32 *speedo_lp,
+			      struct device *dev)
+{
+	u32 reg;
+	int ate_ver;
+	int bit_minus1;
+	int bit_minus2;
+
+	reg = tegra30_fuse_readl(FUSE_SPEEDO_CALIB_0);
+
+	*speedo_lp = (reg & 0xFFFF) * 4;
+	*speedo_g = ((reg >> 16) & 0xFFFF) * 4;
+
+	ate_ver = tegra30_fuse_readl(FUSE_TEST_PROG_VER);
+	dev_dbg(dev, "ATE prog ver %d.%d\n", ate_ver/10, ate_ver%10);
+
+	if (ate_ver >= 26) {
+		bit_minus1 = tegra30_spare_fuse(LP_SPEEDO_BIT_MINUS1);
+		bit_minus1 |= tegra30_spare_fuse(LP_SPEEDO_BIT_MINUS1_R);
+		bit_minus2 = tegra30_spare_fuse(LP_SPEEDO_BIT_MINUS2);
+		bit_minus2 |= tegra30_spare_fuse(LP_SPEEDO_BIT_MINUS2_R);
+		*speedo_lp |= (bit_minus1 << 1) | bit_minus2;
+
+		bit_minus1 = tegra30_spare_fuse(G_SPEEDO_BIT_MINUS1);
+		bit_minus1 |= tegra30_spare_fuse(G_SPEEDO_BIT_MINUS1_R);
+		bit_minus2 = tegra30_spare_fuse(G_SPEEDO_BIT_MINUS2);
+		bit_minus2 |= tegra30_spare_fuse(G_SPEEDO_BIT_MINUS2_R);
+		*speedo_g |= (bit_minus1 << 1) | bit_minus2;
+	} else {
+		*speedo_lp |= 0x3;
+		*speedo_g |= 0x3;
+	}
+}
+
+static void rev_sku_to_speedo_ids(struct tegra_sku_info *sku_info,
+				  struct device *dev)
+{
+	switch (sku_info->revision) {
+	case TEGRA_REVISION_A01:
+		sku_info->cpu_speedo_id = 0;
+		sku_info->soc_speedo_id = 0;
+		threshold_index = THRESHOLD_INDEX_0;
+		break;
+	case TEGRA_REVISION_A02:
+	case TEGRA_REVISION_A03:
+		switch (sku_info->sku_id) {
+		case 0x87:
+		case 0x82:
+			sku_info->cpu_speedo_id = 1;
+			sku_info->soc_speedo_id = 1;
+			threshold_index = THRESHOLD_INDEX_1;
+			break;
+		case 0x81:
+			switch (package_id) {
+			case 1:
+				sku_info->cpu_speedo_id = 2;
+				sku_info->soc_speedo_id = 2;
+				threshold_index = THRESHOLD_INDEX_2;
+				break;
+			case 2:
+				sku_info->cpu_speedo_id = 4;
+				sku_info->soc_speedo_id = 1;
+				threshold_index = THRESHOLD_INDEX_7;
+				break;
+			default:
+				dev_err(dev, "Unknown pkg %d\n", package_id);
+				BUG();
+				break;
+			}
+			break;
+		case 0x80:
+			switch (package_id) {
+			case 1:
+				sku_info->cpu_speedo_id = 5;
+				sku_info->soc_speedo_id = 2;
+				threshold_index = THRESHOLD_INDEX_8;
+				break;
+			case 2:
+				sku_info->cpu_speedo_id = 6;
+				sku_info->soc_speedo_id = 2;
+				threshold_index = THRESHOLD_INDEX_9;
+				break;
+			default:
+				dev_err(dev, "Unknown pkg %d\n", package_id);
+				BUG();
+				break;
+			}
+			break;
+		case 0x83:
+			switch (package_id) {
+			case 1:
+				sku_info->cpu_speedo_id = 7;
+				sku_info->soc_speedo_id = 1;
+				threshold_index = THRESHOLD_INDEX_10;
+				break;
+			case 2:
+				sku_info->cpu_speedo_id = 3;
+				sku_info->soc_speedo_id = 2;
+				threshold_index = THRESHOLD_INDEX_3;
+				break;
+			default:
+				dev_err(dev, "Unknown pkg %d\n", package_id);
+				BUG();
+				break;
+			}
+			break;
+		case 0x8F:
+			sku_info->cpu_speedo_id = 8;
+			sku_info->soc_speedo_id = 1;
+			threshold_index = THRESHOLD_INDEX_11;
+			break;
+		case 0x08:
+			sku_info->cpu_speedo_id = 1;
+			sku_info->soc_speedo_id = 1;
+			threshold_index = THRESHOLD_INDEX_4;
+			break;
+		case 0x02:
+			sku_info->cpu_speedo_id = 2;
+			sku_info->soc_speedo_id = 2;
+			threshold_index = THRESHOLD_INDEX_5;
+			break;
+		case 0x04:
+			sku_info->cpu_speedo_id = 3;
+			sku_info->soc_speedo_id = 2;
+			threshold_index = THRESHOLD_INDEX_6;
+			break;
+		case 0:
+			switch (package_id) {
+			case 1:
+				sku_info->cpu_speedo_id = 2;
+				sku_info->soc_speedo_id = 2;
+				threshold_index = THRESHOLD_INDEX_2;
+				break;
+			case 2:
+				sku_info->cpu_speedo_id = 3;
+				sku_info->soc_speedo_id = 2;
+				threshold_index = THRESHOLD_INDEX_3;
+				break;
+			default:
+				dev_err(dev, "Unknown pkg %d\n", package_id);
+				BUG();
+				break;
+			}
+			break;
+		default:
+			dev_warn(dev, "Unknown SKU %d\n", sku_info->sku_id);
+			sku_info->cpu_speedo_id = 0;
+			sku_info->soc_speedo_id = 0;
+			threshold_index = THRESHOLD_INDEX_0;
+			break;
+		}
+		break;
+	default:
+		dev_warn(dev, "Unknown chip rev %d\n", sku_info->revision);
+		sku_info->cpu_speedo_id = 0;
+		sku_info->soc_speedo_id = 0;
+		threshold_index = THRESHOLD_INDEX_0;
+		break;
+	}
+}
+
+void tegra30_init_speedo_data(struct tegra_sku_info *sku_info,
+			      struct device *dev)
+{
+	u32 cpu_speedo_val;
+	u32 core_speedo_val;
+	int i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(cpu_process_speedos) !=
+			THRESHOLD_INDEX_COUNT);
+	BUILD_BUG_ON(ARRAY_SIZE(core_process_speedos) !=
+			THRESHOLD_INDEX_COUNT);
+
+	package_id = tegra30_fuse_readl(FUSE_PACKAGE_INFO) & 0x0F;
+
+	rev_sku_to_speedo_ids(sku_info, dev);
+	fuse_speedo_calib(&cpu_speedo_val, &core_speedo_val, dev);
+	dev_dbg(dev, "CPU speedo value %u\n", cpu_speedo_val);
+	dev_dbg(dev, "Core speedo value %u\n", core_speedo_val);
+
+	for (i = 0; i < CPU_PROCESS_CORNERS_NUM; i++) {
+		if (cpu_speedo_val < cpu_process_speedos[threshold_index][i])
+			break;
+	}
+	sku_info->cpu_process_id = i - 1;
+
+	if (sku_info->cpu_process_id == -1) {
+		dev_warn(dev, "CPU speedo value %3d out of range",
+		       cpu_speedo_val);
+		sku_info->cpu_process_id = 0;
+		sku_info->cpu_speedo_id = 1;
+	}
+
+	for (i = 0; i < CORE_PROCESS_CORNERS_NUM; i++) {
+		if (core_speedo_val < core_process_speedos[threshold_index][i])
+			break;
+	}
+	sku_info->core_process_id = i - 1;
+
+	if (sku_info->core_process_id == -1) {
+		dev_warn(dev, "CORE speedo value %3d out of range",
+		       core_speedo_val);
+		sku_info->core_process_id = 0;
+		sku_info->soc_speedo_id = 1;
+	}
+}
-- 
1.7.7.rc0.72.g4b5ea.dirty

