Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbaLJOJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:09:43 -0500
Received: from www.linutronix.de ([62.245.132.108]:53757 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180AbaLJOJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:09:41 -0500
Date: Wed, 10 Dec 2014 15:08:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, yuyang.du@intel.com,
        lkp@01.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Daniel J Blueman <daniel@numascale.com>, subbaram@codeaurora.org,
        Brian Norris <computersforpeace@gmail.com>,
        Slava Pestov <sp@datera.io>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, mpe@ellerman.id.au
Subject: Re: [PATCH] powerpc: secondary CPUs signal to master before setting
 active and online (fixes kernel BUG at kernel/smpboot.c:134!)
In-Reply-To: <CA+55aFyR5PzNkojvEej1NXnpEFOPOYfnxCcPDAjg1rE79tQv7A@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412101427080.13233@nanos>
References: <1418009221-12719-1-git-send-email-anton@samba.org> <20141208083408.GA8023@gmail.com> <20141208211859.6e81ec81@kryten> <20141209105819.0e847b4b@kryten> <CA+55aFyR5PzNkojvEej1NXnpEFOPOYfnxCcPDAjg1rE79tQv7A@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2014, Linus Torvalds wrote:
> On Mon, Dec 8, 2014 at 3:58 PM, Anton Blanchard <anton@samba.org> wrote:
> > Hi Ingo,
> >
> >> At that point I thought the previous task_cpu() was somewhat ingrained
> >> in the scheduler and came up with the patch. If not, we could go on a
> >> hunt to see what else needs fixing.
> >
> > I had another look. The scheduled does indeed make assumptions about the
> > previous task_cpu, but we have a hammer to fix it up called
> > select_fallback_rq.
> >
> > I annotated select_fallback_rq, and did hit a case where the CPU was
> > not active. ppc64 patch below.
> 
> Anton, I'll assume I will get this through the usual powerpc pull requests?
> 
> > I think x86 have a similar (although harder to hit) issue.

Indeed way harder to hit:

CPU 0				CPU 1

    				set_cpu_online(1, true) {
while (!cpu_online(cpu1))	   cpumask_set_cpu(1, to_cpumask(cpu_online_bits));
      relax();

wakeup_thread_on_cpu1();
				   cpumask_set_cpu(1, to_cpumask(cpu_active_bits));

On bare metal probably impossible, but on virt it should be
observable. Fix is simple.

Thanks,

	tglx

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 668d8f2a8781..534f3384f03f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -222,7 +222,6 @@ static void notrace start_secondary(void *unused)
 	lock_vector_lock();
 	set_cpu_online(smp_processor_id(), true);
 	unlock_vector_lock();
-	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	x86_platform.nmi_init();
 
 	/* enable local interrupts */
@@ -234,6 +233,7 @@ static void notrace start_secondary(void *unused)
 	x86_cpuinit.setup_percpu_clockev();
 
 	wmb();
+	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	cpu_startup_entry(CPUHP_ONLINE);
 }
 
@@ -932,7 +932,7 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 	check_tsc_sync_source(cpu);
 	local_irq_restore(flags);
 
-	while (!cpu_online(cpu)) {
+	while (per_cpu(cpu_state,cpu) != CPU_ONLINE) {
 		cpu_relax();
 		touch_nmi_watchdog();
 	}


