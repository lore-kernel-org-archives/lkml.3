Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbaEAKH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:07:58 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57403 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbaEAJ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:37 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 14/47] mtd: nand: stm_nand_bch: provide Device Tree support
Date: Thu,  1 May 2014 10:56:21 +0100
Message-Id: <1398938214-17847-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fetch platform specific data from Device Tree. Any functions which
are useful to other STM NAND Controllers have been separated into a
separate file so they can be easily referenced by them as they
appear.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/Kconfig        |   7 ++
 drivers/mtd/nand/Makefile       |   1 +
 drivers/mtd/nand/stm_nand_bch.c |  56 +++++++++++++++
 drivers/mtd/nand/stm_nand_dt.c  | 149 ++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/nand/stm_nand_dt.h  |  39 +++++++++++
 include/linux/mtd/stm_nand.h    |   9 +++
 6 files changed, 261 insertions(+)
 create mode 100644 drivers/mtd/nand/stm_nand_dt.c
 create mode 100644 drivers/mtd/nand/stm_nand_dt.h

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 7b1352a..119aed5 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -517,4 +517,11 @@ config MTD_NAND_STM_BCH
 	help
 	  Adds support for the STMicroelectronics NANDi BCH Controller.
 
+config MTD_NAND_STM_BCH_DT
+	tristate "STMicroelectronics: NANDi BCH Controller Device Tree support"
+	default MTD_NAND_STM_BCH if OF
+	help
+	  Adds support for the STMicroelectronics NANDi BCH Controller's
+	  Device Tree component.
+
 endif # MTD_NAND
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index 94e7737..890f47f 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_MTD_NAND_MPC5121_NFC)	+= mpc5121_nfc.o
 obj-$(CONFIG_MTD_NAND_RICOH)		+= r852.o
 obj-$(CONFIG_MTD_NAND_JZ4740)		+= jz4740_nand.o
 obj-$(CONFIG_MTD_NAND_STM_BCH)		+= stm_nand_bch.o
+obj-$(CONFIG_MTD_NAND_STM_BCH_DT)	+= stm_nand_dt.o
 obj-$(CONFIG_MTD_NAND_GPMI_NAND)	+= gpmi-nand/
 obj-$(CONFIG_MTD_NAND_XWAY)		+= xway_nand.o
 obj-$(CONFIG_MTD_NAND_BCM47XXNFLASH)	+= bcm47xxnflash/
diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 2670cec..b1de66e 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/clk.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
@@ -23,8 +24,10 @@
 #include <linux/completion.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/stm_nand.h>
+#include <linux/mtd/partitions.h>
 
 #include "stm_nand_regs.h"
+#include "stm_nand_dt.h"
 
 /* Bad Block Table (BBT) */
 struct nandi_bbt_info {
@@ -523,9 +526,42 @@ nandi_init_resources(struct platform_device *pdev)
 	return nandi;
 }
 
