Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbaGRH3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:29:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:5273 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932477AbaGRH3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:29:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,683,1400050800"; 
   d="scan'208";a="458509021"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: pjt@google.com, bsegall@google.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, fengguang.wu@intel.com,
        Yuyang Du <yuyang.du@intel.com>
Subject: [PATCH 0/2 v4] sched: Rewrite per entity runnable load average tracking
Date: Fri, 18 Jul 2014 07:26:04 +0800
Message-Id: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Morten, Ben, and Fengguang.

v4 changes:

- Insert memory barrier before writing cfs_rq->load_last_update_copy.
- Fix typos.

We carried out some performance tests (thanks to Fengguang and his LKP). The results are shown
as follows. The patchset (including two patches) is on top of mainline v3.16-rc3. To make a fair
and clear comparison, we have two parts:

(1) v3.16-rc3 vs. PATCH 1/2 + 2/2
(2) PATCH 1/2 vs. PATCH 1/2 + 2/2

Overall, this rewrite has better performance, and reduced net overhead in load average tracking.

--------------------------------------------------------------------------------------

host: lkp-snb01
model: Sandy Bridge-EP
memory: 32G

host: lkp-sb03
model: Sandy Bridge-EP
memory: 64G

host: lkp-nex04
model: Nehalem-EX
memory: 256G

host: xps2
model: Nehalem
memory: 4G

host: lkp-a0x
model: Atom
memory: 8G

Legend:
	[+-]XX% - change percent
	~XX%    - stddev percent

(1) v3.16-rc3         PATCH 1/2 + 2/2
---------------  -------------------------  
      0.03 ~ 0%      +0.0%       0.03 ~ 0%  snb-drag/fileio/600s-100%-1HDD-ext4-64G-1024f-seqwr-sync
     51.72 ~ 1%      +0.5%      51.99 ~ 1%  snb-drag/fileio/600s-100%-1HDD-xfs-64G-1024f-rndrd-sync
     53.24 ~ 0%      +0.9%      53.72 ~ 0%  snb-drag/fileio/600s-100%-1HDD-xfs-64G-1024f-rndrw-sync
      0.01 ~ 0%      +0.0%       0.01 ~ 0%  snb-drag/fileio/600s-100%-1HDD-xfs-64G-1024f-rndwr-sync
      3.27 ~ 0%      -0.1%       3.27 ~ 0%  snb-drag/fileio/600s-100%-1HDD-xfs-64G-1024f-seqrd-sync
      0.02 ~ 0%      +0.0%       0.02 ~ 0%  snb-drag/fileio/600s-100%-1HDD-xfs-64G-1024f-seqrewr-sync
      0.02 ~ 0%      +0.0%       0.02 ~ 0%  snb-drag/fileio/600s-100%-1HDD-xfs-64G-1024f-seqwr-sync
    108.31 ~ 1%      +0.7%     109.06 ~ 0%  TOTAL fileio.request_latency_95%_ms

---------------  -------------------------  
    155810 ~ 3%     +62.6%     253355 ~ 0%  lkp-snb01/hackbench/1600%-process-pipe
    146931 ~ 1%      +5.5%     154948 ~ 0%  lkp-snb01/hackbench/1600%-process-socket
    172780 ~ 1%     +23.0%     212579 ~ 2%  lkp-snb01/hackbench/1600%-threads-pipe
    152966 ~ 0%      +3.6%     158433 ~ 0%  lkp-snb01/hackbench/1600%-threads-socket
     95943 ~ 0%      +2.7%      98501 ~ 0%  lkp-snb01/hackbench/50%-process-pipe
     86759 ~ 0%     +79.4%     155606 ~ 0%  lkp-snb01/hackbench/50%-process-socket
     90232 ~ 0%      +3.3%      93205 ~ 0%  lkp-snb01/hackbench/50%-threads-pipe
     79416 ~ 0%     +85.6%     147379 ~ 0%  lkp-snb01/hackbench/50%-threads-socket
    980841 ~ 1%     +29.9%    1274010 ~ 0%  TOTAL hackbench.throughput

---------------  -------------------------  
  3.02e+08 ~ 5%      -2.5%  2.944e+08 ~ 3%  lkp-a06/qperf/600s
  3.02e+08 ~ 5%      -2.5%  2.944e+08 ~ 3%  TOTAL qperf.sctp.bw

