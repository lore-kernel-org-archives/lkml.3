Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaDWFpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:45:00 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:59487 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaDWFo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:44:57 -0400
MIME-Version: 1.0
In-Reply-To: <53567E72.1030201@linaro.org>
References: <1398176280-7258-1-git-send-email-leela.krishna@linaro.org> <53567E72.1030201@linaro.org>
From: Leela Krishna Amudala <leela.krishna@linaro.org>
Date: Wed, 23 Apr 2014 11:14:36 +0530
Message-ID: <CAM7CM0=zVH-zvcAFAnmSWYL3F=ZUZJL0iGp5mRFKmxt-n+i=3w@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: cpu hotplug: use v7_exit_coherency_flush
 macro for cache disabling
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm <linux-pm@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "kgene.kim" <kgene.kim@samsung.com>,
        Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Thanks for reviewing the patch.

On Tue, Apr 22, 2014 at 8:06 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 04/22/2014 04:18 PM, Leela Krishna Amudala wrote:
>>
>> Remove the duplicated code for cache disabling and use
>> "v7_exit_coherency_flush"
>> macro to do the same job.
>
>
> Hi Leela,
>
> thanks for this patch! It would be nice if you can describe why those macros
> can be replaced by the generic v7_exit_coherency_flush macro.
>

Okay, will give the description in commit message

>
>>
>> Signed-off-by: Leela Krishna Amudala <leela.krishna@linaro.org>
>>
>> ---
>> cpu hotplug is tested with 3.15-rc1 on Origen(which has cortex A9) and
>> Arndale octa(which has cortex A7 and A15) boards.
>>
>>   arch/arm/mach-exynos/hotplug.c |   56
>> ++--------------------------------------
>>   1 file changed, 2 insertions(+), 54 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/hotplug.c
>> b/arch/arm/mach-exynos/hotplug.c
>> index 5eead53..9eb8d1b 100644
>> --- a/arch/arm/mach-exynos/hotplug.c
>> +++ b/arch/arm/mach-exynos/hotplug.c
>> @@ -24,56 +24,6 @@
>>   #include "common.h"
>>   #include "regs-pmu.h"
>>
>> -static inline void cpu_enter_lowpower_a9(void)
>> -{
>> -       unsigned int v;
>> -
>> -       asm volatile(
>> -       "       mcr     p15, 0, %1, c7, c5, 0\n"
>> -       "       mcr     p15, 0, %1, c7, c10, 4\n"
>> -       /*
>> -        * Turn off coherency
>> -        */
>> -       "       mrc     p15, 0, %0, c1, c0, 1\n"
>> -       "       bic     %0, %0, %3\n"
>> -       "       mcr     p15, 0, %0, c1, c0, 1\n"
>> -       "       mrc     p15, 0, %0, c1, c0, 0\n"
>> -       "       bic     %0, %0, %2\n"
>> -       "       mcr     p15, 0, %0, c1, c0, 0\n"
>> -         : "=&r" (v)
>> -         : "r" (0), "Ir" (CR_C), "Ir" (0x40)
>> -         : "cc");
>> -}
>> -
>> -static inline void cpu_enter_lowpower_a15(void)
>> -{
>> -       unsigned int v;
>> -
>> -       asm volatile(
>> -       "       mrc     p15, 0, %0, c1, c0, 0\n"
>> -       "       bic     %0, %0, %1\n"
>> -       "       mcr     p15, 0, %0, c1, c0, 0\n"
>> -         : "=&r" (v)
>> -         : "Ir" (CR_C)
>> -         : "cc");
>> -
>> -       flush_cache_louis();
>> -
>> -       asm volatile(
>> -       /*
>> -       * Turn off coherency
>> -       */
>> -       "       mrc     p15, 0, %0, c1, c0, 1\n"
>> -       "       bic     %0, %0, %1\n"
>> -       "       mcr     p15, 0, %0, c1, c0, 1\n"
>> -       : "=&r" (v)
>> -       : "Ir" (0x40)
>> -       : "cc");
>> -
>> -       isb();
>> -       dsb();
>> -}
>> -
>>   static inline void cpu_leave_lowpower(void)
>>   {
>>         unsigned int v;
>> @@ -141,10 +91,8 @@ void __ref exynos_cpu_die(unsigned int cpu)
>>          * appropriate sequence for entering low power.
>>          */
>>         asm("mrc p15, 0, %0, c0, c0, 0" : "=r"(primary_part) : : "cc");
>
>
> Can't you remove this asm line above as well as the primary_part variable ?

Didn't notice it, will remove this.

>
>
>> -       if ((primary_part & 0xfff0) == 0xc0f0)
>> -               cpu_enter_lowpower_a15();
>> -       else
>> -               cpu_enter_lowpower_a9();
>> +
>> +       v7_exit_coherency_flush(louis);
>>
>>         platform_do_lowpower(cpu, &spurious);
>>
>>
>
>
> --
>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>
