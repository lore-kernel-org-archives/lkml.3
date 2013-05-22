Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab3EVAjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 20:39:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3EVAja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 20:39:30 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=RIr-MpdgGL4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ECGzpTKyZd4A:10 a=VPW9pYw8AAAA:8 a=D19gQVrFAAAA:8 a=OLL_FvSJAAAA:8 a=C_NXJBhpAAAA:8 a=Woz1Frsghjb9lkq_kJwA:9 a=QEXdDO2ut3YA:10 a=Wl2VdSxwYFAA:10 a=uGZG98Jh4UMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369183168.6828.168.camel@gandalf.local.home>
Subject: Re: [PATCH - sort of] x86: Livelock in handle_pte_fault
From: Steven Rostedt <rostedt@goodmis.org>
To: Stanislav Meduna <stano@meduna.org>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        riel <riel@redhat.com>
Date: Tue, 21 May 2013 20:39:28 -0400
In-Reply-To: <5195ED8B.7060002@meduna.org>
References: <5195ED8B.7060002@meduna.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-17 at 10:42 +0200, Stanislav Meduna wrote:
> Hi all,
> 
> I don't know whether this is linux-rt specific or applies to
> the mainline too, so I'll repeat some things the linux-rt
> readers already know.
> 
> Environment:
> 
> - Geode LX or Celeron M
> - _not_ CONFIG_SMP
> - linux 3.4 with realtime patches and full preempt configured
> - an application consisting of several mostly RR-class threads

The threads do a mlockall too right? I'm not sure mlock will lock memory
for a new thread's stack.

> - the application runs with mlockall()

With both MCL_FUTURE and MCL_CURRENT set, right?

> - there is no swap

Hmm, doesn't mean that code can't be swapped out, as it is just mapped
from the file it came from. But you'd think mlockall would prevent that.

> 
> Problem:
> 
> - after several hours to 1-2 weeks some of the threads start to loop
>   in the following way
> 
>   0d...0 62811.755382: function:  do_page_fault
>   0....0 62811.755386: function:     handle_mm_fault
>   0....0 62811.755389: function:        handle_pte_fault
>   0d...0 62811.755394: function:  do_page_fault
>   0....0 62811.755396: function:     handle_mm_fault
>   0....0 62811.755398: function:        handle_pte_fault
>   0d...0 62811.755402: function:  do_page_fault
>   0....0 62811.755404: function:     handle_mm_fault
>   0....0 62811.755406: function:        handle_pte_fault
> 
>   and stay in the loop until the RT throttling gets activated.
>   One of the faulting addresses was in code (after returning
>   from a syscall), a second one in stack (inside put_user right
>   before a syscall ends), both were surely mapped.
> 
> - After RT throttler activates it somehow magically fixes itself,
>   probably (not verified) because another _process_ gets scheduled.
>   When throttled the RR and FF threads are not allowed to run for
>   a while (20 ms in my configuration). The livelocks lasts around
>   1-3 seconds, and there is a SCHED_OTHER process that runs each
>   2 seconds.

Hmm, if there was a missed TLB flush, and we are faulting due to a bad
TLB table, and it goes into an infinite faulting loop, the only thing
that will stop it is the RT throttle. Then a new task gets scheduled,
and we flush the TLB and everything is fine again.

> 
> - Kernel threads with higher priority than the faulting one (linux-rt
>   irq threads) run normally. A higher priority user thread from the
>   same process gets scheduled and then enters the same faulting loop.

Kernel threads share the mm, and wont cause a reload of the CR3.

> 
> - in ps -o min_flt,maj_flt the number of minor page faults
>   for the offending thread skyrockets to hundreds of thousands
>   (normally it stays zero as everything is already mapped
>   when it is started)
> 
> - The code in handle_pte_fault proceeds through the
>     entry = pte_mkyoung(entry);
>   line and the following
>     ptep_set_access_flags
>   returns zero.
> 
> - The livelock is extremely timing sensitive - different workloads
>   cause it not to happen at all or far later.
> 
> - I was able to make this happen a bit faster (once per ~4 hours)
>   with the rt thread repeatly causing the kernel to try to
>   invoke modprobe to load a missing module - so there is a load
>   of kworker-s launching modprobes (in case anyone wonders how it
>   can happen: this was a bug in our application with invalid level
>   specified for setsockopt causing searching for TCP congestion
>   module instead of setting SO_LINGER)

Note, that modules are in vmalloc space, and do fault in. But it also
changes the PGD.

> 
> - the symptoms are similar to
>     http://lkml.indiana.edu/hypermail/linux/kernel/1103.0/01364.html
>   which got fixed by
>     https://lkml.org/lkml/2011/3/15/516
>   but this fix does not apply to the processors in question
> 
> - the patch below _seems_ to fix it, or at least massively delay it -
>   the testcase now runs for 2.5 days instead of 4 hours. I doubt
>   it is the proper patch (it brutally reloads the CR3 every time
>   a thread with userspace mapping is switched to). I just got the
>   suspicion that there is some way the kernel forgets to update
>   the memory mapping when going from an userpace thread through
>   some kernel ones back to another userspace one and tried to make
>   sure the mapping is always reloaded.

Seems a bit extreme. Looks to me there's a missing flush TLB somewhere.

Do you have a reproducer you can share. That way, maybe we can all share
the joy.

-- Steve

> 
> - the whole history starts at
>     http://www.spinics.net/lists/linux-rt-users/msg09758.html
>   I originally thought the problem is in timerfd and hunted it
>   in several places until I learned to use the tracing infrastructure
>   and started to pin it down with trace prints etc :)
> 
> - A trace file of the hang is at
>   http://www.meduna.org/tmp/trace.mmfaulthang.dat.gz
> 
> Does this ring a bell with someone?
> 
> Thanks
>                                               Stano
> 
> 
> 
> 
> diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
> index 6902152..3d54a15 100644
> --- a/arch/x86/include/asm/mmu_context.h
> +++ b/arch/x86/include/asm/mmu_context.h
> @@ -54,21 +54,23 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
>  		if (unlikely(prev->context.ldt != next->context.ldt))
>  			load_LDT_nolock(&next->context);
>  	}
> -#ifdef CONFIG_SMP
>  	else {
> +#ifdef CONFIG_SMP
>  		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
>  		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);
> 
>  		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
> +#endif
>  			/* We were in lazy tlb mode and leave_mm disabled
>  			 * tlb flush IPI delivery. We must reload CR3
>  			 * to make sure to use no freed page tables.
>  			 */
>  			load_cr3(next->pgd);
>  			load_LDT_nolock(&next->context);
> +#ifdef CONFIG_SMP
>  		}
> -	}
>  #endif
> +	}
>  }
> 
>  #define activate_mm(prev, next)