---------------  -------------------------  
 6.578e+08 ~ 1%      +1.1%  6.651e+08 ~ 1%  lkp-a06/qperf/600s
 6.578e+08 ~ 1%      +1.1%  6.651e+08 ~ 1%  TOTAL qperf.tcp.bw

---------------  -------------------------  
 6.678e+08 ~ 0%      +0.7%  6.728e+08 ~ 0%  lkp-a06/qperf/600s
 6.678e+08 ~ 0%      +0.7%  6.728e+08 ~ 0%  TOTAL qperf.udp.recv_bw

---------------  -------------------------  
 6.721e+08 ~ 0%      +1.1%  6.797e+08 ~ 0%  lkp-a06/qperf/600s
 6.721e+08 ~ 0%      +1.1%  6.797e+08 ~ 0%  TOTAL qperf.udp.send_bw

---------------  -------------------------  
     55388 ~ 2%      -1.9%      54324 ~ 0%  lkp-a06/qperf/600s
     55388 ~ 2%      -1.9%      54324 ~ 0%  TOTAL qperf.sctp.latency

---------------  -------------------------  
     39988 ~ 1%      -1.0%      39581 ~ 0%  lkp-a06/qperf/600s
     39988 ~ 1%      -1.0%      39581 ~ 0%  TOTAL qperf.tcp.latency

---------------  -------------------------  
     33022 ~ 2%      -1.6%      32484 ~ 0%  lkp-a06/qperf/600s
     33022 ~ 2%      -1.6%      32484 ~ 0%  TOTAL qperf.udp.latency

---------------  -------------------------  
   1048360 ~ 0%      +0.0%    1048360 ~ 0%  lkp-a05/iperf/300s-udp
   1048360 ~ 0%      +0.0%    1048360 ~ 0%  TOTAL iperf.udp.bps

---------------  -------------------------  
 4.801e+09 ~ 2%      -2.4%  4.688e+09 ~ 0%  lkp-a05/iperf/300s-tcp
 4.801e+09 ~ 2%      -2.4%  4.688e+09 ~ 0%  TOTAL iperf.tcp.receiver.bps

---------------  -------------------------  
 4.801e+09 ~ 2%      -2.4%  4.688e+09 ~ 0%  lkp-a05/iperf/300s-tcp
 4.801e+09 ~ 2%      -2.4%  4.688e+09 ~ 0%  TOTAL iperf.tcp.sender.bps

---------------  -------------------------  
    140261 ~ 1%      +2.6%     143971 ~ 0%  lkp-sb03/nepim/300s-100%-udp
    126862 ~ 1%      +4.4%     132471 ~ 4%  lkp-sb03/nepim/300s-100%-udp6
    577494 ~ 3%      -2.7%     561810 ~ 2%  lkp-sb03/nepim/300s-25%-udp
    515120 ~ 2%      +3.3%     532350 ~ 2%  lkp-sb03/nepim/300s-25%-udp6
   1359739 ~ 3%      +0.8%    1370604 ~ 2%  TOTAL nepim.udp.avg.kbps_in

---------------  -------------------------  
    160888 ~ 2%      +3.2%     165964 ~ 2%  lkp-sb03/nepim/300s-100%-udp
    127159 ~ 1%      +4.4%     132798 ~ 4%  lkp-sb03/nepim/300s-100%-udp6
    653177 ~ 3%      -1.0%     646770 ~ 3%  lkp-sb03/nepim/300s-25%-udp
    515540 ~ 2%      +4.1%     536440 ~ 2%  lkp-sb03/nepim/300s-25%-udp6
   1456766 ~ 3%      +1.7%    1481974 ~ 3%  TOTAL nepim.udp.avg.kbps_out

---------------  -------------------------  
    680285 ~ 1%      +1.7%     691663 ~ 1%  lkp-sb03/nepim/300s-100%-tcp
    645357 ~ 1%      +1.2%     653140 ~ 1%  lkp-sb03/nepim/300s-100%-tcp6
   2850752 ~ 1%      +0.0%    2851577 ~ 0%  lkp-sb03/nepim/300s-25%-tcp
   2588447 ~ 1%      +0.2%    2593352 ~ 0%  lkp-sb03/nepim/300s-25%-tcp6
   6764842 ~ 1%      +0.4%    6789733 ~ 0%  TOTAL nepim.tcp.avg.kbps_in

