Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaAIMfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:35:40 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59334 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaAIMfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:35:10 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, b.brezillon@overkiz.com, arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v2 07/12] at91: dt: smc: Added smc bus driver
Date: Thu,  9 Jan 2014 13:31:44 +0100
Message-Id: <1389270709-32662-8-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
References: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EBI/SMC external interface is used to access external peripherals (NAND
and Ethernet controller in the case of sam9261ek). Different configurations and
timings are required for those peripherals. This bus driver can be used to
setup the bus timings/configuration from the device tree.
It currently accepts timings in clock period and in nanoseconds.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/memory/Kconfig     |  10 ++
 drivers/memory/Makefile    |   1 +
 drivers/memory/atmel-smc.c | 431 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 442 insertions(+)
 create mode 100644 drivers/memory/atmel-smc.c

diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index 29a11db..fbdfd63 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -50,4 +50,14 @@ config TEGRA30_MC
 	  analysis, especially for IOMMU/SMMU(System Memory Management
 	  Unit) module.
 
+config ATMEL_SMC
+	bool "Atmel SMC/EBI driver"
+	default y
+	depends on SOC_AT91SAM9 && OF
+	help
+	  Driver for Atmel SMC/EBI controller.
+	  Used to configure the EBI (external bus interface) when the device-
+	  tree is used. This bus supports NANDs, external ethernet controller,
+	  SRAMs, ATA devices, etc.
+
 endif
diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
index 969d923..101abc4 100644
--- a/drivers/memory/Makefile
+++ b/drivers/memory/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_TI_EMIF)		+= emif.o
 obj-$(CONFIG_MVEBU_DEVBUS)	+= mvebu-devbus.o
 obj-$(CONFIG_TEGRA20_MC)	+= tegra20-mc.o
 obj-$(CONFIG_TEGRA30_MC)	+= tegra30-mc.o
