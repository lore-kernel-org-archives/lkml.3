Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3JIHUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:20:37 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:47388 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab3JIHUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:20:35 -0400
Message-ID: <525503BE.6000000@gmail.com>
Date: Wed, 09 Oct 2013 09:20:30 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Jisheng Zhang <jszhang@marvell.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 8/8] ARM: add initial support for Marvell Berlin SoCs
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com> <1381235073-17134-9-git-send-email-sebastian.hesselbarth@gmail.com> <20131009112058.683739d0@xhacker>
In-Reply-To: <20131009112058.683739d0@xhacker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 05:20 AM, Jisheng Zhang wrote:
> On Tue, 8 Oct 2013 05:24:33 -0700
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>
>> This adds initial support for the Marvell Berlin (88DE3xxx) SoC family
>> and basic machine setup for Armada 1500 (88DE3100) SoCs.
>
> First of all, thanks for these patches. I worked and is still working on Marvell
> Berlin Linux kernel BSP at Marvell. As the person who brought up Linux kernel for
> various Berlin SoCs since BG2, I have some comments to share with you.

Jisheng,

great to finally have someone in the discussion who actually "knows" and
is not just "guessing" as I am ;)

[...]
>> diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
>> new file mode 100644
>> index 0000000..56a671e
>> --- /dev/null
>> +++ b/arch/arm/mach-berlin/Kconfig
>> @@ -0,0 +1,24 @@
>> +config ARCH_BERLIN
>> +	bool "Marvell Berlin (88DE3xxx) SoCs" if ARCH_MULTI_V7
>> +	select GENERIC_CLOCKEVENTS
>> +	select GENERIC_IRQ_CHIP
>> +	select COMMON_CLK
>> +	select DW_APB_ICTL
>> +	select DW_APB_TIMER_OF
>> +
>> +if ARCH_BERLIN
>> +
>> +menu "Marvell Berlin (88DE3xxx) SoC variants"
> It would be better to s/88DE3xxx/88DExxxx or remove 88DE3xxx totally

Ok, we can get rid of the numbers.

>> +
>> +config MACH_MV88DE3100
> Can you please use MACH_BERLIN2? This is what we used internally in latest BSP

Ok.

>> +	bool "Marvell 88DE3100 (Armada 1500)"
>> +	select ARM_GIC
>> +	select CACHE_L2X0
> The tauros3 and PL310 are different although the programming interface are
> compatible. In PJ4B and Tauros3, the CP15 cache maintenance commands include
> both L1 and L2, memory mapped PA-based maintenance operations in L2 are not needed.
> How to handle this in cache-l2x0.c?

TBH, I haven't really looked into l2cc, yet. I will assemble some people
and move this discussion over to the corresponding patch later this day.

>> +	select CPU_PJ4B
>> +	select HAVE_ARM_TWD if LOCAL_TIMERS
>> +	select HAVE_SMP
>> +	select LOCAL_TIMERS if SMP
>> +
>> +endmenu
>> +
>> +endif
>> diff --git a/arch/arm/mach-berlin/Makefile b/arch/arm/mach-berlin/Makefile
>> new file mode 100644
>> index 0000000..ab69fe9
>> --- /dev/null
>> +++ b/arch/arm/mach-berlin/Makefile
>> @@ -0,0 +1 @@
>> +obj-y += berlin.o
>> diff --git a/arch/arm/mach-berlin/berlin.c b/arch/arm/mach-berlin/berlin.c
>> new file mode 100644
>> index 0000000..54b3ba7
>> --- /dev/null
>> +++ b/arch/arm/mach-berlin/berlin.c
>> @@ -0,0 +1,39 @@
>> +/*
>> + * Device Tree support for Marvell Berlin (88DE3xxx) platforms.
> ditto

Ok.

>> + *
>> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> + *
>> + * based on GPL'ed 2.6 kernel sources
>> + *  (c) Marvell International Ltd.
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2.  This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/of_platform.h>
>> +#include <asm/hardware/cache-l2x0.h>
>> +#include <asm/mach/arch.h>
>> +
>> +static void __init berlin_init_machine(void)
>> +{
>> +	/*
>> +	 * with DT probing for L2CCs, berlin_init_machine can be removed.
>> +	 * Note: 88DE3005 (Armada 1500-mini) uses pl310 l2cc
>> +	 */
>> +	l2x0_of_init(0x70c00000, 0xfeffffff);
>> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>> +}
>> +
>> +static const char * const berlin_dt_compat[] = {
>> +	"marvell,berlin",
>> +	NULL,
>> +};
>> +
>> +DT_MACHINE_START(BERLIN_DT, "Marvell Berlin (88DE3xxx)")
> ditto

Ok.

>> +	.dt_compat      = berlin_dt_compat,
>> +	.init_machine   = berlin_init_machine,
>> +MACHINE_END
>
>
>>   create mode 100644 arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts
>>   create mode 100644 arch/arm/boot/dts/mv88de3100.dtsi
>
> Armada 1500 == mv88de3100 == BG2
>
> We always call BGx internally, so s/mv88de3100/berlin2 in all patches except
> patch 4 would be better. IOW, I prefer to call berlin2/berlin2ct/berlin2cd etc
> and never use mv88dexxxx or armada xxxx in code, dt bindings except documents.
> This would remove unnecessary confusions. What do you think?

I am fine with berlin2 instead of mv88de3100 where possible. But I
think it would be good to have berlin2 <> Armada 1500 somewhere,
possibly in all user visible places. Armada 1500 is the marketing
name you have chosen, and that is what people will look for.

Feel free to also directly comment on all the other patches, I am
in no hurry to mainline this patch set. The more we can work out
now, the better. But please keep it close to this patch set feature-
wise, I prefer to get it first and add more features later.

Sebastian

