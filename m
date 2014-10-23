Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaJWX6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:58:34 -0400
Received: from mail-bn1bon0074.outbound.protection.outlook.com ([157.56.111.74]:25888
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755089AbaJWX6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:58:31 -0400
From: <atull@opensource.altera.com>
To: <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <michal.simek@xilinx.com>, <rdunlap@infradead.org>,
        <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <mgerlach@opensource.altera.com>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v2 3/3] fpga bridge driver
Date: Thu, 23 Oct 2014 18:51:07 -0500
Message-ID: <1414108267-22058-4-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DB4PR04CA0024.eurprd04.prod.outlook.com (25.160.41.34) To
 BL2PR03MB306.namprd03.prod.outlook.com (10.141.68.14)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB306;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(22564002)(64706001)(66066001)(86152002)(92566001)(92726001)(2201001)(33646002)(48376002)(21056001)(50986999)(86362001)(50466002)(93916002)(47776003)(20776003)(105586002)(95666004)(50226001)(4396001)(85306004)(42186005)(53416004)(106356001)(80022003)(229853001)(77096002)(46102003)(81156004)(107046002)(69596002)(85852003)(122386002)(19580405001)(19580395003)(40100003)(89996001)(87976001)(88136002)(87286001)(76482002)(104166001)(99396003)(120916001)(101416001)(15975445006)(102836001)(31966008)(76176999)(15202345003)(77156001)(62966002)(2004002)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB306;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Support for bringing bridges out of reset.  Bridges show up in sysfs
under /sys/class/fpga-bridge and can be enabled/disabled from sysfs
or from the device tree.

Supports enabling the following hps/fpga bridges:
 * fpga2sdram
 * fpga2hps
 * hps2fpga
 * lwhps2fpga

Control from sysfs:
 Enable:
  $ echo 1 > /sys/class/fpga-bridge/fpga2hps/enable

 Disable:
  $ echo 0 > /sys/class/fpga-bridge/fpga2hps/enable

 Check enable/disable status (checks for all bits set):
  $ cat /sys/class/fpga-bridge/fpga2hps/enable
  (will print '0' or '1')

Device tree has an optional property 'init-val'. This property
configures the driver to enable or disable the bridge when instantiated.
If the property does not exist, the driver will leave the bridge in
its current state.

Notes:

The L3 remap register is write-only (!) and reads zeros.  So
doing a 'read, modify, write' operation on that register will
clear the mpuzero bit that was set by u-boot.  So we keep
a cached copy of what we write to it.

The read, write, and command ports on the fpga2sdram bridge can
only be reconfigured if there are no transactions to the sdram
during the reconfiguration.  Currently, this guarantee can only
be made by code running out of onchip ram before Linux is started.
Therefore, this driver only supports enabling and disabling of the
ports that have already been configured.  Since the driver cannot
determine the port configuration in all cases, the device tree
must be populated with masks for all of the ports.

The fpga bridge framework needs be started before the individual
bridge drivers, and the individual bridge drivers need to be
started before any other driver for components on the FPGA.
The earliest the bridge drivers successfully start is during
arch_init().

Signed-off-by: Alan Tull <atull@opensource.altera.com>
Signed-off-by: Matthew Gerlach <mgerlach@opensource.altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
 drivers/misc/Kconfig                         |    3 +-
 drivers/misc/Makefile                        |    1 +
 drivers/misc/fpga-bridge/Kconfig             |   20 +++
 drivers/misc/fpga-bridge/Makefile            |    6 +
 drivers/misc/fpga-bridge/altera-fpga2sdram.c |  236 ++++++++++++++++++++++++++
 drivers/misc/fpga-bridge/altera-hps2fpga.c   |  220 ++++++++++++++++++++++++
 drivers/misc/fpga-bridge/fpga-bridge.c       |  230 +++++++++++++++++++++++++
 drivers/misc/fpga-bridge/fpga-bridge.h       |   51 ++++++
 8 files changed, 766 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/fpga-bridge/Kconfig
 create mode 100644 drivers/misc/fpga-bridge/Makefile
 create mode 100644 drivers/misc/fpga-bridge/altera-fpga2sdram.c
 create mode 100644 drivers/misc/fpga-bridge/altera-hps2fpga.c
 create mode 100644 drivers/misc/fpga-bridge/fpga-bridge.c
 create mode 100644 drivers/misc/fpga-bridge/fpga-bridge.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index bbeb451..6792a03 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -527,5 +527,6 @@ source "drivers/misc/vmw_vmci/Kconfig"
 source "drivers/misc/mic/Kconfig"
 source "drivers/misc/genwqe/Kconfig"
 source "drivers/misc/echo/Kconfig"
