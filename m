Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3K2O5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 09:57:11 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34961 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab3K2O5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 09:57:09 -0500
Message-ID: <5298AA82.1090309@ti.com>
Date: Fri, 29 Nov 2013 09:53:54 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <grygorii.strashko@ti.com>,
        <linux@arm.linux.org.uk>, <pawel.moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <rob@landley.net>, <computersforpeace@gmail.com>,
        <dwmw2@infradead.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] ARM: davinci: aemif: get rid of davinci-nand driver
 dependency on aemif
References: <1385562694-24618-1-git-send-email-ivan.khoronzhuk@ti.com> <52981A4B.70703@ti.com>
In-Reply-To: <52981A4B.70703@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 November 2013 11:38 PM, Sekhar Nori wrote:
> On Wednesday 27 November 2013 08:01 PM, Ivan Khoronzhuk wrote:
>> The problem that the set timings code contains the call of Davinci
>> platform function davinci_aemif_setup_timing() which is not
>> accessible if kernel is built for another platform like Keystone.
>>
>> The Keysone platform is going to use TI AEMIF driver.
>> If TI AEMIF is used we don't need to set timings and bus width.
>> It is done by AEMIF driver.
>>
>> To get rid of davinci-nand driver dependency on aemif platform code
>> we moved aemif code to davinci platform.
>>
>> The platform AEMIF code (aemif.c) has to be removed once Davinci
>> will be converted to DT and use ti-aemif.c driver.
>>
>> The long device name "davinci_ntosd2_nandflash_device" was renamed
>> to "ntosd2_nandflash" as requested by Sekhar Nori, because after
>> adding changes the line is so broken that its almost unreadable.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> 
> This patch can be simplified in some places.
> 
>> ---
>> v2..v1:
>> - enabled AEMIF clock
>> - removed EXPORT_SYMBOL(davinci_aemif_setup)
>> - renamed ugly name davinci_ntosd2_nandflash_device
>>
>> CC:
>> Sekhar Nori <nsekhar@ti.com>
>>
>>  arch/arm/mach-davinci/aemif.c                   |   89 ++++++++++++++++++++++-
>>  arch/arm/mach-davinci/board-da830-evm.c         |    3 +
>>  arch/arm/mach-davinci/board-da850-evm.c         |    3 +
>>  arch/arm/mach-davinci/board-dm355-evm.c         |    5 ++
>>  arch/arm/mach-davinci/board-dm355-leopard.c     |    5 ++
>>  arch/arm/mach-davinci/board-dm365-evm.c         |    4 +
>>  arch/arm/mach-davinci/board-dm644x-evm.c        |    5 ++
>>  arch/arm/mach-davinci/board-dm646x-evm.c        |    3 +
>>  arch/arm/mach-davinci/board-mityomapl138.c      |    3 +
>>  arch/arm/mach-davinci/board-neuros-osd2.c       |   13 +++-
>>  arch/arm/mach-davinci/devices-tnetv107x.c       |    3 +
>>  drivers/mtd/nand/davinci_nand.c                 |   23 ------
>>  include/linux/platform_data/mtd-davinci-aemif.h |    5 +-
> 
> Most of these boards dont really have a timing structure defined.
> Instead of blindly calling AEMIF setup on all boards, it can be
> done only on boards that actually need it.
>
Make sense to me.

 
>>  /*
>>   * aemif_calc_rate - calculate timing data.
>>   * @wanted: The cycle time needed in nanoseconds.
>> @@ -86,7 +98,7 @@ static int aemif_calc_rate(int wanted, unsigned long clk, int max)
>>   *
>>   * Returns 0 on success, else negative errno.
>>   */
>> -int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
>> +static int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
> 
> passing the clkrate to this function helps avoid a repeated clk_get().
> I made these changes locally and here is the updated patch:
>
probably a good idea.
 
> ---8<---
> From cdea7d6f753db09447fe2232959864ab999fe565 Mon Sep 17 00:00:00 2001
> From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> Date: Wed, 27 Nov 2013 16:31:34 +0200
> Subject: [PATCH 1/1] ARM: davinci: aemif: get rid of davinci-nand driver
>  dependency on aemif
> 
> The problem that the set timings code contains the call of Davinci
> platform function davinci_aemif_setup_timing() which is not
> accessible if kernel is built for another platform like Keystone.
> 
> The Keysone platform is going to use TI AEMIF driver.
> If TI AEMIF is used we don't need to set timings and bus width.
> It is done by AEMIF driver. The TI AEMIF driver cannot
> be used on all current DaVinci platforms since it is DT-only.
> 
> To get rid of davinci-nand driver dependency on aemif platform code
> we moved aemif code to davinci platform.
> 
> The platform AEMIF code (aemif.c) has to be removed once Davinci
> will be converted to DT and use ti-aemif.c driver.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> ---
>  arch/arm/mach-davinci/aemif.c                   |  106 ++++++++++++++++++++---
>  arch/arm/mach-davinci/board-da830-evm.c         |    3 +
>  arch/arm/mach-davinci/board-da850-evm.c         |    3 +
>  arch/arm/mach-davinci/board-dm644x-evm.c        |    5 ++
>  arch/arm/mach-davinci/board-dm646x-evm.c        |    3 +
Ivan commented same need for board-mityomapl138.c as well.


>  drivers/mtd/nand/davinci_nand.c                 |   23 -----
>  include/linux/platform_data/mtd-davinci-aemif.h |    5 +-
>  7 files changed, 112 insertions(+), 36 deletions(-)
> 
Apart from that one board question, I think the patch is nicely
breaking the hard dependency with nand driver and machine code
making easier for re-use.

FWIW,
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Regards,
Santosh