---------------  -------------------------  
    680449 ~ 1%      +1.7%     691824 ~ 1%  lkp-sb03/nepim/300s-100%-tcp
    645502 ~ 1%      +1.2%     653247 ~ 1%  lkp-sb03/nepim/300s-100%-tcp6
   2850934 ~ 1%      +0.0%    2851776 ~ 0%  lkp-sb03/nepim/300s-25%-tcp
   2588647 ~ 1%      +0.2%    2593553 ~ 0%  lkp-sb03/nepim/300s-25%-tcp6
   6765533 ~ 1%      +0.4%    6790402 ~ 0%  TOTAL nepim.tcp.avg.kbps_out

---------------  -------------------------  
     45789 ~ 1%      +1.9%      46658 ~ 0%  lkp-sb03/nuttcp/300s
     45789 ~ 1%      +1.9%      46658 ~ 0%  TOTAL nuttcp.throughput_Mbps

---------------  -------------------------  
     47139 ~ 4%      +3.6%      48854 ~ 3%  lkp-sb03/thrulay/300s
     47139 ~ 4%      +3.6%      48854 ~ 3%  TOTAL thrulay.throughput

---------------  -------------------------  
      0.02 ~11%     -10.1%       0.02 ~12%  lkp-sb03/thrulay/300s
      0.02 ~11%     -10.1%       0.02 ~12%  TOTAL thrulay.jitter

---------------  -------------------------  
      0.10 ~ 5%      -3.3%       0.10 ~ 4%  lkp-sb03/thrulay/300s
      0.10 ~ 5%      -3.3%       0.10 ~ 4%  TOTAL thrulay.RTT

---------------  -------------------------  
  75644346 ~ 0%      +0.5%   76029397 ~ 0%  xps2/pigz/100%-128K
  77167258 ~ 0%      +0.5%   77522343 ~ 0%  xps2/pigz/100%-512K
 152811604 ~ 0%      +0.5%  153551740 ~ 0%  TOTAL pigz.throughput

---------------  -------------------------  
     12773 ~ 0%      -1.2%      12615 ~ 0%  lkp-nex04/ebizzy/200%-100x-10s
     12773 ~ 0%      -1.2%      12615 ~ 0%  TOTAL ebizzy.throughput

---------------  -------------------------  
      6.87 ~ 2%     -83.6%       1.12 ~ 3%  lkp-snb01/hackbench/50%-process-socket
      6.43 ~ 2%     -79.8%       1.30 ~ 1%  lkp-snb01/hackbench/50%-threads-socket
     13.30 ~ 2%     -81.8%       2.42 ~ 2%  TOTAL perf-profile.cpu-cycles._raw_spin_lock_irqsave.__wake_up_sync_key.sock_def_readable.unix_stream_sendmsg.sock_aio_write

---------------  -------------------------  
      0.90 ~42%     -77.3%       0.20 ~16%  lkp-snb01/hackbench/1600%-process-pipe
      0.90 ~42%     -77.3%       0.20 ~16%  TOTAL perf-profile.cpu-cycles.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common.__wake_up_sync_key

---------------  -------------------------  
      1.76 ~ 2%     -83.7%       0.29 ~ 8%  lkp-snb01/hackbench/50%-process-socket
      1.08 ~ 1%     -71.8%       0.30 ~ 3%  lkp-snb01/hackbench/50%-threads-socket
      2.84 ~ 2%     -79.2%       0.59 ~ 5%  TOTAL perf-profile.cpu-cycles.__schedule.schedule.schedule_timeout.unix_stream_recvmsg.sock_aio_read

---------------  -------------------------  
      1.78 ~33%     -63.6%       0.65 ~28%  lkp-snb01/hackbench/1600%-process-pipe
      0.92 ~31%     -59.9%       0.37 ~30%  lkp-snb01/hackbench/1600%-threads-pipe
      1.55 ~10%    -100.0%       0.00 ~ 0%  lkp-snb01/hackbench/50%-process-socket
      1.84 ~ 5%     +14.9%       2.11 ~ 2%  lkp-snb01/hackbench/50%-threads-pipe
      1.43 ~ 9%     -79.7%       0.29 ~ 2%  lkp-snb01/hackbench/50%-threads-socket
      7.51 ~17%     -54.5%       3.42 ~10%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common

