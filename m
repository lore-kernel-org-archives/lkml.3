Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaEETsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:48:06 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:47430 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaEETsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:48:03 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 5 May 2014 15:51:42 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140505193629.GB11096@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405051546290.31072@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu> <20140505093124.GN17778@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1405051200010.31049@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405051309160.31072@vincent-weaver-1.umelst.maine.edu>
 <20140505171428.GU26782@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1405051443260.31072@vincent-weaver-1.umelst.maine.edu> <20140505193629.GB11096@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2014, Peter Zijlstra wrote:

> > It looks like it is stuck repeating this forever:
> > 	perf_fuzzer-5256  [000]   275.943049: kmalloc:              (T.1262+0xe) call_site=ffffffff810d022f ptr=0xffff8800cb028400 bytes_req=216 bytes_alloc=256 gfp_flags=GFP_KERNEL|GFP_ZERO
> > 	perf_fuzzer-5256  [000]   275.943057: function:             perf_lock_task_context
> > 	perf_fuzzer-5256  [000]   275.943057: function:             alloc_perf_context
> > and memory is slowly leaking away.
> 
> Oh, usually when my WSM gets funny like this and I enable the tracer it
> just stops being a computer and starts being a brick.

I'd give you more details from the tracer but that's all lost in the 
middle of a dreaded
	CPU:1 [87702 EVENTS DROPPED]
incident.

Though I can try again to see if I can get a better trace.

Also possibly related, the following was 
generated at least one of the times things got wedged (according to my 
notes this same warning has also been triggered previously by Dave Jones 
and trinity but I don't know if it's the same problem or not):

[  804.036004] WARNING: CPU: 1 PID: 26033 at kernel/events/core.c:2398 task_ctx_sched_out+0x49/0x6e()
[  804.036004] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg mcs7830 usbnet evdev video wmi acpi_cpufreq ohci_pci pcspkr psmouse button processor thermal_sys coretemp serio_raw ohci_hcd i2c_nforce2 sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[  804.036004] CPU: 1 PID: 26033 Comm: perf_fuzzer Tainted: G      D       3.15.0-rc4+ #44
[  804.036004] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  804.036004]  000000000000095e ffff880039ac3c08 ffffffff81539016 000000000000095e
[  804.036004]  0000000000000000 ffff880039ac3c48 ffffffff8103fcb9 0000000000000000
[  804.036004]  ffffffff810ca939 ffff88011fc95b08 ffff8800cbb6a010 0000000000000000
[  804.036004] Call Trace:
[  804.036004]  [<ffffffff81539016>] dump_stack+0x49/0x5b
[  804.036004]  [<ffffffff8103fcb9>] warn_slowpath_common+0x81/0x9b
[  804.036004]  [<ffffffff810ca939>] ? task_ctx_sched_out+0x49/0x6e
[  804.036004]  [<ffffffff8103fced>] warn_slowpath_null+0x1a/0x1c
[  804.036004]  [<ffffffff810ca939>] task_ctx_sched_out+0x49/0x6e
[  804.036004]  [<ffffffff810d0111>] perf_event_exit_task+0xee/0x1fe
[  804.036004]  [<ffffffff8105e91c>] ? switch_task_namespaces+0x1d/0x51
[  804.036004]  [<ffffffff81041bb6>] do_exit+0x400/0x942
[  804.036004]  [<ffffffff810f3d50>] ? do_read_fault+0x169/0x263
[  804.036004]  [<ffffffff810d3b51>] ? unlock_page+0x27/0x2c
[  804.036004]  [<ffffffff81042170>] do_group_exit+0x78/0xa0
[  804.036004]  [<ffffffff8104f378>] get_signal_to_deliver+0x46d/0x48a
[  804.036004]  [<ffffffff810bc037>] ? function_trace_call+0xc8/0xf2
[  804.036004]  [<ffffffff81002526>] do_signal+0x46/0x5e8
[  804.036004]  [<ffffffff810b8279>] ? __trace_buffer_unlock_commit+0x3c/0x44
[  804.036004]  [<ffffffff8100c176>] ? ftrace_raw_event_sys_exit+0x4a/0x72
[  804.036004]  [<ffffffff81002af4>] do_notify_resume+0x2c/0x64
[  804.036004]  [<ffffffff8153c235>] retint_signal+0x3d/0x78
[  804.036004] ---[ end trace 6cadd738b5f7eb96 ]---


