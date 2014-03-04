Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbaCDNVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:21:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:4688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757200AbaCDNVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:21:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,585,1389772800"; 
   d="scan'208";a="485774947"
Date: Tue, 4 Mar 2014 21:21:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        linux-fsdevel@vger.kernel.org
Subject: [blk-lib] 6a0608544e5: fileio -77.4% max latency, -5.7% throughput
Message-ID: <20140304132130.GB28854@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,

FYI, we noticed the below changes on

git://evilpiepirate.org/~kent/linux-bcache.git for-jens
commit 6a0608544e5672bd9a044c285119547eae41abe5 ("blk-lib.c: generic_make_request() handles large bios now")

test case: snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqrewr-sync

11541d5f5b7002b  6a0608544e5672bd9a044c285  
---------------  -------------------------  
      1885 ~60%     -77.4%        426 ~ 7%  TOTAL fileio.request_latency_max_ms
      6258 ~ 0%      -5.7%       5904 ~ 0%  TOTAL fileio.requests_per_sec
        26 ~ 1%    +702.3%        211 ~ 8%  TOTAL slabinfo.kmalloc-4096.num_slabs
       217 ~ 1%    +682.3%       1697 ~ 8%  TOTAL slabinfo.kmalloc-4096.num_objs
        26 ~ 1%    +702.3%        211 ~ 8%  TOTAL slabinfo.kmalloc-4096.active_slabs
       211 ~ 2%    +701.5%       1697 ~ 8%  TOTAL slabinfo.kmalloc-4096.active_objs
         2 ~ 0%     -50.0%          1 ~ 0%  TOTAL vmstat.procs.b
      2236 ~ 0%     +63.6%       3659 ~ 3%  TOTAL slabinfo.kmalloc-256.num_objs
      2217 ~ 0%     +63.4%       3623 ~ 3%  TOTAL slabinfo.kmalloc-256.active_objs
      3274 ~ 1%     +47.8%       4837 ~ 2%  TOTAL proc-vmstat.nr_slab_unreclaimable
     13096 ~ 1%     +47.7%      19350 ~ 2%  TOTAL meminfo.SUnreclaim
  62558204 ~ 5%     -30.7%   43379766 ~ 1%  TOTAL cpuidle.C3-SNB.time
     91031 ~ 4%     -29.4%      64253 ~ 2%  TOTAL cpuidle.C1E-SNB.usage
     34092 ~ 2%     -17.6%      28085 ~ 1%  TOTAL cpuidle.C3-SNB.usage
      2656 ~ 2%     -15.0%       2258 ~ 2%  TOTAL proc-vmstat.kswapd_high_wmark_hit_quickly
    266339 ~ 2%     +14.2%     304129 ~ 0%  TOTAL cpuidle.C6-SNB.usage
     21899 ~ 2%      +9.6%      23992 ~ 2%  TOTAL interrupts.RES
        20 ~ 0%      -8.0%         18 ~ 2%  TOTAL time.percent_of_cpu_this_job_got
   3430189 ~ 0%      -5.9%    3226430 ~ 0%  TOTAL time.voluntary_context_switches
       117 ~ 0%      -6.0%        110 ~ 0%  TOTAL time.system_time
     11691 ~ 0%      -5.6%      11042 ~ 0%  TOTAL vmstat.system.cs
       711 ~ 0%      +4.4%        742 ~ 0%  TOTAL iostat.sda.await
       712 ~ 0%      +4.4%        743 ~ 0%  TOTAL iostat.sda.w_await
     99142 ~ 0%      -2.2%      96963 ~ 0%  TOTAL iostat.sda.wkB/s
     99257 ~ 0%      -2.2%      97110 ~ 0%  TOTAL vmstat.io.bo
       139 ~ 0%      +1.7%        141 ~ 0%  TOTAL iostat.sda.avgqu-sz



                               fileio.requests_per_sec

   6300 ++----------------------------------------------------------*-------+
   6250 *+.*..  .*.*..*..*..*..*..*.*..*..*..*..*..*.*..*..*..*..*.   *..*..*
        |     *.                                                            |
   6200 ++                                                                  |
   6150 ++                                                                  |
        |                                                                   |
   6100 ++                                                                  |
   6050 ++                                                                  |
   6000 ++                        O                                         |
        |     O                                            O                |
   5950 O+ O                                         O                      |
   5900 ++       O    O  O     O                              O             |
        |          O        O       O  O     O     O                        |
   5850 ++                                O     O       O                   |
   5800 ++------------------------------------------------------------------+


                            fileio.request_latency_max_ms

   4500 ++------------------------------------------------------------------+
        |                                                             *     |
   4000 ++                                                            :     |
   3500 ++                                                            ::    |
        |                                                            : :    |
   3000 ++                                   *                       : :    |
   2500 ++                             *..  + :    *                 :  :   |
        |                             +    +   :  + :                :  :   |
   2000 ++        .*..               +    *    : +  :                :  :   |
   1500 ++       *    *..   *..    .*           *    : .*..*..*..*..:    : .*
        *..    ..         ..     .*                  *.             :    *. |
   1000 ++   .*          *     *.                                   *       |
    500 ++ *.         O                                                     |
        O  O  O  O O     O  O  O  O O  O  O  O  O  O O  O  O  O             |
      0 ++------------------------------------------------------------------+



Thanks,
Fengguang
