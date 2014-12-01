Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaLAK1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:27:40 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50424 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752646AbaLAK1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:27:37 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 05/11] memory: add Atmel EBI (External Bus Interface) driver
Date: Mon,  1 Dec 2014 11:27:21 +0100
Message-Id: <1417429647-3419-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EBI (External Bus Interface) is used to access external peripherals
(NOR, SRAM, NAND, and other specific devices like ethernet controllers).
Each device is assigned a CS line and an address range and can have its
own configuration (timings, access mode, bus width, ...).
This driver provides a generic DT binding to configure a device according
to its requirements.
For specific device controllers (like the NAND one) the SMC timings
should be configured by the controller driver through the matrix and
smc syscon regmaps.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/memory/Kconfig     |  11 +
 drivers/memory/Makefile    |   1 +
 drivers/memory/atmel-ebi.c | 627 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 639 insertions(+)
 create mode 100644 drivers/memory/atmel-ebi.c

diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index 6d91c27..dfe24a2 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -17,6 +17,17 @@ config ATMEL_SDRAMC
 	  Starting with the at91sam9g45, this controller supports SDR, DDR and
 	  LP-DDR memories.
 
+config ATMEL_EBI
+	bool "Atmel EBI driver"
+	default y
+	depends on ARCH_AT91 && OF
+	select MFD_SYSCON
+	help
+	  Driver for Atmel EBI controller.
+	  Used to configure the EBI (external bus interface) when the device-
+	  tree is used. This bus supports NANDs, external ethernet controller,
+	  SRAMs, ATA devices, etc.
+
 config TI_AEMIF
 	tristate "Texas Instruments AEMIF driver"
 	depends on (ARCH_DAVINCI || ARCH_KEYSTONE) && OF
diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
index c32d319..7ca2c19 100644
--- a/drivers/memory/Makefile
+++ b/drivers/memory/Makefile
@@ -6,6 +6,7 @@ ifeq ($(CONFIG_DDR),y)
 obj-$(CONFIG_OF)		+= of_memory.o
 endif
 obj-$(CONFIG_ATMEL_SDRAMC)	+= atmel-sdramc.o
+obj-$(CONFIG_ATMEL_EBI)		+= atmel-ebi.o
 obj-$(CONFIG_TI_AEMIF)		+= ti-aemif.o
 obj-$(CONFIG_TI_EMIF)		+= emif.o
 obj-$(CONFIG_FSL_CORENET_CF)	+= fsl-corenet-cf.o
