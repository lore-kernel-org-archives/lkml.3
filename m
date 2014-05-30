Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbaE3M47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:56:59 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41242 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaE3M45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:56:57 -0400
Message-ID: <53888008.5020108@gmail.com>
Date: Fri, 30 May 2014 14:56:40 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH] ARM: exynos4212: hotplug: Fix CPU idle clock down after
 CPU1 off
References: <1399990378-7023-1-git-send-email-k.kozlowski@samsung.com> <53887095.7090108@gmail.com> <1401453990.11651.2.camel@AMDC1943>
In-Reply-To: <1401453990.11651.2.camel@AMDC1943>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.05.2014 14:46, Krzysztof Kozlowski wrote:
> On pią, 2014-05-30 at 13:50 +0200, Tomasz Figa wrote:
>> Hi Krzysztof,
>>
>> On 13.05.2014 16:12, Krzysztof Kozlowski wrote:
>>> On Exynos4212 USE_DELAYED_RESET_ASSERTION must be set in
>>> ARM_CORE1_OPTION register during CPU power down. This is the proper way
>>> of powering down CPU. Additionally without this the CPU clock down won't
>>> work after powering down CPU1 and CPU will work at full frequency chosen
>>> by CPUfreq governor.
>>>
>>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>>> ---
>>>  arch/arm/mach-exynos/hotplug.c  | 28 +++++++++++++++++++++++++---
>>>  arch/arm/mach-exynos/regs-pmu.h |  2 ++
>>>  2 files changed, 27 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
>>> index 5eead530c6f8..59b813e74558 100644
>>> --- a/arch/arm/mach-exynos/hotplug.c
>>> +++ b/arch/arm/mach-exynos/hotplug.c
>>> @@ -74,7 +74,7 @@ static inline void cpu_enter_lowpower_a15(void)
>>>  	dsb();
>>>  }
>>>  
>>> -static inline void cpu_leave_lowpower(void)
>>> +static inline void cpu_leave_lowpower(unsigned int cpu)
>>>  {
>>>  	unsigned int v;
>>>  
>>> @@ -88,6 +88,14 @@ static inline void cpu_leave_lowpower(void)
>>>  	  : "=&r" (v)
>>>  	  : "Ir" (CR_C), "Ir" (0x40)
>>>  	  : "cc");
>>> +
>>> +	if (cpu == 1 && soc_is_exynos4212()) {
>>
>> AFAIK this is needed not only on Exynos4x12, but at least also on 4412.
>> Also I don't think the (cpu == 1) condition is necessary. See below.
> 
> I'll test it on Exynos4412.
> 
>>
>>> +		unsigned int tmp;
>>> +
>>> +		tmp = __raw_readl(S5P_ARM_CORE1_OPTION);
>>> +		tmp &= ~(S5P_USE_DELAYED_RESET_ASSERTION);
>>> +		__raw_writel(tmp, S5P_ARM_CORE1_OPTION);
>>> +	}
>>>  }
>>>  
>>>  static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
>>> @@ -95,8 +103,22 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
>>>  	for (;;) {
>>>  
>>>  		/* make cpu1 to be turned off at next WFI command */
>>> -		if (cpu == 1)
>>> +		if (cpu == 1) {
>>
>> I think this patch should be rebased on top of my "[PATCH] ARM: EXYNOS:
>> Fix core ID used by platsmp and hotplug code". Then instead of if (cpu
>> == 1) you would just use EXYNOS_ARM_CORE_OPTION(core_id).
>>
>> Also same comment as above, I believe this is also needed on Exynos4412.
> 
> Probably your patch needs rebasing too. I couldn't apply (cleanly) on
> current Linus' tree and on Kukjin's for-next. What are the requirements
> for it?

Hmm, I based it on Kukjin's for-next from the day I sent the patch,
23.05 if I remember correctly. AFAICT everything needed by this patch is
already merged in Kukjin's tree (and I believe already was when I sent
that patch).

To make sure, I'm talking about this patch:
http://www.spinics.net/lists/linux-samsung-soc/msg31604.html

Best regards,
Tomasz
