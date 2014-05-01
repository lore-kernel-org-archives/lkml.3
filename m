Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbaEARPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 13:15:05 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:49920 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaEARPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 13:15:03 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 1 May 2014 13:18:31 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu> <20140429094632.GP27561@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu> <20140429190108.GB30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu> <20140430184437.GH17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011003360.18142@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu> <20140501150948.GR11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Thomas Gleixner wrote:

> Heading out now and postponing the chase for tomorrow morning.

Some decoding of the trace.

One thing that's possibly unrelated, but on both this and the previous
bug the main thread was doing a "perf_poll" while the bug is triggered.
I guess in theory that could mess up the ref count, although in both
cases the poll() call started after the event was closed so I wouldn't
think it'd be able to poll on a closed fd.


Allocated:
	<...>-2508  [002]   634.721037: kmalloc:              (perf_event_alloc+0x5a) call_site=ffffffff81139b4a ptr=0xffff8800cef05000 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO

This time it's PERF_COUNT_SW_PAGE_FAULTS_MAJ but with inherit enabled:
	<...>-2508  [002]   634.721193: bprint:               SYSC_perf_event_open: Opened: 1 6 0 1
	<...>-2508  [002]   634.721193: sys_exit:             NR 298 = 3


__perf_event_task_sched in
We are added to the CPU1 swevent hlist for the last time (and never 
deleted, hence the bug):
	<...>-2508  [001]   634.838474: function:             __perf_event_task_sched_in
	<...>-2508  [001]   634.838490: bprint:               perf_swevent_add: VMW add_rcu: 0xffff8800cef05000

Event fd closed in parent:
	<...>-2508  [001]   634.839922: sys_enter:            NR 3 (3, 7ffff523dc8c, 0, 22, 7f420cf6210c, 7f420cf62120)
	<...>-2508  [001]   634.839924: sys_exit:             NR 3 = 0

Kill the child:
	<...>-2508  [001]   634.845994: sys_enter:            NR 62 (b63, 9, 7, 1, 7f420cf620f8, 7f420cf62120)

Event released:
	perf_fuzzer-2915  [006]   634.846247: function:             perf_release
	perf_fuzzer-2915  [006]   634.846248: bprint:               put_event: put ref: 0; ptr=0x0xffff8800cef05000 other=0x(nil)
	perf_fuzzer-2915  [006]   634.846252: function:             perf_group_detach
	perf_fuzzer-2915  [006]   634.846253: function:                perf_event__header_size
	perf_fuzzer-2915  [006]   634.846253: function:             perf_remove_from_context


__perf_event_task_sched out on CPU1.
If not closed would have been deleted from the swevent_hlist around here:
	<...>-2508  [001]   634.846265: function:             __perf_event_task_sched_out
	<...>-2508  [001]   634.846270: bprint:               perf_swevent_del: VMW del_rcu: 0xffff8800cf1b8800

Event freed:
	perf_fuzzer-2915  [006]   634.846280: bprint:               _free_event: freeing with 0 refs; ptr=0x0xffff8800cef05000
	perf_fuzzer-2915  [006]   634.846282: function:             sw_perf_event_destroy


Grace period expire:
	<idle>-0     [006]   635.138983: kfree:                (free_event_rcu+0x2f) call_site=ffffffff81130c3f ptr=0xffff8800cef05000

