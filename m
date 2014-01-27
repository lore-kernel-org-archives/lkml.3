Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaA0Q7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 11:59:17 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42706 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbaA0Q7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:59:16 -0500
Date: Mon, 27 Jan 2014 08:59:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [rcu] c0f4dfd4f9: -53% perf-stat.cpu-migrations
Message-ID: <20140127165912.GN9012@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140124123320.GC27801@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124123320.GC27801@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012716-1542-0000-0000-0000058D819F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 08:33:20PM +0800, Fengguang Wu wrote:
> Hi Paul,
> 
> Just FYI, we noticed -53% perf-stat.cpu-migrations in dd write tests
> on btrfs, which looks good. First good commit is

Nice!  ;-)

							Thanx, Paul

> commit c0f4dfd4f90f1667d234d21f15153ea09a2eaa66
> Author:     Paul E. McKenney <paul.mckenney@linaro.org>
> AuthorDate: Fri Dec 28 11:30:36 2012 -0800
> Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CommitDate: Tue Mar 26 08:04:51 2013 -0700
> 
>     rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks
>     
>     Because RCU callbacks are now associated with the number of the grace
>     period that they must wait for, CPUs can now take advance callbacks
>     corresponding to grace periods that ended while a given CPU was in
>     dyntick-idle mode.  This eliminates the need to try forcing the RCU
>     state machine while entering idle, thus reducing the CPU intensiveness
>     of RCU_FAST_NO_HZ, which should increase its energy efficiency.
>     
>     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
>  Documentation/kernel-parameters.txt |  28 ++-
>  include/linux/rcupdate.h            |   1 +
>  init/Kconfig                        |  17 +-
>  kernel/rcutree.c                    |  28 +--
>  kernel/rcutree.h                    |  12 +-
>  kernel/rcutree_plugin.h             | 374 ++++++++++--------------------------
>  kernel/rcutree_trace.c              |   2 -
>  7 files changed, 149 insertions(+), 313 deletions(-)
> 
> b11cc5760a9c48c  c0f4dfd4f90f1667d234d21f1  
> ---------------  -------------------------  
>      86878 ~138%     -90.3%       8397 ~152%   cpuidle.POLL.time
>        154 ~16%     -87.3%         19 ~55%   cpuidle.POLL.usage
>   12177976 ~ 4%     -85.6%    1748244 ~20%   cpuidle.C1-NHM.time
>     381439 ~ 3%     -68.4%     120538 ~ 2%   softirqs.RCU
>       0.53 ~87%    +161.8%       1.40 ~16%   perf-profile.cpu-cycles.copy_user_generic_string.__btrfs_buffered_write.btrfs_file_aio_write.do_sync_write.vfs_write
>    5227241 ~ 4%     -58.3%    2180928 ~ 7%   cpuidle.C1E-NHM.time
>       0.67 ~88%     +88.6%       1.26 ~21%   perf-profile.cpu-cycles.calc_csum_metadata_size.btrfs_delalloc_release_metadata.btrfs_clear_bit_hook.clear_state_bit.clear_extent_bit
>     231531 ~ 2%     -48.3%     119653 ~ 2%   interrupts.LOC
>      91019 ~ 2%     -40.2%      54404 ~ 2%   cpuidle.C3-NHM.usage
>  1.991e+08 ~ 3%     -36.7%   1.26e+08 ~ 7%   cpuidle.C3-NHM.time
>       7.07 ~ 4%     -32.7%       4.76 ~ 8%   turbostat.%c3
>      23380 ~33%     +41.2%      33024 ~ 6%   proc-vmstat.kswapd_low_wmark_hit_quickly
>      62805 ~ 3%     -28.4%      44960 ~ 2%   softirqs.SCHED
>      64678 ~ 1%     -30.1%      45195 ~ 1%   softirqs.TIMER
>      55051 ~ 3%     -22.2%      42823 ~ 2%   interrupts.0:IO-APIC-edge.timer
>        920 ~ 4%     +19.2%       1097 ~ 5%   slabinfo.kmalloc-512.active_objs
>        920 ~ 4%     +19.2%       1097 ~ 5%   slabinfo.kmalloc-512.num_objs
>     361987 ~ 2%      +9.9%     397730 ~ 0%   cpuidle.C6-NHM.usage
>       5.30 ~ 1%      -9.7%       4.78 ~ 1%   turbostat.%c1
>     178105 ~ 3%     -53.5%      82837 ~ 1%   perf-stat.cpu-migrations
>       5763 ~ 8%     -44.7%       3186 ~22%   vmstat.system.cs
>    3566268 ~ 8%     -44.8%    1968744 ~21%   perf-stat.context-switches
>        658 ~ 2%     -30.4%        458 ~ 0%   vmstat.system.in
>   53376814 ~12%     -24.2%   40482438 ~22%   perf-stat.node-load-misses
>  2.996e+10 ~ 3%     -10.8%  2.672e+10 ~ 3%   perf-stat.L1-icache-load-misses
>  1.998e+09 ~ 4%     -11.6%  1.766e+09 ~ 2%   perf-stat.branch-misses
>  1.005e+12 ~ 5%     -11.9%  8.852e+11 ~ 6%   perf-stat.stalled-cycles-frontend
>  6.344e+08 ~ 2%      -6.8%  5.915e+08 ~ 2%   perf-stat.LLC-store-misses
>  2.892e+10 ~ 2%      +5.4%  3.047e+10 ~ 3%   perf-stat.bus-cycles
> 
> 
>                               perf-stat.cpu-migrations
> 
>    90000 ++*----*----------*-*---*------*-----------------------------------+
>          *   **   *.*.**.*     *  *.*.*   **.*.*.*.*   .*.                  |
>    80000 ++                                         *.*   *                 |
>          |                                                                  |
>    70000 ++                                                                 |
>          |                                                                  |
>    60000 ++                                                                 |
>          |                                                                  |
>    50000 ++                                                                 |
>          |                                                                  |
>    40000 ++                                                                 |
>          | O O                                                              |
>    30000 O+     O O O OO O O O O OO O O O OO O O O OO O O O O OO O O O OO O O
>          |    O                                                             |
>    20000 ++-----------------------------------------------------------------+
> 

