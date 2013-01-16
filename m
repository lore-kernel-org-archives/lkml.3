Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3APLoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 06:44:05 -0500
Received: from mail.hostpark.net ([212.243.197.30]:37863 "EHLO
	mail.hostpark.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab3APLoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 06:44:03 -0500
X-Greylist: delayed 84637 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jan 2013 06:44:02 EST
Message-ID: <50F6927D.3070303@mpl.ch>
Date: Wed, 16 Jan 2013 12:43:57 +0100
From: Stefan Peter <s.peter@mpl.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, jason@lakedaemon.net, dwmw2@infradead.org,
        jm@lentin.co.uk, arnd@arndb.de, sebastian.hesselbarth@googlemail.com,
        iwamatsu@nigauri.org, artem.bityutskiy@linux.intel.com,
        wfp5p@virginia.edu, gregkh@linuxfoundation.org,
        broonie@opensource.wolfsonmicro.com, mchehab@redhat.com,
        nico@linaro.org
Subject: Re: [PATCH 3/4] Enable ecc-mode selection in the driver
References: <cover.1358242644.git.s.peter@mpl.ch> <2d08c4c072fd4922a6056362adb96a455307d583.1358242644.git.s.peter@mpl.ch> <20130115125119.GH13482@lunn.ch>
In-Reply-To: <20130115125119.GH13482@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew

on 15.01.2013 13:51, Andrew Lunn wrote:
> On Tue, Jan 15, 2013 at 01:13:12PM +0100, Stefan Peter wrote:
>> In order to be able to use the ecc-mode, add the bch module to the default
>> settings for the kirwood boards and enable the activation in orin-nand.c
>>
>> Signed-off-by: Stefan Peter <s.peter@mpl.ch>
>> ---
>> diff --git a/arch/arm/configs/kirkwood_defconfig b/arch/arm/configs/kirkwood_defconfig
>> index 93f3794..4a9d3f7 100644
>> --- a/arch/arm/configs/kirkwood_defconfig
>> +++ b/arch/arm/configs/kirkwood_defconfig
>> @@ -84,6 +84,7 @@ CONFIG_MTD_CFI_STAA=y
>>  CONFIG_MTD_PHYSMAP=y
>>  CONFIG_MTD_M25P80=y
>>  CONFIG_MTD_NAND=y
>> +CONFIG_MTD_NAND_ECC_BCH=y
>>  CONFIG_MTD_NAND_ORION=y
>>  CONFIG_BLK_DEV_LOOP=y
>>  # CONFIG_SCSI_PROC_FS is not set
>> diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
>> index cd72b92..1a35257 100644
>> --- a/drivers/mtd/nand/orion_nand.c
>> +++ b/drivers/mtd/nand/orion_nand.c
>> @@ -14,6 +14,7 @@
>>  #include <linux/module.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/of.h>
>> +#include <linux/of_mtd.h>
>>  #include <linux/mtd/mtd.h>
>>  #include <linux/mtd/nand.h>
>>  #include <linux/mtd/partitions.h>
>> @@ -130,6 +131,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
>>  		if (!of_property_read_u32(pdev->dev.of_node,
>>  						"chip-delay", &val))
>>  			board->chip_delay = (u8)val;
>> +		board->ecc_mode = of_get_nand_ecc_mode(pdev->dev.of_node);
> 
>>  	} else
>>  		board = pdev->dev.platform_data;
>>  
>> @@ -140,7 +142,8 @@ static int __init orion_nand_probe(struct platform_device *pdev)
>>  	nc->IO_ADDR_R = nc->IO_ADDR_W = io_base;
>>  	nc->cmd_ctrl = orion_nand_cmd_ctrl;
>>  	nc->read_buf = orion_nand_read_buf;
>> -	nc->ecc.mode = NAND_ECC_SOFT;
>> +	nc->ecc.mode = board->ecc_mode == NAND_ECC_SOFT_BCH ?
>> +		NAND_ECC_SOFT_BCH : NAND_ECC_SOFT;
> 
> Hi Stefan
> 
> What about a user that wants one of the other valid values?
> NAND_ECC_OOB_FIRST, NAND_ECC_HW_SYNDROME, etc.

As far as I understand, NAND_ECC_NONE, NAND_ECC_SOFT and
NAND_ECC_SOFT_BCH are the only ECC modes that do not require
corresponding hardware support which is missing in the marvell
88F6180/88F619x/88F628x. From my point of view, NAND_ECC_NONE does not
make sense, too, because MLC NAND Flash requires ECC to be usable.

> 
> Would:
> 
> 	if (IS_ERR(board->ecc_mode)) {
> 		nc->ecc.mode = NAND_ECC_SOFT;
> 		dev_info(&pdev->dev, "Defaulting to NAND_ECC_SOFT");
> 	} else
> 		nc->ecc.mode = board->ecc_mode
> 
> be better?

I feel safer by limiting the modes to what I could test.

Regards

Stefan Peter


-- 
MPL AG, Switzerland                     http://www.mpl.ch
Tel. +41 (0)56 483 34 34          Fax: +41(0)56 493 30 20
