Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763018Ab3ECJ6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:58:12 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:61982 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762174Ab3ECJ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:58:10 -0400
Message-ID: <51838A2B.50302@gmail.com>
Date: Fri, 03 May 2013 11:58:03 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH v2 2/5] ARM: dove: add DT parsing for legacy mv643xx_eth
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com> <1367538519-23940-1-git-send-email-sebastian.hesselbarth@gmail.com> <1367538519-23940-3-git-send-email-sebastian.hesselbarth@gmail.com> <20130503050632.GC24965@lunn.ch>
In-Reply-To: <20130503050632.GC24965@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 07:06 AM, Andrew Lunn wrote:
> On Fri, May 03, 2013 at 01:48:36AM +0200, Sebastian Hesselbarth wrote:
>> To allow to move to orion irqchip driver, existing legacy devices
>> have to map their irqs. This patch adds init code to map the
>> corresponding irqs. It will vanish as soon as there is true device tree
>> support for mv643xx_eth.
>>
>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>> ---
>> Changelog:
>> v1->v2:
>> - split off DT changes (Suggested by Jason Cooper)
>>
>> Cc: Grant Likely<grant.likely@linaro.org>
>> Cc: Rob Herring<rob.herring@calxeda.com>
>> Cc: Rob Landley<rob@landley.net>
>> Cc: Thomas Gleixner<tglx@linutronix.de>
>> Cc: Russell King<linux@arm.linux.org.uk>
>> Cc: Arnd Bergmann<arnd@arndb.de>
>> Cc: Jason Cooper<jason@lakedaemon.net>
>> Cc: Andrew Lunn<andrew@lunn.ch>
>> Cc: Jason Gunthorpe<jgunthorpe@obsidianresearch.com>
>> Cc: Thomas Petazzoni<thomas.petazzoni@free-electrons.com>
>> Cc: Gregory Clement<gregory.clement@free-electrons.com>
>> Cc: Ezequiel Garcia<ezequiel.garcia@free-electrons.com>
>> Cc: Jean-Francois Moine<moinejf@free.fr>
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   arch/arm/mach-dove/board-dt.c |   31 ++++++++++++++++++++++++++++++-
>>   1 file changed, 30 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-dove/board-dt.c b/arch/arm/mach-dove/board-dt.c
>> index fbde1dd..9df6dd7 100644
>> --- a/arch/arm/mach-dove/board-dt.c
>> +++ b/arch/arm/mach-dove/board-dt.c
>> @@ -12,6 +12,7 @@
>>   #include<linux/clk-provider.h>
>>   #include<linux/clk/mvebu.h>
>>   #include<linux/of.h>
>> +#include<linux/of_irq.h>
>>   #include<linux/of_platform.h>
>>   #include<linux/platform_data/usb-ehci-orion.h>
>>   #include<asm/hardware/cache-tauros2.h>
>> @@ -57,6 +58,34 @@ static struct mv643xx_eth_platform_data dove_dt_ge00_data = {
>>   	.phy_addr = MV643XX_ETH_PHY_ADDR_DEFAULT,
>>   };
>>
>> +#define DOVE_GE00_PHYS_BASE	0xf1070000
>> +
>> +static void __init dove_legacy_ge00_init(void)
>> +{
>> +	struct device_node *np = of_find_compatible_node(NULL, NULL,
>> +					 "marvell,mv643xx-eth-block");
>> +	int irq_sum, irq_err;
>> +
>> +	if (!np)
>> +		return;
>> +
>> +	irq_sum = irq_of_parse_and_map(np, 0);
>> +	if (!irq_sum) {
>> +		pr_err("%s: missing sum irq\n", np->full_name);
>> +		return;
>> +	}
>> +
>> +	irq_err = irq_of_parse_and_map(np, 1);
>> +	if (!irq_err) {
>> +		pr_err("%s: missing err irq\n", np->full_name);
>> +		return;
>> +	}
>> +
>> +	/* legacy ge00_init wants phys base */
>> +	orion_ge00_init(&dove_dt_ge00_data, DOVE_GE00_PHYS_BASE,
>> +			irq_sum, irq_err, 1600);
>> +}
>
> Hi Sebastian
>
> I know the above code is throw away, but it might help with getting
> Kirkwood, Orion5x, mv78xx00 supported if we refactor this code and
> move most of it into plat-orion/common.c. I could imaging a function
>
> orion_ge00_irq_init(struct mv643xx_eth_platform_data *eth_data,
>                      unsigned long mapbase, unsigned int tx_csum_limit)
>
> which does the irq lookup and then calls orion_ge00_init().

Andrew,

sure. Feel free to move legacy code to where all SoCs can use it.

> Jason: what is the status of the ethernet driver conversion to DT?
> Will it get merged this week, or is it material for the next merge
> window?

What I remember from Florian's work it was close to be released. I
never saw Florian sending an update to his patches, maybe he ran out
of time?

I guess DT timer will be a quick patch when we have all SoCs running
on DT irqchip and maybe Florian can update his patches even before we
sort out Thomas request. Then we could also merge DT timer within this
patch set and get rid of legacy helpers before we even introduce them.

Sebastian