+static void *stm_bch_dt_get_pdata(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct stm_plat_nand_bch_data *pdata;
+	int ecc_strength;
+	int ret;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	of_property_read_u32(np, "nand-ecc-strength", &ecc_strength);
+	if (ecc_strength == 0)
+		pdata->bch_ecc_cfg = BCH_NO_ECC;
+	else if (ecc_strength == 18)
+		pdata->bch_ecc_cfg = BCH_18BIT_ECC;
+	else if (ecc_strength == 30)
+		pdata->bch_ecc_cfg = BCH_30BIT_ECC;
+	else
+		pdata->bch_ecc_cfg = BCH_ECC_AUTO;
+
+	ret = stm_of_get_nand_banks(&pdev->dev, np, &pdata->bank);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	of_property_read_u32(np, "st,bch-bitflip-threshold",
+			     &pdata->bch_bitflip_threshold);
+
+	return pdata;
+}
+
 static int stm_nand_bch_probe(struct platform_device *pdev)
 {
 	struct stm_plat_nand_bch_data *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
+	struct mtd_part_parser_data ppdata;
 	struct stm_nand_bank_data *bank;
 	struct nandi_bbt_info *bbt_info;
 	struct nandi_controller *nandi;
@@ -534,6 +570,19 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 	struct mtd_info *mtd;
 	int err;
 
+	if (!np) {
+		dev_err(&pdev->dev, "DT node found\n");
+		return -EINVAL;
+	}
+
+	pdata = stm_bch_dt_get_pdata(pdev);
+	if (IS_ERR(pdata))
+		return PTR_ERR(pdata);
+
+	ppdata.of_node = stm_of_get_partitions_node(np, 0);
+
+	pdev->dev.platform_data = pdata;
+
 	nandi = nandi_init_resources(pdev);
 	if (IS_ERR(nandi)) {
 		dev_err(&pdev->dev, "failed to initialise NANDi resources\n");
@@ -613,12 +662,19 @@ static const struct dev_pm_ops stm_nand_bch_pm_ops = {
 static const struct dev_pm_ops stm_nand_bch_pm_ops;
 #endif
 
+static struct of_device_id nand_bch_match[] = {
+	{ .compatible = "st,nand-bch", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, nand_bch_match);
+
 static struct platform_driver stm_nand_bch_driver = {
 	.probe	= stm_nand_bch_probe ,
 	.remove	= stm_nand_bch_remove,
 	.driver	= {
 		.name	= "stm-nand-bch",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(nand_bch_match),
 		.pm	= &stm_nand_bch_pm_ops,
 	},
 };
diff --git a/drivers/mtd/nand/stm_nand_dt.c b/drivers/mtd/nand/stm_nand_dt.c
new file mode 100644
index 0000000..75ff131
--- /dev/null
+++ b/drivers/mtd/nand/stm_nand_dt.c
@@ -0,0 +1,149 @@
+/*
+ * drivers/mtd/nand/stm_nand_dt.c
+ *
+ * Support for NANDi BCH Controller Device Tree component
+ *
+ * Copyright (c) 2014 STMicroelectronics Limited
+ * Author: Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/byteorder/generic.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/stm_nand.h>
+
+#include "stm_nand_regs.h"
+
+/**
+* stm_of_get_partitions_node - get partitions node from stm-nand type devices.
+*
+* @dev		device pointer to use for devm allocations.
+* @np		device node of the driver.
+* @bank_nr	which bank number to use to get partitions.
+*
+* Returns a node pointer if found, with refcount incremented, use
+* of_node_put() on it when done.
+*
+*/
+struct device_node *stm_of_get_partitions_node(struct device_node *np,
+					       int bank_nr)
+{
+	struct device_node *banksnp, *banknp, *partsnp = NULL;
+	char name[10];
+
+	banksnp = of_parse_phandle(np, "st,nand-banks", 0);
+	if (!banksnp)
+		return NULL;
+
+	sprintf(name, "bank%d", bank_nr);
+	banknp = of_get_child_by_name(banksnp, name);
+	if (banknp)
+		return NULL;
+
+	partsnp = of_get_child_by_name(banknp, "partitions");
+	of_node_put(banknp);
+
+	return partsnp;
+}
+EXPORT_SYMBOL(stm_of_get_partitions_node);
+
+/**
+ * stm_of_get_nand_banks - Get nand banks info from a given device node.
+ *
+ * @dev			device pointer to use for devm allocations.
+ * @np			device node of the driver.
+ * @banksptr		double pointer to banks which is allocated
+ *			and filled with bank data.
+ *
+ * Returns a count of banks found in the given device node.
+ *
+ */
+int stm_of_get_nand_banks(struct device *dev, struct device_node *np,
+			  struct stm_nand_bank_data **banksptr)
+{
+	struct stm_nand_bank_data *banks;
+	struct device_node *banknp, *banksnp;
+	int nr_banks = 0;
+
+	if (!np)
+		return -ENODEV;
+
+	banksnp = of_parse_phandle(np, "st,nand-banks", 0);
+	if (!banksnp) {
+		dev_warn(dev, "No NAND banks specified in DT: %s\n",
+			 np->full_name);
+		return -ENODEV;
+	}
+
+	for_each_child_of_node(banksnp, banknp)
+		nr_banks++;
+
+	*banksptr = devm_kzalloc(dev, sizeof(*banks) * nr_banks, GFP_KERNEL);
+	banks = *banksptr;
+	banknp = NULL;
+
+	for_each_child_of_node(banksnp, banknp) {
+		struct device_node *timingnp;
+		int bank = 0;
+
+		of_property_read_u32(banknp, "st,nand-csn", &banks[bank].csn);
+
+		if (of_get_nand_bus_width(banknp) == 16)
+			banks[bank].options |= NAND_BUSWIDTH_16;
+		if (of_get_nand_on_flash_bbt(banknp))
+			banks[bank].bbt_options |= NAND_BBT_USE_FLASH;
+
+		banks[bank].nr_partitions = 0;
+		banks[bank].partitions = NULL;
+
+		timingnp = of_parse_phandle(banknp, "st,nand-timing-spec", 0);
+		if (timingnp) {
+			struct nand_timing_spec *ts;
+
+			ts = devm_kzalloc(dev,
+					  sizeof(struct nand_timing_spec),
+					  GFP_KERNEL);
+
+			of_property_read_u32(timingnp, "tR", &ts->tR);
+			of_property_read_u32(timingnp, "tCLS", &ts->tCLS);
+			of_property_read_u32(timingnp, "tCS", &ts->tCS);
+			of_property_read_u32(timingnp, "tALS", &ts->tALS);
+			of_property_read_u32(timingnp, "tDS", &ts->tDS);
+			of_property_read_u32(timingnp, "tWP", &ts->tWP);
+			of_property_read_u32(timingnp, "tCLH", &ts->tCLH);
+			of_property_read_u32(timingnp, "tCH", &ts->tCH);
+			of_property_read_u32(timingnp, "tALH", &ts->tALH);
+			of_property_read_u32(timingnp, "tDH", &ts->tDH);
+			of_property_read_u32(timingnp, "tWB", &ts->tWB);
+			of_property_read_u32(timingnp, "tWH", &ts->tWH);
+			of_property_read_u32(timingnp, "tWC", &ts->tWC);
+			of_property_read_u32(timingnp, "tRP", &ts->tRP);
+			of_property_read_u32(timingnp, "tREH", &ts->tREH);
+			of_property_read_u32(timingnp, "tRC", &ts->tRC);
+			of_property_read_u32(timingnp, "tREA", &ts->tREA);
+			of_property_read_u32(timingnp, "tRHOH", &ts->tRHOH);
+			of_property_read_u32(timingnp, "tCEA", &ts->tCEA);
+			of_property_read_u32(timingnp, "tCOH", &ts->tCOH);
+			of_property_read_u32(timingnp, "tCHZ", &ts->tCHZ);
+			of_property_read_u32(timingnp, "tCSD", &ts->tCSD);
+			banks[bank].timing_spec = ts;
+		}
+		of_property_read_u32(banknp, "st,nand-timing-relax",
+				     &banks[bank].timing_relax);
+		bank++;
+	}
+
+	return nr_banks;
+}
+EXPORT_SYMBOL(stm_of_get_nand_banks);
diff --git a/drivers/mtd/nand/stm_nand_dt.h b/drivers/mtd/nand/stm_nand_dt.h
new file mode 100644
index 0000000..de4507c
--- /dev/null
+++ b/drivers/mtd/nand/stm_nand_dt.h
@@ -0,0 +1,39 @@
+/*
+ * drivers/mtd/nand/stm_nand_dt.h
+ *
+ * Support for NANDi BCH Controller Device Tree component
+ *
+ * Copyright (c) 2014 STMicroelectronics Limited
+ * Author: Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef STM_NAND_DT_H
+#define STM_NAND_DT_H
+
+#if defined(CONFIG_MTD_NAND_STM_BCH_DT)
+struct device_node *stm_of_get_partitions_node(struct device_node *np,
+					       int bank_nr);
+
+int stm_of_get_nand_banks(struct device *dev, struct device_node *np,
+			  struct stm_nand_bank_data **banksp);
+#else
+static inline
+struct device_node *stm_of_get_partitions_node(struct device_node *np,
+					       int bank_nr)
+{
+	return NULL;
+}
+
+static inline int  stm_of_get_nand_banks(struct device *dev,
+					 struct device_node *np,
+					 struct stm_nand_bank_data **banksp)
+{
+	return 0;
+}
+#endif /* CONFIG_MTD_NAND_STM_BCH_DT */
+#endif /* STM_NAND_DT_H */
diff --git a/include/linux/mtd/stm_nand.h b/include/linux/mtd/stm_nand.h
index 99a69ca..f82f9f7 100644
--- a/include/linux/mtd/stm_nand.h
+++ b/include/linux/mtd/stm_nand.h
@@ -37,6 +37,15 @@ struct stm_nand_bank_data {
 	int			timing_relax;
 };
 
+/* ECC Modes */
+enum stm_nand_bch_ecc_config {
+	BCH_18BIT_ECC = 0,
+	BCH_30BIT_ECC,
+	BCH_NO_ECC,
+	BCH_ECC_RSRV,
+	BCH_ECC_AUTO,
+};
+
 struct stm_plat_nand_bch_data {
 	struct stm_nand_bank_data *bank;
 	enum stm_nand_bch_ecc_config bch_ecc_cfg;
-- 
1.8.3.2

