Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbaD1OSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:18:11 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:36440 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaD1OSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:18:06 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 28 Apr 2014 10:21:34 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu> <20140417094815.GA9348@gmail.com> <20140417114533.GJ11096@twins.programming.kicks-ass.net> <20140417142213.GA29338@gmail.com>
 <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu> <20140417145418.GM11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu> <20140418152314.GY11182@twins.programming.kicks-ass.net>
 <20140418165958.GQ13658@twins.programming.kicks-ass.net> <20140418171516.GR13658@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, Vince Weaver wrote:

> [ 2226.257503] WARNING: CPU: 4 PID: 0 at lib/debugobjects.c:260 debug_print_object+0x83/0xa0()
> [ 2226.266545] ODEBUG: free active (active state 0) object type: hrtimer hint: perf_swevent_hrtimer+0x0/0x140
> [ 2226.389820] Call Trace:
> [ 2226.392428]  <IRQ>  [<ffffffff8164f7b3>] dump_stack+0x45/0x56
> [ 2226.398595]  [<ffffffff810647cd>] warn_slowpath_common+0x7d/0xa0
> [ 2226.405059]  [<ffffffff8106483c>] warn_slowpath_fmt+0x4c/0x50
> [ 2226.411240]  [<ffffffff813cc9e3>] debug_print_object+0x83/0xa0
> [ 2226.417535]  [<ffffffff81139200>] ? __perf_event_overflow+0x270/0x270
> [ 2226.424463]  [<ffffffff813cde73>] debug_check_no_obj_freed+0x263/0x360
> [ 2226.431500]  [<ffffffff811316aa>] ? free_event_rcu+0x2a/0x30
> [ 2226.437579]  [<ffffffff81196fd0>] kfree+0xb0/0x560
> [ 2226.442740]  [<ffffffff810ccd46>] ? rcu_process_callbacks+0x236/0x620
> [ 2226.449658]  [<ffffffff81131680>] ? pmu_dev_release+0x10/0x10
> [ 2226.455811]  [<ffffffff811316aa>] free_event_rcu+0x2a/0x30
> [ 2226.461727]  [<ffffffff810ccdad>] rcu_process_callbacks+0x29d/0x620
> [ 2226.468440]  [<ffffffff810ccd46>] ? rcu_process_callbacks+0x236/0x620
> [ 2226.475384]  [<ffffffff81069ab5>] __do_softirq+0xf5/0x290
> [ 2226.481210]  [<ffffffff81069e9d>] irq_exit+0xad/0xc0
> [ 2226.486540]  [<ffffffff81662e35>] smp_apic_timer_interrupt+0x45/0x60
> [ 2226.493350]  [<ffffffff8166181d>] apic_timer_interrupt+0x6d/0x80
> [ 2226.499798]  <EOI>  [<ffffffff810d958e>] ? tick_nohz_idle_exit+0x12e/0x1b0
> [ 2226.507192]  [<ffffffff810aa7de>] cpu_startup_entry+0x12e/0x3d0
> [ 2226.513542]  [<ffffffff81042a43>] start_secondary+0x193/0x200
> [ 2226.519706] ---[ end trace ec55e71b02ef43b3 ]---

so it's looking more and more like this issue is with a
	PERF_COUNT_SW_TASK_CLOCK
event.

It's being deallocated in a different process than it was started (due to 
fork).

And it really looks like the problem is even though the event is free'd, 
there's still an active hrtimer associated with it somehow.

I can't seem to find *why* there's an associated hrtimer though, as the 
event as far as I can tell was created with sample_period=0 and the 
various
	perf_swevent_init_hrtimer()
calls seem to guard with is_sampling()

This is made all the more confusing because the PERF_COUNT_SW_TASK_CLOCK 
events are handled by their own PMU even though it's faked up so they look 
like regular software events.  Is there a reason for that?

Vince
