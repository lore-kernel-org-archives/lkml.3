Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbaD3I3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:29:38 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:33705 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbaD3I3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:29:34 -0400
MIME-Version: 1.0
In-Reply-To: <5360AE05.7020106@samsung.com>
References: <1398232351-16280-1-git-send-email-leela.krishna@linaro.org> <5360AE05.7020106@samsung.com>
From: Leela Krishna Amudala <leela.krishna@linaro.org>
Date: Wed, 30 Apr 2014 13:59:12 +0530
Message-ID: <CAM7CM0mJHWEAaqJ=jMkKXjkxr+XzC+QstSkFzX_g52JvrLUDCA@mail.gmail.com>
Subject: Re: [PATCH V2] ARM: EXYNOS: cpu hotplug: use v7_exit_coherency_flush
 macro for cache disabling
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-pm <linux-pm@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kgene,

Can you please pick this patch to your tree ?

Best Wishes,
Leela Krishna.

On Wed, Apr 30, 2014 at 1:32 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> Hi,
>
> On 04/23/2014 02:52 PM, Leela Krishna Amudala wrote:
>> A common macro v7_exit_coherency_flush available which does the below tasks in
>> the seqeunce.
>> -clearing C bit
>> -clearing L1 cache
>> -exit SMP
>> -instruction and data synchronization
>>
>> So removing the local functions which does the same thing and use the macro instead.
>>
>> Signed-off-by: Leela Krishna Amudala <leela.krishna@linaro.org>
>> Acked-by: Nicolas Pitre <nico@linaro.org>
>> ---
>> Changes since V1:
>>       - removed unwanted primary_part variable in exynos_cpu_die()
>>       - given more description in commit message
>>         suggested by Daniel Lezcano <daniel.lezcano@linaro.org>
>>
>>  arch/arm/mach-exynos/hotplug.c |   63 +---------------------------------------
>>  1 file changed, 1 insertion(+), 62 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
>> index 5eead53..9ca692d 100644
>> --- a/arch/arm/mach-exynos/hotplug.c
>> +++ b/arch/arm/mach-exynos/hotplug.c
>> @@ -24,56 +24,6 @@
>>  #include "common.h"
>>  #include "regs-pmu.h"
>>
>> -static inline void cpu_enter_lowpower_a9(void)
>> -{
>> -     unsigned int v;
>> -
>> -     asm volatile(
>> -     "       mcr     p15, 0, %1, c7, c5, 0\n"
>> -     "       mcr     p15, 0, %1, c7, c10, 4\n"
>> -     /*
>> -      * Turn off coherency
>> -      */
>> -     "       mrc     p15, 0, %0, c1, c0, 1\n"
>> -     "       bic     %0, %0, %3\n"
>> -     "       mcr     p15, 0, %0, c1, c0, 1\n"
>> -     "       mrc     p15, 0, %0, c1, c0, 0\n"
>> -     "       bic     %0, %0, %2\n"
>> -     "       mcr     p15, 0, %0, c1, c0, 0\n"
>> -       : "=&r" (v)
>> -       : "r" (0), "Ir" (CR_C), "Ir" (0x40)
>> -       : "cc");
>> -}
>> -
>> -static inline void cpu_enter_lowpower_a15(void)
>> -{
>> -     unsigned int v;
>> -
>> -     asm volatile(
>> -     "       mrc     p15, 0, %0, c1, c0, 0\n"
>> -     "       bic     %0, %0, %1\n"
>> -     "       mcr     p15, 0, %0, c1, c0, 0\n"
>> -       : "=&r" (v)
>> -       : "Ir" (CR_C)
>> -       : "cc");
>> -
>> -     flush_cache_louis();
>> -
>> -     asm volatile(
>> -     /*
>> -     * Turn off coherency
>> -     */
>> -     "       mrc     p15, 0, %0, c1, c0, 1\n"
>> -     "       bic     %0, %0, %1\n"
>> -     "       mcr     p15, 0, %0, c1, c0, 1\n"
>> -     : "=&r" (v)
>> -     : "Ir" (0x40)
>> -     : "cc");
>> -
>> -     isb();
>> -     dsb();
>> -}
>> -
>>  static inline void cpu_leave_lowpower(void)
>>  {
>>       unsigned int v;
>> @@ -132,19 +82,8 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
>>  void __ref exynos_cpu_die(unsigned int cpu)
>>  {
>>       int spurious = 0;
>> -     int primary_part = 0;
>>
>> -     /*
>> -      * we're ready for shutdown now, so do it.
>> -      * Exynos4 is A9 based while Exynos5 is A15; check the CPU part
>> -      * number by reading the Main ID register and then perform the
>> -      * appropriate sequence for entering low power.
>> -      */
>> -     asm("mrc p15, 0, %0, c0, c0, 0" : "=r"(primary_part) : : "cc");
>> -     if ((primary_part & 0xfff0) == 0xc0f0)
>> -             cpu_enter_lowpower_a15();
>> -     else
>> -             cpu_enter_lowpower_a9();
>> +     v7_exit_coherency_flush(louis);
>>
>>       platform_do_lowpower(cpu, &spurious);
>>
>>
>
> I tested this patch on Exynos3250 based on Cortex-A7 dual core.
>
> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
>
> Thanks,
> Chanwoo Choi
>
