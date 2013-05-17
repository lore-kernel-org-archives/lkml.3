Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3EQJ0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:26:06 -0400
Received: from www.meduna.org ([92.240.244.38]:58694 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab3EQJ0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:26:04 -0400
X-Greylist: delayed 2565 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 May 2013 05:26:03 EDT
Message-ID: <5195ED8B.7060002@meduna.org>
Date: Fri, 17 May 2013 10:42:51 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH - sort of] x86: Livelock in handle_pte_fault
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2013-05-17 10:43:12
X-Connected-IP: 95.105.165.4:9358
X-Message-Linecount: 146
X-Body-Linecount: 131
X-Message-Size: 5440
X-Body-Size: 4762
X-Received-Count: 1
X-Recipient-Count: 7
X-Local-Recipient-Count: 7
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I don't know whether this is linux-rt specific or applies to
the mainline too, so I'll repeat some things the linux-rt
readers already know.

Environment:

- Geode LX or Celeron M
- _not_ CONFIG_SMP
- linux 3.4 with realtime patches and full preempt configured
- an application consisting of several mostly RR-class threads
- the application runs with mlockall()
- there is no swap

Problem:

- after several hours to 1-2 weeks some of the threads start to loop
  in the following way

  0d...0 62811.755382: function:  do_page_fault
  0....0 62811.755386: function:     handle_mm_fault
  0....0 62811.755389: function:        handle_pte_fault
  0d...0 62811.755394: function:  do_page_fault
  0....0 62811.755396: function:     handle_mm_fault
  0....0 62811.755398: function:        handle_pte_fault
  0d...0 62811.755402: function:  do_page_fault
  0....0 62811.755404: function:     handle_mm_fault
  0....0 62811.755406: function:        handle_pte_fault

  and stay in the loop until the RT throttling gets activated.
  One of the faulting addresses was in code (after returning
  from a syscall), a second one in stack (inside put_user right
  before a syscall ends), both were surely mapped.

- After RT throttler activates it somehow magically fixes itself,
  probably (not verified) because another _process_ gets scheduled.
  When throttled the RR and FF threads are not allowed to run for
  a while (20 ms in my configuration). The livelocks lasts around
  1-3 seconds, and there is a SCHED_OTHER process that runs each
  2 seconds.

- Kernel threads with higher priority than the faulting one (linux-rt
  irq threads) run normally. A higher priority user thread from the
  same process gets scheduled and then enters the same faulting loop.

- in ps -o min_flt,maj_flt the number of minor page faults
  for the offending thread skyrockets to hundreds of thousands
  (normally it stays zero as everything is already mapped
  when it is started)

- The code in handle_pte_fault proceeds through the
    entry = pte_mkyoung(entry);
  line and the following
    ptep_set_access_flags
  returns zero.

- The livelock is extremely timing sensitive - different workloads
  cause it not to happen at all or far later.

- I was able to make this happen a bit faster (once per ~4 hours)
  with the rt thread repeatly causing the kernel to try to
  invoke modprobe to load a missing module - so there is a load
  of kworker-s launching modprobes (in case anyone wonders how it
  can happen: this was a bug in our application with invalid level
  specified for setsockopt causing searching for TCP congestion
  module instead of setting SO_LINGER)

- the symptoms are similar to
    http://lkml.indiana.edu/hypermail/linux/kernel/1103.0/01364.html
  which got fixed by
    https://lkml.org/lkml/2011/3/15/516
  but this fix does not apply to the processors in question

- the patch below _seems_ to fix it, or at least massively delay it -
  the testcase now runs for 2.5 days instead of 4 hours. I doubt
  it is the proper patch (it brutally reloads the CR3 every time
  a thread with userspace mapping is switched to). I just got the
  suspicion that there is some way the kernel forgets to update
  the memory mapping when going from an userpace thread through
  some kernel ones back to another userspace one and tried to make
  sure the mapping is always reloaded.

- the whole history starts at
    http://www.spinics.net/lists/linux-rt-users/msg09758.html
  I originally thought the problem is in timerfd and hunted it
  in several places until I learned to use the tracing infrastructure
  and started to pin it down with trace prints etc :)

- A trace file of the hang is at
  http://www.meduna.org/tmp/trace.mmfaulthang.dat.gz

Does this ring a bell with someone?

Thanks
                                              Stano




diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 6902152..3d54a15 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -54,21 +54,23 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		if (unlikely(prev->context.ldt != next->context.ldt))
 			load_LDT_nolock(&next->context);
 	}
-#ifdef CONFIG_SMP
 	else {
+#ifdef CONFIG_SMP
 		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
 		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);

 		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
+#endif
 			/* We were in lazy tlb mode and leave_mm disabled
 			 * tlb flush IPI delivery. We must reload CR3
 			 * to make sure to use no freed page tables.
 			 */
 			load_cr3(next->pgd);
 			load_LDT_nolock(&next->context);
+#ifdef CONFIG_SMP
 		}
-	}
 #endif
+	}
 }

 #define activate_mm(prev, next)

