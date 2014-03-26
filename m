Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaCZJrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 05:47:47 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:48165 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaCZJqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 05:46:55 -0400
Message-ID: <5332A42E.9030409@gmail.com>
Date: Wed, 26 Mar 2014 10:55:58 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 07/14] ARM: mvebu: Extend the pmsu registers
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com> <1395787705-31061-8-git-send-email-gregory.clement@free-electrons.com> <20140326003027.GJ28304@titan.lakedaemon.net> <53329EFE.4040705@free-electrons.com>
In-Reply-To: <53329EFE.4040705@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 10:33 AM, Gregory CLEMENT wrote:
> On 26/03/2014 01:30, Jason Cooper wrote:
>> On Tue, Mar 25, 2014 at 11:48:18PM +0100, Gregory CLEMENT wrote:
>>> The initial binding for PMSU were wrong. It didn't take into account
>>> all the registers from the PMSU and moreover it referred to registers
>>> which are not part of PMSU.
>>>
>>> The Power Management Unit Service block also controls the Coherency
>>> Fabric subsystem. These registers are needed for the CPU idle
>>> implementation for the Armada 370/XP, it allows to enter a deep CPU
>>> idle state where the Coherency Fabric and the L2 cache are powered
>>> down.
>>>
>>> This commit add support for a new compatible for the PMSU node
>>> including the block related to the coherency fabric. It also keeps
>>> compatibility with the old binding
>>>
>>> This patch also adds warnings if one of the base registers set can't
>>> be ioremapped.
>>>
>>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>>> ---
>>>   arch/arm/mach-mvebu/pmsu.c | 47 +++++++++++++++++++++++++++++++++++++++++-----
>>>   1 file changed, 42 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
>>> index d71ef53107c4..865bcb651e01 100644
>>> --- a/arch/arm/mach-mvebu/pmsu.c
>>> +++ b/arch/arm/mach-mvebu/pmsu.c
>>> @@ -27,11 +27,21 @@
>>>   static void __iomem *pmsu_mp_base;
>>>   static void __iomem *pmsu_reset_base;
>>>
>>> -#define PMSU_BOOT_ADDR_REDIRECT_OFFSET(cpu)	((cpu * 0x100) + 0x24)
>>> +#define PMSU_BASE_OFFSET    0x100
>>> +#define PMSU_REG_SIZE	    0x1000
>>> +
>>> +#define PMSU_BOOT_ADDR_REDIRECT_OFFSET(cpu)	((cpu * 0x100) + 0x124)
>>>   #define PMSU_RESET_CTL_OFFSET(cpu)		(cpu * 0x8)
>>>
>>>   static struct of_device_id of_pmsu_table[] = {
>>> -	{.compatible = "marvell,armada-370-xp-pmsu"},
>>> +	{
>>> +		.compatible = "marvell,armada-370-pmsu",
>>> +		.data = (void *) false,
>>
>> This looks sketchy to me.
>
> Could you elaborate it?
>
> For a boolean I didn't saw the point to use a pointer.

Isn't the different compatible boolean enough?
You can use of_device_is_compatible() below.

>>> +	},
>>> +	{
>>> +		.compatible = "marvell,armada-370-xp-pmsu",
>>> +		.data = (void *) true, /* legacy */
>>
>> Same.
>>
>>> +	},
>>>   	{ /* end of list */ },
>>>   };
>>>
>>> @@ -59,15 +69,42 @@ int armada_xp_boot_cpu(unsigned int cpu_id, void *boot_addr)
>>>   }
>>>   #endif
>>>
>>> +static void __init armada_370_xp_pmsu_legacy_init(struct device_node *np)
>>> +{
>>> +	u32 addr;
>>> +	pr_warn("*** Warning ***  Using an old binding which will be deprecated\n");
>>
>> This should be noted in the binding docs...

pr_warn(FW_{WARN,BUG} "deprecated pmsu binding\n");

[...]
>>>   	np = of_find_matching_node(NULL, of_pmsu_table);
>>>   	if (np) {
>>> +		const struct of_device_id *match =
>>> +			of_match_node(of_pmsu_table, np);
>>> +		BUG_ON(!match);
>>> +
>>>   		pr_info("Initializing Power Management Service Unit\n");
>>> -		pmsu_mp_base = of_iomap(np, 0);
>>> -		pmsu_reset_base = of_iomap(np, 1);
>>> +
>>> +		if (match->data) /* legacy */
>>> +			armada_370_xp_pmsu_legacy_init(np);

if (of_device_is_compatible(np, "marvell,armada-370-xp-pmsu"))
	armada_370_xp_pmsu_legacy_init(np);
else
	...

Sebastian

>> And if a new compatible string actually needs data passed?
>
> in this case we would have to update the of_pmsu_table, so this
> code could be also updated if needed in the same time. So I don't
> see the problem, maybe I miss something.
>
> But the plan is really to remove this legacy part later (after a
> few kernel release)
>
>>
>>> +		else
>>> +			pmsu_mp_base = of_iomap(np, 0);
>>> +		WARN_ON(!pmsu_mp_base);
>>> +		of_node_put(np);
>>> +
>>> +		/*
>>> +		 * This temporaty hack will be removed as soon as we

