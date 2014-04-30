Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbaD3MyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:54:15 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46351 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878AbaD3MyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:54:13 -0400
Date: Wed, 30 Apr 2014 13:54:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Gupta, Pekon" <pekon@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "angus.clark@st.com" <angus.clark@st.com>
Subject: Re: [RFC 13/47] mtd: nand: stm_nand_bch: provide Device Tree support
Message-ID: <20140430125406.GN29462@lee--X1>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-14-git-send-email-lee.jones@linaro.org>
 <20980858CB6D3A4BAE95CA194937D5E73EAB5C83@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EAB5C83@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >From: Lee Jones [mailto:lee.jones@linaro.org]
> >
> >Fetch platform specific data from Device Tree. Any functions which
> >are useful to other STM NAND Controllers have been separated into a
> >separate file so they can be easily referenced by them as they
> >appear.
> >
> >Signed-off-by: Lee Jones <lee.jones@linaro.org>

[...]

> >+#ifdef CONFIG_OF
> >+static void *stm_bch_dt_get_pdata(struct platform_device *pdev)
> >+{
> >+	struct device_node *np = pdev->dev.of_node;
> >+	struct stm_plat_nand_bch_data *pdata;
> >+	const char *ecc_config;
> >+	int ret;
> >+
> >+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> >+	if (!pdata)
> >+		return ERR_PTR(-ENOMEM);
> >+
> >+	of_property_read_string(np, "st,bch-ecc-mode", &ecc_config);
> 
> Can you use any of the existing generic NAND bindings like combination of
> "nand-ecc-mode" and "nand-ecc-strength" ?
> Example: nand-ecc-mode = "bch" & nand-ecc-strength=18
> Some of generic bindings are recently added
> 	commit 8dd49165ef5f46b5ad9ba296c559ccff315f9421  (currently in l2-mtd tree)
> 	mtd: nand: Add a devicetree binding for ECC strength and ECC step size
> 
> It's good to use generic bindings as much as you can, and you don't need
> any approvals from DT Maintainers too. Though you may need to add
> new values for "nand-ecc-mode" like {auto, hw-ham, hw-bch}

Sure, I can make use of the generic bindings already offered here.

> >+	if (!strcmp("noecc", ecc_config))
> >+		pdata->bch_ecc_cfg = BCH_NO_ECC;
> >+	else if (!strcmp("18bit", ecc_config))
> >+		pdata->bch_ecc_cfg = BCH_18BIT_ECC;
> >+	else if (!strcmp("30bit", ecc_config))
> >+		pdata->bch_ecc_cfg = BCH_30BIT_ECC;
> >+	else
> >+		pdata->bch_ecc_cfg = BCH_ECC_AUTO;
> >+
> >+	ret = stm_of_get_nand_banks(&pdev->dev, np, &pdata->bank);
> >+	if (ret < 0)
> >+		return ERR_PTR(ret);
> >+
> >+	pdata->flashss = of_property_read_bool(np, "st,nand-flashss");
> >+
> >+	of_property_read_u32(np, "st,bch-bitflip-threshold",
> >+			     &pdata->bch_bitflip_threshold);
> >+
> mtd->bitflip_threshold is by default set to ecc.strength (unless a driver initializes it).
> And then can be re-configured for each MTD partition separately 
> 	/sys/class/mtd/mtdX/bitflip_threshold
> 	Refer: $kernel/Documentation/ABI/testing/sysfs-class-mtd
> So, I don't think this is a HW parameter, and so should not be passed from DT.

I think the bit-flip threshold is/can be chip specific, and as we know
which chip we're likely to be booting on, we can specify this via the
hardware description.  Thus, I think it's perfectly viable for an
option to pass through DT to exist.


> >+struct device_node *stm_of_get_partitions_node(struct device_node *np,
> >+					       int bank_nr)
> >+{
> >+	struct device_node *banksnp, *banknp, *partsnp = NULL;
> >+	char name[10];
> >+
> >+	banksnp = of_parse_phandle(np, "st,nand-banks", 0);
> >+	if (!banksnp)
> >+		return NULL;
> >+
> >+	sprintf(name, "bank%d", bank_nr);
> >+	banknp = of_get_child_by_name(banksnp, name);
> >+	if (banknp)
> >+		return NULL;
> >+
> >+	partsnp = of_get_child_by_name(banknp, "partitions");
> >+	of_node_put(banknp);
> >+
> Sorry, I'm bit confused here .. I think you don't need to find children of
> Your bank node. This should already taken care in default parser
> drivers/mtd/ofpart.c : parse_ofpart_partitions()
> And all you need to pass is 'of_node' of bank (device).
> Is my understanding correct ?

We have 3 options here, you _can_ use parse_ofpart_partitions() if
your partition information conforms to its schema, but said schema
does not support banks and/or other information that we choose to
place within the bank node.  The second option is to register a
parser.  My personal view is that registering a parser is using the
framework for 'using the framework's' sake i.e. doesn't actually
achieve anything special.  We've chosen the third option, which is to
parse and extract the information ourselves - which is actually fairly
trivial, and pass the required partition data in through the
mtd_device_parse_register() call - which is where the information
would be parsed in the case of the first two options.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
