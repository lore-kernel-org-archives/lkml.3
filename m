Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaENUj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:39:29 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58506 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaENUj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:39:27 -0400
Date: Thu, 15 May 2014 00:39:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140514203924.GE28328@moon>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
 <20140506202307.GA1458@moon>
 <20140508020050.GX39568@redhat.com>
 <20140508073756.GM8607@moon>
 <20140508074930.GN8607@moon>
 <20140508080234.GO8607@moon>
 <alpine.DEB.2.10.1405091211430.13652@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405091211430.13652@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 12:19:49PM -0400, Vince Weaver wrote:
> On Thu, 8 May 2014, Cyrill Gorcunov wrote:
> > 
> > Updated.
> > ---
> >  arch/x86/kernel/cpu/perf_event_p4.c |   67 ++++++++++++++++--------------------
> >  1 file changed, 30 insertions(+), 37 deletions(-)
> 
> I tried this patch, and even though it seemed to fix one of the NMI storms 
> I was experiencing I've managed to trigger again using a different random 
> seed.
> 
> I've been trying to track down a trace of what is triggering things, but 
> this is very difficult as the full log isn't making it to the serial 
> console, even when I fsync() stdout.
> 
> Maybe related, but the following messages tend to happen a lot while 
> fuzzing, and always happen before the fuzzing that eventually locks up:
> 
> The warnings are for
> 	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
> and
> 	WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);

So I'm experiencing the same problem on latest -tip + my patches applied.

[  635.184382] perf interrupt took too long (2522 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[  638.674769] perf interrupt took too long (5009 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[ 1126.156992] ------------[ cut here ]------------
[ 1126.157010] WARNING: CPU: 0 PID: 6166 at arch/x86/kernel/cpu/perf_event.c:1083 x86_pmu_start+0x50/0xe5()
[ 1126.157014] Modules linked in:
[ 1126.157022] CPU: 0 PID: 6166 Comm: perf_fuzzer Not tainted 3.15.0-rc5-gfddecae-dirty #2
[ 1126.157024] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./P5GD1 PRO, BIOS 1012.001 10/13/2005
[ 1126.157024]  00000000 00000000 f49add90 c15684ed 00000000 f49adda8 c10385cc c10112a9
[ 1126.157024]  f5d5e7f0 f3bafc00 0000000c f49addb8 c10385f7 00000009 00000000 f49addd0
[ 1126.157024]  c10112a9 00000002 f5d5e7f4 f3bafc00 f5d5e7f0 f49addf8 c10118ea 00000001
[ 1126.157024] Call Trace:
[ 1126.157024]  [<c15684ed>] dump_stack+0x49/0x73
[ 1126.157024]  [<c10385cc>] warn_slowpath_common+0x66/0x7d
[ 1126.157024]  [<c10112a9>] ? x86_pmu_start+0x50/0xe5
[ 1126.157024]  [<c10385f7>] warn_slowpath_null+0x14/0x18
[ 1126.157024]  [<c10112a9>] x86_pmu_start+0x50/0xe5
[ 1126.157024]  [<c10118ea>] x86_pmu_enable+0x221/0x260
[ 1126.157024]  [<c10c6e8f>] perf_pmu_enable+0x1f/0x23
[ 1126.157024]  [<c10c87a0>] perf_cpu_hrtimer_handler+0xe9/0x131
[ 1126.157024]  [<c10c86b7>] ? __perf_install_in_context+0xc7/0xc7
[ 1126.157024]  [<c1053304>] __run_hrtimer+0xa6/0x149
[ 1126.157024]  [<c1053b57>] hrtimer_interrupt+0xe6/0x1e5
[ 1126.157024]  [<c12b28c0>] ? __this_cpu_preempt_check+0xf/0x11
[ 1126.157024]  [<c1026a7f>] local_apic_timer_interrupt+0x45/0x4a
[ 1126.157024]  [<c1026f7c>] smp_trace_apic_timer_interrupt+0x48/0xa2
[ 1126.157024]  [<c156f006>] trace_apic_timer_interrupt+0x32/0x38
[ 1126.157024]  [<c106007b>] ? sched_slice.isra.40+0x7e/0x91
[ 1126.157024]  [<c108bec1>] ? generic_exec_single+0x4f/0xea
[ 1126.157024]  [<c10c4179>] ? perf_cgroup_exit+0x17/0x17
[ 1126.157024]  [<c10c4179>] ? perf_cgroup_exit+0x17/0x17
[ 1126.157024]  [<c108c011>] smp_call_function_single+0x66/0x9a
[ 1126.157024]  [<c10c3730>] cpu_function_call+0x29/0x2e
[ 1126.157024]  [<c10c7107>] ? group_sched_out+0x66/0x66
[ 1126.157024]  [<c10c5aae>] perf_event_disable+0x2d/0x7b
[ 1126.157024]  [<c10c5a81>] ? list_del_event+0xa8/0xa8
[ 1126.157024]  [<c10c3a2a>] perf_event_for_each_child+0x4c/0x7b
[ 1126.157024]  [<c10c768f>] perf_event_task_disable+0x3a/0x67
[ 1126.157024]  [<c1048bb9>] SyS_prctl+0x14a/0x345
[ 1126.157024]  [<c106e363>] ? trace_hardirqs_on_caller+0x177/0x1d2
[ 1126.157024]  [<c156e644>] sysenter_do_call+0x12/0x32
[ 1126.157024] ---[ end trace 1c8a0d8dcf7e5bde ]---

Continue investigating...
