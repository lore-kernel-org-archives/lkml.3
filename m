Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbbALSHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:07:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:64478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbbALSHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:07:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,745,1413270000"; 
   d="scan'208";a="660612266"
From: "Liang, Kan" <kan.liang@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V6 1/1] perf tool: perf diff support for different
 binaries
Thread-Topic: [PATCH V6 1/1] perf tool: perf diff support for different
 binaries
Thread-Index: AQHQKcCYJ7KOEpNzNUyoh7SK6Z35IZyyvomAgAn9D5A=
Date: Mon, 12 Jan 2015 18:06:53 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701694FB9@SHSMSX103.ccr.corp.intel.com>
References: <1417534758-26416-1-git-send-email-kan.liang@intel.com>
 <20150106145356.GA10675@kernel.org> <20150106161607.GA15396@kernel.org>
In-Reply-To: <20150106161607.GA15396@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Em Tue, Jan 06, 2015 at 11:53:56AM -0300, Arnaldo Carvalho de Melo
> escreveu:
> > Em Tue, Dec 02, 2014 at 10:39:18AM -0500, kan.liang@intel.com escreveu:
> > > Currently, the perf diff only works with same binaries. That's
> > > because it compares the symbol start address. It doesn't work if the
> > > perf.data comes from different binaries. This patch matches the
> function names.
> 
> > Sorry Kan, I saw these patches, its just that it the above statement
> > looked completely strange to me, i.e. of course it should look at the
> > dso name, then at the symbol name, comparing via addresses makes no
> > sense to me, so I kept leaving this patch to look after processing
> > other patches and doing other things, then the year end holidays, etc.
> 
> > So now I'm looking at old code, from 2009:
> 
> >   commit 604c5c92972dcb4b98be34775452d09a5d4ec248
> >   Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> >   Date:   Wed Dec 16 14:09:53 2009 -0200
> 
> >     perf diff: Change the default sort order to "dso,symbol"
> 
> <SNIP>
> 
> > Now I'm trying to figure out _when_ this got broken, what was the
> > reasoning for that code to have changed in a way that made it not match
> by dso_name, symbol_name.
> 
> <SNIP>
> 
> > > New perf diff result.
> > > [lk@localhost perf_diff]$ perf diff example_v1.data example_v2.data
> > >                      [kernel.vmlinux]  [k] __perf_event_task_sched_out
> > >      0.00%           [kernel.vmlinux]  [k] apic_timer_interrupt
> > >                      [kernel.vmlinux]  [k] idle_cpu
> > >                      [kernel.vmlinux]  [k] intel_pstate_timer_func
> > >                      [kernel.vmlinux]  [k] native_read_msr_safe
> > >      0.00%           [kernel.vmlinux]  [k] native_read_tsc
> > >      0.00%           [kernel.vmlinux]  [k] native_write_msr_safe
> > >                      [kernel.vmlinux]  [k] ntp_tick_length
> > >      0.00%           [kernel.vmlinux]  [k] rb_erase
> > >      0.00%           [kernel.vmlinux]  [k] tick_sched_timer
> > >      0.00%           [kernel.vmlinux]  [k] unmap_single_vma
> > >      0.00%           [kernel.vmlinux]  [k] update_wall_time
> > >      0.00%           example           [.] f1
> > >     46.24%   -0.08%  example           [.] f2
> > >     53.71%   +0.11%  example           [.] f3
> > >      0.02%           example           [.] main
> 
> So, with:
> 
> [root@ssdandy l]# perf --version
> perf version 3.1.rc9.37.g3f2728.dirty
> 
> commit 3f2728bdb6a4cad0d18b09d03e2008121c902751
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Wed Oct 5 16:10:06 2011 -0300
> 
>     perf report: Add option to show total period
> 
> I get:
> 
> [root@ssdandy l]# gcc example_v1.c -o example [root@ssdandy l]# perf
> record -F 10000 ./example [ perf record: Woken up 7 times to write data ]
> [ perf record: Captured and wrote 1.739 MB perf.data (~75981 samples) ]
> [root@ssdandy l]# gcc example_v2.c -o example [root@ssdandy l]# perf
> record -F 10000 ./example [ perf record: Woken up 7 times to write data ]
> [ perf record: Captured and wrote 1.733 MB perf.data (~75735 samples) ]
> [root@ssdandy l]# perf diff
> # Baseline  Delta          Shared Object                       Symbol
> # ........ ..........  .................  ...........................
> #
>      0.00%    +53.60%  example            [.] f3
>     54.23%     -8.02%  example            [.] f2
>      0.02%             [kernel.kallsyms]  [k] native_read_msr_safe
>      0.04%     -0.01%  [kernel.kallsyms]  [k] native_write_msr_safe
>      0.01%             [kernel.kallsyms]  [k] thermal_interrupt
>      0.01%             [kernel.kallsyms]  [k] apic_timer_interrupt
>      0.00%             [kernel.kallsyms]  [k] update_wall_time
>      0.00%             example            [.] main
>      0.00%             example            [.] f1
>      0.00%             [kernel.kallsyms]  [k] notifier_call_chain
>      0.00%             [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>      0.01%             [kernel.kallsyms]  [k] _raw_spin_lock
>      0.00%             [kernel.kallsyms]  [k] native_read_tsc
>      0.00%             [kernel.kallsyms]  [k] task_tick_fair
>      0.00%             [kernel.kallsyms]  [k] account_user_time
>      0.00%             [kernel.kallsyms]  [k] unmap_page_range
>      0.00%             [kernel.kallsyms]  [k] kfree
>      0.00%             [kernel.kallsyms]  [k] sidtab_context_to_sid
>      0.00%             ld-2.17.so         [.] _dl_relocate_object
>      0.00%             [kernel.kallsyms]  [k] update_cfs_rq_blocked_load
>      0.00%             [kernel.kallsyms]  [k] perf_event_task_tick
>      0.00%             [kernel.kallsyms]  [k] rcu_irq_enter
>      0.00%             [kernel.kallsyms]  [k] run_timer_softirq
>      0.00%             [kernel.kallsyms]  [k] task_cputime
>      0.00%             [kernel.kallsyms]  [k] exit_idle
>      0.00%             [kernel.kallsyms]  [k] __update_cpu_load
>      0.00%             [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
>      0.00%             [kernel.kallsyms]  [k] account_process_tick
>      0.00%             [kernel.kallsyms]  [k] raise_softirq
>      0.00%             [kernel.kallsyms]  [k] update_process_times
>      0.01%             [kernel.kallsyms]  [k] native_sched_clock
>      0.00%             [kernel.kallsyms]  [k] therm_throt_process
>      0.00%             [kernel.kallsyms]  [k] intel_thermal_interrupt
>      0.01%             [kernel.kallsyms]  [k] update_vsyscall
>      0.00%             [kernel.kallsyms]  [k] jiffies_to_timeval
>      0.00%             [kernel.kallsyms]  [k] intel_pstate_timer_func
>      0.00%             [kernel.kallsyms]  [k] x86_pmu_disable
>      0.00%             [kernel.kallsyms]  [k] __do_softirq
>      0.00%             [kernel.kallsyms]  [k] hrtimer_interrupt
>      0.00%             [kernel.kallsyms]  [k] tick_sched_do_timer
>      0.00%             [kernel.kallsyms]  [k] do_softirq
>      0.00%             [kernel.kallsyms]  [k] sidtab_search_core
>      0.00%             [kernel.kallsyms]  [k] selinux_inode_permission
>      0.00%             [kernel.kallsyms]  [k] kmem_cache_alloc
>      0.00%             [kernel.kallsyms]  [k] finish_wait
> [root@ssdandy l]#
> 
> After this there were the changes to allow using the hists browser to be
> used with 'top' and 'diff' was left broken for a while, I'll see if I can continue
> bisecting this after lunch.
> 

Hi Arnaldo,

I'm not quite what should I modified for this patch.

I think it may be broken after the commit as below (not test)
9c443dfdd31e ("perf diff: Fix support for all --sort combinations").

Should I change the patch description to bug fix, remove the examples,
 and remove the changes in Documentation?

It's only one-line change, so I will keep the code part.

What do you think?

Thanks,
Kan