---------------  -------------------------  
      0.89 ~20%     -88.0%       0.11 ~19%  lkp-snb01/hackbench/1600%-process-pipe
      0.47 ~ 5%    +110.0%       0.98 ~13%  lkp-snb01/hackbench/50%-process-pipe
      1.35 ~14%     -19.7%       1.09 ~13%  TOTAL perf-profile.cpu-cycles.__schedule.schedule_user.sysret_careful.__write_nocancel

---------------  -------------------------  
      2.81 ~ 2%     +40.3%       3.94 ~ 5%  lkp-snb01/hackbench/50%-process-pipe
      1.37 ~ 7%     -82.5%       0.24 ~ 5%  lkp-snb01/hackbench/50%-process-socket
      2.84 ~ 1%     +42.8%       4.06 ~ 1%  lkp-snb01/hackbench/50%-threads-pipe
      1.56 ~ 3%     -75.2%       0.39 ~ 4%  lkp-snb01/hackbench/50%-threads-socket
      8.58 ~ 3%      +0.5%       8.63 ~ 3%  TOTAL perf-profile.cpu-cycles.idle_cpu.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function

---------------  -------------------------  
      2.60 ~33%     -72.5%       0.72 ~16%  lkp-snb01/hackbench/1600%-process-pipe
      0.97 ~15%     -52.8%       0.46 ~17%  lkp-snb01/hackbench/1600%-threads-pipe
      2.85 ~ 1%     +26.9%       3.62 ~ 3%  lkp-snb01/hackbench/50%-process-pipe
      6.42 ~16%     -25.3%       4.80 ~ 6%  TOTAL perf-profile.cpu-cycles.__schedule.schedule.pipe_wait.pipe_read.new_sync_read

---------------  -------------------------  
      1.14 ~22%     -75.2%       0.28 ~16%  lkp-snb01/hackbench/1600%-process-pipe
      0.91 ~14%     -56.9%       0.39 ~16%  lkp-snb01/hackbench/1600%-threads-pipe
      0.88 ~ 2%     +36.5%       1.20 ~ 6%  lkp-snb01/hackbench/50%-process-pipe
      0.88 ~ 2%     +41.6%       1.25 ~ 2%  lkp-snb01/hackbench/50%-threads-pipe
      3.82 ~11%     -18.0%       3.13 ~ 6%  TOTAL perf-profile.cpu-cycles.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common


(2) PATCH 1/2         PATCH 1/2 + 2/2 
---------------  -------------------------  
      6.73 ~ 2%     -83.3%       1.12 ~ 3%  lkp-snb01/hackbench/50%-process-socket
      6.63 ~ 0%     -80.4%       1.30 ~ 1%  lkp-snb01/hackbench/50%-threads-socket
     13.36 ~ 1%     -81.9%       2.42 ~ 2%  TOTAL perf-profile.cpu-cycles._raw_spin_lock_irqsave.__wake_up_sync_key.sock_def_readable.unix_stream_sendmsg.sock_aio_write

---------------  -------------------------  
      1.10 ~46%     -81.5%       0.20 ~16%  lkp-snb01/hackbench/1600%-process-pipe
      1.10 ~46%     -81.5%       0.20 ~16%  TOTAL perf-profile.cpu-cycles.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common.__wake_up_sync_key

---------------  -------------------------  
      1.80 ~ 1%     -84.0%       0.29 ~ 8%  lkp-snb01/hackbench/50%-process-socket
      1.09 ~ 1%     -72.2%       0.30 ~ 3%  lkp-snb01/hackbench/50%-threads-socket
      2.89 ~ 1%     -79.6%       0.59 ~ 5%  TOTAL perf-profile.cpu-cycles.__schedule.schedule.schedule_timeout.unix_stream_recvmsg.sock_aio_read

