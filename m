Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaGKKYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:24:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50678 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbaGKKYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:24:04 -0400
Message-ID: <53BFBB1F.9000901@ti.com>
Date: Fri, 11 Jul 2014 13:23:27 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Gupta, Pekon" <pekon@ti.com>, Tony Lindgren <tony@atomide.com>
CC: "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "javier@dowhile0.org" <javier@dowhile0.org>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/10] OMAP: GPMC: NAND: Introduce GPMC APIs for OMAP
 NAND
References: <1404909450-11970-1-git-send-email-rogerq@ti.com> <20140711065211.GK28884@atomide.com> <20980858CB6D3A4BAE95CA194937D5E73EB01DD5@DBDE04.ent.ti.com> <53BFA038.5010903@ti.com> <20980858CB6D3A4BAE95CA194937D5E73EB01EC6@DBDE04.ent.ti.com>
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EB01EC6@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 12:42 PM, Gupta, Pekon wrote:
>> From: Quadros, Roger
>>> On 07/11/2014 10:27 AM, Gupta, Pekon wrote:
>>>> From: Tony Lindgren [mailto:tony@atomide.com]
>>>>> * Roger Quadros <rogerq@ti.com> [140709 05:39]:
>>>>> Hi,
>>>>>
>>>>> The following hardware modules/registers are meant for NAND controller driver
>>>>> usage:
>>>>> - NAND I/O control (NAND address, data, command registers)
>>>>> - Prefetch/Write-post engine
>>>>> - ECC/BCH engine
>>>>>
>>>>> However, these registers sit in the GPMC controller's register space and there
>>>>> need to be some sane way to access them from the OMAP NAND controller driver.
>>>>>
>>>>> Till now the GPMC driver was populating a data structure (struct gpmc_nand_regs)
>>>>> with the register addresses and passing it to the OMAP NAND driver via platform
>>>>> data. This mechanism cannot be used for true Device tree support as custom
>>>>> platform data passing mechanism doesn't seem to work. Moreover, direct
>>>>> access to these registers must be limited to the GPMC driver. This calls for
>>>>> a few custom OMAP GPMC specific APIs that the OMAP NAND driver can use
>>>>> to access these GPMC space registers.
>>>>>
>>>>> This series attempts to add the following new APIs and gets rid of
>>>>> 'struct gpmc_nand_regs' and 'gpmc_update_nand_regs()'.
>>>>>
>>>>> -For NAND I/O control registers
>>>>> u32 omap_gpmc_read_reg(int cs, enum omap_gpmc_reg reg);
>>>>> void omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg, u32 val);
>>>>>
>>>>> -For Prefetch engine
>>>>> int omap_gpmc_prefetch_start(int cs, int fifo_th, bool dma,
>>>>> 			     u32 count, int is_write);
>>>>> int omap_gpmc_prefetch_stop(int cs);
>>>>> u32 omap_gpmc_get_prefetch_count(void);
>>>>> u32 omap_gpmc_get_prefetch_fifo_count(void);
>>>>>
>>>>> -For ECC/BCH engine
>>>>> void omap_gpmc_ecc_disable(void);
>>>>> void omap_gpmc_ecc_configure_enable(int cs, bool ecc16, u8 ecc_size0,
>>>>> 				    u8 ecc_size1, bool use_bch,
>>>>> 				    enum omap_gpmc_bch_type bch_type,
>>>>> 				    u8 bch_sectors, u8 bch_wrap_mode);
>>>
>>> I think this one has too big argument list.
>>> And also this interface will become inconsistent when you will expand the
>>> NAND driver to support devices with larger page-size(like 8K NAND devices)
>>> Why can't we just use
>>> 	omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg);
>>> as already defined above?
>>
>> omap_gpmc_write_reg will not be optimal for reading larger result blocks
>> and does not create enough abstraction between the clearly separate blocks
>> i.e. prefetch engine and ecc engine.
>>
>>> This is one-time configuration per read/write cycle so using
>>> 'omap_gpmc_write_reg()' shouldn't be much of issue. And this will
>>> automatically plugin to current chip->ecc.hwctl() calls.
>>>
>>
>> hwctl() doesn't take care of ECC. Those are done by
>> chip->ecc.correct() and chip->ecc.calculate().
>>
> Incorrect assumption :-).
> chip-ecc.hwctl() is used to configure ecc_size0 and ecc_size1, which in-turn
> depend on ecc-scheme selected. Also, ecc_wrap_mode differs from
> ecc-scheme for software and hardware implementations.
> 

