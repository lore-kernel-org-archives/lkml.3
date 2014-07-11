Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaGKJnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:43:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48177 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaGKJnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:43:07 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: "Quadros, Roger" <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>
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
Subject: RE: [RFC PATCH 00/10] OMAP: GPMC: NAND: Introduce GPMC APIs for
 OMAP NAND
Thread-Topic: [RFC PATCH 00/10] OMAP: GPMC: NAND: Introduce GPMC APIs for
 OMAP NAND
Thread-Index: AQHPnNSoLhPEvObPz0CGl94w9dwZ+5uacORA//+9ewCAAGnYkA==
Date: Fri, 11 Jul 2014 09:42:28 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EB01EC6@DBDE04.ent.ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
 <20140711065211.GK28884@atomide.com>
 <20980858CB6D3A4BAE95CA194937D5E73EB01DD5@DBDE04.ent.ti.com>
 <53BFA038.5010903@ti.com>
In-Reply-To: <53BFA038.5010903@ti.com>
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

>From: Quadros, Roger
>>On 07/11/2014 10:27 AM, Gupta, Pekon wrote:
>>> From: Tony Lindgren [mailto:tony@atomide.com]
>>>> * Roger Quadros <rogerq@ti.com> [140709 05:39]:
>>>> Hi,
>>>>
>>>> The following hardware modules/registers are meant for NAND controller driver
>>>> usage:
>>>> - NAND I/O control (NAND address, data, command registers)
>>>> - Prefetch/Write-post engine
>>>> - ECC/BCH engine
>>>>
>>>> However, these registers sit in the GPMC controller's register space and there
>>>> need to be some sane way to access them from the OMAP NAND controller driver.
>>>>
>>>> Till now the GPMC driver was populating a data structure (struct gpmc_nand_regs)
>>>> with the register addresses and passing it to the OMAP NAND driver via platform
>>>> data. This mechanism cannot be used for true Device tree support as custom
>>>> platform data passing mechanism doesn't seem to work. Moreover, direct
>>>> access to these registers must be limited to the GPMC driver. This calls for
>>>> a few custom OMAP GPMC specific APIs that the OMAP NAND driver can use
>>>> to access these GPMC space registers.
>>>>
>>>> This series attempts to add the following new APIs and gets rid of
>>>> 'struct gpmc_nand_regs' and 'gpmc_update_nand_regs()'.
>>>>
>>>> -For NAND I/O control registers
>>>> u32 omap_gpmc_read_reg(int cs, enum omap_gpmc_reg reg);
>>>> void omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg, u32 val);
>>>>
>>>> -For Prefetch engine
>>>> int omap_gpmc_prefetch_start(int cs, int fifo_th, bool dma,
>>>> 			     u32 count, int is_write);
>>>> int omap_gpmc_prefetch_stop(int cs);
>>>> u32 omap_gpmc_get_prefetch_count(void);
>>>> u32 omap_gpmc_get_prefetch_fifo_count(void);
>>>>
>>>> -For ECC/BCH engine
>>>> void omap_gpmc_ecc_disable(void);
>>>> void omap_gpmc_ecc_configure_enable(int cs, bool ecc16, u8 ecc_size0,
>>>> 				    u8 ecc_size1, bool use_bch,
>>>> 				    enum omap_gpmc_bch_type bch_type,
>>>> 				    u8 bch_sectors, u8 bch_wrap_mode);
>>
>> I think this one has too big argument list.
>> And also this interface will become inconsistent when you will expand the
>> NAND driver to support devices with larger page-size(like 8K NAND devices)
>> Why can't we just use
>> 	omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg);
>> as already defined above?
>
>omap_gpmc_write_reg will not be optimal for reading larger result blocks
>and does not create enough abstraction between the clearly separate blocks
>i.e. prefetch engine and ecc engine.
>
>> This is one-time configuration per read/write cycle so using
>> 'omap_gpmc_write_reg()' shouldn't be much of issue. And this will
>> automatically plugin to current chip->ecc.hwctl() calls.
>>
>
>hwctl() doesn't take care of ECC. Those are done by
>chip->ecc.correct() and chip->ecc.calculate().
>
Incorrect assumption :-).
chip-ecc.hwctl() is used to configure ecc_size0 and ecc_size1, which in-turn
depend on ecc-scheme selected. Also, ecc_wrap_mode differs from
ecc-scheme for software and hardware implementations.