---------------  -------------------------  
      1.29 ~29%     -49.7%       0.65 ~28%  lkp-snb01/hackbench/1600%-process-pipe
      0.83 ~47%     -55.8%       0.37 ~30%  lkp-snb01/hackbench/1600%-threads-pipe
      1.38 ~ 7%    -100.0%       0.00 ~ 0%  lkp-snb01/hackbench/50%-process-socket
      1.61 ~ 4%     -82.0%       0.29 ~ 2%  lkp-snb01/hackbench/50%-threads-socket
      5.11 ~18%     -74.5%       1.30 ~23%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common

---------------  -------------------------  
      0.83 ~14%     -87.1%       0.11 ~19%  lkp-snb01/hackbench/1600%-process-pipe
      0.50 ~ 3%     +97.3%       0.98 ~13%  lkp-snb01/hackbench/50%-process-pipe
      1.33 ~10%     -18.1%       1.09 ~13%  TOTAL perf-profile.cpu-cycles.__schedule.schedule_user.sysret_careful.__write_nocancel

---------------  -------------------------  
      1.19 ~21%     -52.1%       0.57 ~30%  lkp-snb01/hackbench/1600%-threads-pipe
      2.95 ~ 0%     +33.6%       3.94 ~ 5%  lkp-snb01/hackbench/50%-process-pipe
      1.52 ~ 6%     -84.2%       0.24 ~ 5%  lkp-snb01/hackbench/50%-process-socket
      2.98 ~ 1%     +36.4%       4.06 ~ 1%  lkp-snb01/hackbench/50%-threads-pipe
      1.50 ~ 3%     -74.2%       0.39 ~ 4%  lkp-snb01/hackbench/50%-threads-socket
     10.13 ~ 4%      -9.2%       9.20 ~ 5%  TOTAL perf-profile.cpu-cycles.idle_cpu.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function

---------------  -------------------------  
      2.85 ~35%     -74.9%       0.72 ~16%  lkp-snb01/hackbench/1600%-process-pipe
      0.92 ~13%     -50.2%       0.46 ~17%  lkp-snb01/hackbench/1600%-threads-pipe
      2.92 ~ 1%     +23.9%       3.62 ~ 3%  lkp-snb01/hackbench/50%-process-pipe
      6.69 ~17%     -28.3%       4.80 ~ 6%  TOTAL perf-profile.cpu-cycles.__schedule.schedule.pipe_wait.pipe_read.new_sync_read

---------------  -------------------------  
    153533 ~ 2%     +65.0%     253355 ~ 0%  lkp-snb01/hackbench/1600%-process-pipe
    152059 ~ 0%      +1.9%     154948 ~ 0%  lkp-snb01/hackbench/1600%-process-socket
    174164 ~ 2%     +22.1%     212579 ~ 2%  lkp-snb01/hackbench/1600%-threads-pipe
    158193 ~ 0%      +0.2%     158433 ~ 0%  lkp-snb01/hackbench/1600%-threads-socket
     94656 ~ 0%      +4.1%      98501 ~ 0%  lkp-snb01/hackbench/50%-process-pipe
     87638 ~ 0%     +77.6%     155606 ~ 0%  lkp-snb01/hackbench/50%-process-socket
     89973 ~ 0%      +3.6%      93205 ~ 0%  lkp-snb01/hackbench/50%-threads-pipe
     80210 ~ 0%     +83.7%     147379 ~ 0%  lkp-snb01/hackbench/50%-threads-socket
    990430 ~ 1%     +28.6%    1274010 ~ 0%  TOTAL hackbench.throughput

---------------  -------------------------  
    702188 ~ 0%      -1.5%     691663 ~ 1%  lkp-sb03/nepim/300s-100%-tcp
    655502 ~ 0%      -0.4%     653140 ~ 1%  lkp-sb03/nepim/300s-100%-tcp6
   2860533 ~ 0%      -0.3%    2851577 ~ 0%  lkp-sb03/nepim/300s-25%-tcp
   2609335 ~ 0%      -0.6%    2593352 ~ 0%  lkp-sb03/nepim/300s-25%-tcp6
   6827559 ~ 0%      -0.6%    6789733 ~ 0%  TOTAL nepim.tcp.avg.kbps_in