+obj-$(CONFIG_ATMEL_SMC)        += atmel-smc.o
diff --git a/drivers/memory/atmel-smc.c b/drivers/memory/atmel-smc.c
new file mode 100644
index 0000000..0a1d9ba
--- /dev/null
+++ b/drivers/memory/atmel-smc.c
@@ -0,0 +1,431 @@
+/*
+ * EBI driver for Atmel SAM9 chips
+ * inspired by the fsl weim bus driver
+ *
+ * Copyright (C) 2013 JJ Hiblot.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/of_device.h>
+#include <mach/at91sam9_smc.h>
+
+struct  smc_data {
+	struct clk *bus_clk;
+	void __iomem *base;
+	struct device *dev;
+};
+
+struct at91_smc_devtype {
+	unsigned int	cs_count;
+};
+
+static const struct at91_smc_devtype sam9261_smc_devtype = {
+	.cs_count	= 6,
+};
+
+static const struct of_device_id smc_id_table[] = {
+	{ .compatible = "atmel,at91sam9261-smc", .data = &sam9261_smc_devtype},
+	{ }
+};
+MODULE_DEVICE_TABLE(of, smc_id_table);
+
+struct smc_parameters_type {
+	const char *name;
+	u16 width;
+	u16 shift;
+};
+
+static const struct smc_parameters_type smc_parameters[] = {
+	{"smc,burst_size",	2, 28},
+	{"smc,burst_enabled",	1, 24},
+	{"smc,tdf_mode",	1, 20},
+	{"smc,bus_width",	2, 12},
+	{"smc,byte_access_type", 1,  8},
+	{"smc,nwait_mode",	2,  4},
+	{"smc,write_mode",	1,  0},
+	{"smc,read_mode",	1,  1},
+	{NULL}
+};
+
+static int get_mode_register_from_dt(struct smc_data *smc,
+				     struct device_node *np,
+				     struct sam9_smc_config *cfg)
+{
+	int ret;
+	u32 val;
+	struct device *dev = smc->dev;
+	const struct smc_parameters_type *p = smc_parameters;
+	u32 mode = cfg->mode;
+
+	while (p->name) {
+		ret = of_property_read_u32(np, p->name , &val);
+		if (ret == -EINVAL) {
+			dev_dbg(dev, "%s: property %s not set.\n", np->name,
+				p->name);
+			p++;
+			continue;
+		} else if (ret) {
+			dev_err(dev, "%s: can't get property %s.\n", np->name,
+				p->name);
+			return ret;
+		}
+		if (val >= (1<<p->width)) {
+			dev_err(dev, "%s: property %s out of range.\n",
+				np->name, p->name);
+			return -ERANGE;
+		}
+		mode &= ~(((1<<p->width)-1) << p->shift);
+		mode |= (val << p->shift);
+		p++;
+	}
+	cfg->mode = mode;
+	return 0;
+}
+
+static int generic_timing_from_dt(struct smc_data *smc, struct device_node *np,
+				  struct sam9_smc_config *cfg)
+{
+	u32 val;
+
+	if (!of_property_read_u32(np, "smc,ncs_read_setup" , &val))
+		cfg->ncs_read_setup = val;
+
+	if (!of_property_read_u32(np, "smc,nrd_setup" , &val))
+		cfg->nrd_setup = val;
+
+	if (!of_property_read_u32(np, "smc,ncs_write_setup" , &val))
+		cfg->ncs_write_setup = val;
+
+	if (!of_property_read_u32(np, "smc,nwe_setup" , &val))
+		cfg->nwe_setup = val;
+
+	if (!of_property_read_u32(np, "smc,ncs_read_pulse" , &val))
+		cfg->ncs_read_pulse = val;
+
+	if (!of_property_read_u32(np, "smc,nrd_pulse" , &val))
+		cfg->nrd_pulse = val;
+
+	if (!of_property_read_u32(np, "smc,ncs_write_pulse" , &val))
+		cfg->ncs_write_pulse = val;
+
+	if (!of_property_read_u32(np, "smc,nwe_pulse" , &val))
+		cfg->nwe_pulse = val;
+
+	if (!of_property_read_u32(np, "smc,read_cycle" , &val))
+		cfg->read_cycle = val;
+
+	if (!of_property_read_u32(np, "smc,write_cycle" , &val))
+		cfg->write_cycle = val;
+
+	if (!of_property_read_u32(np, "smc,tdf_cycles" , &val))
+		cfg->tdf_cycles = val;
+
+	return get_mode_register_from_dt(smc, np, cfg);
+}
+
+/* convert the time in ns in a number of clock cycles */
+static u32 ns_to_cycles(u32 ns, u32 clk)
+{
+	/*
+	 * convert the clk to kHz for the rest of the calculation to avoid
+	 * overflow
+	 */
+	u32 clk_kHz = clk / 1000;
+	u32 ncycles = ((ns * clk_kHz) + 1000000 - 1) / 1000000;
+	return ncycles;
+}
+
+static u32 cycles_to_coded_cycle(u32 cycles, int a, int b)
+{
+	u32 mask_high = (1 << a) - 1;
+	u32 mask_low = (1 << b) - 1;
+	u32 coded;
+
+	/* check if the value can be described with the coded format */
+	if (cycles & (mask_high & ~mask_low)) {
+		/* not representable. we need to round up */
+		cycles |= mask_high;
+		cycles += 1;
+	}
+	/* Now the value can be represented in the coded format */
+	coded = (cycles & ~mask_high) >> (a - b);
+	coded |= (cycles & mask_low);
+	return coded;
+}
+
+static u32 ns_to_rw_cycles(u32 ns, u32 clk)
+{
+	return cycles_to_coded_cycle(ns_to_cycles(ns, clk), 8, 7);
+}
+
+static u32 ns_to_pulse_cycles(u32 ns, u32 clk)
+{
+	return cycles_to_coded_cycle(ns_to_cycles(ns, clk), 8, 6);
+}
+
+static u32 ns_to_setup_cycles(u32 ns, u32 clk)
+{
+	return cycles_to_coded_cycle(ns_to_cycles(ns, clk), 7, 5);
+}
+
+static u32 cycles_to_ns(u32 cycles, u32 clk)
+{
+	/*
+	 * convert the clk to kHz for the rest of the calculation to avoid
+	 * overflow
+	 */
+	u32 clk_kHz = clk / 1000;
+	return (cycles * 1000000) / clk_kHz;
+}
+
+static u32 coded_cycle_to_cycles(u32 coded, int a, int b)
+{
+	u32 cycles = (coded >> b) << a;
+	u32 mask_low = (1 << b) - 1;
+	cycles |= (coded & mask_low);
+	return cycles;
+}
+
+static u32 rw_cycles_to_ns(u32 reg, u32 clk)
+{
+	return cycles_to_ns(coded_cycle_to_cycles(reg, 8, 7), clk);
+}
+
+static u32 pulse_cycles_to_ns(u32 reg, u32 clk)
+{
+	return cycles_to_ns(coded_cycle_to_cycles(reg, 8, 6), clk);
+}
+
+static u32 setup_cycles_to_ns(u32 reg, u32 clk)
+{
+	return cycles_to_ns(coded_cycle_to_cycles(reg, 7, 5), clk);
+}
+
+static void dump_timing(struct smc_data *smc, struct sam9_smc_config *config)
+{
+	u32 freq = clk_get_rate(smc->bus_clk);
+	struct device *dev = smc->dev;
+
+#define DUMP(fn, y)	dev_info(dev, "%s : 0x%x (%d ns)\n", #y, config->y,\
+				 fn(config->y, freq))
+#define DUMP_PULSE(y)	DUMP(pulse_cycles_to_ns, y)
+#define DUMP_RWCYCLE(y)	DUMP(rw_cycles_to_ns, y)
+#define DUMP_SETUP(y)	DUMP(setup_cycles_to_ns, y)
+#define DUMP_SIMPLE(y)	DUMP(cycles_to_ns, y)
+
+	DUMP_SETUP(nwe_setup);
+	DUMP_SETUP(ncs_write_setup);
+	DUMP_SETUP(nrd_setup);
+	DUMP_SETUP(ncs_read_setup);
+	DUMP_PULSE(nwe_pulse);
+	DUMP_PULSE(ncs_write_pulse);
+	DUMP_PULSE(nrd_pulse);
+	DUMP_PULSE(ncs_read_pulse);
+	DUMP_RWCYCLE(write_cycle);
+	DUMP_RWCYCLE(read_cycle);
+	DUMP_SIMPLE(tdf_cycles);
+}
+
+static int ns_timing_from_dt(struct smc_data *smc, struct device_node *np,
+			     struct sam9_smc_config *cfg)
+{
+	u32 t_ns;
+	u32 freq = clk_get_rate(smc->bus_clk);
+
+	if (!of_property_read_u32(np, "smc,ncs_read_setup" , &t_ns))
+		cfg->ncs_read_setup = ns_to_setup_cycles(t_ns, freq);
+
+	if (!of_property_read_u32(np, "smc,nrd_setup" , &t_ns))
+		cfg->nrd_setup = ns_to_setup_cycles(t_ns, freq);
+
+	if (!of_property_read_u32(np, "smc,ncs_write_setup" , &t_ns))
+		cfg->ncs_write_setup = ns_to_setup_cycles(t_ns, freq);
+
+	if (!of_property_read_u32(np, "smc,nwe_setup" , &t_ns))
+		cfg->nwe_setup = ns_to_setup_cycles(t_ns, freq);
+
+	if (!of_property_read_u32(np, "smc,ncs_read_pulse" , &t_ns))
+		cfg->ncs_read_pulse = ns_to_pulse_cycles(t_ns, freq);
+
+	if (!of_property_read_u32(np, "smc,nrd_pulse" , &t_ns))
+		cfg->nrd_pulse = ns_to_pulse_cycles(t_ns, freq);
+
+	if (!of_property_read_u32(np, "smc,ncs_write_pulse" , &t_ns))
+		cfg->ncs_write_pulse = ns_to_pulse_cycles(t_ns, freq);
+
+	if (!of_property_read_u32(np, "smc,nwe_pulse" , &t_ns))
+		cfg->nwe_pulse = ns_to_pulse_cycles(t_ns, freq);
+
+	if (!of_property_read_u32(np, "smc,read_cycle" , &t_ns))
+		cfg->read_cycle = ns_to_rw_cycles(t_ns, freq);
+
+	if (!of_property_read_u32(np, "smc,write_cycle" , &t_ns))
+		cfg->write_cycle = ns_to_rw_cycles(t_ns, freq);
+
+	if (!of_property_read_u32(np, "smc,tdf_cycles" , &t_ns))
+		cfg->tdf_cycles = ns_to_cycles(t_ns, freq);
+
+	return get_mode_register_from_dt(smc, np, cfg);
+}
+
+struct converter {
+	const char *name;
+	int (*fn) (struct smc_data *smc, struct device_node *np,
+		   struct sam9_smc_config *cfg);
+};
+static const struct converter converters[] = {
+	{"raw", generic_timing_from_dt},
+	{"nanosec", ns_timing_from_dt},
+};
+
+/* Parse and set the timing for this device. */
+static int smc_timing_setup(struct smc_data *smc, struct device_node *np,
+		const struct at91_smc_devtype *devtype)
+{
+	int ret;
+	u32 cs;
+	int i;
+	struct device *dev = smc->dev;
+	const struct converter *converter;
+	const char *converter_name = NULL;
+	struct sam9_smc_config cfg;
+
+	ret = of_property_read_u32(np, "smc,cs" , &cs);
+	if (ret < 0) {
+		dev_err(dev, "missing mandatory property : smc,cs\n");
+		return ret;
+	}
+	if (cs >= devtype->cs_count) {
+		dev_err(dev, "invalid value for property smc,cs (=%d)."
+		"Must be in range 0 to %d\n", cs, devtype->cs_count-1);
+		return -EINVAL;
+	}
+
+	of_property_read_string(np, "smc,converter", &converter_name);
+	if (converter_name) {
+		for (i = 0; i < ARRAY_SIZE(converters); i++)
+			if (strcmp(converters[i].name, converter_name) == 0)
+				converter = &converters[i];
+		if (!converter) {
+			dev_info(dev, "unknown converter. aborting\n");
+			return -EINVAL;
+		}
+	} else {
+		dev_dbg(dev, "cs %d: no smc converter provided. using "
+		"raw register values\n", cs);
+		converter = &converters[0];
+	}
+	dev_dbg(dev, "cs %d using converter : %s\n", cs, converter->name);
+	sam9_smc_cs_read(smc->base + (0x10 * cs), &cfg);
+	converter->fn(smc, np, &cfg);
+	ret = sam9_smc_check_cs_configuration(&cfg);
+	if (ret < 0) {
+		dev_info(dev, "invalid smc configuration for cs %d."
+		"clipping values\n", cs);
+		sam9_smc_clip_cs_configuration(&cfg);
+		dump_timing(smc, &cfg);
+	}
+#ifdef DEBUG
+	else
+		dump_timing(smc, &cfg);
+#endif
+
+	sam9_smc_cs_configure(smc->base + (0x10 * cs), &cfg);
+	return 0;
+}
+
+static int smc_parse_dt(struct smc_data *smc)
+{
+	struct device *dev = smc->dev;
+	const struct of_device_id *of_id = of_match_device(smc_id_table, dev);
+	const struct at91_smc_devtype *devtype = of_id->data;
+	struct device_node *child;
+	int ret;
+
+	for_each_child_of_node(dev->of_node, child) {
+		if (!child->name)
+			continue;
+		if (!of_device_is_available(child))
+			continue;
+		ret = smc_timing_setup(smc, child, devtype);
+		if (ret) {
+			static struct property status = {
+				.name = "status",
+				.value = "disabled",
+				.length = sizeof("disabled"),
+			};
+			dev_err(dev, "%s set timing failed. This node will be disabled.\n",
+				child->full_name);
+			ret = of_update_property(child, &status);
+			if (ret < 0) {
+				dev_err(dev, "can't disable %s. aborting probe\n",
+				child->full_name);
+				break;
+			}
+		}
+	}
+
+	ret = of_platform_populate(dev->of_node, of_default_bus_match_table,
+				   NULL, dev);
+	if (ret)
+		dev_err(dev, "%s fail to create devices.\n",
+			dev->of_node->full_name);
+
+	return ret;
+}
+
+static int smc_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int ret;
+	void __iomem *base;
+	struct clk *clk;
+	struct smc_data *smc = devm_kzalloc(&pdev->dev, sizeof(struct smc_data),
+					    GFP_KERNEL);
+
+	if (!smc)
+		return -ENOMEM;
+
+	smc->dev = &pdev->dev;
+
+	/* get the resource */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_request_and_ioremap(&pdev->dev, res);
+	if (IS_ERR(base)) {
+		dev_err(&pdev->dev, "can't map SMC base address\n");
+		return PTR_ERR(base);
+	}
+
+	/* get the clock */
+	clk = devm_clk_get(&pdev->dev, "smc");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	smc->bus_clk = clk;
+	smc->base = base;
+
+	/* parse the device node */
+	ret = smc_parse_dt(smc);
+	if (!ret)
+		dev_info(&pdev->dev, "Driver registered.\n");
+
+	return ret;
+}
+
+static struct platform_driver smc_driver = {
+	.driver = {
+		.name		= "atmel-smc",
+		.owner		= THIS_MODULE,
+		.of_match_table	= smc_id_table,
+	},
+};
+module_platform_driver_probe(smc_driver, smc_probe);
+
+MODULE_AUTHOR("JJ Hiblot");
+MODULE_DESCRIPTION("Atmel's SMC/EBI driver");
+MODULE_LICENSE("GPL");
-- 
1.8.5.2