>>
>>
>>>> void omap_gpmc_ecc_get_result(int length, u32 *result);
>> Can you please rename it to "omap_gpmc_ecc_get_hamming_result()"
>> Just to keep it consistent with "omap_gpmc_ecc_get_bch_result()"
>>
>
>OK. Sounds reasonable.
>
>>>> void omap_gpmc_ecc_get_bch_result(int length, u8 sector, u32 *result);
>>>
>> This one looks good, but you should also take in int 'ecc-scheme'.
>
>Could you please explain why?
>
>>
>> Actually you can just move omap_calculate_ecc_bch(...) out of NAND
>> driver into GPMC driver and rename it, because support of ECC
>> scheme is property of hardware controller not NAND driver.
>> What ecc-schemes GPMC controller supports should be inside GPMC driver,
>> and NAND driver should just attach them to appropriate interfaces. Right ?
>>
>> Same way just think of moving chip->ecc.hwctl() callbacks implementations
>> out of NAND driver into GPMC driver. Then you would _not_ need to
>> export any GPMC registers into NAND driver.
>
>I don't agree with moving anything nand_chip related (i.e. ecc.hwctl(), ecc.calculate()
>or ecc.correct()) to GMPC driver because they are supposed to be implemented by
>the NAND driver. ECC is a functionality of NAND controller not of GPMC controller.
>It is just a IP design mistake that they smudged the ECC registers so badly
>in the GPMC register space.
>
Not really, I don't think that's a problem. That's TI's way of looking at
controller architecture. If you read discussion of GPMI (freescale's 
NAND controller) and NAND controllers from other vendors, there are
other complexities. Anyways that's not the discussion here, so converging back :-) ..

And, yes, you should _not_ touch chip->ecc.correct() or any other such
Implementations because those are NAND framework specific.
But below code isn't related to NAND framework, all NAND needs is how
you calcaluate the ECC, whether you do by 
- reading GPMC registers or
- by using software bch library, or
- mixed of both.
Therefore, I suggest you to move following code from NAND driver to
GPMC driver, nothing other than. And this exported function does not
need any NAND framework information, except number_of_sectors.

