Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405AbaLKBDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:03:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933183AbaLKBDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:03:46 -0500
Date: Thu, 11 Dec 2014 02:03:44 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, luto@amacapital.net, JBeulich@suse.com,
        jgross@suse.com, bpoirier@suse.de, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 2/2] x86/xen: allow privcmd hypercalls to be
	preempted
Message-ID: <20141211010344.GO25677@wotan.suse.de>
References: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com> <1418254487-9988-3-git-send-email-mcgrof@do-not-panic.com> <5488E552.8050207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5488E552.8050207@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 04:29:06PM -0800, H. Peter Anvin wrote:
> On 12/10/2014 03:34 PM, Luis R. Rodriguez wrote:
> > diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> > index 344b63f..40b5c0c 100644
> > --- a/arch/x86/kernel/entry_32.S
> > +++ b/arch/x86/kernel/entry_32.S
> > @@ -982,7 +982,28 @@ ENTRY(xen_hypervisor_callback)
> >  ENTRY(xen_do_upcall)
> >  1:	mov %esp, %eax
> >  	call xen_evtchn_do_upcall
> > +#ifdef CONFIG_PREEMPT
> >  	jmp  ret_from_intr
> > +#else
> > +	GET_THREAD_INFO(%ebp)
> > +#ifdef CONFIG_VM86
> > +	movl PT_EFLAGS(%esp), %eax	# mix EFLAGS and CS
> > +	movb PT_CS(%esp), %al
> > +	andl $(X86_EFLAGS_VM | SEGMENT_RPL_MASK), %eax
> > +#else
> > +	movl PT_CS(%esp), %eax
> > +	andl $SEGMENT_RPL_MASK, %eax
> > +#endif
> > +	cmpl $USER_RPL, %eax
> > +	jae resume_userspace		# returning to v8086 or userspace
> > +	DISABLE_INTERRUPTS(CLBR_ANY)
> > +	cmpb $0,PER_CPU_VAR(xen_in_preemptible_hcall)
> > +	jz resume_kernel
> > +	movb $0,PER_CPU_VAR(xen_in_preemptible_hcall)
> > +	call cond_resched_irq
> > +	movb $1,PER_CPU_VAR(xen_in_preemptible_hcall)
> > +	jmp resume_kernel
> > +#endif /* CONFIG_PREEMPT */
> >  	CFI_ENDPROC
> >  ENDPROC(xen_hypervisor_callback)
> >  
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index c0226ab..0ccdd06 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -1170,7 +1170,23 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
> >  	popq %rsp
> >  	CFI_DEF_CFA_REGISTER rsp
> >  	decl PER_CPU_VAR(irq_count)
> > +#ifdef CONFIG_PREEMPT
> >  	jmp  error_exit
> > +#else
> > +	movl %ebx, %eax
> > +	RESTORE_REST
> > +	DISABLE_INTERRUPTS(CLBR_NONE)
> > +	TRACE_IRQS_OFF
> > +	GET_THREAD_INFO(%rcx)
> > +	testl %eax, %eax
> > +	je error_exit_user
> > +	cmpb $0,PER_CPU_VAR(xen_in_preemptible_hcall)
> > +	jz retint_kernel
> > +	movb $0,PER_CPU_VAR(xen_in_preemptible_hcall)
> > +	call cond_resched_irq
> > +	movb $1,PER_CPU_VAR(xen_in_preemptible_hcall)
> > +	jmp retint_kernel
> > +#endif /* CONFIG_PREEMPT */
> >  	CFI_ENDPROC
> >  END(xen_do_hypervisor_callback)
> >  
> > @@ -1398,6 +1414,7 @@ ENTRY(error_exit)
> >  	GET_THREAD_INFO(%rcx)
> >  	testl %eax,%eax
> >  	jne retint_kernel
> > +error_exit_user:
> >  	LOCKDEP_SYS_EXIT_IRQ
> >  	movl TI_flags(%rcx),%edx
> >  	movl $_TIF_WORK_MASK,%edi
> 
> You're adding a bunch of code for the *non*-preemptive case here... why?

This is an issue onloy for for non*-preemptive kernels.

Some of Xen's hypercalls can take a long time and unfortunately for
*non*-preemptive kernels this can be quite a bit of an issue.
We've handled situations like this with cond_resched() before which will
push even *non*-preemptive kernels to behave as voluntarily preemptive,
I was not aware to what extent this was done and precedents set but
its pretety widespread now... this then just addresses once particular
case where this is also an issuefor but now in IRQ context.

I agree its a hack but so are all the other cond_reshed() calls then.
I don't think its a good idea to be spreading use of something like
this everywhere but after careful review and trying toa void this
exact code for a while I have not been able to find any other reasonable
alternative.

  Luis