---------------  -------------------------  
    702354 ~ 0%      -1.5%     691824 ~ 1%  lkp-sb03/nepim/300s-100%-tcp
    655502 ~ 0%      -0.3%     653247 ~ 1%  lkp-sb03/nepim/300s-100%-tcp6
   2860734 ~ 0%      -0.3%    2851776 ~ 0%  lkp-sb03/nepim/300s-25%-tcp
   2609536 ~ 0%      -0.6%    2593553 ~ 0%  lkp-sb03/nepim/300s-25%-tcp6
   6828128 ~ 0%      -0.6%    6790402 ~ 0%  TOTAL nepim.tcp.avg.kbps_out

---------------  -------------------------  
    140076 ~ 0%      +2.8%     143971 ~ 0%  lkp-sb03/nepim/300s-100%-udp
    126302 ~ 0%      +4.9%     132471 ~ 4%  lkp-sb03/nepim/300s-100%-udp6
    557984 ~ 0%      +0.7%     561810 ~ 2%  lkp-sb03/nepim/300s-25%-udp
    501648 ~ 1%      +6.1%     532350 ~ 2%  lkp-sb03/nepim/300s-25%-udp6
   1326011 ~ 0%      +3.4%    1370604 ~ 2%  TOTAL nepim.udp.avg.kbps_in

---------------  -------------------------  
    162279 ~ 1%      +2.3%     165964 ~ 2%  lkp-sb03/nepim/300s-100%-udp
    127240 ~ 1%      +4.4%     132798 ~ 4%  lkp-sb03/nepim/300s-100%-udp6
    649372 ~ 1%      -0.4%     646770 ~ 3%  lkp-sb03/nepim/300s-25%-udp
    502056 ~ 1%      +6.8%     536440 ~ 2%  lkp-sb03/nepim/300s-25%-udp6
   1440949 ~ 1%      +2.8%    1481974 ~ 3%  TOTAL nepim.udp.avg.kbps_out

---------------  -------------------------  
     49149 ~ 1%      -0.6%      48854 ~ 3%  lkp-sb03/thrulay/300s
     49149 ~ 1%      -0.6%      48854 ~ 3%  TOTAL thrulay.throughput

---------------  -------------------------  
      0.02 ~ 9%      +3.6%       0.02 ~12%  lkp-sb03/thrulay/300s
      0.02 ~ 9%      +3.6%       0.02 ~12%  TOTAL thrulay.jitter

---------------  -------------------------  
      0.10 ~ 1%      +2.1%       0.10 ~ 4%  lkp-sb03/thrulay/300s
      0.10 ~ 1%      +2.1%       0.10 ~ 4%  TOTAL thrulay.RTT

---------------  -------------------------  
 4.817e+09 ~ 1%      -2.7%  4.688e+09 ~ 0%  lkp-a05/iperf/300s-tcp
 4.817e+09 ~ 1%      -2.7%  4.688e+09 ~ 0%  TOTAL iperf.tcp.receiver.bps

---------------  -------------------------  
 4.817e+09 ~ 1%      -2.7%  4.688e+09 ~ 0%  lkp-a05/iperf/300s-tcp
 4.817e+09 ~ 1%      -2.7%  4.688e+09 ~ 0%  TOTAL iperf.tcp.sender.bps

---------------  -------------------------  
 3.036e+08 ~ 7%      -3.0%  2.944e+08 ~ 3%  lkp-a06/qperf/600s
 3.036e+08 ~ 7%      -3.0%  2.944e+08 ~ 3%  TOTAL qperf.sctp.bw

---------------  -------------------------  
 6.678e+08 ~ 0%      -0.4%  6.651e+08 ~ 1%  lkp-a06/qperf/600s
 6.678e+08 ~ 0%      -0.4%  6.651e+08 ~ 1%  TOTAL qperf.tcp.bw

---------------  -------------------------  
  6.73e+08 ~ 0%      -0.0%  6.728e+08 ~ 0%  lkp-a06/qperf/600s
  6.73e+08 ~ 0%      -0.0%  6.728e+08 ~ 0%  TOTAL qperf.udp.recv_bw

---------------  -------------------------  
 6.773e+08 ~ 0%      +0.4%  6.797e+08 ~ 0%  lkp-a06/qperf/600s
 6.773e+08 ~ 0%      +0.4%  6.797e+08 ~ 0%  TOTAL qperf.udp.send_bw

