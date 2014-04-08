Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbaDHPXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:23:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:35079 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757207AbaDHPXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:23:14 -0400
Date: Tue, 8 Apr 2014 11:23:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: fweisbec@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ftrace: ftrace_bug, ftrace failed to modify nva3_ram_init
Message-ID: <20140408112312.616eccf2@gandalf.local.home>
In-Reply-To: <53440F6F.8030003@oracle.com>
References: <53440730.3070507@oracle.com>
	<20140408105921.0e62da8f@gandalf.local.home>
	<53440F6F.8030003@oracle.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Apr 2014 11:02:07 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> On 04/08/2014 10:59 AM, Steven Rostedt wrote:
> > On Tue, 08 Apr 2014 10:26:56 -0400
> > Sasha Levin <sasha.levin@oracle.com> wrote:
> > 
> >> Hi all,
> >>
> >> While fuzzing with trinity inside a KVM tools guest running the latest -next
> >> kernel, I've stumbled on the following:
> >>
> >> [ 2983.109380] WARNING: CPU: 0 PID: 744 at kernel/trace/ftrace.c:1704 ftrace_bug+0xb0/0x280()
> >> [ 2983.110893] Modules linked in:
> >> [ 2983.111439] CPU: 0 PID: 744 Comm: trinity-main Tainted: G        W     3.14.0-next-20140407-sasha-00023-gd35b0d6 #382
> > 
> > What was the warning before this?
> 
> There was nothing before that in both cases I've seen this issue.

I believe the "W" taint means there was a previous warning.

> 
> >> [ 2983.112845]  0000000000000009 ffff88002c4e3b88 ffffffffa252ee51 0000000000002420
> >> [ 2983.113993]  0000000000000000 ffff88002c4e3bc8 ffffffff9f15a2dc ffffffff9fffffc0
> >> [ 2983.115134]  ffff88018aaad530 ffffffffa0000000 000000000000ad53 ffffffffa6486e10
> >> [ 2983.116221] Call Trace:
> >> [ 2983.116603] dump_stack (lib/dump_stack.c:52)
> >> [ 2983.117306] warn_slowpath_common (kernel/panic.c:419)
> >> [ 2983.118252] ? nva3_ram_prog (drivers/gpu/drm/nouveau/core/subdev/fb/ramnva3.c:318)
> >> [ 2983.119091] ? nva3_ram_tidy (drivers/gpu/drm/nouveau/core/subdev/fb/ramnva3.c:326)
> >> [ 2983.119836] ? __fentry__ (arch/x86/kernel/entry_64.S:106)
> >> [ 2983.121379] warn_slowpath_null (kernel/panic.c:454)
> >> [ 2983.122635] ftrace_bug (kernel/trace/ftrace.c:1704 (discriminator 3))
> >> [ 2983.123688] ftrace_replace_code (arch/x86/kernel/ftrace.c:625 (discriminator 3))
> >> [ 2983.124938] ftrace_modify_all_code (kernel/trace/ftrace.c:2011)
> >> [ 2983.126208] arch_ftrace_update_code (arch/x86/include/asm/atomic.h:103 arch/x86/kernel/ftrace.c:680)
> >> [ 2983.127613] ftrace_run_update_code (kernel/trace/ftrace.c:2088)
> >> [ 2983.128540] ftrace_startup_enable (kernel/trace/ftrace.c:2114)
> >> [ 2983.129392] ftrace_startup (kernel/trace/ftrace.c:2146)
> >> [ 2983.130679] register_ftrace_function (kernel/trace/ftrace.c:4864)
> >> [ 2983.131667] perf_ftrace_event_register (kernel/trace/trace_event_perf.c:356)
> >> [ 2983.132590] perf_trace_init (kernel/trace/trace_event_perf.c:187 kernel/trace/trace_event_perf.c:206)
> >> [ 2983.133377] ? __lock_is_held (kernel/locking/lockdep.c:3516)
> >> [ 2983.134181] perf_tp_event_init (kernel/events/core.c:5937)
> >> [ 2983.135043] perf_init_event (kernel/events/core.c:6598)
> >> [ 2983.135882] ? perf_pmu_unregister (kernel/events/core.c:6577)
> >> [ 2983.136803] perf_event_alloc (kernel/events/core.c:6754)
> >> [ 2983.137831] SYSC_perf_event_open (kernel/events/core.c:7062)
> >> [ 2983.138798] ? preempt_count_sub (kernel/sched/core.c:2526)
> >> [ 2983.139643] ? context_tracking_user_exit (arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:182 (discriminator 2))
> >> [ 2983.140912] ? context_tracking_user_exit (arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:182 (discriminator 2))
> >> [ 2983.141941] SyS_perf_event_open (kernel/events/core.c:6990)
> >> [ 2983.142771] tracesys (arch/x86/kernel/entry_64.S:749)
> >> [ 2983.144740] ---[ end trace 6321065f5978f85b ]---
> >> [ 2983.145355] ftrace failed to modify nva3_ram_init (drivers/gpu/drm/nouveau/core/subdev/fb/ramnva3.c:326)
> >> [ 2983.146357]  actual: 90:66:66:66:90
> > 
> > Hmm, I wonder what the "ideal" nop is on this machine. But I think it
> > should probably have been 66:66:66:66:90?
> > 
> > Is this reproducible?
> 
> It happened twice during the overnight fuzzing session, so while I can't
> force it to happen again I'm assuming that it'll show up again if we
> wait enough.

Is it always the same function that fails? (I would highly doubt it
would be). Also, do you have any idea of what the sequence of events
that were performed was?

-- Steve
