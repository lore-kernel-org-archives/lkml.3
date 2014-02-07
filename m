Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaBGFa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:30:56 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43955 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaBGFax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:30:53 -0500
Message-ID: <52F46EB3.5080403@linux.vnet.ibm.com>
Date: Fri, 07 Feb 2014 10:57:15 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] PPC: powernv: remove redundant cpuidle_idle_call()
References: <1391696188-14540-1-git-send-email-nicolas.pitre@linaro.org> <CAKnoXLxCAqKaniGOwegNcOarS4FpoNKDY5PxOhe6j4wdtUAkLQ@mail.gmail.com> <52F3BCFE.3010703@linux.vnet.ibm.com> <alpine.LFD.2.11.1402070105170.1906@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1402070105170.1906@knanqh.ubzr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020705-2000-0000-0000-00000F9CF934
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On 02/07/2014 06:47 AM, Nicolas Pitre wrote:
> On Thu, 6 Feb 2014, Preeti U Murthy wrote:
> 
>> Hi Daniel,
>>
>> On 02/06/2014 09:55 PM, Daniel Lezcano wrote:
>>> Hi Nico,
>>>
>>>
>>> On 6 February 2014 14:16, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>>>
>>>> The core idle loop now takes care of it.
>>>>
>>>> Signed-off-by: Nicolas Pitre <nico@linaro.org>
>>>> ---
>>>>  arch/powerpc/platforms/powernv/setup.c | 13 +------------
>>>>  1 file changed, 1 insertion(+), 12 deletions(-)
>>>>
>>>> diff --git a/arch/powerpc/platforms/powernv/setup.c
>>>> b/arch/powerpc/platforms/powernv/setup.c
>>>> index 21166f65c9..a932feb290 100644
>>>> --- a/arch/powerpc/platforms/powernv/setup.c
>>>> +++ b/arch/powerpc/platforms/powernv/setup.c
>>>> @@ -26,7 +26,6 @@
>>>>  #include <linux/of_fdt.h>
>>>>  #include <linux/interrupt.h>
>>>>  #include <linux/bug.h>
>>>> -#include <linux/cpuidle.h>
>>>>
>>>>  #include <asm/machdep.h>
>>>>  #include <asm/firmware.h>
>>>> @@ -217,16 +216,6 @@ static int __init pnv_probe(void)
>>>>         return 1;
>>>>  }
>>>>
>>>> -void powernv_idle(void)
>>>> -{
>>>> -       /* Hook to cpuidle framework if available, else
>>>> -        * call on default platform idle code
>>>> -        */
>>>> -       if (cpuidle_idle_call()) {
>>>> -               power7_idle();
>>>> -       }
>>>>
>>>
>>> The cpuidle_idle_call is called from arch_cpu_idle in
>>> arch/powerpc/kernel/idle.c between a ppc64_runlatch_off|on section.
>>> Shouldn't the cpuidle-powernv driver call these functions when entering
>>> idle ?
>>
>> Yes they should, I will send out a patch that does that ontop of this.
>> There have been cpuidle driver cleanups for powernv and pseries in this
>> merge window. While no change would be required in the pseries cpuidle
>> driver as a result of Nicolas's cleanup, we would need to add the
>> ppc64_runlatch_on and off functions before and after the entry into the
>> powernv idle states.
> 
> What about creating arch_cpu_idle_enter() and arch_cpu_idle_exit() in 
> arch/powerpc/kernel/idle.c and calling ppc64_runlatch_off() and 
> ppc64_runlatch_on() respectively from there instead?  Would that work?  
> That would make the idle consolidation much easier afterwards.

I would not suggest doing this. The ppc64_runlatch_*() routines need to
be called when we are sure that the cpu is about to enter or has exit an
idle state. Moving the ppc64_runlatch_on() routine to
arch_cpu_idle_enter() for instance is not a good idea because there are
places where the cpu can decide not to enter any idle state before the
call to cpuidle_idle_call() itself. In that case communicating
prematurely that we are in an idle state would not be a good idea.

So its best to add the ppc64_runlatch_* calls in the powernv cpuidle
driver IMO. We could however create idle_loop_prologue/epilogue()
variants inside it so that in addition to the runlatch routines we could
potentially add more such similar routines that are powernv specific.
  If there are cases where there is work to be done prior to and post an
entry into an idle state common to both pseries and powernv, we will
probably put them in arch_cpu_idle_enter/exit(). But the runlatch
routines are not suitable to be moved there as far as I can see.

Thank you

Regards
Preeti U Murthy
> 
> 
> Nicolas
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 

