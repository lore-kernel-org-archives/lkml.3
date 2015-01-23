Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbbAWBkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:40:52 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:49590 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbbAWBkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:40:49 -0500
MIME-Version: 1.0
In-Reply-To: <1421972951-3940-3-git-send-email-mcgrof@do-not-panic.com>
References: <1421972951-3940-1-git-send-email-mcgrof@do-not-panic.com> <1421972951-3940-3-git-send-email-mcgrof@do-not-panic.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Jan 2015 17:40:27 -0800
Message-ID: <CALCETrXKeoFKCDYcqeN=HV6MJt_CjwSPQmn_DbBxY6s-76W3Tw@mail.gmail.com>
Subject: Re: [RFC v4 2/2] x86/xen: allow privcmd hypercalls to be preempted
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jan Beulich <JBeulich@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 4:29 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
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
>         -- long delay (real or emulated) --
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
>
> This enables hypercall preemption by selectively forcing checks for
> voluntary preempting only on ioctl initiated private hypercalls
> where we know some folks have run into reported issues [1].
>
> This also adds a trace event to be able to review when xen hypercalls
> are preemtped, right now we just tell you when it happens and which
> CPU got preempted.
>
> ergon:~ # echo 1 > /sys/kernel/debug/tracing/events/xen/xen_hypercall_preemption/trigger
> ergon:~ # cat /sys/kernel/debug/tracing/trace_pipe
> ...
>  qemu-system-i38-2114  [000] ....   491.038440: xen_hypercall_preemption: on CPU 0
>  qemu-system-i38-2114  [003] ....   518.138592: xen_hypercall_preemption: on CPU 3
> ...
>
> [0] http://xenbits.xen.org/gitweb/?p=xen.git;a=commitdiff;h=42217cbc5b3e84b8c145d8cfb62dd5de0134b9e8;hp=3a0b9c57d5c9e82c55dd967c84dd06cb43c49ee9
> [1] https://bugzilla.novell.com/show_bug.cgi?id=861093
> [2] http://ftp.suse.com/pub/people/mcgrof/xen/emulate-long-xen-hypercalls.patch
>
> Based on original work by: David Vrabel <david.vrabel@citrix.com>
> Suggested-by: Andy Lutomirski <luto@amacapital.net>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Jan Beulich <JBeulich@suse.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>  arch/x86/kernel/entry_32.S       |  2 ++
>  arch/x86/kernel/entry_64.S       |  2 ++
>  drivers/xen/events/events_base.c | 23 +++++++++++++++++++++++
>  include/trace/events/xen.h       |  9 +++++++++
>  include/xen/events.h             |  1 +
>  5 files changed, 37 insertions(+)
>

Reviewed-by: Andy Lutomirski <luto@amacapital.net>

>
> +/*
> + * CONFIG_PREEMPT=n kernels can end up triggering the softlock
> + * TASK_UNINTERRUPTIBLE hanger check (default 120 seconds)
> + * when certain multicalls are used [0] on large systems, in
> + * that case we need a way to voluntarily preempt. This is
> + * only an issue on CONFIG_PREEMPT=n kernels.
> + *
> + * [0] https://bugzilla.novell.com/show_bug.cgi?id=861093
> + */
> +void xen_end_upcall(struct pt_regs *regs)
> +{
> +       if (xen_is_preemptible_hypercall(regs)) {
> +               int cpuid = smp_processor_id();
> +               if (_cond_resched())
> +                       trace_xen_hypercall_preemption(cpuid);

If you want to speed this up a bit, I think you could move the
smp_processor_id() into the TP_fast_assign.  But don't tracepoints
report the cpu number even without any action?
