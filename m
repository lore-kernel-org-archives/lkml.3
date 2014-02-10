Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaBJNdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:33:38 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:56303 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729AbaBJNdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:33:35 -0500
Message-ID: <52F8D503.1080600@st.com>
Date: Mon, 10 Feb 2014 14:32:51 +0100
From: Fabrice Gasnier <fabrice.gasnier@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "vgupta@synopsys.com" <vgupta@synopsys.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxime.coquelin@st.com" <maxime.coquelin@st.com>
Subject: Re: [RFC PATCH] ARM: Add imprecise abort enable/disable macro
References: <1391789955-26927-1-git-send-email-fabrice.gasnier@st.com> <1391789955-26927-2-git-send-email-fabrice.gasnier@st.com> <20140207170903.GT5976@mudshark.cambridge.arm.com> <52F892C8.80508@st.com> <52F89522.6030302@codethink.co.uk>
In-Reply-To: <52F89522.6030302@codethink.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 10:00 AM, Ben Dooks wrote:
> On 10/02/14 08:50, Fabrice Gasnier wrote:
>> On 02/07/2014 06:09 PM, Will Deacon wrote:
>>> On Fri, Feb 07, 2014 at 04:19:15PM +0000, Fabrice GASNIER wrote:
>>>> This patch adds imprecise abort enable/disable macros.
>>>> It also enables imprecise aborts when starting kernel.
>>>>
>>>> Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
>>>> ---
>>>>   arch/arm/include/asm/irqflags.h |   33
>>>> +++++++++++++++++++++++++++++++++
>>>>   arch/arm/kernel/smp.c           |    1 +
>>>>   arch/arm/kernel/traps.c         |    4 ++++
>>>>   3 files changed, 38 insertions(+)
>>>>
>>>> diff --git a/arch/arm/include/asm/irqflags.h
>>>> b/arch/arm/include/asm/irqflags.h
>>>> index 3b763d6..82e3834 100644
>>>> --- a/arch/arm/include/asm/irqflags.h
>>>> +++ b/arch/arm/include/asm/irqflags.h
>>>> @@ -51,6 +51,9 @@ static inline void arch_local_irq_disable(void)
>>>>   #define local_fiq_enable()  __asm__("cpsie f    @ __stf" : : :
>>>> "memory", "cc")
>>>>   #define local_fiq_disable() __asm__("cpsid f    @ __clf" : : :
>>>> "memory", "cc")
>>>> +
>>>> +#define local_abt_enable()  __asm__("cpsie a    @ __sta" : : :
>>>> "memory", "cc")
>>>> +#define local_abt_disable() __asm__("cpsid a    @ __cla" : : :
>>>> "memory", "cc")
>>>>   #else
>>>>   /*
>>>> @@ -130,6 +133,36 @@ static inline void arch_local_irq_disable(void)
>>>>       : "memory", "cc");                    \
>>>>       })
>>>> +/*
>>>> + * Enable Aborts
>>>> + */
>>>> +#define local_abt_enable()                    \
>>>> +    ({                            \
>>>> +        unsigned long temp;                \
>>>> +    __asm__ __volatile__(                    \
>>>> +    "mrs    %0, cpsr        @ sta\n"        \
>>>> +"    bic    %0, %0, %1\n"                    \
>>>> +"    msr    cpsr_c, %0"                    \
>>>> +    : "=r" (temp)                        \
>>>> +    : "r" (PSR_A_BIT)                    \
>>> Can you use "i" instead of a register for this constant?
>> Hi,
>>
>> Sure, I will change it in a future patch.
>>>
>>>> +    : "memory", "cc");                    \
>>> You don't need the "cc" clobber.
>> That surprises me: I think "orr" and "bic" instruction might change N
>> and Z bits, depending on the result.
>> So shouldn't "cc" be placed here ?
>> I also see that it is used in local_fiq_enable/disable macros just
>> above, that are similar:
>
> No, only if they have the S flag set on the instruction (ORRS,BICS)
>
>
Thank you for pointing that out!


