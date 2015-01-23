Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbbAWLpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:45:15 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:57961 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbbAWLpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:45:10 -0500
X-IronPort-AV: E=Sophos;i="5.09,453,1418083200"; 
   d="scan'208";a="220836875"
Message-ID: <54C23442.9000008@citrix.com>
Date: Fri, 23 Jan 2015 11:45:06 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <david.vrabel@citrix.com>,
        <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>
CC: Borislav Petkov <bp@suse.de>, <kvm@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, <paulmck@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] [RFC v4 2/2] x86/xen: allow privcmd hypercalls to
 be preempted
References: <1421972951-3940-1-git-send-email-mcgrof@do-not-panic.com> <1421972951-3940-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1421972951-3940-3-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/15 00:29, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> Xen has support for splitting heavy work work into a series
> of hypercalls, called multicalls, and preempting them through
> what Xen calls continuation [0]. Despite this though without
> CONFIG_PREEMPT preemption won't happen, without preemption
> a system can become pretty useless on heavy handed hypercalls.
> Such is the case for example when creating a > 50 GiB HVM guest,
> we can get softlockups [1] with:.
> 
> kernel: [  802.084335] BUG: soft lockup - CPU#1 stuck for 22s! [xend:31351]
> 
> The softlock up triggers on the TASK_UNINTERRUPTIBLE hanger check
> (default 120 seconds), on the Xen side in this particular case
> this happens when the following Xen hypervisor code is used:
> 
> xc_domain_set_pod_target() -->
>   do_memory_op() -->
>     arch_memory_op() -->
>       p2m_pod_set_mem_target()
> 	-- long delay (real or emulated) --
> 
> This happens on arch_memory_op() on the XENMEM_set_pod_target memory
> op even though arch_memory_op() can handle continuation via
> hypercall_create_continuation() for example.
> 
> Machines over 50 GiB of memory are on high demand and hard to come
> by so to help replicate this sort of issue long delays on select
> hypercalls have been emulated in order to be able to test this on
> smaller machines [2].
> 
> On one hand this issue can be considered as expected given that
> CONFIG_PREEMPT=n is used however we have forced voluntary preemption
> precedent practices in the kernel even for CONFIG_PREEMPT=n through
> the usage of cond_resched() sprinkled in many places. To address
> this issue with Xen hypercalls though we need to find a way to aid
> to the schedular in the middle of hypercalls. We are motivated to
> address this issue on CONFIG_PREEMPT=n as otherwise the system becomes
> rather unresponsive for long periods of time; in the worst case, at least
> only currently by emulating long delays on select io disk bound
> hypercalls, this can lead to filesystem corruption if the delay happens
> for example on SCHEDOP_remote_shutdown (when we call 'xl <domain> shutdown').
> 
> We can address this problem by trying to check if we should schedule
> on the xen timer in the middle of a hypercall on the return from the
> timer interrupt. We want to be careful to not always force voluntary
> preemption though so to do this we only selectively enable preemption
> on very specific xen hypercalls.
[...]
> @@ -1243,6 +1247,25 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>  	set_irq_regs(old_regs);
>  }
>  
> +/*
> + * CONFIG_PREEMPT=n kernels can end up triggering the softlock
> + * TASK_UNINTERRUPTIBLE hanger check (default 120 seconds)
> + * when certain multicalls are used [0] on large systems, in
> + * that case we need a way to voluntarily preempt. This is
> + * only an issue on CONFIG_PREEMPT=n kernels.

Rewrite this comment as;

* Some hypercalls issued by the toolstack can take many 10s of
* seconds.  Allow tasks running hypercalls via the privcmd driver to be
* voluntarily preempted even if full kernel preemption is disabled.

> + * [0] https://bugzilla.novell.com/show_bug.cgi?id=861093

This link isn't accessible so I don't think it should be included here.

> + */
> +void xen_end_upcall(struct pt_regs *regs)
> +{
> +	if (xen_is_preemptible_hypercall(regs)) {
> +		int cpuid = smp_processor_id();
> +		if (_cond_resched())
> +			trace_xen_hypercall_preemption(cpuid);

I don't think a tracepoint here is useful.

> +	}
> +}
> +NOKPROBE_SYMBOL(xen_end_upcall);

Do we need this is this function is no longer notrace?

David
