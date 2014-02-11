Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaBKTqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:46:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41799 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbaBKTqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:46:10 -0500
Date: Tue, 11 Feb 2014 20:45:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: Another preempt folding issue?
Message-ID: <20140211194553.GZ9987@twins.programming.kicks-ass.net>
References: <52FA6D4B.7020709@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FA6D4B.7020709@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 07:34:51PM +0100, Stefan Bader wrote:
> Hi Peter,
> 
> I am currently looking at a weird issue that manifest itself when trying to run
> kvm enabled qemu on a i386 host (v3.13 kernel, oh and potentially important the
> cpu is 64bit capable, so qemu-system-x86_64 is called). 

AMD or Intel machine?

> Sooner or later this
> causes softlockup messages on the host. I tracked this down to __vcpu_run in
> arch/x86/kvm/x86.c which does a loop which in that case never seems to make
> progress or exit.
> 
> What I found is that vcpu_enter_guest will exit quickly without causing the loop
> to exit when need_resched() is true. Looking at a crash dump I took, this was
> the case (thread_info->flags had TIF_NEED_RESCHED set). So after immediately
> returning __vcpu_run has the following code:
> 
>         if (need_resched()) {
>                 srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>                 kvm_resched(vcpu); // now cond_resched();
>                 vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>         }
> 
> The kvm_resched basically would end up doing a cond_resched() which now checks
> preempt_count() to be 0. If that is zero it will do the reschedule, otherwise it
> just does nothing. Looking at the percpu variables in the dump, I saw that
> the preempt_count was 0x8000000 (actually it was 0x80110000 but that was me
> triggering the kexec crashdump with sysrq-c).
> 
> I saw that there have been some changes in the upstream kernel and have picked
> the following:
> 1) x86, acpi, idle: Restructure the mwait idle routines
> 2) x86, idle: Use static_cpu_has() for CLFLUSH workaround, add barriers
> 3) sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding
> 4) sched/preempt/x86: Fix voluntary preempt for x86
> 
> Patch 1) and 2) as dependencies of 3) (to get the mwait function correct and to
> the other file). Finally 4) is fixing up 3). [maybe worth suggesting to do for
> 3.13.y stable].
> 
> Still, with all those I got the softlockup. Since I knew from the dump info that
> something is wrong with the folding, I made the pragmatic approach and added the
> following:
> 
>         if (need_resched()) {
>                 srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
> +               preempt_fold_need_resched();
>                 kvm_resched(vcpu); // now cond_resched();
>                 vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>         }
> 
> And this lets the kvm guest run without the softlockups! However I am less than
> convinced that this is the right thing to do. Somehow something done when
> converting the preempt_count into percpu has caused at least the i386 side to
> get into this mess (as there has not been any whining about 64bit). Just fail to
> see what.

I've been looking at the same thing too; I've got a trace from someone
who can reproduce and its just not making sense.

Looks like the hardware is loosing an interrupt (or worse).

With the below patch on top of current -git (might be whitespace damaged
due to copy-paste).

---
 arch/x86/kvm/x86.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 39c28f09dfd5..f8b2fc7ce491 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6115,7 +6115,11 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
                }
                if (need_resched()) {
                        srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
-                       cond_resched();
+                       if (need_resched() != should_resched()) {
+                               tracing_stop();
+                               printk(KERN_ERR "Stopped tracing, due to inconsistent state.\n");
+                       }
+                       schedule();
                        vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
                }
        }

---

I got the following from an Athlon X2 (fam 0xf):

On Mon, Feb 10, 2014 at 05:23:15PM -0200, Marcelo Tosatti wrote:
> What is the problem exactly?

>From the trace:

 qemu-system-x86-2455  [001] d.s3   393.630586: smp_reschedule_interrupt <-reschedule_interrupt
 qemu-system-x86-2455  [001] d.s3   393.630586: scheduler_ipi <-smp_reschedule_interrupt
 qemu-system-x86-2455  [001] ..s3   393.630586: preempt_count_sub <-_raw_spin_unlock_irqrestore
 qemu-system-x86-2455  [001] ..s2   393.630586: _raw_spin_lock_irq <-run_timer_softirq
 qemu-system-x86-2455  [001] d.s2   393.630586: preempt_count_add <-_raw_spin_lock_irq
 qemu-system-x86-2455  [001] d.s3   393.630586: _raw_spin_unlock_irq <-run_timer_softirq
 qemu-system-x86-2455  [001] ..s3   393.630586: preempt_count_sub <-_raw_spin_unlock_irq
 qemu-system-x86-2455  [001] ..s2   393.630586: rcu_bh_qs <-__do_softirq
 qemu-system-x86-2455  [001] d.s2   393.630586: irqtime_account_irq <-__do_softirq
 qemu-system-x86-2455  [001] d.s2   393.630586: __local_bh_enable <-__do_softirq
 qemu-system-x86-2455  [001] d.s2   393.630586: preempt_count_sub <-__local_bh_enable


           dmesg-2458  [000] d.s5   393.630614: resched_task <-check_preempt_wakeup
           dmesg-2458  [000] d.s5   393.630614: native_smp_send_reschedule <-resched_task
           dmesg-2458  [000] d.s5   393.630614: default_send_IPI_mask_logical <-native_smp_send_reschedule


 qemu-system-x86-2455  [001] .n..   393.630636: preempt_count_add <-kmap_atomic_prot
 qemu-system-x86-2455  [001] .n.1   393.630639: __kunmap_atomic <-clear_huge_page
 qemu-system-x86-2455  [001] .n.1   393.630639: preempt_count_sub <-__kunmap_atomic
 qemu-system-x86-2455  [001] .n..   393.630639: _cond_resched <-clear_huge_page
 qemu-system-x86-2455  [001] .n..   393.630640: kmap_atomic <-clear_huge_page
 qemu-system-x86-2455  [001] .n..   393.630640: kmap_atomic_prot <-kmap_atomic
 qemu-system-x86-2455  [001] .n..   393.630640: preempt_count_add <-kmap_atomic_prot


The resched_task() in the middle does:

  set_tsk_need_resched();
  smp_mb();
  smp_send_reschedule();

This means that the remote cpu must observe TIF_NEED_RESCHED (.n.. in
the traces) when the IPI (smp_reschedule_interrupt) hits.

Now given the machine has unsynchronized TSC the order in the above is
not necessarily the true order, but there's only two possible scenarios:

1) its the right order; the smp_reschedule_interrupt() is from a
 previous resched_task()/rcu kick or any of the other users that sends
 it.

 In which case we should get another smp_reschedule_interrupt() _after_
 the resched_task() which should observe the 'n' and promote it to an
 'N'.

 This doesn't happen and we're stuck with the 'n' state..

2) its the wrong order and the smp_reschedule_interrupt() actually
 happened after the resched_task(), but in that case we should have
 observed the 'n', we did not.

Now given that 2) would mean a bug in the coherency fabric and 1) would
mean a lost interrupt, 1 seems like the more likely suspect.

Joerg wanted the extra kvm tracepoints to see what the vm-exit reason
is.

