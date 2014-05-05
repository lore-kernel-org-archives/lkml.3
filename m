Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaEEG4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 02:56:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53640 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaEEGz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 02:55:59 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "angus.clark@st.com" <angus.clark@st.com>
Subject: RE: [RFC 13/47] mtd: nand: stm_nand_bch: provide Device Tree support
Thread-Topic: [RFC 13/47] mtd: nand: stm_nand_bch: provide Device Tree
 support
Thread-Index: AQHPSAMgB9WSu3WEI0qVLuMmzpyAn5rzCprAgDbvtgCAB81FEA==
Date: Mon, 5 May 2014 06:55:17 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EACA3F0@DBDE04.ent.ti.com>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-14-git-send-email-lee.jones@linaro.org>
 <20980858CB6D3A4BAE95CA194937D5E73EAB5C83@DBDE04.ent.ti.com>
 <20140430125406.GN29462@lee--X1>
In-Reply-To: <20140430125406.GN29462@lee--X1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s456uDqk000602

Hi Lee,

>From: Lee Jones [mailto:lee.jones@linaro.org]
>> >From: Lee Jones [mailto:lee.jones@linaro.org]

[...]

>> >+	of_property_read_u32(np, "st,bch-bitflip-threshold",
>> >+			     &pdata->bch_bitflip_threshold);
>> >+
>> mtd->bitflip_threshold is by default set to ecc.strength (unless a driver initializes it).
>> And then can be re-configured for each MTD partition separately
>> 	/sys/class/mtd/mtdX/bitflip_threshold
>> 	Refer: $kernel/Documentation/ABI/testing/sysfs-class-mtd
>> So, I don't think this is a HW parameter, and so should not be passed from DT.
>
>I think the bit-flip threshold is/can be chip specific, and as we know
>which chip we're likely to be booting on, we can specify this via the
>hardware description.  Thus, I think it's perfectly viable for an
>option to pass through DT to exist.
>
I don't think thatâ€™s the correct interpretation of bitflip_threshold.

(1) bitflip_threshold is dependent on ecc.strength (ECC scheme) of your driver.
MTD layers uses bitflip_threshold to warn above layers that number of
correctable bit-flips have reached a dangerous level beyond which driver's
ECC scheme may not be able to correct them. So above layers should start
taking additional corrective action like scrubbing.
	@@drivers/mtd/mtdcore.c: mtd_read()
		return ret_code >= mtd->bitflip_threshold ? -EUCLEAN : 0;

(2) Also, user-space may control it based on how your device ages on field.
A fresh silicon may not show too many bitflips. But as device ages the
probability of simultaneous bitflips will increase. So user-space may lower
the bitflip_threshold to avoid accumulation of bitflips in a single page.
 
Thus, bitflip_threshold should not be passed via DT.
It's neither a hardware parameter, nor itâ€™s a static constant.

>
>> >+struct device_node *stm_of_get_partitions_node(struct device_node *np,
>> >+					       int bank_nr)
>> >+{
>> >+	struct device_node *banksnp, *banknp, *partsnp = NULL;
>> >+	char name[10];
>> >+
>> >+	banksnp = of_parse_phandle(np, "st,nand-banks", 0);
>> >+	if (!banksnp)
>> >+		return NULL;
>> >+
>> >+	sprintf(name, "bank%d", bank_nr);
>> >+	banknp = of_get_child_by_name(banksnp, name);
>> >+	if (banknp)
>> >+		return NULL;
>> >+
>> >+	partsnp = of_get_child_by_name(banknp, "partitions");
>> >+	of_node_put(banknp);
>> >+
>> Sorry, I'm bit confused here .. I think you don't need to find children of
>> Your bank node. This should already taken care in default parser
>> drivers/mtd/ofpart.c : parse_ofpart_partitions()
>> And all you need to pass is 'of_node' of bank (device).
>> Is my understanding correct ?
>
>We have 3 options here, you _can_ use parse_ofpart_partitions() if
>your partition information conforms to its schema, but said schema
>does not support banks and/or other information that we choose to
>place within the bank node.  The second option is to register a
>parser.  My personal view is that registering a parser is using the
>framework for 'using the framework's' sake i.e. doesn't actually
>achieve anything special.  We've chosen the third option, which is to
>parse and extract the information ourselves - which is actually fairly
>trivial, and pass the required partition data in through the
>mtd_device_parse_register() call - which is where the information
>would be parsed in the case of the first two options.
>
Do you really want to have *custom* partition format ?
If your previous code was non-DT (platform file based), then I think
It's good point to move to unified generic partition format which others
are following, as you make your driver DT compliant, and in mainline.

I understand you primary objective would be to get ST driver work
out of mainline asap, but if you upstream too many custom stuff you
are only adding maintenance burden for your code. This is where
most of my comments originate.
However, I leave it to Brian to decide, if he is okay with these.


with regards, pekon
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
