Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbbAETyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:54:16 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40316 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbbAETyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:54:15 -0500
Message-ID: <54AAEBCC.2030900@ti.com>
Date: Mon, 5 Jan 2015 13:53:48 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lokesh Vutla <lokeshvutla@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <t-kristo@ti.com>, <nm@ti.com>, <nsekhar@ti.com>,
        <bcousson@baylibre.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP2+: hwmod: Fix _wait_target_ready() for hwmods
 without sysc
References: <1418917790-1791-1-git-send-email-rogerq@ti.com> <5492F84E.7020706@ti.com> <alpine.DEB.2.02.1501020654050.27058@utopia.booyaka.com> <54AA4CD4.40105@ti.com>
In-Reply-To: <54AA4CD4.40105@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 02:35 AM, Lokesh Vutla wrote:
> Hi Paul,
> On Saturday 03 January 2015 02:40 AM, Paul Walmsley wrote:
>> + Suman, lakml
>>
>> Hi Roger
>>
>> On Thu, 18 Dec 2014, Roger Quadros wrote:
>>
>>> Fixing up Paul's email id.
>>>
>>> cheers,
>>> -roger
>>>
>>> On 18/12/14 17:49, Roger Quadros wrote:
>>>> There are quite a few hwmods that don't have sysconfig register and so
>>>> _find_mpu_rt_port(oh) will return NULL thus preventing ready state check
>>>> on those modules after the module is enabled.
>>
>> Hmm.  Any IP block that exposes registers that are accessible by the MPU 
>> should have an MPU register target port, even if there's no SYSCONFIG 
>> register.  And if an IP block doesn't have registers that are accessible 
>> from the MPU, then there shouldn't be much point to waiting for the module 
>> to become ready.
>>
>> Looks like the real problem is the test for oh->class->sysc before the 
>> call to _init_mpu_rt_base().  That was introduced by commit 6423d6df1440 
>> ("ARM: OMAP2+: hwmod: check for module address space during init"). It's 
>> not clear to me why that test was added, since _init_mpu_rt_base() doesn't 
>> do anything with oh->class->sysc or SYSCONFIG registers.
> This was introduced by commit 
> 97597b962529 (ARM: OMAP2+: hwmod: Don't call _init_mpu_rt_base if no sysc)

That's right, the test was present even before 6423d6df1440, I merely
made this a block.

> Patch description states that "there are few hwmod which doesn't have sysconfig registers and hence
> no need to ioremap() them in early init code".
> Isn't this correct? 
> May be a dumb question: If IP doesn't have sysconfig, is there any case that hwmod does
> access the register address space of that IP? Why do we need to enable MPU register target port?
> 
> Thanks and regards,
> Lokesh
> 
>>
>> Could you please test the following patch?
>> I don't have an AM437x-gp-evm.  
>>
>>
>> - Paul
>>
>> ---
>>  arch/arm/mach-omap2/omap_hwmod.c | 12 ++++--------
>>  1 file changed, 4 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
>> index cbb908dc5cf0..ce6d11f3eda7 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod.c
>> @@ -2451,14 +2451,10 @@ static int __init _init(struct omap_hwmod *oh, void *data)
>>  				oh->name, np->name);
>>  	}
>>  
>> -	if (oh->class->sysc) {
>> -		r = _init_mpu_rt_base(oh, NULL, index, np);
>> -		if (r < 0) {
>> -			WARN(1, "omap_hwmod: %s: doesn't have mpu register target base\n",
>> -			     oh->name);
>> -			return 0;
>> -		}
>> -	}
>> +	r = _init_mpu_rt_base(oh, NULL, index, np);
>> +	if (r < 0)
>> +		pr_debug("omap_hwmod: %s: doesn't have mpu register target base\n",
>> +			 oh->name);
>>  
>>  	r = _init_clocks(oh, NULL);
>>  	if (r < 0) {
>>
> 

