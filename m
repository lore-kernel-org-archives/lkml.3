Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaBNNSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:18:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44415 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaBNNSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:18:06 -0500
Date: Fri, 14 Feb 2014 14:17:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
Message-ID: <20140214131745.GC15586@twins.programming.kicks-ass.net>
References: <52FA6D4B.7020709@canonical.com>
 <20140211194553.GZ9987@twins.programming.kicks-ass.net>
 <52FB2EC8.4080602@canonical.com>
 <20140212103713.GE3545@laptop.programming.kicks-ass.net>
 <20140212104017.GA5121@pd.tnic>
 <52FB5669.7090506@canonical.com>
 <20140212115412.GW27965@twins.programming.kicks-ass.net>
 <52FCFA23.4060701@canonical.com>
 <20140213182522.GB14089@laptop.programming.kicks-ass.net>
 <52FDF61D.80709@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FDF61D.80709@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 11:55:25AM +0100, Stefan Bader wrote:
> Ok, I think I now got a log of the actual issue. It seems cpu#1 missed out on
> handling a reschedule interrupt but did send one to cpu#0 and on cpu#0 while
> handling the interrupt the tif flag was not set (yet?) but then when it is,
> there is no more interrupt to do the folding... (sorry for the wrapping)...
> 
>  qemu-system-x86-2503  [000] d.h.  1145.887872: default_send_IPI_mask_logical <-native_smp_send_reschedule
>  qemu-system-x86-2503  [000] d...  1145.887888: resched_task <-check_preempt_curr
>           <idle>-0     [000] d.h.  1145.888001: resched_task <-check_preempt_curr

>           <idle>-0     [001] dn..  1145.888788: smp_reschedule_interrupt <-reschedule_interrupt
>           <idle>-0     [001] dn..  1145.888789: scheduler_ipi <-smp_reschedule_interrupt

>   gnome-terminal-2440  [000] d...  1145.888957: resched_task <-check_preempt_curr
>   gnome-terminal-2440  [000] d...  1145.888959: native_smp_send_reschedule <-resched_task
>   gnome-terminal-2440  [000] d...  1145.888959: default_send_IPI_mask_logical <-native_smp_send_reschedule

>           <idle>-0     [001] dn..  1145.889296: smp_reschedule_interrupt <-reschedule_interrupt
>           <idle>-0     [001] dn..  1145.889297: scheduler_ipi <-smp_reschedule_interrupt

>   gnome-terminal-2440  [000] d...  1145.889465: resched_task <-check_preempt_curr
>   gnome-terminal-2440  [000] d...  1145.889467: native_smp_send_reschedule <-resched_task
>   gnome-terminal-2440  [000] d...  1145.889467: default_send_IPI_mask_logical <-native_smp_send_reschedule

>             Xorg-1054  [001] d.h.  1145.889469: resched_task <-check_preempt_wakeup
>             Xorg-1054  [001] d.h.  1145.889469: native_smp_send_reschedule <-resched_task
>             Xorg-1054  [001] d.h.  1145.889469: default_send_IPI_mask_logical <-native_smp_send_reschedule

>  qemu-system-x86-2503  [000] d.s.  1145.889643: smp_reschedule_interrupt <-reschedule_interrupt
>  qemu-system-x86-2503  [000] d.s.  1145.889643: scheduler_ipi <-smp_reschedule_interrupt
>  qemu-system-x86-2503  [000] .n..  1145.889647: kvm_arch_vcpu_ioctl_run: sched inconsistency
>  qemu-system-x86-2503  [000] .n..  1145.889662: kvm_arch_vcpu_ioctl_run: sched inconsistency
>  qemu-system-x86-2503  [000] .n..  1145.889664: kvm_arch_vcpu_ioctl_run: sched inconsistency
>  qemu-system-x86-2503  [000] .n..  1145.889668: kvm_arch_vcpu_ioctl_run: need(1) != should(0)
>  qemu-system-x86-2503  [000] .n..  1145.889669: kvm_arch_vcpu_ioctl_run: exit_reason=2
>  qemu-system-x86-2503  [000] .n..  1145.889669: kvm_arch_vcpu_ioctl_run: preempt_count=80000000
> 

So afaiu you're running this on an AMD fam 0xf which doesn't have
synchronized TSC; so again the timing might be off.. however:

The first block from cpu 0, sends an IPI to cpu 1, cpu 1 sees 'n'.

Then again, cpu 0 sends to cpu 1, we observe 'n'.

So far so good and timing seems to reflect causality.

Then however, cpu 0 sends, but nothing in this trace answers on cpu 1..
odd.

Then cpu 1 sends to cpu 0, cpu 0 does receive the IPI but does _not_
observe 'n', which is mighty odd. However after the IPI is handled cpu 0
magically gets the 'n'.



So one thing I did wonder about; if cpu 0 sends an IPI while cpu 1 is
already processing the same interrupt; cpu 1 should latch the interrupt
and it would re-trigger with when we re-enable interrupts after we're
done with the first.

The only thing that would ruin that is late-ack, eg. ack (clear the
latch) when exiting the interrupt; but I checked and we ack before we
call scheduler_ipi().

Now; if this were to happen (but I don't exactly see how on a 2 CPU
system, nor do I see this in the trace), there might be a hole...

CPU 0				|	CPU 1
--------------------------------+--------------------------------
                                |
/* ! resched_task */		|
smp_send_reschedule(1)		|L
				|L  smp_reschedule_interrupt()
resched_task()			|L
  set_tsk_need_resched()	|L
  smp_mb()			|L
  smp_send_reschedule(1)	|L
				|L    ack_APIC_irq()
				|     scheduler_ipi()
				|       need_resched();

Now strictly speaking that need_resched() load could creep up before
the store and we'd fail to observe 'n'.

However, x86 forbids reads from passing an earlier write to the same
location (it allows passing earlier writes in general). At which point
the only other option is GCC emitting that load far earlier, in fact
before ack_APIC_irq(), but that would be a violation of the C std
because scheduler_ipi() is a (real) function call and acts as a compiler
barrier AFAIK (as opposed to inlining which doesn't act as a compiler
barrier).

So colour me confused..


You could try putting an smp_mb() at the very start of scheduler_ipi()
just to make absolutely sure, but it _should_ not matter.

Of course, I could be completely off base with how interrupts work; and
there's a wide gaping hole in there, in which case, someone please
educate me ;-)