Right. so hwctl(), calculate() and correct() go hand in hand and must be implemented
by the NAND controller driver.

> 
>>>
>>>
>>>>> void omap_gpmc_ecc_get_result(int length, u32 *result);
>>> Can you please rename it to "omap_gpmc_ecc_get_hamming_result()"
>>> Just to keep it consistent with "omap_gpmc_ecc_get_bch_result()"
>>>
>>
>> OK. Sounds reasonable.
>>
>>>>> void omap_gpmc_ecc_get_bch_result(int length, u8 sector, u32 *result);
>>>>
>>> This one looks good, but you should also take in int 'ecc-scheme'.
>>
>> Could you please explain why?
>>
>>>
>>> Actually you can just move omap_calculate_ecc_bch(...) out of NAND
>>> driver into GPMC driver and rename it, because support of ECC
>>> scheme is property of hardware controller not NAND driver.
>>> What ecc-schemes GPMC controller supports should be inside GPMC driver,
>>> and NAND driver should just attach them to appropriate interfaces. Right ?
>>>
>>> Same way just think of moving chip->ecc.hwctl() callbacks implementations
>>> out of NAND driver into GPMC driver. Then you would _not_ need to
>>> export any GPMC registers into NAND driver.
>>
>> I don't agree with moving anything nand_chip related (i.e. ecc.hwctl(), ecc.calculate()
>> or ecc.correct()) to GMPC driver because they are supposed to be implemented by
>> the NAND driver. ECC is a functionality of NAND controller not of GPMC controller.
>> It is just a IP design mistake that they smudged the ECC registers so badly
>> in the GPMC register space.
>>
> Not really, I don't think that's a problem. That's TI's way of looking at

Moreover, that is TI's legacy stuff coming right from OMAP2/3 days.

> controller architecture. If you read discussion of GPMI (freescale's 
> NAND controller) and NAND controllers from other vendors, there are
> other complexities. Anyways that's not the discussion here, so converging back :-) ..
> 
> And, yes, you should _not_ touch chip->ecc.correct() or any other such
> Implementations because those are NAND framework specific.
> But below code isn't related to NAND framework, all NAND needs is how
> you calcaluate the ECC, whether you do by 
> - reading GPMC registers or
> - by using software bch library, or
> - mixed of both.
> Therefore, I suggest you to move following code from NAND driver to
> GPMC driver, nothing other than. And this exported function does not
> need any NAND framework information, except number_of_sectors.

Well I you have still not pointed out what is the benefit of that approach or what are the problems with the approach I am suggesting.

I am suggesting that the API just return the ECC/BCH result registers as it is.
You are suggesting that the API do the calculations and return the NAND ready ECC buffer.

To do the calculations it needs to know about the ECC scheme which is NAND controller specific and this is unnecessary in the GPMC driver.

Tony, what is your opinion?

> 
> @@omap_calculate_ecc_bch(...)
> 	switch (info->ecc_opt) {
> 		case OMAP_ECC_BCH8_CODE_HW_DETECTION_SW:
> 		case OMAP_ECC_BCH8_CODE_HW:

> 
> 
>> Could you please explain your view point as to why you want me to move these ecc.*()
>> to GPMC driver other than being extensively tested?
>>
> I'm not asking to move ecc.*() to GPMC .. Not at all.. As just explained above.
> 
>> We can extensively test the new changes before merging any code to mainline as well.
>>
> OMAP NAND driver is almost stable and feature complete in kernel-3.16.

> I'm in support for cleaning interface between GPMC and NAND, But
> keeping other changes like NAND driver optimizations out of current patch
> series for now at-least.

I too support not breaking existing functionality. I didn't write this series with optimization in mind. Just establishing the APIs necessary.

cheers,
-roger
