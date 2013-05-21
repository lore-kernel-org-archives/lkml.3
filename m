Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3EUImN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:42:13 -0400
Received: from intranet.asianux.com ([58.214.24.6]:61977 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3EUImK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:42:10 -0400
X-Spam-Score: -100.8
Message-ID: <519B332F.1000404@asianux.com>
Date: Tue, 21 May 2013 16:41:19 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: kernel: compiling issue, need 'EXPORT_SYMBOL_GPL(read_current_timer)'
References: <5199C725.8050102@asianux.com> <168084c28e8ba5124c05553e97463172@localhost> <20130520095606.GH31359@mudshark.cambridge.arm.com> <519AF2DC.2040200@asianux.com> <5bf8a8dd20ecd01c14f0ed9aa054f2df@localhost>
In-Reply-To: <5bf8a8dd20ecd01c14f0ed9aa054f2df@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 02:13 PM, Marc Zyngier wrote:
> On Tue, 21 May 2013 12:06:52 +0800, Chen Gang <gang.chen@asianux.com>
> wrote:
>> On 05/20/2013 05:56 PM, Will Deacon wrote:
>>> On Mon, May 20, 2013 at 08:15:04AM +0100, Marc Zyngier wrote:
>>>> On Mon, 20 May 2013 14:48:05 +0800, Chen Gang <gang.chen@asianux.com>
>>>> wrote:
>>>>> Need 'EXPORT_SYMBOL_GPL(read_current_timer)' if build with
>>>>> allmodconfig.
>>>>>
>>>>> The related error:
>>>>>   ERROR: "read_current_timer" [lib/rbtree_test.ko] undefined!
>>>>>   ERROR: "read_current_timer" [lib/interval_tree_test.ko] undefined!
>>>>>   ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined!
>>>>>   ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!
>>>>>
>>>>>
>>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>>> ---
>>>>>  arch/arm64/kernel/time.c |    1 +
>>>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
>>>>> index a551f88..7fcba80 100644
>>>>> --- a/arch/arm64/kernel/time.c
>>>>> +++ b/arch/arm64/kernel/time.c
>>>>> @@ -73,6 +73,7 @@ int read_current_timer(unsigned long *timer_value)
>>>>>  	*timer_value = arch_timer_read_counter();
>>>>>  	return 0;
>>>>>  }
>>>>> +EXPORT_SYMBOL_GPL(read_current_timer);
>>>>>  
>>>>>  void __init time_init(void)
>>>>>  {
>>>>
>>>> While this solves the problem, I'm not sure this is the best fix. The
>>>> real
>>>> issue is with get_cycles, which is a macro around read_current_timer.
>>>>
>>>> AArch32 exports it because of the number of timer implementations. On
>>>> arm64, we should be able to just return CNTVCT_EL0.
>>>>
>>>> Catalin, Will, what do you think?
>>>
>>> Should be ok once the arch timer driver has moved exclusively to
> virtual
>>> time. I'm also not sure we even need to implement read_current_timer()
> --
>>> it's only used for delay-loop calibration, which we don't need for the
>>> arch timer.
>>>
>>
>> For whether we need implement read_current_timer():
>>
>>   many platforms have implemented it (openrisc, arm, sparc, hexagon,
>>   avr32, x86).
>>   it is called by init/calibrate.c when 'ARCH_HAS_READ_CURRENT_TIMER' is
>>   defined.
>>   since arm64 can implement it, better to provide it as an architect
>>   features to let outside use.
> 
> Nobody disputes the interest of read_current_timer.
> 

It is for Will said "I'm also not sure we even need to implement
read_current_timer()".

I think we still need it.


>> For the implementation of read_current_timer():
>>
>>   it has to face various configurations
>>     (e.g. CONFIG_ARM_ARCH_TIMER, arch_timer_read_zero,
>>     arch_counter_get_cntvct, arch_counter_get_cntpct)
>>   so better still use variable instead of.
>>     (excuse me, I do not know what is 'CNTVCT_EL0', is it like a
> constant
>>     number ?)
> 
> Architected timer is mandatory on arm64, so we can always rely on it it be
> present. CNTVCT_EL0 is the system register accessing the Virtual Counter,
> which is basically what read_current_timer() returns.
> 

OK, thanks. for CNTVCT_EL0, can we use arch_counter_get_cntvct() which
is defined in "arch/arm64/include/asm/arch_timer.h" ?


>> For the implementation of get_cycles()
>>
>>   if read_current_timer() is provided,
>>   better to let get_cycles() to call it, instead of implement once
> again.
> 
> There is certainly some value in reusing existing code, but in this
> particular case we can simply inline two instructions (isb + mrs
> cntvct_el0), and I'm not even completely sure about the isb.
> 

OK, thanks.


So, how about the fix below :)

------------------------diff begin-------------------------------

diff --git a/arch/arm64/include/asm/timex.h b/arch/arm64/include/asm/timex.h
index b24a31a..768ba44 100644
--- a/arch/arm64/include/asm/timex.h
+++ b/arch/arm64/include/asm/timex.h
@@ -16,11 +16,13 @@
 #ifndef __ASM_TIMEX_H
 #define __ASM_TIMEX_H
 
+#include <asm/arch_timer.h>
+
 /*
  * Use the current timer as a cycle counter since this is what we use for
  * the delay loop.
  */
-#define get_cycles()	({ cycles_t c; read_current_timer(&c); c; })
+#define get_cycles()	arch_counter_get_cntvct()
 
 #include <asm-generic/timex.h>
 
diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index a551f88..6d7ce08 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -38,6 +38,7 @@
 
 #include <asm/thread_info.h>
 #include <asm/stacktrace.h>
+#include <asm/arch_timer.h>
 
 #ifdef CONFIG_SMP
 unsigned long profile_pc(struct pt_regs *regs)
@@ -70,7 +71,7 @@ unsigned long long notrace sched_clock(void)
 
 int read_current_timer(unsigned long *timer_value)
 {
-	*timer_value = arch_timer_read_counter();
+	*timer_value = arch_counter_get_cntvct();
 	return 0;
 }


------------------------diff end---------------------------------

-- 
Chen Gang

Asianux Corporation