@@omap_calculate_ecc_bch(...)
	switch (info->ecc_opt) {
		case OMAP_ECC_BCH8_CODE_HW_DETECTION_SW:
		case OMAP_ECC_BCH8_CODE_HW:
			bch_val1 = readl(gpmc_regs->gpmc_bch_result0[i]);
			bch_val2 = readl(gpmc_regs->gpmc_bch_result1[i]);
			bch_val3 = readl(gpmc_regs->gpmc_bch_result2[i]);
			bch_val4 = readl(gpmc_regs->gpmc_bch_result3[i]);
			*ecc_code++ = (bch_val4 & 0xFF);
			*ecc_code++ = ((bch_val3 >> 24) & 0xFF);
			*ecc_code++ = ((bch_val3 >> 16) & 0xFF);
			*ecc_code++ = ((bch_val3 >> 8) & 0xFF);
			*ecc_code++ = (bch_val3 & 0xFF);
			*ecc_code++ = ((bch_val2 >> 24) & 0xFF);
			*ecc_code++ = ((bch_val2 >> 16) & 0xFF);
			*ecc_code++ = ((bch_val2 >> 8) & 0xFF);
			*ecc_code++ = (bch_val2 & 0xFF);
			*ecc_code++ = ((bch_val1 >> 24) & 0xFF);
			*ecc_code++ = ((bch_val1 >> 16) & 0xFF);
			*ecc_code++ = ((bch_val1 >> 8) & 0xFF);
			*ecc_code++ = (bch_val1 & 0xFF);
			break;
		case OMAP_ECC_BCH4_CODE_HW_DETECTION_SW:
		case OMAP_ECC_BCH4_CODE_HW:
			bch_val1 = readl(gpmc_regs->gpmc_bch_result0[i]);
			bch_val2 = readl(gpmc_regs->gpmc_bch_result1[i]);
			*ecc_code++ = ((bch_val2 >> 12) & 0xFF);
			*ecc_code++ = ((bch_val2 >> 4) & 0xFF);
			*ecc_code++ = ((bch_val2 & 0xF) << 4) |
				((bch_val1 >> 28) & 0xF);
			*ecc_code++ = ((bch_val1 >> 20) & 0xFF);
			*ecc_code++ = ((bch_val1 >> 12) & 0xFF);
			*ecc_code++ = ((bch_val1 >> 4) & 0xFF);
			*ecc_code++ = ((bch_val1 & 0xF) << 4);
			break;
		case OMAP_ECC_BCH16_CODE_HW:
			val = readl(gpmc_regs->gpmc_bch_result6[i]);
			ecc_code[0]  = ((val >>  8) & 0xFF);
			ecc_code[1]  = ((val >>  0) & 0xFF);
			val = readl(gpmc_regs->gpmc_bch_result5[i]);
			ecc_code[2]  = ((val >> 24) & 0xFF);
			ecc_code[3]  = ((val >> 16) & 0xFF);
			ecc_code[4]  = ((val >>  8) & 0xFF);
			ecc_code[5]  = ((val >>  0) & 0xFF);
			val = readl(gpmc_regs->gpmc_bch_result4[i]);
			ecc_code[6]  = ((val >> 24) & 0xFF);
			ecc_code[7]  = ((val >> 16) & 0xFF);
			ecc_code[8]  = ((val >>  8) & 0xFF);
			ecc_code[9]  = ((val >>  0) & 0xFF);
			val = readl(gpmc_regs->gpmc_bch_result3[i]);
			ecc_code[10] = ((val >> 24) & 0xFF);
			ecc_code[11] = ((val >> 16) & 0xFF);
			ecc_code[12] = ((val >>  8) & 0xFF);
			ecc_code[13] = ((val >>  0) & 0xFF);
			val = readl(gpmc_regs->gpmc_bch_result2[i]);
			ecc_code[14] = ((val >> 24) & 0xFF);
			ecc_code[15] = ((val >> 16) & 0xFF);
			ecc_code[16] = ((val >>  8) & 0xFF);
			ecc_code[17] = ((val >>  0) & 0xFF);
			val = readl(gpmc_regs->gpmc_bch_result1[i]);
			ecc_code[18] = ((val >> 24) & 0xFF);
			ecc_code[19] = ((val >> 16) & 0xFF);
			ecc_code[20] = ((val >>  8) & 0xFF);
			ecc_code[21] = ((val >>  0) & 0xFF);
			val = readl(gpmc_regs->gpmc_bch_result0[i]);
			ecc_code[22] = ((val >> 24) & 0xFF);
			ecc_code[23] = ((val >> 16) & 0xFF);
			ecc_code[24] = ((val >>  8) & 0xFF);
			ecc_code[25] = ((val >>  0) & 0xFF);
			break;
		default:
			return -EINVAL;
		}


>Could you please explain your view point as to why you want me to move these ecc.*()
>to GPMC driver other than being extensively tested?
>
I'm not asking to move ecc.*() to GPMC .. Not at all.. As just explained above.

>We can extensively test the new changes before merging any code to mainline as well.
>
OMAP NAND driver is almost stable and feature complete in kernel-3.16.
I'm in support for cleaning interface between GPMC and NAND, But
keeping other changes like NAND driver optimizations out of current patch
series for now at-least.


with regards, pekon
