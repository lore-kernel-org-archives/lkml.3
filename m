Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaATJbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:31:00 -0500
Received: from mga03.intel.com ([143.182.124.21]:10588 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbaATJa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:30:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="461546625"
Date: Mon, 20 Jan 2014 17:30:53 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [rcu] 878d7439d0: -100% softirqs.RCU
Message-ID: <20140120093053.GF18632@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Just FYI, we noticed the below changes in old commit 878d7439d0 ("rcu:
Fix batch-limit size problem") in test case will-it-scale/open1:

62da1921292ef78  878d7439d0f45a95869e41757  
---------------  -------------------------  
      0.00 ~200%  +60900.0%       1.22 ~18%  TOTAL perf-profile.cpu-clock.file_free_rcu.rcu_process_callbacks.__do_softirq.call_softirq.do_softirq
      0.28 ~126%    +339.3%       1.23       TOTAL perf-profile.cpu-clock.__d_lookup_rcu.link_path_walk.do_filp_open.do_sys_open.sys_open
      1.16 ~15%    -100.0%       0.00       TOTAL perf-profile.cpu-clock.file_free_rcu.rcu_process_callbacks.__do_softirq.run_ksoftirqd.smpboot_thread_fn
  1.89e+08 ~14%    -100.0%      63093 ~ 6%  TOTAL softirqs.RCU
      3.66 ~ 7%    -100.0%       0.00       TOTAL perf-profile.cpu-clock.rcu_process_callbacks.__do_softirq.run_ksoftirqd.smpboot_thread_fn.kthread
      1.29 ~11%    -100.0%       0.00       TOTAL perf-profile.cpu-clock.rcu_process_gp_end.isra.23.rcu_process_callbacks.__do_softirq.run_ksoftirqd.smpboot_thread_fn
      1.39 ~ 9%    -100.0%       0.00       TOTAL perf-profile.cpu-clock.check_for_new_grace_period.isra.25.rcu_process_callbacks.__do_softirq.run_ksoftirqd.smpboot_thread_fn
     57276 ~ 9%    +110.2%     120367 ~15%  TOTAL slabinfo.kmalloc-256.active_objs
      3582 ~ 9%    +110.0%       7525 ~15%  TOTAL slabinfo.kmalloc-256.active_slabs
      3582 ~ 9%    +110.0%       7525 ~15%  TOTAL slabinfo.kmalloc-256.num_slabs
     57331 ~ 9%    +110.0%     120407 ~15%  TOTAL slabinfo.kmalloc-256.num_objs
     23741 ~ 6%     +71.2%      40652 ~13%  TOTAL meminfo.SUnreclaim
     19830 ~ 4%     -44.1%      11094 ~ 8%  TOTAL interrupts.RES
      6113 ~ 8%     +74.6%      10674 ~12%  TOTAL proc-vmstat.nr_slab_unreclaimable
      2.44 ~13%     +62.9%       3.98 ~13%  TOTAL perf-profile.cpu-clock.__slab_alloc.kmem_cache_alloc.get_empty_filp.do_filp_open.do_sys_open
         3 ~ 0%     -33.3%          2 ~ 0%  TOTAL vmstat.procs.r
     53183 ~ 3%     +31.6%      70006 ~ 8%  TOTAL meminfo.Slab
      1001 ~ 9%     -14.3%        858 ~10%  TOTAL slabinfo.kmalloc-128.num_objs
      1001 ~ 9%     -14.3%        858 ~10%  TOTAL slabinfo.kmalloc-128.active_objs
      2.47 ~ 7%     +12.1%       2.76 ~ 6%  TOTAL perf-profile.cpu-clock.__call_rcu.call_rcu_sched.__fput.____fput.task_work_run
      6686 ~ 5%     -95.9%        272 ~ 3%  TOTAL time.involuntary_context_switches
       109 ~ 1%     +21.3%        132 ~ 1%  TOTAL time.system_time
        55 ~ 0%     +19.6%         66 ~ 0%  TOTAL time.percent_of_cpu_this_job_got
       899 ~ 3%     +10.5%        993 ~ 7%  TOTAL vmstat.system.cs

                                 time.system_time

   140 ++-------------------------------------------------------------------+
       |                    O         O    O                        O       |
   135 ++                                                                   |
       O O O   O O    O O O   O O O O   O    O   O O           O      O O O O
   130 ++    O      O                          O     O O O O O    O         |
       |                                                                    |
   125 ++                                                                   |
       |                                                                    |
   120 ++                                                                   |
       |                                                                    |
   115 ++                                                                   |
       |                         .*.              .*.          *..          |
   110 *+ .*.      .*. .*.*.*. .*   *.*.*..*.*.*.*   *. .*.   +      .*.    |
       | *   *.*.*.   *       *                        *   *.*    *.*   *   |
   105 ++-------------------------------------------------------------------+


                         time.percent_of_cpu_this_job_got

   66 O+O-O-O-O--O-O-O-O-O-O-O-O--O-O-O-O-O-O-O-O--O-O-O-O-O-O-O-O--O-O-O-O-O
      |                                                                     |
   64 ++                                                                    |
      |                                                                     |
      |                                                                     |
   62 ++                                                                    |
      |                                                                     |
   60 ++                                                                    |
      |                                                                     |
   58 ++                                                                    |
      |                           *           *                             |
      |                          + +         + +                            |
   56 ++                .*.*.   +   *.*.*.*.*   *..*.*.       .*.           |
      *.*.*.*.*..*.*.*.*     *.*                       *.*.*.*   *..*.*.*   |
   54 ++--------------------------------------------------------------------+


                          time.involuntary_context_switches

   9000 ++------------------------------------------------------------------+
        |                                              *                    |
   8000 ++ .*.*. .*   *    *. .*.*.         .*   *.   + +  .*.              |
   7000 *+*     *  + + + ..  *     *.*.*.*.*  + +  *.*   *.   *. .*.*.      |
        |           *   *                      *                *     *.*   |
   6000 ++                                                                  |
   5000 ++                                                                  |
        |                                                                   |
   4000 ++                                                                  |
   3000 ++                                                                  |
        |                                                                   |
   2000 ++                                                                  |
   1000 ++                                                                  |
        | O     O   O                                                       |
      0 O+--O-O---O---O-O--O-O-O-O-O-O-O-O-O-O-O-O-O-O-O-O--O-O-O-O-O-O-O-O-O
