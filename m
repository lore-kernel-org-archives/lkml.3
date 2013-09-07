Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab3IGMie (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 08:38:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:12490 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab3IGMi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 08:38:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,859,1371106800"; 
   d="scan'208";a="392390974"
Date: Sat, 7 Sep 2013 20:38:19 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: 3-5% increased netperf throughput by "sched: Micro-optimize the
 smart wake-affine logic"
Message-ID: <20130907123819.GA705@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

We are glad to report some measurable performance improvements by your
commit

commit 7d9ffa8961482232d964173cccba6e14d2d543b2
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Thu Jul 4 12:56:46 2013 +0800

    sched: Micro-optimize the smart wake-affine logic
    
    Smart wake-affine is using node-size as the factor currently, but the overhead
    of the mask operation is high.
    
    Thus, this patch introduce the 'sd_llc_size' percpu variable, which will record
    the highest cache-share domain size, and make it to be the new factor, in order
    to reduce the overhead and make it more reasonable.
    
    Tested-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
    Tested-by: Michael Wang <wangyun@linux.vnet.ibm.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Acked-by: Michael Wang <wangyun@linux.vnet.ibm.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Link: http://lkml.kernel.org/r/51D5008E.6030102@linux.vnet.ibm.com
    [ Tidied up the changelog. ]
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

:040000 040000 e7c8a8c55bfa1261f3c6b75674a83eb76bb88a3f 129777b8d0b74ce189760ad76d9aaecd65b7ee7f M	kernel
bisect run success

# bad: [37570e7ef5be99ba5188bb17ed547ac4bbf65e73] Merge remote-tracking branch 'nfc-next/master' into devel-hourly-2013090406
# good: [6e4664525b1db28f8c4e1130957f70a94c19213e] Linux 3.11
git bisect start '37570e7ef5be99ba5188bb17ed547ac4bbf65e73' '6e4664525b1db28f8c4e1130957f70a94c19213e' '--'
# good: [8bcaa20433634ac70c96d9e5f8ece4b8577c9694] Merge remote-tracking branch 'arm-soc/for-next' into devel-hourly-2013090406
git bisect good 8bcaa20433634ac70c96d9e5f8ece4b8577c9694
# good: [820acdf740b7d04476959189e9a144c2315339a4] drm/i915: do display power state notification on crtc enable/disable
git bisect good 820acdf740b7d04476959189e9a144c2315339a4
# bad: [5bae522a51aa6bbae54bd2d745d0320f74c40b76] Merge remote-tracking branch 'perf/perf/trace.fmt' into devel-hourly-2013090406
git bisect bad 5bae522a51aa6bbae54bd2d745d0320f74c40b76
# bad: [8afb4c018e21c882c8fad196772ef74d494185e2] perf tools: Re-implement debug print function for linking python/perf.so
git bisect bad 8afb4c018e21c882c8fad196772ef74d494185e2
# good: [17f41571bb2c4a398785452ac2718a6c5d77180e] kprobes/x86: Call out into INT3 handler directly instead of using notifier
git bisect good 17f41571bb2c4a398785452ac2718a6c5d77180e
# bad: [34f77abcb34e1da4ee3ca5c5a41b673664eee1fa] perf annotate: Put dso name in symbol annotation title
git bisect bad 34f77abcb34e1da4ee3ca5c5a41b673664eee1fa
# bad: [8404db63461af62025f32f8368861fb33604e62f] perf tests: Add attr record group sampling test
git bisect bad 8404db63461af62025f32f8368861fb33604e62f
# bad: [9a545de019b536771feefb76f85e5038b65c2190] perf: Migrate per cpu event accounting
git bisect bad 9a545de019b536771feefb76f85e5038b65c2190
# good: [62470419e993f8d9d93db0effd3af4296ecb79a5] sched: Implement smarter wake-affine logic
git bisect good 62470419e993f8d9d93db0effd3af4296ecb79a5
# bad: [90983b16078ab0fdc58f0dab3e8e3da79c9579a2] perf: Sanitize get_callchain_buffer()
git bisect bad 90983b16078ab0fdc58f0dab3e8e3da79c9579a2
# bad: [6050cb0b0b366092d1383bc23d7b16cd26db00f0] perf: Fix branch stack refcount leak on callchain init failure
git bisect bad 6050cb0b0b366092d1383bc23d7b16cd26db00f0
# bad: [7d9ffa8961482232d964173cccba6e14d2d543b2] sched: Micro-optimize the smart wake-affine logic
git bisect bad 7d9ffa8961482232d964173cccba6e14d2d543b2
# first bad commit: [7d9ffa8961482232d964173cccba6e14d2d543b2] sched: Micro-optimize the smart wake-affine logic

A comparison of all good commits [*] with all bad commits [o]
(good/bad in the sense of git bisect)

                              netperf.Throughput_Mbps

   208 ++-------------------------------------------------------------------+
   206 +OOO O OOO     OOOO       O      O     O O O       O   O             |
       O     O   O   O       OO O   O O                 O          O   O O  O
   204 ++                  O   O   O O O  OOOO O   OOOOO   OOO O OO OOO   OO|
   202 ++          O        O                                               |
       |            O                                                       |
   200 ++                                                                   |
   198 ++                                                                   |
   196 ++                                                                   |
       |                                      *                             |
   194 ++                     ****. ***  .**** **.*******.* ***             |
   192 ++                    *     *   **                  ::               |
       | *   ***          .* :                             *                |
   190 ** *.*   **.** ****  *                                               |
   188 ++------------*------------------------------------------------------+


                                  vmstat.system.in

   1640 ++----------O-------------------------------------------------------+
        O O    OO  O   O         O                O                         |
   1620 +O    O   O   O O      O   O                O      O     O     O   OO
        |    O           OOO        OO   OO      O      O O O O    OO O     |
   1600 ++ O     O            O O       O      O     OO      O    O  O   O  |
        |                   O     O    O   O O           O      O         O |
   1580 ++                                  O   O  O                        |
        |                                                                   |
   1560 ++                                                   *              |
        |                       *          *     *        *  :*             |
   1540 ++ *                    :: ***.* * :**.* ::* * .** :*               |
        |  :+ * *     *       ** **     ::*     * * * *    *                |
   1520 ++*  * ::*** +:   ** :          *                                   |
        * :    *    *  :**  ::                                              |
   1500 +*-------------*----*-----------------------------------------------+


                                  vmstat.system.cs

   10000 ++-----------------------------------------------------------------+
         *****.*****                                                        |
    9800 ++         ** .******                                              |
    9600 ++           *       :*    **  **.*  * *** .* * ****               |
         |                    * *.**  **    ** *   *  * *    *.*            |
    9400 ++                                                                 |
    9200 ++                                                                 |
         |                                                                  |
    9000 ++                                                                 |
    8800 ++  O                                                              |
         O  O   OO O                    O  OOO  O    O OOO  OO  OO  OO    O |
    8600 ++O   O  O  O  OO   OO O   O O  O    OO   O  O   OO      O   O OO OO
    8400 +O         O     OOO  O  OO O O         OO            O   O        |
         |            O                                                     |
    8200 ++-----------------------------------------------------------------+


                          lock_stat.slock-AF_INET.contentions

   110000 ++----------------------------------------------------------------+
          |                                                                 |
   105000 ++      O     O         O                O                        |
          OOO   O   O O  O OO   O   O O           O  O    O O               O
          |   O  O   O O     OOO O O   OOOOO   O      OOO    OOO O OOO OOO O|
   100000 ++ O     O                        OOO     O    O      O O       O |
          |                                      O                          |
    95000 ++                                                                |
          |                                                                 |
    90000 ++                     * * .*** * ** *. * ***      ***            |
          |            *       ** * *    * *  *  * *   ****.*               |
          |  **.* **** ::*. ** :                                            |
    85000 ***    *    * *  *  *                                             |
          |                                                                 |
    80000 ++----------------------------------------------------------------+


                lock_stat.slock-AF_INET.contentions.lock_sock_nested

   92000 ++-----------------------------------------------------------------+
   90000 ++             O         O               O                         |
         | O     O         O   O    O                O                      |
   88000 OO    O   O O   OO O   O    O  OO       O    OO  OO O O        O  OO
   86000 ++     O   O O      OO    O  OO   OO OO        O   O    OOOOOO  O  |
   84000 ++ OO    O                          O     O     O      O         O |
   82000 ++                                     O                           |
         |                                                                  |
   80000 ++                                                                 |
   78000 ++                           *  *. *  * *           *.             |
   76000 ++           *       ***.** * * : * * :* **.** *** *  *            |
   74000 ++ **.* *    :+   ** :     *   *     *        *   *                |
         | *    * ***:  ***  *                                              |
   72000 **          *                                                      |
   70000 ++-----------------------------------------------------------------+


                    lock_stat.slock-AF_INET.contentions.tcp_v4_rcv

   110000 ++----------------------------------------------------------------+
          |                                                                 |
   105000 ++      O     O         O                O                        |
          OOO   O   O O  O OO   O   O O           O  O    O O               O
          |   O  O   O O     OOO O O   OOOOO   O      OOO    OOO O OOO OOO O|
   100000 ++ O     O                        OOO     O    O      O O       O |
          |                                      O                          |
    95000 ++                                                                |
          |                                                                 |
    90000 ++                     * * .*** * ** *. * ***      ***            |
          |            *       ** * *    * *  *  * *   ****.*               |
          |  **.* **** ::*. ** :                                            |
    85000 ***    *    * *  *  *                                             |
          |                                                                 |
    80000 ++----------------------------------------------------------------+

