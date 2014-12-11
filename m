Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850AbaLKLJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 06:09:47 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:11901 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbaLKLJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 06:09:46 -0500
X-IronPort-AV: E=Sophos;i="5.07,557,1413244800"; 
   d="scan'208";a="203295639"
Message-ID: <54897B76.6070500@citrix.com>
Date: Thu, 11 Dec 2014 11:09:42 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: Juergen Gross <jgross@suse.com>, Peter Zijlstra <peterz@infradead.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        <bpoirier@suse.de>
Subject: Re: [Xen-devel] [PATCH v2 2/2] x86/xen: allow privcmd hypercalls
 to be preempted
References: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com>	<1418254487-9988-3-git-send-email-mcgrof@do-not-panic.com> <CALCETrVAQ5JRoyL=V=fj+KxwUXfOTibKQkEDcvSqJzEi2sgshA@mail.gmail.com>
In-Reply-To: <CALCETrVAQ5JRoyL=V=fj+KxwUXfOTibKQkEDcvSqJzEi2sgshA@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/14 23:51, Andy Lutomirski wrote:
> On Wed, Dec 10, 2014 at 3:34 PM, Luis R. Rodriguez
>> --- a/arch/x86/kernel/entry_64.S
>> +++ b/arch/x86/kernel/entry_64.S
>> @@ -1170,7 +1170,23 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
>>         popq %rsp
>>         CFI_DEF_CFA_REGISTER rsp
>>         decl PER_CPU_VAR(irq_count)
>> +#ifdef CONFIG_PREEMPT
>>         jmp  error_exit
>> +#else
>> +       movl %ebx, %eax
>> +       RESTORE_REST
>> +       DISABLE_INTERRUPTS(CLBR_NONE)
>> +       TRACE_IRQS_OFF
>> +       GET_THREAD_INFO(%rcx)
>> +       testl %eax, %eax
>> +       je error_exit_user
>> +       cmpb $0,PER_CPU_VAR(xen_in_preemptible_hcall)
>> +       jz retint_kernel
> 
> I think I understand this part.
> 
>> +       movb $0,PER_CPU_VAR(xen_in_preemptible_hcall)
> 
> Why?  Is the issue that, if preemptible hypercalls nest, you don't
> want to preempt again?

We need to clear and reset this per-cpu variable around the schedule
point since the current task may be rescheduled on a different CPU, or
we may switch to a task that was previously preempted at this point.

That this prevents nested preemption is fine because we only want
hypercalls issued by the privcmd driver on behalf of userspace to be
preemptible.

>> +       call cond_resched_irq
> 
> On !CONFIG_PREEMPT, there's no preempt_disable, right?  So how do you
> guarantee that you don't preempt something you shouldn't?  Is the idea
> that these events will only fire nested *directly* inside a
> preemptible hypercall?  Also, should you check that IRQs were on when
> the event fired?  (Are they on in pt_regs?)

Testing xen_in_preemptible_hcall is sufficient.  We bracket the
hypercalls we want to be preemptible like so:

	xen_preemptible_hcall_begin();
 	ret = privcmd_call(hypercall.op,
 			   hypercall.arg[0], hypercall.arg[1],
 			   hypercall.arg[2], hypercall.arg[3],
 			   hypercall.arg[4]);
	xen_preemptible_hcall_end();

begin() and end() are somewhat like a Xen-specific prempt_enable() and
preempt_disable(), overriding the default no-preempt state.

>> +       movb $1,PER_CPU_VAR(xen_in_preemptible_hcall)
>> +       jmp retint_kernel
>> +#endif /* CONFIG_PREEMPT */
>>         CFI_ENDPROC
> 
> All that being said, this is IMO a bit gross.  You've added a bunch of
> asm that's kind of like a parallel error_exit, and the error entry and
> exit code is hairy enough that this scares me.  Can you do this mostly
> in C instead?  This would look a nicer if it could be:

I abandoned my initial attempt that looked like this because I thought
it was gross too.

>     call xen_evtchn_do_upcall
>     popq %rsp
>     CFI_DEF_CFA_REGISTER rsp
>     decl PER_CPU_VAR(irq_count)
> +  call xen_end_upcall
>     jmp error_exit
> 
> Where xen_end_upcall would be witten in C, nokprobes and notrace (if
> needed) and would check pt_regs and whatever else and just call
> schedule if needed?

Oh that's a good idea, thanks!

David

