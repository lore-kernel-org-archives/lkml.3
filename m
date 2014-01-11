Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaAKKUM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 05:20:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:13384 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbaAKKUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 05:20:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,643,1384329600"; 
   d="scan'208";a="457129409"
Date: Sat, 11 Jan 2014 18:19:58 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        lkp@linux.intel.com
Subject: [sched] 73628fba4: +69% context switches
Message-ID: <20140111101956.GA11150@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

FYI, we find much increased interrupts and context switches introduced
by commit 73628fba4 ("sched: unify imbalance bias for target group")
in your noload branch:

7bea8c18805a5f1  73628fba451ae72221b155696  
---------------  -------------------------  
     14979 ~ 4%   +1304.8%     210434 ~ 1%  lkp-ne04/micro/aim7/shell_rtns_1
      2748 ~ 5%    +977.4%      29607 ~ 0%  nhm-white/micro/aim7/shared
     17727        +1254.1%     240041       TOTAL interrupts.RES

7bea8c18805a5f1  73628fba451ae72221b155696  
---------------  -------------------------  
      3617 ~ 0%     +69.2%       6118 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
      3617          +69.2%       6118       TOTAL vmstat.system.in

7bea8c18805a5f1  73628fba451ae72221b155696  
---------------  -------------------------  
    132746 ~ 0%     +69.0%     224346 ~ 1%  lkp-ne04/micro/aim7/shell_rtns_1
    220038 ~ 0%      +6.0%     233218 ~ 0%  nhm-white/micro/aim7/shared
    352785          +29.7%     457564       TOTAL time.involuntary_context_switches

7bea8c18805a5f1  73628fba451ae72221b155696  
---------------  -------------------------  
   1424581 ~ 0%      +8.6%    1546786 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
   1424581           +8.6%    1546786       TOTAL time.voluntary_context_switches

7bea8c18805a5f1  73628fba451ae72221b155696  
---------------  -------------------------  
     20982 ~ 0%     +12.5%      23599 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
      6005 ~ 0%      +4.2%       6256 ~ 0%  nhm-white/micro/aim7/shared
     26988          +10.6%      29856       TOTAL vmstat.system.cs

                                  vmstat.system.cs

   24000 ++-------------------------O---------------------------------------+
         O           O           O                              O     O     |
   23500 ++ O  O  O           O                        O     O     O     O  |
         |                 O           O   O  O  O  O     O                 |
   23000 ++             O                                                   |
         |                                                                  |
   22500 ++                                                                 |
         |                                                                  |
   22000 ++                                                                 |
         |                                                                  |
   21500 ++                                                                 |
         |             .*..           .*...*..*..*..*..*..                  |
   21000 *+.  .*..*..*.    *..*..  .*.                    *..*..*..*..*..*..*
         |  *.                   *.                                         |
   20500 ++-----------------------------------------------------------------+


                             time.voluntary_context_switches

   1.56e+06 ++----------O-------------O-----------------O-------O-----------+
            O  O  O  O                      O     O        O O        O     |
   1.54e+06 ++             O       O     O                         O     O  |
   1.52e+06 ++               O  O              O     O                      |
            |                                                               |
    1.5e+06 ++                                                              |
            |                                                               |
   1.48e+06 ++                                                              |
            |                                                               |
   1.46e+06 ++                                                              |
   1.44e+06 ++                                                              |
            |             .*.        .*..     .*..                          |
   1.42e+06 *+.*..*..*..*.   *..*..*.    *..*.    *..*..*..*.*..*..*..*..*..*
            |                                                               |
    1.4e+06 ++--------------------------------------------------------------+


                           time.involuntary_context_switches

   240000 ++----------------------------------------------------------------+
   230000 ++                                           O        O           |
          O        O  O           O  O     O     O        O  O     O  O  O  |
   220000 ++ O  O        O     O        O                                   |
   210000 ++                O                 O     O                       |
   200000 ++                                                                |
   190000 ++                                                                |
          |                                                                 |
   180000 ++                                                                |
   170000 ++                                                                |
   160000 ++                                                                |
   150000 ++                                                                |
          |                                                                 |
   140000 ++            .*..                    .*..*..*..        .*..      |
   130000 *+-*--*--*--*-----*--*--*--*--*--*--*-----------*--*--*-----*--*--*


                                  vmstat.system.in

   6500 ++------------------------------------------------------------------+
        |                                                       O           |
   6000 O+       O  O            O  O                 O  O   O     O  O  O  |
        |  O  O        O   O  O        O  O  O  O  O                        |
        |                                                                   |
   5500 ++                                                                  |
        |                                                                   |
   5000 ++                                                                  |
        |                                                                   |
   4500 ++                                                                  |
        |                                                                   |
        |                                                                   |
   4000 ++                                                                  |
        |                                                  ..*..  .*..*..*..|
   3500 *+-*--*--*--*--*---*--*--*--*--*--*--*--*--*--*--*------*-----------*

Thanks,
Fengguang
