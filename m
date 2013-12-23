Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab3LWFOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:14:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:57224 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab3LWFOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:14:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,534,1384329600"; 
   d="scan'208";a="448521768"
Date: Mon, 23 Dec 2013 13:14:12 +0800
From: fengguang.wu@intel.com
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: 5d4cf996cf1: -84.0% fileio.request_latency_max_ms
Message-ID: <20131223051412.GB29169@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

We are glad to reprort much improved fileio.request_latency_max_ms on commit

commit 5d4cf996cf134e8ddb4f906b8197feb9267c2b77
Author: Mel Gorman <mgorman@suse.de>
Date:   Tue Dec 17 09:21:25 2013 +0000

    sched: Assign correct scheduling domain to 'sd_llc'
    
    Commit 42eb088e (sched: Avoid NULL dereference on sd_busy) corrected a NULL
    dereference on sd_busy but the fix also altered what scheduling domain it
    used for the 'sd_llc' percpu variable.
    
    One impact of this is that a task selecting a runqueue may consider
    idle CPUs that are not cache siblings as candidates for running.
    Tasks are then running on CPUs that are not cache hot.
    
    This was found through bisection where ebizzy threads were not seeing equal
    performance and it looked like a scheduling fairness issue. This patch
    mitigates but does not completely fix the problem on all machines tested
    implying there may be an additional bug or a common root cause. Here are
    the average range of performance seen by individual ebizzy threads. It
    was tested on top of candidate patches related to x86 TLB range flushing.
    
    	4-core machine
    			    3.13.0-rc3            3.13.0-rc3
    			       vanilla            fixsd-v3r3
    	Mean   1        0.00 (  0.00%)        0.00 (  0.00%)
    	Mean   2        0.34 (  0.00%)        0.10 ( 70.59%)
    	Mean   3        1.29 (  0.00%)        0.93 ( 27.91%)
    	Mean   4        7.08 (  0.00%)        0.77 ( 89.12%)
    	Mean   5      193.54 (  0.00%)        2.14 ( 98.89%)
    	Mean   6      151.12 (  0.00%)        2.06 ( 98.64%)
    	Mean   7      115.38 (  0.00%)        2.04 ( 98.23%)
    	Mean   8      108.65 (  0.00%)        1.92 ( 98.23%)
    
    	8-core machine
    	Mean   1         0.00 (  0.00%)        0.00 (  0.00%)
    	Mean   2         0.40 (  0.00%)        0.21 ( 47.50%)
    	Mean   3        23.73 (  0.00%)        0.89 ( 96.25%)
    	Mean   4        12.79 (  0.00%)        1.04 ( 91.87%)
    	Mean   5        13.08 (  0.00%)        2.42 ( 81.50%)
    	Mean   6        23.21 (  0.00%)       69.46 (-199.27%)
    	Mean   7        15.85 (  0.00%)      101.72 (-541.77%)
    	Mean   8       109.37 (  0.00%)       19.13 ( 82.51%)
    	Mean   12      124.84 (  0.00%)       28.62 ( 77.07%)
    	Mean   16      113.50 (  0.00%)       24.16 ( 78.71%)
    
    It's eliminated for one machine and reduced for another.
    
    Signed-off-by: Mel Gorman <mgorman@suse.de>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Alex Shi <alex.shi@linaro.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Fengguang Wu <fengguang.wu@intel.com>
    Cc: H Peter Anvin <hpa@zytor.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Link: http://lkml.kernel.org/r/20131217092124.GV11295@suse.de
    Signed-off-by: Ingo Molnar <mingo@kernel.org>


9dbdb155532395b  5d4cf996cf134e8ddb4f906b8  
---------------  -------------------------  
      1898 ~110%     -84.0%        303 ~28%  snb-drag/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-seqwr-sync
      1898          -84.0%        303       TOTAL fileio.request_latency_max_ms

9dbdb155532395b  5d4cf996cf134e8ddb4f906b8  
---------------  -------------------------  
      1712 ~ 3%     +75.1%       2997 ~ 3%  snb-drag/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-seqwr-sync
      1712          +75.1%       2997       TOTAL proc-vmstat.nr_tlb_remote_flush

9dbdb155532395b  5d4cf996cf134e8ddb4f906b8  
---------------  -------------------------  
      1774 ~ 3%     +74.3%       3093 ~ 3%  snb-drag/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-seqwr-sync
      1774          +74.3%       3093       TOTAL proc-vmstat.nr_tlb_remote_flush_received

9dbdb155532395b  5d4cf996cf134e8ddb4f906b8  
---------------  -------------------------  
      1707 ~ 2%     +64.7%       2812 ~ 2%  snb-drag/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-seqwr-sync
      1707          +64.7%       2812       TOTAL proc-vmstat.kswapd_high_wmark_hit_quickly

