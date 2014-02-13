Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaBMRjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:39:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49424 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaBMRjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:39:08 -0500
Date: Thu, 13 Feb 2014 18:38:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
Message-ID: <20140213173852.GH6835@laptop.programming.kicks-ass.net>
References: <52FA6D4B.7020709@canonical.com>
 <20140211194553.GZ9987@twins.programming.kicks-ass.net>
 <52FB2EC8.4080602@canonical.com>
 <20140212103713.GE3545@laptop.programming.kicks-ass.net>
 <20140212104017.GA5121@pd.tnic>
 <52FB5669.7090506@canonical.com>
 <20140212115412.GW27965@twins.programming.kicks-ass.net>
 <52FCFA23.4060701@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FCFA23.4060701@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 06:00:19PM +0100, Stefan Bader wrote:
> On 12.02.2014 12:54, Peter Zijlstra wrote:
> > On Wed, Feb 12, 2014 at 12:09:29PM +0100, Stefan Bader wrote:
> >> Something else here I run a kernel with CONFIG_PREEMPT not set and NR_CPUS
> >> limited to 8 (for the 32bit kernel). So the default apic driver is used. Since
> >> default_send_IPI_mask_logical is only used from there, I assume the trace you
> >> got does the same. Maybe something there is wrong which would explain why we
> >> only see it on 32bit hosts.
> > 
> > Can you try with a different APIC driver to test this?
> > 
> I don't think I can. And I think the statement about this only be used for 32bit
> could be wrong. I got mislead to think so because those are only defined in
> probe_32 but the 64bit counterpart isn't containing much aside that.
> 
> Anyway, I played around with tracing a bit more. So with this change:
> 
>                 if (need_resched()) {
>                         srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>                         if (need_resched() != should_resched()) {
> +                               trace_printk("need(%i) != should(%i)\n",
> +                                       need_resched(), should_resched());
> +                               trace_printk("exit_reason=%u\n",
> +                                       vcpu->run->exit_reason);
> +                                trace_printk("preempt_count=%lx\n",
> +                                        __this_cpu_read_4(__preempt_count));
> +                                tracing_stop();
> +                                printk(KERN_ERR "Stopped tracing, due to
> inconsistent state.\n");
>                         }
>  +                      schedule();
>  -                      cond_reschedule();
>                         vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>                 }
> 
> I get the following (weird) output:
> 
>             Xorg-1078  [001] d...    71.270251: native_smp_send_reschedule
> <-resched_task
>             Xorg-1078  [001] d...    71.270251: default_send_IPI_mask_logical
> <-native_smp_send_reschedule
>       bamfdaemon-2318  [001] d...    71.270465: resched_task <-check_preempt_wakeup
>       bamfdaemon-2318  [001] d...    71.270539: resched_task <-check_preempt_wakeup
>           compiz-2365  [001] d...    71.270689: resched_task <-check_preempt_wakeup
>           compiz-2365  [001] d...    71.270827: resched_task <-check_preempt_wakeup
>           compiz-2365  [001] d...    71.270940: resched_task <-check_preempt_wakeup
>  qemu-system-x86-2679  [000] dn..    71.270999: smp_reschedule_interrupt
> <-reschedule_interrupt
>  qemu-system-x86-2679  [000] dn..    71.270999: scheduler_ipi
> <-smp_reschedule_interrupt
>  qemu-system-x86-2679  [000] .N..    71.271001: kvm_arch_vcpu_ioctl_run: need(1)
> != should(0)
>  qemu-system-x86-2679  [000] .N..    71.271002: kvm_arch_vcpu_ioctl_run:
> exit_reason=2
>  qemu-system-x86-2679  [000] .N..    71.271003: kvm_arch_vcpu_ioctl_run:
> preempt_count=0
> 
> So am I reading this right, that the interrupt did get delivered to cpu#0 while
> the thread info already had the resched flag set. So this really should have
> cleared the bit in preempt_count. But while the trace info shows 'N' for some
> reason should_reschedule returns false but at the same time reading the preempt
> count manually shows it 0?

*blink*... That's weird indeed... do you have the asm that goes along
with that?
