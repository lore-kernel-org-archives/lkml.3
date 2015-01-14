Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbbANM1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:27:12 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55022 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbbANM1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:27:10 -0500
Message-ID: <54B6607D.5040107@ti.com>
Date: Wed, 14 Jan 2015 14:26:37 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: Lokesh Vutla <lokeshvutla@ti.com>, <tony@atomide.com>,
        <santosh.shilimkar@oracle.com>, <t-kristo@ti.com>, <nm@ti.com>,
        <nsekhar@ti.com>, <bcousson@baylibre.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <s-anna@ti.com>
Subject: Re: [PATCH] ARM: OMAP2+: hwmod: Fix _wait_target_ready() for hwmods
 without sysc
References: <1418917790-1791-1-git-send-email-rogerq@ti.com> <5492F84E.7020706@ti.com> <alpine.DEB.2.02.1501020654050.27058@utopia.booyaka.com> <54AA4CD4.40105@ti.com> <alpine.DEB.2.02.1501060202540.28771@utopia.booyaka.com> <54AD166C.9060507@ti.com> <alpine.DEB.2.02.1501132345220.28034@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1501132345220.28034@utopia.booyaka.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/15 01:46, Paul Walmsley wrote:
> On Wed, 7 Jan 2015, Roger Quadros wrote:
> 
>>> From: Paul Walmsley <paul@pwsan.com>
>>> Date: Mon, 5 Jan 2015 15:49:57 -0700
>>> Subject: [PATCH] Only skip ioremap() if IP block does not have OCP header
>>>  registers. Experimental.
>>>
>>> ---
>>>  arch/arm/mach-omap2/omap_hwmod.c | 33 +++++++++++++++++++++------------
>>>  1 file changed, 21 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
>>> index cbb908dc5cf0..03df8833d399 100644
>>> --- a/arch/arm/mach-omap2/omap_hwmod.c
>>> +++ b/arch/arm/mach-omap2/omap_hwmod.c
>>> @@ -1938,6 +1938,8 @@ static int _reset(struct omap_hwmod *oh)
>>>  	pr_debug("omap_hwmod: %s: resetting\n", oh->name);
>>>  
>>>  	if (oh->class->reset) {
>>> +		WARN(!oh->_mpu_rt_va, "Attempt to call custom reset with no MPU register target ioremapped: %s",
>>> +		     oh->name);
>>
>> Not part of $subject.
> 
> Hmm, how do you mean?  If we skip the ioremap(), wouldn't you like to know 
> before some custom reset code gets called that pretty much always depends 
> on the ioremap() succeeding? :-)

Ah yes. you are right.

> 
>>>  		r = oh->class->reset(oh);
>>>  	} else {
>>>  		if (oh->rst_lines_cnt > 0) {
>>> @@ -2358,15 +2360,19 @@ static int of_dev_hwmod_lookup(struct device_node *np,
>>>  }
>>>  
>>>  /**
>>> - * _init_mpu_rt_base - populate the virtual address for a hwmod
>>> + * _init_mpu_rt_base - populate the MPU port and virtual address
>>>   * @oh: struct omap_hwmod * to locate the virtual address
>>>   * @data: (unused, caller should pass NULL)
>>>   * @index: index of the reg entry iospace in device tree
>>>   * @np: struct device_node * of the IP block's device node in the DT data
>>>   *
>>> - * Cache the virtual address used by the MPU to access this IP block's
>>> - * registers.  This address is needed early so the OCP registers that
>>> - * are part of the device's address space can be ioremapped properly.
>>> + * Cache the interconnect target port and the virtual address used by
>>> + * the MPU to access this IP block's registers.  The address is needed
>>> + * early so the OCP registers that are part of the device's address
>>> + * space can be ioremapped properly.  The presence or absence of the
>>> + * interconnect target port also indicates whether the hwmod code
>>> + * should wait for the IP block to indicate readiness after it is
>>> + * enabled.
>>>   *
>>>   * Returns 0 on success, -EINVAL if an invalid hwmod is passed, and
>>>   * -ENXIO on absent or invalid register target address space.
>>> @@ -2385,6 +2391,13 @@ static int __init _init_mpu_rt_base(struct omap_hwmod *oh, void *data,
>>>  	if (oh->_int_flags & _HWMOD_NO_MPU_PORT)
>>>  		return -ENXIO;
>>>  
>>> +	/*
>>> +	 * If there's no need for the hwmod code to read or write to
>>> +	 * the IP block registers, bail out early before the ioremap()
>>> +	 */
>>> +	if (!oh->class->sysc)
>>> +		return 0;
>>> +
>>>  	mem = _find_mpu_rt_addr_space(oh);
>>>  	if (!mem) {
>>>  		pr_debug("omap_hwmod: %s: no MPU register target found\n",
>>> @@ -2451,14 +2464,10 @@ static int __init _init(struct omap_hwmod *oh, void *data)
>>>  				oh->name, np->name);
>>>  	}
>>>  
>>> -	if (oh->class->sysc) {
>>> -		r = _init_mpu_rt_base(oh, NULL, index, np);
>>> -		if (r < 0) {
>>> -			WARN(1, "omap_hwmod: %s: doesn't have mpu register target base\n",
>>> -			     oh->name);
>>> -			return 0;
>>> -		}
>>> -	}
>>> +	r = _init_mpu_rt_base(oh, NULL, index, np);
>>> +	if (r < 0)
>>> +		pr_debug("omap_hwmod: %s: doesn't have mpu register target base\n",
>>> +			 oh->name);
>>
>> This is the real piece that fixes the issue.
>>
>>>  
>>>  	r = _init_clocks(oh, NULL);
>>>  	if (r < 0) {
>>>
>>
>> I've tested this patch on am43x-gp-evm, and it seems to fix the issue 
>> although with some unpleasant warning messages.
> 
> Could you paste those in?
> 
I can't reproduce what I saw earlier. Sorry for the noise.

cheers,
-roger

