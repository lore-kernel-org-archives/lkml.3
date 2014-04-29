Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaD2U40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 16:56:26 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:47482 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaD2U4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 16:56:24 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 29 Apr 2014 16:59:55 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140429190108.GB30445@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu> <20140418152314.GY11182@twins.programming.kicks-ass.net> <20140418165958.GQ13658@twins.programming.kicks-ass.net> <20140418171516.GR13658@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu>
 <20140429094632.GP27561@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu> <20140429190108.GB30445@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, Peter Zijlstra wrote:

> Fair point, nope not in that case. If you can trigger this without ever
> using .inherit=1 this would exclude a lot of funny code.

I don't think inherit is being set, but I'm not actually sure.
I will have to add that to the trace_printk() and recompile/re-run



In the meantime I had a lucky crash and managed to catch a trace.

Unfortunately there's a lot of active events so it's not clear which is 
which.  I think this is going to need another round of trace generation :(

This trace can be found here:
	http://web.eece.maine.edu/~vweaver/junk/bug.out.bz2

A summary:

The troublesome memory address is allocated as part of a perf_event_open
	perf_fuzzer-4387  [001]  1802.628663: kmalloc:              (perf_event_alloc+0x5a) call_site=ffffffff8113a8fa ptr=0xffff8800a3122800 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO

The event opened successfully, fd=41, it looks like it is 
PERF_COUNT_SW_EMULATION_FAULTS with attr.period=0
	perf_fuzzer-4387  [001]  1802.628677: bprint:               SYSC_perf_event_open: Opened: 1 8 0
	perf_fuzzer-4387  [001]  1802.628677: sys_exit:             NR 298 = 41

The parent forks:
	perf_fuzzer-4387  [002]  1803.571239: sys_exit:             NR 56 = 5504

The event is closed in the parent:
	perf_fuzzer-4387  [002]  1803.582345: sys_enter:            NR 3 (29, 3000, 3000, 7f7524d760a4, 7f7524d76108, 7f7524d76120)
	perf_fuzzer-4387  [002]  1803.582345: sys_exit:             NR 3 = 0

The parent kills the child:
	perf_fuzzer-4387  [003]  1803.590145: sys_enter:            NR 62 (1580, 9, 7, 7f7524d760b8, 7f7524d760b8, 7f7524d76120)

Presumably one of the many perf_swevent_del() calls in the child is us.
	perf_fuzzer-5504  [004]  1803.590277: function:             perf_swevent_del

*** The parent somehow fails to call perf_swevent_del() on CPU3? ***

The grace period expires and the memory is freed:
	ksoftirqd/4-28    [004]  1803.609802: kfree:                (free_event_rcu+0x2f) call_site=ffffffff8113177f ptr=0xffff8800a3122800

An event is deleted from swevent_hlist, but ->pprev was our free'd address:
	perf_fuzzer-4387  [003]  1803.610555: function:             perf_swevent_del

Slab corruption:
	[ 1803.610555] ------------[ cut here ]------------
	[ 1803.615419] WARNING: CPU: 3 PID: 4387 at include/linux/list.h:620 perf_swevent_del+0x6e/0x90()
	[ 1803.948487] Slab corruption (Tainted: G        W    ): kmalloc-2048 start=ffff8800a3122800, len=2048
	[ 1803.958294] 040: 6b 6b 6b 6b 6b 6b 6b 6b 88 f7 92 17 01 88 ff ff  kkkkkkkk........