-source "drivers/misc/cxl/Kconfig"
+source "drivers/misc/fpga-bridge/Kconfig"
+
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 7d5c4cd..83dda02 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_C2PORT)		+= c2port/
 obj-$(CONFIG_HMC6352)		+= hmc6352.o
 obj-y				+= eeprom/
 obj-y				+= cb710/
+obj-$(CONFIG_FPGA_BRIDGE)	+= fpga-bridge/
 obj-$(CONFIG_SPEAR13XX_PCIE_GADGET)	+= spear13xx_pcie_gadget.o
 obj-$(CONFIG_VMWARE_BALLOON)	+= vmw_balloon.o
 obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
diff --git a/drivers/misc/fpga-bridge/Kconfig b/drivers/misc/fpga-bridge/Kconfig
new file mode 100644
index 0000000..725474e
--- /dev/null
+++ b/drivers/misc/fpga-bridge/Kconfig
@@ -0,0 +1,20 @@
+#
+# FPGA bridge manager configuration
+#
+
+menu "FPGA Bridges"
+
+config FPGA_BRIDGE
+       tristate "FPGA Bridge Drivers"
+       depends on OF
+       help
+         Say Y here if you want to support bridges connected between host
+	 processors and FPGAs or between FPGAs.
+
+config ALTERA_SOCFPGA_BRIDGE
+       tristate "Altera SoCFPGA Bridges"
+       depends on FPGA_BRIDGE
+       help
+         Say Y to enable drivers for FPGA bridges for Altera socfpga
+	 devices.
+endmenu
diff --git a/drivers/misc/fpga-bridge/Makefile b/drivers/misc/fpga-bridge/Makefile
new file mode 100644
index 0000000..3700f8a
--- /dev/null
+++ b/drivers/misc/fpga-bridge/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for the fpga-bridge drivers
+#
+
+obj-$(CONFIG_FPGA_BRIDGE)	+= fpga-bridge.o
+obj-$(CONFIG_ALTERA_SOCFPGA_BRIDGE) += altera-fpga2sdram.o altera-hps2fpga.o
\ No newline at end of file
diff --git a/drivers/misc/fpga-bridge/altera-fpga2sdram.c b/drivers/misc/fpga-bridge/altera-fpga2sdram.c
new file mode 100644
index 0000000..9e5765e
--- /dev/null
+++ b/drivers/misc/fpga-bridge/altera-fpga2sdram.c
@@ -0,0 +1,236 @@
+/*
+ * FPGA to sdram Bridge Driver for Altera SoCFPGA Devices
+ *
+ *  Copyright (C) 2013 Altera Corporation, All Rights Reserved.
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
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <linux/of_address.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/regmap.h>
+#include "fpga-bridge.h"
+
+#define ALT_SDR_CTL_FPGAPORTRST_OFST		0x80
+#define ALT_SDR_CTL_FPGAPORTRST_PORTRSTN_MSK	0x00003fff
+#define ALT_SDR_CTL_FPGAPORTRST_RD_SHIFT	0
+#define ALT_SDR_CTL_FPGAPORTRST_WR_SHIFT	4
+#define ALT_SDR_CTL_FPGAPORTRST_CTRL_SHIFT	8
+
+#define FOUR_BIT_MASK 0xf
+#define SIX_BIT_MASK 0x3f
+
+static struct of_device_id altera_fpga_of_match[];
+
+struct alt_fpga2sdram_data {
+	char	name[48];
+	struct platform_device *pdev;
+	struct device_node *np;
+	struct regmap *sdrctl;
+	int mask;
+};
+
+static atomic_t instances;
+
+static int alt_fpga2sdram_enable_show(struct fpga_bridge *bridge)
+{
+	struct alt_fpga2sdram_data *priv = bridge->priv;
+	int value;
+
+	regmap_read(priv->sdrctl, ALT_SDR_CTL_FPGAPORTRST_OFST, &value);
+
+	return ((value & priv->mask) == priv->mask);
+}
+
+static inline void _alt_fpga2sdram_enable_set(struct alt_fpga2sdram_data *priv,
+					      bool enable)
+{
+	int value;
+
+	if (enable)
+		value = priv->mask;
+	else
+		value = 0;
+
+	regmap_update_bits(priv->sdrctl, ALT_SDR_CTL_FPGAPORTRST_OFST,
+			   priv->mask, value);
+}
+
+static void alt_fpga2sdram_enable_set(struct fpga_bridge *bridge, bool enable)
+{
+	_alt_fpga2sdram_enable_set(bridge->priv, enable);
+}
+
+struct prop_map {
+	char *prop_name;
+	uint32_t *prop_value;
+	uint32_t prop_max;
+};
+
+static int alt_fpga2sdram_get_mask(struct alt_fpga2sdram_data *priv)
+{
+	int i;
+	uint32_t read, write, cmd;
+	struct prop_map map[] = {
+		{"read-ports-mask", &read, FOUR_BIT_MASK},
+		{"write-ports-mask", &write, FOUR_BIT_MASK},
+		{"cmd-ports-mask", &cmd, SIX_BIT_MASK},
+	};
+
+	for (i = 0; i < ARRAY_SIZE(map); i++) {
+		if (of_property_read_u32(priv->np, map[i].prop_name,
+					 map[i].prop_value)) {
+			dev_err(&priv->pdev->dev,
+				"failed to find property, %s\n",
+				map[i].prop_name);
+			return -EINVAL;
+		} else if (*map[i].prop_value > map[i].prop_max) {
+			dev_err(&priv->pdev->dev,
+				"%s value 0x%x > than max 0x%x\n",
+				map[i].prop_name,
+				*map[i].prop_value,
+				map[i].prop_max);
+			return -EINVAL;
+		}
+	}
+
+	priv->mask =
+		(read << ALT_SDR_CTL_FPGAPORTRST_RD_SHIFT) |
+		(write << ALT_SDR_CTL_FPGAPORTRST_WR_SHIFT) |
+		(cmd << ALT_SDR_CTL_FPGAPORTRST_CTRL_SHIFT);
+
+	return 0;
+}
+
+struct fpga_bridge_ops altera_fpga2sdram_br_ops = {
+	.enable_set = alt_fpga2sdram_enable_set,
+	.enable_show = alt_fpga2sdram_enable_show,
+};
+
+static struct alt_fpga2sdram_data fpga2sdram_data  = {
+	.name = "fpga2sdram",
+};
+
+static int alt_fpga_bridge_probe(struct platform_device *pdev)
+{
+	struct alt_fpga2sdram_data *priv;
+	struct alt_fpga2sdram_data *data;
+	uint32_t init_val;
+	const struct of_device_id *of_id = of_match_device(altera_fpga_of_match,
+						     &pdev->dev);
+	int ret = 0;
+
+	if (atomic_inc_return(&instances) > 1) {
+		atomic_dec(&instances);
+		dev_err(&pdev->dev,
+			"already one instance of driver\n");
+		return -ENODEV;
+	}
+
+	data = (struct alt_fpga2sdram_data *)of_id->data;
+	WARN_ON(!data);
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->np = pdev->dev.of_node;
+	priv->pdev = pdev;
+	priv->mask = data->mask;
+	strncpy(priv->name, data->name, ARRAY_SIZE(priv->name));
+
+	priv->sdrctl = syscon_regmap_lookup_by_phandle(priv->np,
+						       "altr,sdr-syscon");
+	if (IS_ERR(priv->sdrctl)) {
+		devm_kfree(&pdev->dev, priv);
+		dev_err(&pdev->dev,
+			"regmap for altr,sdr-syscon lookup failed.\n");
+		return PTR_ERR(priv->sdrctl);
+	}
+
+	ret = alt_fpga2sdram_get_mask(priv);
+	if (ret) {
+		devm_kfree(&pdev->dev, priv);
+		return ret;
+	}
+
+	ret = register_fpga_bridge(pdev, &altera_fpga2sdram_br_ops,
+				   priv->name, priv);
+
+	if (!ret)
+		return ret;
+
+	if (of_property_read_u32(priv->np, "init-val", &init_val)) {
+		dev_info(&priv->pdev->dev, "init-val not specified\n");
+	} else if (init_val > 1) {
+		dev_warn(&priv->pdev->dev, "invalid init-val %u > 1\n",
+			 init_val);
+	} else {
+		dev_info(&priv->pdev->dev, "%s bridge\n",
+			 (init_val ? "enabling" : "disabling"));
+
+		_alt_fpga2sdram_enable_set(priv, init_val);
+	}
+
+	return ret;
+}
+
+static int alt_fpga_bridge_remove(struct platform_device *pdev)
+{
+	remove_fpga_bridge(pdev);
+	atomic_dec(&instances);
+	return 0;
+}
+
+static struct of_device_id altera_fpga_of_match[] = {
+	{ .compatible = "altr,socfpga-fpga2sdram-bridge",
+	  .data = &fpga2sdram_data },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, altera_fpga_of_match);
+
+static struct platform_driver altera_fpga_driver = {
+	.remove = alt_fpga_bridge_remove,
+	.driver = {
+		.name	= "altera_fpga2sdram_bridge",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(altera_fpga_of_match),
+	},
+};
+
+static int __init alt_fpga_bridge_init(void)
+{
+	atomic_set(&instances, 0);
+	return platform_driver_probe(&altera_fpga_driver,
+				     alt_fpga_bridge_probe);
+}
+
+static void __exit alt_fpga_bridge_exit(void)
+{
+	platform_driver_unregister(&altera_fpga_driver);
+}
+
+arch_initcall(alt_fpga_bridge_init);
+module_exit(alt_fpga_bridge_exit);
+
+MODULE_DESCRIPTION("Altera SoCFPGA FPGA to SDRAM Bridge");
+MODULE_AUTHOR("Alan Tull <atull@altera.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/misc/fpga-bridge/altera-hps2fpga.c b/drivers/misc/fpga-bridge/altera-hps2fpga.c
new file mode 100644
index 0000000..a6cbdd3
--- /dev/null
+++ b/drivers/misc/fpga-bridge/altera-hps2fpga.c
@@ -0,0 +1,220 @@
+/*
+ * FPGA to/from HPS Bridge Driver for Altera SoCFPGA Devices
+ *
+ *  Copyright (C) 2013 Altera Corporation, All Rights Reserved.
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
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <linux/of_address.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+#include "fpga-bridge.h"
+
+#define SOCFPGA_RSTMGR_BRGMODRST		0x1c
+#define ALT_RSTMGR_BRGMODRST_H2F_MSK		0x00000001
+#define ALT_RSTMGR_BRGMODRST_LWH2F_MSK		0x00000002
+#define ALT_RSTMGR_BRGMODRST_F2H_MSK		0x00000004
+
+#define ALT_L3_REMAP_OFST			0x0
+#define ALT_L3_REMAP_MPUZERO_MSK		0x00000001
+#define ALT_L3_REMAP_H2F_MSK			0x00000008
+#define ALT_L3_REMAP_LWH2F_MSK			0x00000010
+
+#define HPS2FPGA_BRIDGE_NAME			"hps2fpga"
+#define LWHPS2FPGA_BRIDGE_NAME			"lwhps2fpga"
+#define FPGA2HPS_BRIDGE_NAME			"fpga2hps"
+static struct of_device_id altera_fpga_of_match[];
+
+/* The L3 REMAP register is write only, so keep a cached value. */
+static unsigned int l3_remap_value;
+
+struct altera_hps2fpga_data {
+	char	name[48];
+	struct platform_device *pdev;
+	struct device_node *np;
+	struct reset_control *bridge_reset;
+	struct regmap *l3reg;
+	unsigned int reset_mask;
+	unsigned int remap_mask;
+};
+
+static int alt_hps2fpga_enable_show(struct fpga_bridge *bridge)
+{
+	struct altera_hps2fpga_data *priv = bridge->priv;
+
+	return reset_control_status(priv->bridge_reset);
+}
+
+static inline void _alt_hps2fpga_enable_set(struct altera_hps2fpga_data *priv,
+					    bool enable)
+{
+	/* bring bridge out of reset */
+	if (enable)
+		reset_control_deassert(priv->bridge_reset);
+	else
+		reset_control_assert(priv->bridge_reset);
+
+	/* Allow bridge to be visible to L3 masters or not */
+	if (priv->remap_mask) {
+		l3_remap_value |= ALT_L3_REMAP_MPUZERO_MSK;
+
+		if (enable)
+			l3_remap_value |= priv->remap_mask;
+		else
+			l3_remap_value &= ~priv->remap_mask;
+
+		regmap_write(priv->l3reg, ALT_L3_REMAP_OFST, l3_remap_value);
+	}
+}
+
+static void alt_hps2fpga_enable_set(struct fpga_bridge *bridge, bool enable)
+{
+	_alt_hps2fpga_enable_set(bridge->priv, enable);
+}
+
+struct fpga_bridge_ops altera_hps2fpga_br_ops = {
+	.enable_set = alt_hps2fpga_enable_set,
+	.enable_show = alt_hps2fpga_enable_show,
+};
+
+static struct altera_hps2fpga_data hps2fpga_data  = {
+	.name = HPS2FPGA_BRIDGE_NAME,
+	.reset_mask = ALT_RSTMGR_BRGMODRST_H2F_MSK,
+	.remap_mask = ALT_L3_REMAP_H2F_MSK,
+};
+
+static struct altera_hps2fpga_data lwhps2fpga_data  = {
+	.name = LWHPS2FPGA_BRIDGE_NAME,
+	.reset_mask = ALT_RSTMGR_BRGMODRST_LWH2F_MSK,
+	.remap_mask = ALT_L3_REMAP_LWH2F_MSK,
+};
+
+static struct altera_hps2fpga_data fpga2hps_data  = {
+	.name = FPGA2HPS_BRIDGE_NAME,
+	.reset_mask = ALT_RSTMGR_BRGMODRST_F2H_MSK,
+};
+
+static int alt_fpga_bridge_probe(struct platform_device *pdev)
+{
+	struct altera_hps2fpga_data *priv;
+	const struct of_device_id *of_id;
+	struct device *dev = &pdev->dev;
+	uint32_t init_val;
+	int rc;
+	struct clk *clk;
+
+	of_id = of_match_device(altera_fpga_of_match, dev);
+	priv = (struct altera_hps2fpga_data *)of_id->data;
+	WARN_ON(!priv);
+
+	priv->np = dev->of_node;
+	priv->pdev = pdev;
+
+	priv->bridge_reset = devm_reset_control_get(dev, priv->name);
+	if (IS_ERR(priv->bridge_reset)) {
+		dev_err(dev, "Could not get %s reset control!\n", priv->name);
+		return PTR_ERR(priv->bridge_reset);
+	}
+
+	priv->l3reg = syscon_regmap_lookup_by_phandle(priv->np,
+						      "altr,l3-syscon");
+	if (IS_ERR(priv->l3reg)) {
+		dev_err(dev, "regmap for altr,l3regs lookup failed.\n");
+		return PTR_ERR(priv->l3reg);
+	}
+
+	clk = of_clk_get(pdev->dev.of_node, 0);
+	if (IS_ERR(clk)) {
+		dev_err(dev, "no clock specified\n");
+		return PTR_ERR(clk);
+	}
+
+	rc = clk_prepare_enable(clk);
+	if (rc) {
+		dev_err(dev, "could not enable clock\n");
+		return -EBUSY;
+	}
+
+	rc = register_fpga_bridge(pdev, &altera_hps2fpga_br_ops, priv->name,
+				  priv);
+	if (rc)
+		return rc;
+
+	if (of_property_read_u32(priv->np, "init-val", &init_val)) {
+		dev_info(&priv->pdev->dev, "init-val not specified\n");
+	} else if (init_val > 1) {
+		dev_warn(&priv->pdev->dev, "invalid init-val %u > 1\n",
+			 init_val);
+	} else {
+		dev_info(&priv->pdev->dev, "%s bridge\n",
+			 (init_val ? "enabling" : "disabling"));
+
+		_alt_hps2fpga_enable_set(priv, init_val);
+	}
+
+	return rc;
+}
+
+static int alt_fpga_bridge_remove(struct platform_device *pdev)
+{
+	remove_fpga_bridge(pdev);
+	return 0;
+}
+
+static struct of_device_id altera_fpga_of_match[] = {
+	{ .compatible = "altr,socfpga-hps2fpga-bridge",
+	  .data = &hps2fpga_data },
+	{ .compatible = "altr,socfpga-lwhps2fpga-bridge",
+	  .data = &lwhps2fpga_data },
+	{ .compatible = "altr,socfpga-fpga2hps-bridge",
+	  .data = &fpga2hps_data },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, altera_fpga_of_match);
+
+static struct platform_driver altera_fpga_driver = {
+	.remove = alt_fpga_bridge_remove,
+	.driver = {
+		.name	= "altera_hps2fpga_bridge",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(altera_fpga_of_match),
+	},
+};
+
+static int __init alt_fpga_bridge_init(void)
+{
+	return platform_driver_probe(&altera_fpga_driver,
+				     alt_fpga_bridge_probe);
+}
+
+static void __exit alt_fpga_bridge_exit(void)
+{
+	platform_driver_unregister(&altera_fpga_driver);
+}
+
+arch_initcall(alt_fpga_bridge_init);
+module_exit(alt_fpga_bridge_exit);
+
+MODULE_DESCRIPTION("Altera SoCFPGA HPS to FPGA Bridge");
+MODULE_AUTHOR("Alan Tull <atull@altera.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/misc/fpga-bridge/fpga-bridge.c b/drivers/misc/fpga-bridge/fpga-bridge.c
new file mode 100644
index 0000000..d70862c
--- /dev/null
+++ b/drivers/misc/fpga-bridge/fpga-bridge.c
@@ -0,0 +1,230 @@
+/*
+ * fpga bridge driver
+ *
+ *  Copyright (C) 2013 Altera Corporation, All Rights Reserved.
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
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/slab.h>
+#include "fpga-bridge.h"
+
+static DEFINE_IDA(fpga_bridge_ida);
+static struct class *fpga_bridge_class;
+
+#define FPGA_MAX_DEVICES	256
+
+/*
+ * class attributes
+ */
+static ssize_t fpga_bridge_enable_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct fpga_bridge *bridge = dev_get_drvdata(dev);
+	int enabled;
+
+	enabled = bridge->br_ops->enable_show(bridge);
+
+	return sprintf(buf, "%d\n", enabled);
+}
+
+static ssize_t fpga_bridge_enable_set(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct fpga_bridge *bridge = dev_get_drvdata(dev);
+	bool enable;
+
+	if ((count != 1) && (count != 2))
+		return -EINVAL;
+
+	if ((count == 2) && (buf[1] != '\n'))
+		return -EINVAL;
+
+	if ((buf[0] != '0') && (buf[0] != '1'))
+		return -EINVAL;
+
+	enable = (buf[0] == '1');
+	bridge->br_ops->enable_set(bridge, enable);
+
+	return count;
+}
+
+static DEVICE_ATTR(enable, S_IRUGO | S_IWUSR, fpga_bridge_enable_show,
+	fpga_bridge_enable_set);
+
+static struct attribute *fpga_bridge_attrs[] = {
+	&dev_attr_enable.attr,
+	NULL,
+};
+
+static const struct attribute_group fpga_bridge_group = {
+	.attrs = fpga_bridge_attrs,
+};
+
+const struct attribute_group *fpga_bridge_groups[] = {
+	&fpga_bridge_group,
+	NULL,
+};
+
+static int fpga_bridge_alloc_id(struct fpga_bridge *bridge, int request_nr)
+{
+	int nr, start;
+
+	/* check specified minor number */
+	if (request_nr >= FPGA_MAX_DEVICES) {
+		dev_err(bridge->parent,
+			"Out of device ids (%d)\n", request_nr);
+		return -ENODEV;
+	}
+
+	/*
+	 * If request_nr == -1, dynamically allocate number.
+	 * If request_nr >= 0, attempt to get specific number.
+	 */
+	if (request_nr == -1)
+		start = 0;
+	else
+		start = request_nr;
+
+	nr = ida_simple_get(&fpga_bridge_ida, start, FPGA_MAX_DEVICES,
+			    GFP_KERNEL);
+
+	/* return error code */
+	if (nr < 0)
+		return nr;
+
+	if ((request_nr != -1) && (request_nr != nr)) {
+		dev_err(bridge->parent,
+			"Could not get requested device number (%d)\n", nr);
+		ida_simple_remove(&fpga_bridge_ida, nr);
+		return -ENODEV;
+	}
+
+	bridge->nr = nr;
+
+	return 0;
+}
+
+static void fpga_bridge_free_id(int nr)
+{
+	ida_simple_remove(&fpga_bridge_ida, nr);
+}
+
+int register_fpga_bridge(struct platform_device *pdev,
+			 struct fpga_bridge_ops *br_ops,
+			 char *name, void *priv)
+{
+	struct fpga_bridge *bridge;
+	const char *dt_label;
+	int ret;
+
+	if (!br_ops || !br_ops->enable_set || !br_ops->enable_show) {
+		dev_err(&pdev->dev,
+			"Attempt to register without fpga_bridge_ops\n");
+		return -EINVAL;
+	}
+	if (!name || (name[0] == '\0')) {
+		dev_err(&pdev->dev, "Attempt to register with no name!\n");
+		return -EINVAL;
+	}
+
+	bridge = kzalloc(sizeof(*bridge), GFP_KERNEL);
+	if (!bridge)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, bridge);
+	bridge->br_ops = br_ops;
+	bridge->np = pdev->dev.of_node;
+	bridge->parent = get_device(&pdev->dev);
+	bridge->priv = priv;
+
+	strlcpy(bridge->name, name, sizeof(bridge->name));
+
+	ret = fpga_bridge_alloc_id(bridge, pdev->id);
+	if (ret)
+		goto error_kfree;
+
+	dt_label = of_get_property(bridge->np, "label", NULL);
+	if (dt_label)
+		snprintf(bridge->label, sizeof(bridge->label), "%s", dt_label);
+	else
+		snprintf(bridge->label, sizeof(bridge->label),
+			 "br%d", bridge->nr);
+
+	bridge->dev = device_create(fpga_bridge_class, bridge->parent, 0,
+				    bridge, bridge->label);
+	if (IS_ERR(bridge->dev)) {
+		ret = PTR_ERR(bridge->dev);
+		goto error_device;
+	}
+
+	dev_info(bridge->parent, "fpga bridge [%s] registered as device %s\n",
+		 bridge->name, bridge->label);
+
+	return 0;
+
+error_device:
+	fpga_bridge_free_id(bridge->nr);
+error_kfree:
+	put_device(bridge->parent);
+	kfree(bridge);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_fpga_bridge);
+
+void remove_fpga_bridge(struct platform_device *pdev)
+{
+	struct fpga_bridge *bridge = platform_get_drvdata(pdev);
+
+	if (bridge && bridge->br_ops && bridge->br_ops->fpga_bridge_remove)
+		bridge->br_ops->fpga_bridge_remove(bridge);
+
+	platform_set_drvdata(pdev, NULL);
+	device_unregister(bridge->dev);
+	fpga_bridge_free_id(bridge->nr);
+	put_device(bridge->parent);
+	kfree(bridge);
+}
+EXPORT_SYMBOL_GPL(remove_fpga_bridge);
+
+static int __init fpga_bridge_dev_init(void)
+{
+	pr_info("fpga bridge driver\n");
+
+	fpga_bridge_class = class_create(THIS_MODULE, "fpga-bridge");
+	if (IS_ERR(fpga_bridge_class))
+		return PTR_ERR(fpga_bridge_class);
+
+	fpga_bridge_class->dev_groups = fpga_bridge_groups;
+
+	return 0;
+}
+
+static void __exit fpga_bridge_dev_exit(void)
+{
+	class_destroy(fpga_bridge_class);
+	ida_destroy(&fpga_bridge_ida);
+}
+
+MODULE_DESCRIPTION("FPGA Bridge Driver");
+MODULE_AUTHOR("Alan Tull <atull@altera.com>");
+MODULE_LICENSE("GPL v2");
+
+core_initcall_sync(fpga_bridge_dev_init);
+module_exit(fpga_bridge_dev_exit);
diff --git a/drivers/misc/fpga-bridge/fpga-bridge.h b/drivers/misc/fpga-bridge/fpga-bridge.h
new file mode 100644
index 0000000..b7b5e70
--- /dev/null
+++ b/drivers/misc/fpga-bridge/fpga-bridge.h
@@ -0,0 +1,51 @@
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/cdev.h>
+
+#ifndef _LINUX_FPGA_BRIDGE_H
+#define _LINUX_FPGA_BRIDGE_H
+
+struct fpga_bridge;
+
+/*---------------------------------------------------------------------------*/
+
+/*
+ * fpga_bridge_ops are the low level functions implemented by a specific
+ * fpga bridge driver.
+ */
+struct fpga_bridge_ops {
+	/* Returns the FPGA bridge's status */
+	int (*enable_show)(struct fpga_bridge *bridge);
+
+	/* Enable a FPGA bridge */
+	void (*enable_set)(struct fpga_bridge *bridge, bool enable);
+
+	/* Set FPGA into a specific state during driver remove */
+	void (*fpga_bridge_remove)(struct fpga_bridge *bridge);
+};
+
+struct fpga_bridge {
+	struct device_node *np;
+	struct device *parent;
+	struct device *dev;
+	struct cdev cdev;
+
+	int nr;
+	char name[48];
+	char label[48];
+	unsigned long flags;
+	struct fpga_bridge_ops *br_ops;
+
+	void *priv;
+};
+
+#if defined(CONFIG_FPGA_BRIDGE) || defined(CONFIG_FPGA_BRIDGE_MODULE)
+
+int register_fpga_bridge(struct platform_device *pdev,
+			 struct fpga_bridge_ops *br_ops,
+			 char *name, void *priv);
+
+void remove_fpga_bridge(struct platform_device *pdev);
+
+#endif /* CONFIG_FPGA_BRIDGE */
+#endif /* _LINUX_FPGA_BRIDGE_H */
-- 
1.7.9.5

