Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaLPTKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 14:10:43 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39593 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaLPTKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 14:10:42 -0500
Message-ID: <5490839A.304@gmail.com>
Date: Tue, 16 Dec 2014 11:10:18 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Wenyou Yang <wenyou.yang@atmel.com>
CC: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: board-dt-sama5: add phy_fixup to override
 NAND_Tree which improperly strapp-in during the reset period.
References: <1418283069-5648-1-git-send-email-wenyou.yang@atmel.com> <54900779.9030509@atmel.com>
In-Reply-To: <54900779.9030509@atmel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/12/14 02:20, Nicolas Ferre wrote:
> Le 11/12/2014 08:31, Wenyou Yang a écrit :
>> Appearance: On some SAMA5D4EK boards, after power up, the Eth1 doesn't work.
>>
>> Reason: The PIOE2 pin is connected to the NAND_Tree# of KSZ8081,
>> But it outputs LOW during the reset period, which cause the NAND_Tree# enabled.
>>
>> Add phy_fixup() to disable NAND_Tree by overriding the Operation
>> Mode Strap Override register(i.e. Register 16h) to clear the NAND_Tree bit.
>>
>> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> 
> It seems correct to me.

Just one minor nit, see below

> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Anyway, I add Florian in the loop as he is the one who proposed this
> solution. So it would have been good to have his feeling about the
> implementation...
> 
> Bye,
> 
>> ---
>>  arch/arm/mach-at91/board-dt-sama5.c |   18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
>> index 8fb9ef5..97f7367 100644
>> --- a/arch/arm/mach-at91/board-dt-sama5.c
>> +++ b/arch/arm/mach-at91/board-dt-sama5.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/of_platform.h>
>>  #include <linux/phy.h>
>>  #include <linux/clk-provider.h>
>> +#include <linux/phy.h>
>>  
>>  #include <asm/setup.h>
>>  #include <asm/irq.h>
>> @@ -26,8 +27,25 @@
>>  
>>  #include "generic.h"
>>  
>> +static int ksz8081_phy_fixup(struct phy_device *phy)
>> +{
>> +	int value;
>> +
>> +	value = phy_read(phy, 0x16);
>> +	value &= ~0x20;
>> +	phy_write(phy, 0x16, value);
>> +
>> +	return 0;
>> +}
>> +
>>  static void __init sama5_dt_device_init(void)
>>  {
>> +	if (of_machine_is_compatible("atmel,sama5d4ek") &&
>> +	   IS_ENABLED(CONFIG_PHYLIB)) {
>> +		phy_register_fixup_for_id("fc028000.etherne:00",
>> +						ksz8081_phy_fixup);

Matching the bus id certainly works, but I would rather match on your
specific PHY device 32-bits OUI to make sure that if you ever change the
PHY on a different design, this is not inadvertently writing to a
register that is not micrel specific?

>> +	}
>> +
>>  	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>>  }
>>  
>>
> 
> 

