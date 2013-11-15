Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3KOO76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:59:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54346 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3KOO7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:59:51 -0500
Date: Fri, 15 Nov 2013 15:59:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf sw_event related lockup
Message-ID: <20131115145944.GA3694@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1311131739560.5706@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1311131739560.5706@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 05:45:59PM -0500, Vince Weaver wrote:
> Hello
> 
> so with the perf_fuzzer modified to avoid the tracepoint issues, I've 
> triggered this software-event related soft lockup.
> 
> From what I can gather from the backtraces, they all map to the loop
> in do_perf_sw_event() in kernel/events/core.c
> 
>         hlist_for_each_entry_rcu(event, head, hlist_entry) {
>                 if (perf_swevent_match(event, type, event_id, data, regs))
>                         perf_swevent_event(event, nr, data, regs);
>         }
> 
> is it possible to get stuck in that as an infinite loop?
> 
> below is the dmesg from the lockup, I eventually had to reboot to clear 
> the problem:

> [  416.755310] NOHZ: local_softirq_pending 100
> [  452.232000] BUG: soft lockup - CPU#1 stuck for 23s! [perf_fuzzer:7211]
> [  452.232000] RIP: 0010:[<ffffffff810caa4c>]  [<ffffffff810caa4c>] __perf_sw_event+0x9a/0x1a5
> [  452.232000] Call Trace:
> [  452.232000]  [<ffffffff81520fa3>] ? __do_page_fault+0x191/0x3f5
> [  452.232000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
> [  452.232000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
> [  452.232000]  [<ffffffff8151e232>] ? page_fault+0x22/0x30
> [  452.232000]  [<ffffffff8129cfe0>] ? __put_user_4+0x20/0x30
> [  452.232000]  [<ffffffff81066629>] ? schedule_tail+0x5c/0x60
> [  452.232000]  [<ffffffff81524b7f>] ? ret_from_fork+0xf/0xb0

> [  480.232000] RIP: 0010:[<ffffffff810cab0c>]  [<ffffffff810cab0c>] __perf_sw_event+0x15a/0x1a5
> [  480.232000] Call Trace:
> [  480.232000]  [<ffffffff81520fa3>] ? __do_page_fault+0x191/0x3f5
> [  480.232000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
> [  480.232000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
> [  480.232000]  [<ffffffff8151e232>] ? page_fault+0x22/0x30
> [  480.232000]  [<ffffffff8129cfe0>] ? __put_user_4+0x20/0x30
> [  480.232000]  [<ffffffff81066629>] ? schedule_tail+0x5c/0x60
> [  480.232000]  [<ffffffff81524b7f>] ? ret_from_fork+0xf/0xb0

> [  486.528000] RIP: 0010:[<ffffffff8129c063>]  [<ffffffff8129c063>] delay_tsc+0x23/0x50
> [  486.528000] Call Trace:
> [  486.528000]  <EOI>  [<ffffffff810cab38>] ? __perf_sw_event+0x186/0x1a5
> [  486.528000]  [<ffffffff810cab40>] ? __perf_sw_event+0x18e/0x1a5
> [  486.528000]  [<ffffffff81520fa3>] ? __do_page_fault+0x191/0x3f5
> [  486.528000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
> [  486.528000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
> [  486.528000]  [<ffffffff8151e232>] ? page_fault+0x22/0x30
> [  486.528000]  [<ffffffff8129cfe0>] ? __put_user_4+0x20/0x30
> [  486.528000]  [<ffffffff81066629>] ? schedule_tail+0x5c/0x60
> [  486.528000]  [<ffffffff81524b7f>] ? ret_from_fork+0xf/0xb0

> [  486.528000] Call Trace:
> [  486.528000]  [<ffffffff810cab38>] ? __perf_sw_event+0x186/0x1a5
> [  486.528000]  [<ffffffff810cab40>] ? __perf_sw_event+0x18e/0x1a5
> [  486.528000]  [<ffffffff81520fa3>] ? __do_page_fault+0x191/0x3f5
> [  486.528000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
> [  486.528000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
> [  486.528000]  [<ffffffff8151e232>] ? page_fault+0x22/0x30
> [  486.528000]  [<ffffffff8129cfe0>] ? __put_user_4+0x20/0x30
> [  486.528000]  [<ffffffff81066629>] ? schedule_tail+0x5c/0x60
> [  486.528000]  [<ffffffff81524b7f>] ? ret_from_fork+0xf/0xb0

Please enable CONFIG_FRAME_POINTER to get better backtraces, but the
above suggests the pagefault swevent, will have a look.
