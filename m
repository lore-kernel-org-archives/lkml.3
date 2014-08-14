Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaHNGBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 02:01:44 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60514 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaHNGBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 02:01:42 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [RFC/PATCHSET 0/3] perf tools: Callchain improvement with --children and -g caller
Date: Thu, 14 Aug 2014 15:01:37 +0900
Message-Id: <1407996100-6359-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset tries to improve the callchain behavior when caller
ordering (which is not default) and --children (which is default)
enabled.  I think that we might need to change default to caller
ordering when --children is enabled - but it needs more discussion of
course.

The "perf report -g" displays callchains callee-first order by default.
That means it can see the callers of the sample in a reverse order.
For example, "intel_idle" entry shows following callchain on my data.
    
      Children      Self  Command          Shared Object       Symbol
      --------  --------  ---------------  ------------------  ----------------
        40.53%    40.53%  swapper          [kernel.kallsyms]   [k] intel_idle
                  |
                   --- intel_idle
                       cpuidle_enter
                       cpuidle_wrap_enter
                       cpuidle_enter_tk
                       cpuidle_idle_call
                       cpu_idle
                      |
                      |--85.25%-- start_secondary
                      |
                       --14.75%-- rest_init
                                 start_kernel
                                 x86_64_start_reservations
                                 x86_64_start_kernel
    
So "intel_idle" was called by "cpuidle_enter", and in turn, it's
called by "cpuidle_wrap_enter" and so on.
    
When with -g "caller", it shows callchains in a reversed order -
"caller-first".  I know it's sometimes useful but never used it
by myself though.
    
        40.53%    40.53%  swapper          [kernel.kallsyms]   [k] intel_idle
                        |
                        |--85.25%-- start_secondary
                        |          cpu_idle
                        |          cpuidle_idle_call
                        |          cpuidle_enter_tk
                        |          cpuidle_wrap_enter
                        |          cpuidle_enter
                        |          intel_idle
                        |
                         --14.75%-- x86_64_start_kernel
                                   x86_64_start_reservations
                                   start_kernel
                                   rest_init
                                   cpu_idle
                                   cpuidle_idle_call
                                   cpuidle_enter_tk
                                   cpuidle_wrap_enter
                                   cpuidle_enter
                                   intel_idle
    
However, with --children feature added, it now can show all *callees*
of the entry and I think it could be very useful.  For example,
"start_kernel" entry now can display it calls rest_init and in turn
cpu_idle and then cpuidle_idle_call (95.72%).
    
         6.14%     0.00%  swapper          [kernel.kallsyms]   [k] start_kernel
                       |
                        --- start_kernel
                            rest_init
                            cpu_idle
                           |
                           |--97.52%-- cpuidle_idle_call
                           |          cpuidle_enter_tk
                           |          |
                           |          |--99.91%-- cpuidle_wrap_enter
                           |          |          cpuidle_enter
                           |          |          intel_idle
                           |           --0.09%-- [...]
                            --2.48%-- [...]
    
Note that start_kernel has no self overhead - meaning that it never
get sampled by itself but constructs such a nice callgraph.  But,
sadly, if an entry has self overhead, callchain will get confused with
generated callchain (like above) and self callchains (which reversed
order) like the eariler example.
    
To be consistent with other entries, I'd like to make it just to show
a single entry - itself - like below since it doesn't have callees
(children) at all.  But still use the whole callchain to construct
children entries (like the start_kernel) as usual.
    
        40.53%    40.53%  swapper          [kernel.kallsyms]   [k] intel_idle
                        |
                        --- intel_idle
    
Note that this is just for --children is enabled.  Without that, it
will do the original behavior.

Okay, here is a real case other that pure self (intel_idle) and pure
generated (start_kernel) entries.  Without this patch the "cpu_idle"
entry in the above data shows callchain info like following.  Note
that it has 0.15% of self overhead.

  $ perf report --children --g caller
  ...
  # Children      Self  Command          Shared Object       Symbol           
  # ........  ........  ...............  ..................  .................
  #
      53.42%     0.15%  swapper          [kernel.kallsyms]   [k] cpu_idle
                    |--99.72%-- cpu_idle
                    |          |          
                    |          |--84.44%-- cpuidle_idle_call
                    |          |          |          
                    |          |          |--92.67%-- cpuidle_enter_tk
                    |          |          |
                    |          |          /* snip */
                    |          |          
                    |          |--7.83%-- tick_nohz_idle_exit
                    |          |          |          
                    |          |          |--77.61%-- hrtimer_cancel
                    |          |          |          hrtimer_try_to_cancel
                    |          |          |          __remove_hrtimer
                    |          |          |          timerqueue_del
                    |          |          |          rb_erase
                    |          |          |          
                    |          |           --22.39%-- account_idle_ticks
                    |          |                     irqtime_account_process_tick.isra.2
                    |          |          
                    |          |--7.07%-- schedule
                    |          |          __schedule
                    |          |          perf_event_task_sched_out
                    |          |          
                    |           --0.65%-- cpuidle_get_cpu_driver
                    |          
                     --0.28%-- x86_64_start_kernel         /* <==== XXX */
                               x86_64_start_reservations
                               start_kernel
                               rest_init
                               cpu_idle

As you can see, mostly it just calls other functions - cpuidle_idle_call,
tick_nohz_idle_exit schedule or cpuidle_get_cpu_driver.  But 0.28% of it
shows as it it called x86_64_start_kernel which is not correct.  It just
came from the reversed self callchain info.

With this patchset applied, the incorrect 0.28% is disappeared and it
moves under cpu_idle itself (with [...]).

      53.42%     0.15%  swapper          [kernel.kallsyms]   [k] cpu_idle
                    |
                    --- cpu_idle
                       |          
                       |--84.20%-- cpuidle_idle_call
                       |          |          
                       |          |--92.67%-- cpuidle_enter_tk
                       |          |          |          
                       |          |          /* snip */
                       |
                       |--7.81%-- tick_nohz_idle_exit
                       |          |          
                       |          |--77.61%-- hrtimer_cancel
                       |          |          hrtimer_try_to_cancel
                       |          |          __remove_hrtimer
                       |          |          timerqueue_del
                       |          |          rb_erase
                       |          |          
                       |           --22.39%-- account_idle_ticks
                       |                     irqtime_account_process_tick.isra.2
                       |          
                       |--7.05%-- schedule
                       |          __schedule
                       |          perf_event_task_sched_out
                       |          
                       |--0.65%-- cpuidle_get_cpu_driver
                        --0.28%-- [...]   /*  <=====  this is the self overhead */


You can get this from 'perf/caller-chain-v1' branch on my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcomed, thanks
Namhyung


Namhyung Kim (3):
  perf report: Relax -g option parsing not to limit the option order
  perf tools: Put callers above callee when callchain order is caller
  perf callchain: Prune misleading callchains for self entries

 tools/perf/ui/hist.c        |  8 ++--
 tools/perf/util/callchain.c | 95 ++++++++++++++++++---------------------------
 tools/perf/util/hist.c      | 23 ++++++++++-
 3 files changed, 65 insertions(+), 61 deletions(-)

-- 
2.0.0