9dbdb155532395b  5d4cf996cf134e8ddb4f906b8  
---------------  -------------------------  
     13752 ~ 4%     -71.5%       3916 ~ 1%  snb-drag/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-seqwr-sync
     13752          -71.5%       3916       TOTAL time.involuntary_context_switches

9dbdb155532395b  5d4cf996cf134e8ddb4f906b8  
---------------  -------------------------  
   2797211 ~ 0%     +22.8%    3434219 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-seqwr-sync
   2797211          +22.8%    3434219       TOTAL time.voluntary_context_switches

9dbdb155532395b  5d4cf996cf134e8ddb4f906b8  
---------------  -------------------------  
      9885 ~ 0%     +22.4%      12102 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-seqwr-sync
      9885          +22.4%      12102       TOTAL vmstat.system.cs

9dbdb155532395b  5d4cf996cf134e8ddb4f906b8  
---------------  -------------------------  
         6 ~ 0%     +16.7%          7 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-seqwr-sync
         6          +16.7%          7       TOTAL time.percent_of_cpu_this_job_got

9dbdb155532395b  5d4cf996cf134e8ddb4f906b8  
---------------  -------------------------  
     39.61 ~ 0%     +14.9%      45.50 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-seqwr-sync
     39.61          +14.9%      45.50       TOTAL time.system_time


Here are the visualized comparison of all GOOD/BAD commits during the bisect:

                            fileio.request_latency_max_ms

   8000 ++------------------------------------------------------------------+
        |                              *                                    |
   7000 *+ *                           :                            *       |
   6000 ++ :       *                   :                            :       |
        |  :       :                   :                            :       |
   5000 ++ ::      :                  ::                           : :      |
        |: ::      ::                 ::                           : :      |
   4000 ++ ::      ::                 : :                          : :      |
        |:: :      ::                 : :                          : :      |
   3000 ++: :     : :                 : :                          : :      |
   2000 ++: :     : :                 : :                          :  :     |
        | :  :    :  :               :  :                         :   :     |
   1000 ++:  :    :  :.*    .*.*     :  :        .*.              :   *     |
        | *  **.*.*  *  *.**    *.*.** O*.*.**.**   **.*.**.**.*.**    *.**.*
      0 O+OO-OO-O-OO-O-OO-OO-O-O----------O-OO-OO-O-OO-O-O--OO-O--O-O-OO----+


                            time.voluntary_context_switches

   3.5e+06 ++---------------------------------------------------------------+
           O OO OO OO OO OO O OO OO OO OO O OO OO  O  O  O   OO  O OO OO    |
   3.4e+06 ++                                     O  O  O  O    O           |
           |                                                                |
   3.3e+06 ++                                                               |
   3.2e+06 ++                                                               |
           |                                                                |
   3.1e+06 ++                                                               |
           |                                                                |
     3e+06 ++                                                               |
   2.9e+06 ++                                                               |
           |       *              *. *.                                     |
   2.8e+06 *+* .* + *.*      .**. : *  **.*.**. *. *.* .**.   *.* .* .* .* .*
           |  *  *     *.**.*    *             *  *   *    *.*   *  *  *  * |
   2.7e+06 ++---------------------------------------------------------------+


                          time.involuntary_context_switches

   16000 ++-----------------------------------------------------------------+
         |     *                                                            |
   14000 ++    :+ .**.*   .**.     * .*   .* .**.  .*.*   *.*.*   *.   *.**.*
         *.**.*  *     *.*    **. + *  *.*  *    **    *.*     *.*  *.*     |
   12000 ++                      *                                          |
         |                                                                  |
   10000 ++                                                                 |
         |                                                                  |
    8000 ++                                                                 |
         |                                                                  |
    6000 ++                                                                 |
         |                                                                  |
    4000 O+OO OO O OO OO O OO OO O OO OO O OO OO OO O OO OO O OO OO O OO    |
         |                                                                  |
    2000 ++-----------------------------------------------------------------+


                                  vmstat.system.cs

   12500 ++-----------------------------------------------------------------+
         |                                               O  O          O    |
   12000 O+OO OO O OO OO O OO OO O OO OO O OO OO OO O OO      OO OO O O     |
         |                                                O                 |
         |                                                                  |
   11500 ++                                                                 |
         |                                                                  |
   11000 ++                                                                 |
         |                                                                  |
   10500 ++                                                                 |
         |                                                                  |
         *.      *. *            *. *.             .*                       |
   10000 ++* .* +  * +      *.* +  *  **.*.**.**.**  + *.**.*.**. *. .* .* .*
         |  *  *      **.*.*   *                      *          *  *  *  * |
    9500 ++-----------------------------------------------------------------+