diff --git a/drivers/memory/atmel-ebi.c b/drivers/memory/atmel-ebi.c
new file mode 100644
index 0000000..6f45107
--- /dev/null
+++ b/drivers/memory/atmel-ebi.c
@@ -0,0 +1,627 @@
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
+
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/mfd/syscon.h>
+#include <linux/mfd/syscon/atmel-matrix.h>
+#include <linux/mfd/syscon/atmel-smc.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/regmap.h>
+
+#define AT91_EBICSA_REGFIELD(soc)			\
+	REG_FIELD(soc ## _MATRIX_EBICSA_OFF, 0,		\
+		  AT91_MATRIX_EBI_NUM_CS - 1)
+
+#define AT91_MULTI_EBICSA_REGFIELD(soc, n)		\
+	REG_FIELD(soc ## _MATRIX_EBI ## n ## CSA_OFF,	\
+		  0, AT91_MATRIX_EBI_NUM_CS - 1)
+
+struct at91sam9_smc_timings {
+	u32 ncs_rd_setup_ns;
+	u32 nrd_setup_ns;
+	u32 ncs_wr_setup_ns;
+	u32 nwe_setup_ns;
+	u32 ncs_rd_pulse_ns;
+	u32 nrd_pulse_ns;
+	u32 ncs_wr_pulse_ns;
+	u32 nwe_pulse_ns;
+	u32 nrd_cycle_ns;
+	u32 nwe_cycle_ns;
+	u32 tdf_ns;
+};
+
+struct at91sam9_smc_generic_fields {
+	struct regmap_field *setup;
+	struct regmap_field *pulse;
+	struct regmap_field *cycle;
+	struct regmap_field *mode;
+};
+
+struct at91sam9_ebi_dev_config {
+	struct at91sam9_smc_timings timings;
+	u32 mode;
+};
+
+struct at91_ebi;
+
+struct at91_ebi_dev {
+	struct device_node *np;
+	struct at91_smc_timings *timings;
+	struct at91_ebi *ebi;
+	u32 mode;
+	int cs;
+	void *config;
+};
+
+struct at91_ebi_caps {
+	unsigned int available_cs;
+	const struct reg_field *ebi_csa;
+	int (*xlate_config)(struct at91_ebi_dev *ebid);
+	int (*apply_config)(struct at91_ebi_dev *ebid);
+	int (*init)(struct at91_ebi *ebi);
+};
+
+struct at91_ebi {
+	struct clk *clk;
+	struct regmap *smc;
+	struct regmap *matrix;
+
+	struct regmap_field *ebi_csa;
+
+	struct device *dev;
+	const struct at91_ebi_caps *caps;
+	struct at91_ebi_dev *devs[AT91_MATRIX_EBI_NUM_CS];
+	void *priv;
+};
+
+static u32 at91sam9_smc_setup_ns_to_cycles(unsigned int clk_rate,
+					   u32 timing_ns)
+{
+	u32 clk_period = DIV_ROUND_UP(NSEC_PER_SEC, clk_rate);
+	u32 coded_cycles = 0;
+	u32 cycles;
+
+	cycles = DIV_ROUND_UP(timing_ns, clk_period);
+	if (cycles / 32) {
+		coded_cycles |= 1 << 5;
+		if (cycles < 128)
+			cycles = 0;
+	}
+
+	coded_cycles |= cycles % 32;
+
+	return coded_cycles;
+}
+
+static u32 at91sam9_smc_pulse_ns_to_cycles(unsigned int clk_rate,
+					   u32 timing_ns)
+{
+	u32 clk_period = DIV_ROUND_UP(NSEC_PER_SEC, clk_rate);
+	u32 coded_cycles = 0;
+	u32 cycles;
+
+	cycles = DIV_ROUND_UP(timing_ns, clk_period);
+	if (cycles / 64) {
+		coded_cycles |= 1 << 6;
+		if (cycles < 256)
+			cycles = 0;
+	}
+
+	coded_cycles |= cycles % 64;
+
+	return coded_cycles;
+}
+
+static u32 at91sam9_smc_cycle_ns_to_cycles(unsigned int clk_rate,
+					   u32 timing_ns)
+{
+	u32 clk_period = DIV_ROUND_UP(NSEC_PER_SEC, clk_rate);
+	u32 coded_cycles = 0;
+	u32 cycles;
+
+	cycles = DIV_ROUND_UP(timing_ns, clk_period);
+	if (cycles / 128) {
+		coded_cycles = cycles / 256;
+		cycles %= 256;
+		if (cycles >= 128) {
+			coded_cycles++;
+			cycles = 0;
+		}
+
+		if (coded_cycles > 0x3) {
+			coded_cycles = 0x3;
+			cycles = 0x7f;
+		}
+
+		coded_cycles <<= 7;
+	}
+
+	coded_cycles |= cycles % 128;
+
+	return coded_cycles;
+}
+
+static int at91sam9_ebi_apply_config(struct at91_ebi_dev *ebid)
+{
+	unsigned int clk_rate = clk_get_rate(ebid->ebi->clk);
+	struct at91sam9_ebi_dev_config *config = ebid->config;
+	struct at91sam9_smc_timings *timings = &config->timings;
+	struct at91sam9_smc_generic_fields *fields = ebid->ebi->priv;
+	u32 val;
+
+	val = at91sam9_smc_setup_ns_to_cycles(clk_rate,
+					      timings->ncs_rd_setup_ns) << 24;
+	val |= at91sam9_smc_setup_ns_to_cycles(clk_rate,
+					       timings->nrd_setup_ns) << 16;
+	val |= at91sam9_smc_setup_ns_to_cycles(clk_rate,
+					       timings->ncs_wr_setup_ns) << 8;
+	val |= at91sam9_smc_setup_ns_to_cycles(clk_rate,
+					       timings->nwe_setup_ns);
+	regmap_fields_write(fields->setup, ebid->cs, val);
+
+	val = at91sam9_smc_pulse_ns_to_cycles(clk_rate,
+					      timings->ncs_rd_pulse_ns) << 24;
+	val |= at91sam9_smc_pulse_ns_to_cycles(clk_rate,
+					       timings->nrd_pulse_ns) << 16;
+	val |= at91sam9_smc_pulse_ns_to_cycles(clk_rate,
+					       timings->ncs_wr_pulse_ns) << 8;
+	val |= at91sam9_smc_pulse_ns_to_cycles(clk_rate,
+					       timings->nwe_pulse_ns);
+	regmap_fields_write(fields->pulse, ebid->cs, val);
+
+	val = at91sam9_smc_cycle_ns_to_cycles(clk_rate,
+					      timings->nrd_cycle_ns) << 16;
+	val |= at91sam9_smc_cycle_ns_to_cycles(clk_rate,
+					       timings->nwe_cycle_ns);
+	regmap_fields_write(fields->cycle, ebid->cs, val);
+
+	val = DIV_ROUND_UP(timings->tdf_ns, clk_rate);
+	if (val > 16)
+		val = 16;
+	regmap_fields_write(fields->mode, ebid->cs, config->mode | val << 16);
+
+	return 0;
+}
+
+static int at91sam9_smc_xslate_timings(struct at91_ebi_dev *ebid)
+{
+	struct at91sam9_ebi_dev_config *config = ebid->config;
+	struct at91sam9_smc_timings *timings;
+	struct device_node *np = ebid->np;
+
+	timings = &config->timings;
+
+	of_property_read_u32(np, "atmel,ncs-rd-setup-ns",
+			     &timings->ncs_rd_setup_ns);
+	of_property_read_u32(np, "atmel,nrd-setup-ns",
+			     &timings->nrd_setup_ns);
+	of_property_read_u32(np, "atmel,ncs-wr-setup-ns",
+			     &timings->ncs_wr_setup_ns);
+	of_property_read_u32(np, "atmel,nwe-setup-ns",
+			     &timings->nwe_setup_ns);
+	of_property_read_u32(np, "atmel,ncs-rd-pulse-ns",
+			     &timings->ncs_rd_pulse_ns);
+	of_property_read_u32(np, "atmel,nrd-pulse-ns",
+			     &timings->nrd_pulse_ns);
+	of_property_read_u32(np, "atmel,ncs-wr-pulse-ns",
+			     &timings->ncs_wr_pulse_ns);
+	of_property_read_u32(np, "atmel,nwe-pulse-ns", &timings->nwe_pulse_ns);
+	of_property_read_u32(np, "atmel,nwe-cycle-ns", &timings->nwe_cycle_ns);
+	of_property_read_u32(np, "atmel,nrd-cycle-ns", &timings->nrd_cycle_ns);
+	of_property_read_u32(np, "atmel,tdf-ns", &timings->tdf_ns);
+
+	return 0;
+}
+
+static int at91sam9_ebi_xslate_config(struct at91_ebi_dev *ebid)
+{
+	struct at91sam9_ebi_dev_config *config = ebid->config;
+	struct device_node *np = ebid->np;
+	const char *tmp_str;
+	u32 tmp;
+	int ret;
+
+	config = devm_kzalloc(ebid->ebi->dev, sizeof(*config), GFP_KERNEL);
+	if (!config)
+		return -ENOMEM;
+
+	ebid->config = config;
+
+	ret = of_property_read_u32(np, "atmel,bus-width", &tmp);
+	if (ret)
+		return ret;
+
+	switch (tmp) {
+	case 8:
+		config->mode |= AT91_SMC_DBW_8;
+		break;
+
+	case 16:
+		config->mode |= AT91_SMC_DBW_16;
+		break;
+
+	case 32:
+		config->mode |= AT91_SMC_DBW_32;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (of_property_read_bool(np, "atmel,tdf-optimized"))
+		config->mode |= AT91_SMC_TDFMODE_OPTIMIZED;
+
+	tmp_str = NULL;
+	of_property_read_string(np, "atmel,byte-access-type", &tmp_str);
+	if (tmp_str && !strcmp(tmp_str, "write"))
+		config->mode |= AT91_SMC_BAT_WRITE;
+
+	tmp_str = NULL;
+	of_property_read_string(np, "atmel,read-mode", &tmp_str);
+	if (tmp_str && !strcmp(tmp_str, "nrd"))
+		config->mode |= AT91_SMC_READMODE_NRD;
+
+	tmp_str = NULL;
+	of_property_read_string(np, "atmel,write-mode", &tmp_str);
+	if (tmp_str && !strcmp(tmp_str, "nwe"))
+		config->mode |= AT91_SMC_WRITEMODE_NWE;
+
+	tmp_str = NULL;
+	of_property_read_string(np, "atmel,exnw-mode", &tmp_str);
+	if (tmp_str) {
+		if (!strcmp(tmp_str, "frozen"))
+			config->mode |= AT91_SMC_EXNWMODE_FROZEN;
+		else if (!strcmp(tmp_str, "ready"))
+			config->mode |= AT91_SMC_EXNWMODE_READY;
+	}
+
+	tmp = 0;
+	ret = of_property_read_u32(np, "atmel,page-mode", &tmp);
+	if (!ret) {
+		switch (tmp) {
+		case 4:
+			config->mode |= AT91_SMC_PS_4;
+			break;
+
+		case 8:
+			config->mode |= AT91_SMC_PS_8;
+			break;
+
+		case 16:
+			config->mode |= AT91_SMC_PS_16;
+			break;
+
+		case 32:
+			config->mode |= AT91_SMC_PS_32;
+			break;
+
+		default:
+			return -EINVAL;
+		}
+
+		config->mode |= AT91_SMC_PMEN;
+	}
+
+	return at91sam9_smc_xslate_timings(ebid);
+}
+
+static int at91sam9_ebi_init(struct at91_ebi *ebi)
+{
+	struct at91sam9_smc_generic_fields *fields;
+	struct reg_field field = REG_FIELD(0, 0, 31);
+
+	fields = devm_kzalloc(ebi->dev, sizeof(*fields), GFP_KERNEL);
+	if (!fields)
+		return -ENOMEM;
+
+	field.id_size = fls(ebi->caps->available_cs);
+	field.id_offset = 0x10;
+
+	field.reg = AT91SAM9_SMC_SETUP(AT91SAM9_SMC_GENERIC_OFFSET);
+	fields->setup = devm_regmap_field_alloc(ebi->dev, ebi->smc, field);
+	if (IS_ERR(fields->setup))
+		return PTR_ERR(fields->setup);
+
+	field.reg = AT91SAM9_SMC_PULSE(AT91SAM9_SMC_GENERIC_OFFSET);
+	fields->pulse = devm_regmap_field_alloc(ebi->dev, ebi->smc, field);
+	if (IS_ERR(fields->pulse))
+		return PTR_ERR(fields->pulse);
+
+	field.reg = AT91SAM9_SMC_CYCLE(AT91SAM9_SMC_GENERIC_OFFSET);
+	fields->cycle = devm_regmap_field_alloc(ebi->dev, ebi->smc, field);
+	if (IS_ERR(fields->cycle))
+		return PTR_ERR(fields->cycle);
+
+	field.reg = AT91SAM9_SMC_MODE(AT91SAM9_SMC_GENERIC_OFFSET);
+	fields->mode = devm_regmap_field_alloc(ebi->dev, ebi->smc, field);
+	if (IS_ERR(fields->mode))
+		return PTR_ERR(fields->mode);
+
+	ebi->priv = fields;
+
+	return 0;
+}
+
+static int sama5d3_ebi_init(struct at91_ebi *ebi)
+{
+	struct at91sam9_smc_generic_fields *fields;
+	struct reg_field field = REG_FIELD(0, 0, 31);
+
+	fields = devm_kzalloc(ebi->dev, sizeof(*fields), GFP_KERNEL);
+	if (!fields)
+		return -ENOMEM;
+
+	field.id_size = fls(ebi->caps->available_cs);
+	field.id_offset = SAMA5_SMC_GENERIC_BLK_SZ;
+
+	field.reg = AT91SAM9_SMC_SETUP(SAMA5_SMC_GENERIC_OFFSET);
+	fields->setup = devm_regmap_field_alloc(ebi->dev, ebi->smc, field);
+	if (IS_ERR(fields->setup))
+		return PTR_ERR(fields->setup);
+
+	field.reg = AT91SAM9_SMC_PULSE(SAMA5_SMC_GENERIC_OFFSET);
+	fields->pulse = devm_regmap_field_alloc(ebi->dev, ebi->smc, field);
+	if (IS_ERR(fields->pulse))
+		return PTR_ERR(fields->pulse);
+
+	field.reg = AT91SAM9_SMC_CYCLE(SAMA5_SMC_GENERIC_OFFSET);
+	fields->cycle = devm_regmap_field_alloc(ebi->dev, ebi->smc, field);
+	if (IS_ERR(fields->cycle))
+		return PTR_ERR(fields->cycle);
+
+	field.reg = SAMA5_SMC_MODE(SAMA5_SMC_GENERIC_OFFSET);
+	fields->mode = devm_regmap_field_alloc(ebi->dev, ebi->smc, field);
+	if (IS_ERR(fields->mode))
+		return PTR_ERR(fields->mode);
+
+	ebi->priv = fields;
+
+	return 0;
+}
+
+static int at91_ebi_dev_setup(struct at91_ebi *ebi, struct device_node *np)
+{
+	struct device *dev = ebi->dev;
+	struct device_node *dev_np;
+	struct at91_ebi_dev *ebid;
+	u32 tmp;
+	int ret;
+
+	dev_np = of_get_next_child(np, NULL);
+	if (!dev_np)
+		return -EINVAL;
+
+	if (!of_device_is_available(dev_np))
+		return 0;
+
+	ebid = devm_kzalloc(ebi->dev, sizeof(*ebid), GFP_KERNEL);
+	if (!ebid)
+		return -ENOMEM;
+
+	ret = of_property_read_u32(dev_np, "reg" , &tmp);
+	if (ret < 0) {
+		dev_err(dev, "missing mandatory reg property\n");
+		return ret;
+	}
+
+	if (tmp > AT91_MATRIX_EBI_NUM_CS ||
+	    !(BIT(tmp) & ebi->caps->available_cs)) {
+		dev_err(dev, "invalid reg property\n");
+		return -EINVAL;
+	}
+
+	ebid->cs = tmp;
+	ebid->np = np;
+	ebid->ebi = ebi;
+
+	if (!of_property_read_bool(np, "atmel,generic-dev"))
+		goto populate;
+
+	if (ebid->ebi->ebi_csa)
+		regmap_field_update_bits(ebid->ebi->ebi_csa,
+					 BIT(ebid->cs),
+					 ~BIT(ebid->cs));
+
+	ret = ebid->ebi->caps->xlate_config(ebid);
+	if (ret)
+		return ret;
+
+	ret = ebid->ebi->caps->apply_config(ebid);
+	if (ret)
+		return ret;
+	ebi->devs[ebid->cs] = ebid;
+
+populate:
+	return of_platform_populate(np, of_default_bus_match_table, NULL, dev);
+}
+
+static const struct reg_field at91sam9260_ebi_csa =
+				AT91_EBICSA_REGFIELD(AT91SAM9260);
+
+static const struct at91_ebi_caps at91sam9260_ebi_caps = {
+	.available_cs = 0xff,
+	.ebi_csa = &at91sam9260_ebi_csa,
+	.xlate_config = at91sam9_ebi_xslate_config,
+	.apply_config = at91sam9_ebi_apply_config,
+	.init = at91sam9_ebi_init,
+};
+
+static const struct reg_field at91sam9261_ebi_csa =
+				AT91_EBICSA_REGFIELD(AT91SAM9261);
+
+static const struct at91_ebi_caps at91sam9261_ebi_caps = {
+	.available_cs = 0xff,
+	.ebi_csa = &at91sam9261_ebi_csa,
+	.xlate_config = at91sam9_ebi_xslate_config,
+	.apply_config = at91sam9_ebi_apply_config,
+	.init = at91sam9_ebi_init,
+};
+
+static const struct reg_field at91sam9263_ebi0_csa =
+				AT91_MULTI_EBICSA_REGFIELD(AT91SAM9263, 0);
+
+static const struct at91_ebi_caps at91sam9263_ebi0_caps = {
+	.available_cs = 0x3f,
+	.ebi_csa = &at91sam9263_ebi0_csa,
+	.xlate_config = at91sam9_ebi_xslate_config,
+	.apply_config = at91sam9_ebi_apply_config,
+	.init = at91sam9_ebi_init,
+};
+
+static const struct reg_field at91sam9263_ebi1_csa =
+				AT91_MULTI_EBICSA_REGFIELD(AT91SAM9263, 1);
+
+static const struct at91_ebi_caps at91sam9263_ebi1_caps = {
+	.available_cs = 0x7,
+	.ebi_csa = &at91sam9263_ebi1_csa,
+	.xlate_config = at91sam9_ebi_xslate_config,
+	.apply_config = at91sam9_ebi_apply_config,
+	.init = at91sam9_ebi_init,
+};
+
+static const struct reg_field at91sam9g45_ebi_csa =
+				AT91_EBICSA_REGFIELD(AT91SAM9G45);
+
+static const struct at91_ebi_caps at91sam9g45_ebi_caps = {
+	.available_cs = 0x3f,
+	.ebi_csa = &at91sam9g45_ebi_csa,
+	.xlate_config = at91sam9_ebi_xslate_config,
+	.apply_config = at91sam9_ebi_apply_config,
+	.init = at91sam9_ebi_init,
+};
+
+static const struct at91_ebi_caps at91sam9x5_ebi_caps = {
+	.available_cs = 0x3f,
+	.ebi_csa = &at91sam9263_ebi0_csa,
+	.xlate_config = at91sam9_ebi_xslate_config,
+	.apply_config = at91sam9_ebi_apply_config,
+	.init = at91sam9_ebi_init,
+};
+
+static const struct at91_ebi_caps sama5d3_ebi_caps = {
+	.available_cs = 0xf,
+	.xlate_config = at91sam9_ebi_xslate_config,
+	.apply_config = at91sam9_ebi_apply_config,
+	.init = sama5d3_ebi_init,
+};
+
+static const struct of_device_id at91_ebi_id_table[] = {
+	{
+		.compatible = "atmel,at91sam9260-ebi",
+		.data = &at91sam9260_ebi_caps,
+	},
+	{
+		.compatible = "atmel,at91sam9261-ebi",
+		.data = &at91sam9261_ebi_caps,
+	},
+	{
+		.compatible = "atmel,at91sam9263-ebi0",
+		.data = &at91sam9263_ebi0_caps,
+	},
+	{
+		.compatible = "atmel,at91sam9263-ebi1",
+		.data = &at91sam9263_ebi1_caps,
+	},
+	{
+		.compatible = "atmel,at91sam9g45-ebi",
+		.data = &at91sam9g45_ebi_caps,
+	},
+	{
+		.compatible = "atmel,at91sam9x5-ebi",
+		.data = &at91sam9x5_ebi_caps,
+	},
+	{
+		.compatible = "atmel,sama5d3-ebi",
+		.data = &sama5d3_ebi_caps,
+	},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, at91_ebi_id_table);
+
+static int at91_ebi_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	struct device_node *child;
+	struct device_node *np;
+	struct at91_ebi *ebi;
+	struct clk *clk;
+	int ret;
+
+	match = of_match_device(at91_ebi_id_table, &pdev->dev);
+	if (!match || !match->data)
+		return -EINVAL;
+
+	ebi = devm_kzalloc(&pdev->dev, sizeof(*ebi), GFP_KERNEL);
+	if (!ebi)
+		return -ENOMEM;
+
+	ebi->caps = match->data;
+	ebi->dev = &pdev->dev;
+
+	clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	ebi->clk = clk;
+
+	np = of_parse_phandle(pdev->dev.of_node, "atmel,smc", 0);
+	if (!np)
+		return -EINVAL;
+
+	ebi->smc = syscon_node_to_regmap(np);
+	if (IS_ERR(ebi->smc))
+		return PTR_ERR(ebi->smc);
+
+	/*
+	 * The sama5d3 does not provide an EBICSA register and thus does need
+	 * to access the matrix registers.
+	 */
+	if (ebi->caps->ebi_csa) {
+		np = of_parse_phandle(pdev->dev.of_node, "atmel,matrix", 0);
+		if (np)
+			return -EINVAL;
+
+		ebi->matrix = syscon_node_to_regmap(np);
+		if (IS_ERR(ebi->matrix))
+			return PTR_ERR(ebi->matrix);
+
+		ebi->ebi_csa = regmap_field_alloc(ebi->matrix,
+						  *ebi->caps->ebi_csa);
+		if (IS_ERR(ebi->ebi_csa))
+			return PTR_ERR(ebi->ebi_csa);
+	}
+
+	ret = ebi->caps->init(ebi);
+	if (ret)
+		return ret;
+
+	for_each_child_of_node(pdev->dev.of_node, child) {
+		ret = at91_ebi_dev_setup(ebi, child);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+static struct platform_driver at91_ebi_driver = {
+	.driver = {
+		.name = "atmel-ebi",
+		.of_match_table	= at91_ebi_id_table,
+	},
+};
+module_platform_driver_probe(at91_ebi_driver, at91_ebi_probe);
+
+MODULE_AUTHOR("JJ Hiblot");
+MODULE_DESCRIPTION("Atmel's EBI driver");
+MODULE_LICENSE("GPL");
-- 
1.9.1

