Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaCZJTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 05:19:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49991 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaCZJTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 05:19:43 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "kernel@stlinux.com" <kernel@stlinux.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "angus.clark@st.com" <angus.clark@st.com>
Subject: RE: [RFC 13/47] mtd: nand: stm_nand_bch: provide Device Tree support
Thread-Topic: [RFC 13/47] mtd: nand: stm_nand_bch: provide Device Tree
 support
Thread-Index: AQHPSAMgB9WSu3WEI0qVLuMmzpyAn5rzCprA
Date: Wed, 26 Mar 2014 09:18:59 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EAB5C83@DBDE04.ent.ti.com>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-14-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1395735604-26706-14-git-send-email-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

>From: Lee Jones [mailto:lee.jones@linaro.org]
>
>Fetch platform specific data from Device Tree. Any functions which
>are useful to other STM NAND Controllers have been separated into a
>separate file so they can be easily referenced by them as they
>appear.
>
>Signed-off-by: Lee Jones <lee.jones@linaro.org>
>---
[...]

>--- a/drivers/mtd/nand/stm_nand_bch.c
>+++ b/drivers/mtd/nand/stm_nand_bch.c
>@@ -16,6 +16,7 @@
> #include <linux/module.h>
> #include <linux/delay.h>
> #include <linux/io.h>
>+#include <linux/of.h>
> #include <linux/clk.h>
> #include <linux/interrupt.h>
> #include <linux/device.h>
>@@ -23,8 +24,10 @@
> #include <linux/completion.h>
> #include <linux/mtd/nand.h>
> #include <linux/mtd/stm_nand.h>
>+#include <linux/mtd/partitions.h>
>
> #include "stm_nand_regs.h"
>+#include "stm_nand_dt.h"
>
> /* Bad Block Table (BBT) */
> struct nandi_bbt_info {
>@@ -365,9 +368,51 @@ nandi_init_resources(struct platform_device *pdev)
> 	return nandi;
> }
>
>+#ifdef CONFIG_OF
>+static void *stm_bch_dt_get_pdata(struct platform_device *pdev)
>+{
>+	struct device_node *np = pdev->dev.of_node;
>+	struct stm_plat_nand_bch_data *pdata;
>+	const char *ecc_config;
>+	int ret;
>+
>+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
>+	if (!pdata)
>+		return ERR_PTR(-ENOMEM);
>+
>+	of_property_read_string(np, "st,bch-ecc-mode", &ecc_config);

Can you use any of the existing generic NAND bindings like combination of
"nand-ecc-mode" and "nand-ecc-strength" ?
Example: nand-ecc-mode = "bch" & nand-ecc-strength=18
Some of generic bindings are recently added
	commit 8dd49165ef5f46b5ad9ba296c559ccff315f9421  (currently in l2-mtd tree)
	mtd: nand: Add a devicetree binding for ECC strength and ECC step size

It's good to use generic bindings as much as you can, and you don't need
any approvals from DT Maintainers too. Though you may need to add
new values for "nand-ecc-mode" like {auto, hw-ham, hw-bch}
 

>+	if (!strcmp("noecc", ecc_config))
>+		pdata->bch_ecc_cfg = BCH_NO_ECC;
>+	else if (!strcmp("18bit", ecc_config))
>+		pdata->bch_ecc_cfg = BCH_18BIT_ECC;
>+	else if (!strcmp("30bit", ecc_config))
>+		pdata->bch_ecc_cfg = BCH_30BIT_ECC;
>+	else
>+		pdata->bch_ecc_cfg = BCH_ECC_AUTO;
>+
>+	ret = stm_of_get_nand_banks(&pdev->dev, np, &pdata->bank);
>+	if (ret < 0)
>+		return ERR_PTR(ret);
>+
>+	pdata->flashss = of_property_read_bool(np, "st,nand-flashss");
>+
>+	of_property_read_u32(np, "st,bch-bitflip-threshold",
>+			     &pdata->bch_bitflip_threshold);
>+
mtd->bitflip_threshold is by default set to ecc.strength (unless a driver initializes it).
And then can be re-configured for each MTD partition separately 
	/sys/class/mtd/mtdX/bitflip_threshold
	Refer: $kernel/Documentation/ABI/testing/sysfs-class-mtd
So, I don't think this is a HW parameter, and so should not be passed from DT.


>+	return pdata;
>+}
>+#else

[...]

>+struct device_node *stm_of_get_partitions_node(struct device_node *np,
>+					       int bank_nr)
>+{
>+	struct device_node *banksnp, *banknp, *partsnp = NULL;
>+	char name[10];
>+
>+	banksnp = of_parse_phandle(np, "st,nand-banks", 0);
>+	if (!banksnp)
>+		return NULL;
>+
>+	sprintf(name, "bank%d", bank_nr);
>+	banknp = of_get_child_by_name(banksnp, name);
>+	if (banknp)
>+		return NULL;
>+
>+	partsnp = of_get_child_by_name(banknp, "partitions");
>+	of_node_put(banknp);
>+
Sorry, I'm bit confused here .. I think you don't need to find children of
Your bank node. This should already taken care in default parser
drivers/mtd/ofpart.c : parse_ofpart_partitions()
And all you need to pass is 'of_node' of bank (device).
Is my understanding correct ?

>+	return partsnp;
>+}
>+EXPORT_SYMBOL(stm_of_get_partitions_node);
>+


with regards, pekon
