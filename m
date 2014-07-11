Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaGKH20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:28:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58465 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbaGKH2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:28:24 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Tony Lindgren <tony@atomide.com>, "Quadros, Roger" <rogerq@ti.com>
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
Thread-Index: AQHPnNSoLhPEvObPz0CGl94w9dwZ+5uacORA
Date: Fri, 11 Jul 2014 07:27:19 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EB01DD5@DBDE04.ent.ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
 <20140711065211.GK28884@atomide.com>
In-Reply-To: <20140711065211.GK28884@atomide.com>
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

Hi Roger,

>From: Tony Lindgren [mailto:tony@atomide.com]
>>* Roger Quadros <rogerq@ti.com> [140709 05:39]:
>> Hi,
>>
>> The following hardware modules/registers are meant for NAND controller driver
>> usage:
>> - NAND I/O control (NAND address, data, command registers)
>> - Prefetch/Write-post engine
>> - ECC/BCH engine
>>
>> However, these registers sit in the GPMC controller's register space and there
>> need to be some sane way to access them from the OMAP NAND controller driver.
>>
>> Till now the GPMC driver was populating a data structure (struct gpmc_nand_regs)
>> with the register addresses and passing it to the OMAP NAND driver via platform
>> data. This mechanism cannot be used for true Device tree support as custom
>> platform data passing mechanism doesn't seem to work. Moreover, direct
>> access to these registers must be limited to the GPMC driver. This calls for
>> a few custom OMAP GPMC specific APIs that the OMAP NAND driver can use
>> to access these GPMC space registers.
>>
>> This series attempts to add the following new APIs and gets rid of
>> 'struct gpmc_nand_regs' and 'gpmc_update_nand_regs()'.
>>
>> -For NAND I/O control registers
>> u32 omap_gpmc_read_reg(int cs, enum omap_gpmc_reg reg);
>> void omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg, u32 val);
>>
>> -For Prefetch engine
>> int omap_gpmc_prefetch_start(int cs, int fifo_th, bool dma,
>> 			     u32 count, int is_write);
>> int omap_gpmc_prefetch_stop(int cs);
>> u32 omap_gpmc_get_prefetch_count(void);
>> u32 omap_gpmc_get_prefetch_fifo_count(void);
>>
>> -For ECC/BCH engine
>> void omap_gpmc_ecc_disable(void);
>> void omap_gpmc_ecc_configure_enable(int cs, bool ecc16, u8 ecc_size0,
>> 				    u8 ecc_size1, bool use_bch,
>> 				    enum omap_gpmc_bch_type bch_type,
>> 				    u8 bch_sectors, u8 bch_wrap_mode);

I think this one has too big argument list.
And also this interface will become inconsistent when you will expand the
NAND driver to support devices with larger page-size(like 8K NAND devices)
Why can't we just use 
	omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg);
as already defined above?
This is one-time configuration per read/write cycle so using
'omap_gpmc_write_reg()' shouldn't be much of issue. And this will
automatically plugin to current chip->ecc.hwctl() calls.



>> void omap_gpmc_ecc_get_result(int length, u32 *result);
Can you please rename it to "omap_gpmc_ecc_get_hamming_result()"
Just to keep it consistent with "omap_gpmc_ecc_get_bch_result()"

>> void omap_gpmc_ecc_get_bch_result(int length, u8 sector, u32 *result);
>
This one looks good, but you should also take in int 'ecc-scheme'.

Actually you can just move omap_calculate_ecc_bch(...) out of NAND
driver into GPMC driver and rename it, because support of ECC
scheme is property of hardware controller not NAND driver.
What ecc-schemes GPMC controller supports should be inside GPMC driver,
and NAND driver should just attach them to appropriate interfaces. Right ?

Same way just think of moving chip->ecc.hwctl() callbacks implementations
out of NAND driver into GPMC driver. Then you would _not_ need to
export any GPMC registers into NAND driver.


with regards, pekon

>These seem fine to me. At least I don't have any better ideas to
>expose these GPMC registers to the NAND driver(s).
>
>> These APIs don't implement any logic to serialize access to the
>> NAND/Prefetch/ECC registers. It is upto the NAND controller driver
>> to ensure that. As these modules can only handle one NAND controller context
>> at a time, we set the nand_chip->hwcontrol to point to a single
>> controller instance even if there are multiple NAND chips on different
>> Chip select spaces. The NAND base driver then takes care of serializing
>> access to the NAND controller (and ECC) through nandchip->hwcontrol->lock.
>>
>> NOTE: Patches are still untested and only meant for review.
>
>Regards,
>
>Tony
