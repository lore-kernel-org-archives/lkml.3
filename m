Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab3KAHy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:54:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:28038 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab3KAHy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:54:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,615,1378882800"; 
   d="scan'208";a="420728630"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH 0/4] per anon_vma lock and turn anon_vma rwsem lock to rwlock_t
Date: Fri,  1 Nov 2013 15:54:23 +0800
Message-Id: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 turns locking the anon_vma's root to locking itself to let it be
a per anon_vma lock, which would reduce contentions.

In the same time, lock range becomes quite small then, which is bascially
a call of anon_vma_interval_tree_insert(). Patch 2 turn rwsem to rwlock_t.
It's a patch made from Ingo, I just made some change to let it apply based on
patch 1.

Patch 3 is from Peter. It was a diff, I edited it to be a patch ;)

Here is the detailed changed stats with this patch applied. The test base is v3.12-rc7,
and 1c00bef768d4341afa7d is patch 1, e3e37183ee805f33e88f is patch 2.

NOTE: both commits are compared to base v3.12-rc7.

      1c00bef768d4341afa7d      e3e37183ee805f33e88f  
  ------------------------  ------------------------  
       +35.0%                    +89.9%               brickland1/micro/aim7/fork_test
       +28.4%                    +49.3%               lkp-ib03/micro/aim7/fork_test
        +2.0%                     +2.7%               lkp-ib03/micro/aim7/shared
        -0.4%                     +0.0%               lkp-sb03/micro/aim7/dbase
       +16.4%                    +59.0%               lkp-sb03/micro/aim7/fork_test
        +0.1%                     +0.3%               lkp-sb03/micro/aim7/shared
        +2.2%                     +5.0%               TOTAL aim7.2000.jobs-per-min

      1c00bef768d4341afa7d      e3e37183ee805f33e88f  
  ------------------------  ------------------------  
       -25.9%      1008.55       -47.3%       717.39  brickland1/micro/aim7/fork_test
        -1.4%       641.19        -3.4%       628.45  brickland1/micro/hackbench/1600%-process-pipe
        -1.0%       122.84        +1.1%       125.36  brickland1/micro/netperf/120s-200%-UDP_RR
        +0.0%       121.29        +0.2%       121.57  lkp-a04/micro/netperf/120s-200%-TCP_SENDFILE
       -22.1%       351.41       -26.3%       332.54  lkp-ib03/micro/aim7/fork_test
        -1.9%        31.33        -2.6%        31.11  lkp-ib03/micro/aim7/shared
        -0.4%       630.36        +0.4%       635.05  lkp-ib03/micro/hackbench/1600%-process-socket
        -0.0%       612.62        +1.8%       623.80  lkp-ib03/micro/hackbench/1600%-threads-socket
       -14.1%       340.30       -37.1%       249.26  lkp-sb03/micro/aim7/fork_test
        -0.1%        41.31        -0.3%        41.22  lkp-sb03/micro/aim7/shared
        -0.0%       614.26        +0.6%       617.81  lkp-sb03/micro/hackbench/1600%-process-socket
       -10.4%      4515.47       -18.2%      4123.55  TOTAL time.elapsed_time


      1c00bef768d4341afa7d      e3e37183ee805f33e88f  
  ------------------------  ------------------------  
       +26.7%    323386.33       -75.7%     61980.00  brickland1/micro/aim7/fork_test
       -22.9%     67734.00       -64.1%     31531.33  brickland1/micro/aim7/shared
        +0.4%      3303.67        -0.8%      3264.33  brickland1/micro/dbench/100%
        +0.7%   1871483.67        -0.4%   1850846.00  brickland1/micro/netperf/120s-200%-TCP_MAERTS
        -1.0%    109553.00        +0.4%    111038.67  brickland1/micro/pigz/100%
        -0.7%     13600.67        +0.1%     13718.67  lkp-a04/micro/netperf/120s-200%-TCP_CRR
        -4.6%    995898.00       -85.2%    154621.40  lkp-ib03/micro/aim7/fork_test
       -31.8%     32178.00       -50.3%     23442.67  lkp-ib03/micro/aim7/shared
        +1.1%   7466432.67        -0.7%   7334831.67  lkp-ib03/micro/hackbench/1600%-threads-pipe
        +2.5%   1044936.33        -1.3%   1006084.00  lkp-ib03/micro/hackbench/1600%-threads-socket
        -1.3%   5635979.00        +0.2%   5721011.67  lkp-ib03/micro/netperf/120s-200%-TCP_RR
       -24.3%     42853.33       -56.8%     24484.33  lkp-nex04/micro/aim7/shared
       -23.3%    754297.67       -83.2%    165479.00  lkp-sb03/micro/aim7/fork_test
        -7.4%     21586.00       -24.1%     17698.33  lkp-sb03/micro/aim7/shared
        +1.1%   3838724.00        +0.3%   3808206.67  lkp-sb03/micro/hackbench/1600%-process-pipe
        +0.8%   5143255.00        -1.1%   5046716.67  lkp-sb03/micro/hackbench/1600%-threads-pipe
        +2.8%    537048.67        -0.8%    518351.67  lkp-sb03/micro/hackbench/1600%-threads-socket
        +4.0%     50446.67        -5.3%     45960.00  lkp-sb03/micro/netperf/120s-200%-TCP_MAERTS
       -42.0%     52693.00       -26.4%     66849.67  lkp-sb03/micro/netperf/120s-200%-TCP_STREAM
        -0.6%  28005389.67        -7.7%  26006116.73  TOTAL vmstat.system.cs


      1c00bef768d4341afa7d      e3e37183ee805f33e88f  
  ------------------------  ------------------------  
        -4.7%        82.00       -98.8%         1.00  brickland1/micro/aim7/fork_test
       -20.5%        48.33       -94.1%         3.60  lkp-ib03/micro/aim7/fork_test
       -21.2%        36.00       -89.8%         4.67  lkp-sb03/micro/aim7/fork_test
       -13.6%       166.33       -95.2%         9.27  TOTAL vmstat.cpu.id

      1c00bef768d4341afa7d      e3e37183ee805f33e88f  
  ------------------------  ------------------------  
       +33.3%        16.00      +705.6%        96.67  brickland1/micro/aim7/fork_test
       +19.6%        59.00       +78.4%        88.00  lkp-sb03/micro/aim7/fork_test
       +22.3%        75.00      +201.1%       184.67  TOTAL vmstat.cpu.sy

      1c00bef768d4341afa7d      e3e37183ee805f33e88f  
  ------------------------  ------------------------  
       -13.5%     59181.00     +3279.0%   2312650.33  brickland1/micro/aim7/fork_test
        +0.3%   1043067.67        -0.9%   1029931.00  brickland1/micro/dbench/100%
      +618.3%    569229.67     +1052.5%    913305.60  lkp-ib03/micro/aim7/fork_test
       -18.7%    242524.33       -42.3%    172044.00  lkp-ib03/micro/aim7/shared
        +0.1%    272753.67        -0.2%    271735.67  lkp-ib03/micro/dbench/100%
       +16.9%    364987.67       -22.9%    240651.33  lkp-nex04/micro/aim7/shared
      +114.3%   2917442.33       -64.8%    479689.33  lkp-sb03/micro/aim7/fork_test
        -6.0%    215758.00       -21.8%    179471.67  lkp-sb03/micro/aim7/shared
        +4.4% 105311876.33        -1.0%  99800919.00  lkp-sb03/micro/hackbench/1600%-process-socket
        +5.5%  46760989.33        -3.7%  42696953.67  lkp-sb03/micro/hackbench/1600%-threads-socket
        +2.8% 2816418767.33        +1.8% 2789428816.27  TOTAL time.involuntary_context_switches

      1c00bef768d4341afa7d      e3e37183ee805f33e88f  
  ------------------------  ------------------------  
       +25.9%      1331.33      +632.8%      7747.67  brickland1/micro/aim7/fork_test
        -0.9%      2519.33        +0.1%      2543.67  brickland1/micro/pigz/100%
       +28.3%      1109.67      +124.5%      1941.80  lkp-ib03/micro/aim7/fork_test
        +2.2%      2806.67        +2.5%      2814.67  lkp-ib03/micro/aim7/shared
        +0.2%      4013.00        -0.1%      4000.67  lkp-ib03/micro/hackbench/1600%-process-socket
        -0.0%      4560.33        +0.1%      4564.67  lkp-ib03/micro/hackbench/1600%-threads-socket
       +15.2%       887.00       +66.3%      1280.67  lkp-sb03/micro/aim7/fork_test
        -0.1%      2780.00        +0.1%      2784.33  lkp-sb03/micro/hackbench/1600%-process-socket
        +3.5%     20007.33       +43.2%     27678.13  TOTAL time.percent_of_cpu_this_job_got

      1c00bef768d4341afa7d      e3e37183ee805f33e88f  
  ------------------------  ------------------------  
        -6.0% 158978511.67       -75.8%  40917513.33  brickland1/micro/aim7/fork_test
       -21.0%   1501457.33       -60.8%    745967.67  brickland1/micro/aim7/shared
        -1.0%  16435150.67        +0.4%  16660202.00  brickland1/micro/pigz/100%
       -24.3% 181461173.67       -81.4%  44681551.80  lkp-ib03/micro/aim7/fork_test
       -23.3%    778478.33       -46.8%    540036.33  lkp-ib03/micro/aim7/shared
        +1.4%      1626.67        -0.6%      1594.67  lkp-ib03/micro/dbench/100%
       -19.0%    970926.00       -54.2%    549055.00  lkp-nex04/micro/aim7/shared
       -31.0% 142091042.00       -80.2%  40817843.33  lkp-sb03/micro/aim7/fork_test
        -8.4%    665758.00       -26.7%    532484.67  lkp-sb03/micro/aim7/shared
        -0.8% 3656947199.67       -12.3% 3230136649.13  TOTAL time.voluntary_context_switches

      1c00bef768d4341afa7d      e3e37183ee805f33e88f  
  ------------------------  ------------------------  
        -0.1%     22463.00        -1.4%     22175.33  brickland1/micro/aim7/dbase
       +22.9%    175223.33       -79.0%     30007.33  brickland1/micro/aim7/fork_test
       -17.7%     50565.67       -51.0%     30098.33  brickland1/micro/aim7/shared
       -30.0%    174966.00        -4.8%    237762.33  brickland1/micro/hackbench/1600%-process-socket
        -1.4%     30419.33        -2.0%     30239.00  brickland1/micro/netperf/120s-200%-TCP_CRR
        -7.0%     32966.00        -0.3%     35324.00  brickland1/micro/netperf/120s-200%-TCP_MAERTS
       -21.2%     32275.00        -9.0%     37277.67  brickland1/micro/netperf/120s-200%-TCP_RR
        -2.9%     38280.00        +7.9%     42522.33  brickland1/micro/netperf/120s-200%-TCP_SENDFILE
        -2.4%     33745.33        +3.2%     35673.00  brickland1/micro/netperf/120s-200%-TCP_STREAM
        -9.9%     32513.67       -11.7%     31873.33  brickland1/micro/netperf/120s-200%-UDP_RR
        -1.7%      1087.67        -0.2%      1104.00  lkp-a04/micro/netperf/120s-200%-TCP_CRR
        -0.7%      8205.67        -0.3%      8236.67  lkp-ib03/micro/aim7/dbase
        -5.8%    500384.83       -95.8%     22462.80  lkp-ib03/micro/aim7/fork_test
       -47.1%     10672.00       -59.2%      8232.67  lkp-ib03/micro/aim7/shared
        -2.1%     13867.00        -8.0%     13029.33  lkp-ib03/micro/netperf/120s-200%-TCP_RR
       -28.5%     21725.67       -62.1%     11525.00  lkp-nex04/micro/aim7/shared
       -25.8%    360451.67       -98.4%      7816.00  lkp-sb03/micro/aim7/fork_test
        -2.8%      6801.67       -13.6%      6049.67  lkp-sb03/micro/aim7/shared
       -11.8%     35885.00        -3.8%     39142.00  lkp-sb03/micro/hackbench/1600%-process-socket
        -2.2%   1392771.67        -6.0%   1338125.33  lkp-sb03/micro/hackbench/1600%-threads-pipe
       +14.0%     11281.67        +0.7%      9959.67  lkp-sb03/micro/netperf/120s-200%-TCP_SENDFILE
        -8.6%   2986551.83       -38.8%   1998635.80  TOTAL vmstat.system.in

      1c00bef768d4341afa7d      e3e37183ee805f33e88f  
  ------------------------  ------------------------  
        +1.4%       350.18        +0.1%       345.91  brickland1/micro/aim7/dbase
        -6.7%     13193.68      +291.0%     55316.25  brickland1/micro/aim7/fork_test
        -7.9%       369.69       -16.5%       334.93  brickland1/micro/aim7/shared
        +1.7%     15760.12        +0.2%     15522.64  brickland1/micro/dbench/100%
       +87.1%         0.19       +54.8%         0.16  brickland1/micro/netperf/120s-200%-TCP_RR
        +1.0%       168.83        -0.6%       166.16  lkp-ib03/micro/aim7/dbase
        -4.2%       103.73       -11.0%        96.37  lkp-ib03/micro/aim7/shared
        +0.4%     21365.40        +2.0%     21720.47  lkp-ib03/micro/hackbench/1600%-process-pipe
        +0.0%     26374.89        +1.9%     26868.37  lkp-ib03/micro/hackbench/1600%-threads-socket
        +1.7%       147.79        +1.0%       146.73  lkp-sb03/micro/aim7/dbase
        -0.8%      2927.50        +5.0%      3099.96  lkp-sb03/micro/aim7/fork_test
        -1.1%        95.14        -5.0%        91.38  lkp-sb03/micro/aim7/shared
        +0.0%     15758.69        +0.8%     15871.96  lkp-sb03/micro/hackbench/1600%-process-socket
        +1.8%        79.81        +0.0%        78.42  lkp-sb03/micro/pigz/100%
        -0.7%     96695.65       +43.5%    139659.72  TOTAL time.system_time

      1c00bef768d4341afa7d      e3e37183ee805f33e88f  
  ------------------------  ------------------------  
        +1.4%         9.69        -0.8%         9.48  brickland1/micro/aim7/dbase
       +33.7%        16.60      +680.3%        96.90  brickland1/micro/aim7/fork_test
        -9.8%         9.93       -21.5%         8.64  brickland1/micro/aim7/shared
        +1.6%        18.43        +0.2%        18.16  brickland1/micro/dbench/100%
        -0.1%        94.68        +0.1%        94.82  brickland1/micro/netperf/120s-200%-TCP_MAERTS
        +3.3%        89.08        +3.6%        89.40  brickland1/micro/netperf/120s-200%-TCP_RR
        -0.4%        90.08        -0.0%        90.44  lkp-a04/micro/netperf/120s-200%-TCP_RR
        +0.1%        90.36        +0.3%        90.55  lkp-a04/micro/netperf/120s-200%-UDP_RR
       +31.5%        47.63      +143.9%        88.37  lkp-ib03/micro/aim7/fork_test
        -8.5%         9.62       -16.7%         8.75  lkp-ib03/micro/aim7/shared
        +0.0%        87.20        -0.2%        86.99  lkp-ib03/micro/hackbench/1600%-threads-pipe
        +0.3%        88.70        +0.6%        88.98  lkp-ib03/micro/hackbench/1600%-threads-socket
        -0.4%        88.10        -0.1%        88.39  lkp-ib03/micro/netperf/120s-200%-TCP_RR
        -1.6%        92.55        -0.4%        93.61  lkp-ib03/micro/netperf/120s-200%-TCP_SENDFILE
        +7.0%        12.22       -13.4%         9.89  lkp-nex04/micro/aim7/shared
       +18.5%        59.24       +77.0%        88.53  lkp-sb03/micro/aim7/fork_test
        -2.5%         9.86        -9.5%         9.15  lkp-sb03/micro/aim7/shared
        +0.1%        84.76        +0.2%        84.86  lkp-sb03/micro/hackbench/1600%-process-socket
        -0.0%        87.91        -0.5%        87.54  lkp-sb03/micro/hackbench/1600%-threads-pipe
        +0.2%        88.95        +0.1%        88.86  lkp-sb03/micro/hackbench/1600%-threads-socket
        +0.4%        83.69        +0.1%        83.40  lkp-sb03/micro/netperf/120s-200%-TCP_CRR
        +2.1%      1259.30       +13.9%      1405.69  TOTAL iostat.cpu.system

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michel Lespinasse <walken@google.com>
---
Ingo Molnar (1):
  mm/rmap: convert anon_vma rwsem to rwlock_t

Peter Zijlstra (1):
  mm/rmap: cleanup unnecessary code

Yuanhan Liu (2):
  mm/rmap: per anon_vma lock
  mm/rmap.c: move anon_vma initialization code into anon_vma_ctor

 include/linux/mmu_notifier.h |    2 +-
 include/linux/rmap.h         |   19 ++---
 mm/huge_memory.c             |    4 +-
 mm/mmap.c                    |   48 ++++++------
 mm/rmap.c                    |  172 +++++++----------------------------------
 5 files changed, 66 insertions(+), 179 deletions(-)

-- 
1.7.7.6

