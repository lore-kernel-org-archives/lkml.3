Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbaEIKDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:03:15 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:52358 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494AbaEIKDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:03:11 -0400
Date: Fri, 9 May 2014 11:03:04 +0100
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
Message-ID: <20140509100304.GR5767@lee--X1>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-14-git-send-email-lee.jones@linaro.org>
 <20980858CB6D3A4BAE95CA194937D5E73EAB5C83@DBDE04.ent.ti.com>
 <20140430125406.GN29462@lee--X1>
 <20980858CB6D3A4BAE95CA194937D5E73EACA3F0@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EACA3F0@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >+	of_property_read_u32(np, "st,bch-bitflip-threshold",
> >> >+			     &pdata->bch_bitflip_threshold);
> >> >+
> >> mtd->bitflip_threshold is by default set to ecc.strength (unless a driver initializes it).
> >> And then can be re-configured for each MTD partition separately
> >> 	/sys/class/mtd/mtdX/bitflip_threshold
> >> 	Refer: $kernel/Documentation/ABI/testing/sysfs-class-mtd
> >> So, I don't think this is a HW parameter, and so should not be passed from DT.
> >
> >I think the bit-flip threshold is/can be chip specific, and as we know
> >which chip we're likely to be booting on, we can specify this via the
> >hardware description.  Thus, I think it's perfectly viable for an
> >option to pass through DT to exist.
> >
> I don't think that’s the correct interpretation of bitflip_threshold.
> 
> (1) bitflip_threshold is dependent on ecc.strength (ECC scheme) of your driver.
> MTD layers uses bitflip_threshold to warn above layers that number of
> correctable bit-flips have reached a dangerous level beyond which driver's
> ECC scheme may not be able to correct them. So above layers should start
> taking additional corrective action like scrubbing.
> 	@@drivers/mtd/mtdcore.c: mtd_read()
> 		return ret_code >= mtd->bitflip_threshold ? -EUCLEAN : 0;
> 
> (2) Also, user-space may control it based on how your device ages on field.
> A fresh silicon may not show too many bitflips. But as device ages the
> probability of simultaneous bitflips will increase. So user-space may lower
> the bitflip_threshold to avoid accumulation of bitflips in a single page.
>  
> Thus, bitflip_threshold should not be passed via DT.
> It's neither a hardware parameter, nor it’s a static constant.

Ah, I see.  I will fixup, thanks for the explanation.

> >> >+struct device_node *stm_of_get_partitions_node(struct device_node *np,
> >> >+					       int bank_nr)
> >> >+{
> >> >+	struct device_node *banksnp, *banknp, *partsnp = NULL;
> >> >+	char name[10];
> >> >+
> >> >+	banksnp = of_parse_phandle(np, "st,nand-banks", 0);
> >> >+	if (!banksnp)
> >> >+		return NULL;
> >> >+
> >> >+	sprintf(name, "bank%d", bank_nr);
> >> >+	banknp = of_get_child_by_name(banksnp, name);
> >> >+	if (banknp)
> >> >+		return NULL;
> >> >+
> >> >+	partsnp = of_get_child_by_name(banknp, "partitions");
> >> >+	of_node_put(banknp);
> >> >+
> >> Sorry, I'm bit confused here .. I think you don't need to find children of
> >> Your bank node. This should already taken care in default parser
> >> drivers/mtd/ofpart.c : parse_ofpart_partitions()
> >> And all you need to pass is 'of_node' of bank (device).
> >> Is my understanding correct ?
> >
> >We have 3 options here, you _can_ use parse_ofpart_partitions() if
> >your partition information conforms to its schema, but said schema
> >does not support banks and/or other information that we choose to
> >place within the bank node.  The second option is to register a
> >parser.  My personal view is that registering a parser is using the
> >framework for 'using the framework's' sake i.e. doesn't actually
> >achieve anything special.  We've chosen the third option, which is to
> >parse and extract the information ourselves - which is actually fairly
> >trivial, and pass the required partition data in through the
> >mtd_device_parse_register() call - which is where the information
> >would be parsed in the case of the first two options.
> >
> Do you really want to have *custom* partition format ?
> If your previous code was non-DT (platform file based), then I think
> It's good point to move to unified generic partition format which others
> are following, as you make your driver DT compliant, and in mainline.
> 
> I understand you primary objective would be to get ST driver work
> out of mainline asap, but if you upstream too many custom stuff you
> are only adding maintenance burden for your code. This is where
> most of my comments originate.
> However, I leave it to Brian to decide, if he is okay with these.
> 
> 
> with regards, pekon

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