---------------  -------------------------  
     54508 ~ 2%      -0.3%      54324 ~ 0%  lkp-a06/qperf/600s
     54508 ~ 2%      -0.3%      54324 ~ 0%  TOTAL qperf.sctp.latency

---------------  -------------------------  
     39293 ~ 1%      +0.7%      39581 ~ 0%  lkp-a06/qperf/600s
     39293 ~ 1%      +0.7%      39581 ~ 0%  TOTAL qperf.tcp.latency

---------------  -------------------------  
     31924 ~ 0%      +1.8%      32484 ~ 0%  lkp-a06/qperf/600s
     31924 ~ 0%      +1.8%      32484 ~ 0%  TOTAL qperf.udp.latency

---------------  -------------------------  
   1048360 ~ 0%      +0.0%    1048360 ~ 0%  lkp-a05/iperf/300s-udp
   1048360 ~ 0%      +0.0%    1048360 ~ 0%  TOTAL iperf.udp.bps

---------------  -------------------------  
     45897 ~ 0%      +1.7%      46658 ~ 0%  lkp-sb03/nuttcp/300s
     45897 ~ 0%      +1.7%      46658 ~ 0%  TOTAL nuttcp.throughput_Mbps

---------------  -------------------------  
  75801537 ~ 0%      +0.3%   76029397 ~ 0%  xps2/pigz/100%-128K
  77314567 ~ 0%      +0.3%   77522343 ~ 0%  xps2/pigz/100%-512K
 153116104 ~ 0%      +0.3%  153551740 ~ 0%  TOTAL pigz.throughput

---------------  -------------------------  
     12763 ~ 0%      -1.2%      12615 ~ 0%  lkp-nex04/ebizzy/200%-100x-10s
     12763 ~ 0%      -1.2%      12615 ~ 0%  TOTAL ebizzy.throughput

--------------------------------------------------------------------------------------

Regarding the overflow issue, we now have for both entity and cfs_rq:

struct sched_avg {
    .....
    u64 load_sum;
    unsigned long load_avg;
    .....
};

Given the weight for both entity and cfs_rq is:

struct load_weight {
    unsigned long weight;
    .....
};

So, load_sum's max is 47742 * load.weight (which is unsigned long), then on 32bit,
it is absolutly safe. On 64bit, with unsigned long being 64bit, but we can afford
about 4353082796 (=2^64/47742/88761) entities with the highest weight (=88761)
always runnable, even considering we may multiply 1<<15 in decay_load64, we can
still support 132845 (=4353082796/2^15) always runnable, which should be acceptible.

load_avg = load_sum / 47742 = load.weight (which is unsigned long), so it should be
perfectly safe for both entity (even with arbitrary user group share) and cfs_rq on
both 32bit and 64bit. Originally, we saved this division, but have to get it back
because of the overflow issue on 32bit (actually load average itself is safe from
overflow, but the rest of the code referencing it always uses long, such as cpu_load,
etc., which prevents it from saving).

v3 changes:

Many thanks to Ben for v3 revision.

- Fix overflow issue both for entity and cfs_rq on both 32bit and 64bit.
- Track all entities (both task and group entity) due to group entity's clock issue.
  This actually improves code simplicity.
- Make a copy of cfs_rq sched_avg's last_update_time, to read an intact 64bit
  variable on 32bit machine when in data race (hope I did it right).
- Minor fixes and code improvement.

v2 changes:

Thanks to PeterZ and Ben for their help in fixing the issues and improving
the quality, and Fengguang and his 0Day in finding compile errors in different
configurations for version 2.

- Batch update the tg->load_avg, making sure it is up-to-date before update_cfs_shares
- Remove migrating task from the old CPU/cfs_rq, and do so with atomic operations


Yuyang Du (2):
  sched: Remove update_rq_runnable_avg
  sched: Rewrite per entity runnable load average tracking

 include/linux/sched.h |   21 +-
 kernel/sched/debug.c  |   30 +--
 kernel/sched/fair.c   |  566 ++++++++++++++++---------------------------------
 kernel/sched/proc.c   |    2 +-
 kernel/sched/sched.h  |   22 +-
 5 files changed, 207 insertions(+), 434 deletions(-)

-- 
1.7.9.5

