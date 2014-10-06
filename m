Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaJFJRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:17:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:25172 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbaJFJRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:17:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,662,1406617200"; 
   d="scan'208";a="613718178"
Date: Mon, 6 Oct 2014 17:17:16 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [rcu] 5057f55e543:  dmesg.BUG:soft_lockup-CPU_stuck_for_s
Message-ID: <20141006091716.GA1608@wfg-t540p.sh.intel.com>
References: <20141006055024.GD28732@wfg-t540p.sh.intel.com>
 <20141006055456.GA650@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141006055456.GA650@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 01:54:56PM +0800, Fengguang Wu wrote:
> On Mon, Oct 06, 2014 at 01:50:24PM +0800, Fengguang Wu wrote:
> > Hi Paul,
> > 
> > FYI, we noticed a number of ups and downs for commit
> > 
> > 5057f55e543b7859cfd26bc281291795eac93f8a ("rcu: Bind RCU grace-period kthreads if NO_HZ_FULL")
> 
> Here is an overview of the performance/power/latency/kernel size
> index. The baseline (71a9b26963f8c2d) number is 100, the larger, the better.
> 
>     96      perf-index  5057f55e543b7859cfd26bc281291795eac93f8a
>     99     power-index  5057f55e543b7859cfd26bc281291795eac93f8a
>    101   latency-index  5057f55e543b7859cfd26bc281291795eac93f8a
>    102      size-index  5057f55e543b7859cfd26bc281291795eac93f8a

The performance changes seem to have a strong correlation with the
time.involuntary_context_switches changes.

71a9b26963f8c2d  5057f55e543b7859cfd26bc28  time.involuntary_context_switches
---------------  -------------------------  ------------------------------------
   1209498 ± 1%      -6.5%    1131376 ± 1%  lkp-a04/netperf/900s-200%-TCP_STREAM
     31677 ± 0%     +42.5%      45147 ± 1%  lkp-a05/iperf/300s-tcp
    116081 ± 0%     +12.5%     130610 ± 1%  lkp-a06/qperf/600s
       546 ±24%   +2329.3%      13280 ± 8%  lkp-sb03/nepim/300s-100%-tcp
       863 ±45%   +1260.1%      11737 ±12%  lkp-sb03/nepim/300s-100%-tcp6
       343 ±18%  +12507.6%      43294 ± 2%  lkp-sb03/nepim/300s-100%-udp6
       633 ±23%   +1292.7%       8816 ±15%  lkp-sb03/nepim/300s-25%-tcp
       417 ± 5%   +1714.5%       7572 ±11%  lkp-sb03/nepim/300s-25%-tcp6
       364 ±20%   +9569.9%      35198 ± 7%  lkp-sb03/nepim/300s-25%-udp
       312 ± 0%  +12223.0%      38521 ± 1%  lkp-sb03/nepim/300s-25%-udp6
       308 ± 0%   +6197.7%      19418 ± 0%  lkp-sb03/nuttcp/300s
       418 ± 4%   +4948.2%      21101 ± 1%  lkp-sb03/thrulay/300s
 1.062e+09 ± 0%      -2.9%  1.031e+09 ± 0%  lkp-snb01/hackbench/50%-threads-pipe
     18870 ± 0%    +265.8%      69025 ± 0%  lkp-snb01/will-it-scale/open2
     20813 ± 0%     +95.2%      40618 ± 0%  xps/ftrace_onoff/5m

iperf tcp:

                                 iperf.tcp.sender.bps

  2.2e+10 ++-----*-*---------*-*--------------------------------------------+
          |     +   +       +                    .*.              .*        |
  2.1e+10 ++  .*     +    .*      *.*.*..*.*.  .*   *..      .*.*.  + .*..  |
          *.*.        *.*.                   *.            .*        *    *.*
          |                                            *.*.                 |
    2e+10 ++                                                                |
          |                                                                 |
  1.9e+10 ++                                                                |
          |                                                                 |
  1.8e+10 ++                      O                                         |
          |                    O      O      O                              |
          O    O   O    O           O    O        O                         |
  1.7e+10 ++O              O O                  O                           |
          |      O    O                    O                                |
  1.6e+10 ++----------------------------------------------------------------+

        [*] bisect-good sample
        [O] bisect-bad  sample


                                iperf.tcp.receiver.bps

  2.2e+10 ++-----*-*---------*-*--------------------------------------------+
          |     +   +       +                    .*.              .*        |
  2.1e+10 ++  .*     +    .*      *.*.*..*.*.  .*   *..      .*.*.  + .*..  |
          *.*.        *.*.                   *.            .*        *    *.*
          |                                            *.*.                 |
    2e+10 ++                                                                |
          |                                                                 |
  1.9e+10 ++                                                                |
          |                                                                 |
  1.8e+10 ++                      O                                         |
          |                    O      O      O                              |
          O    O   O    O           O    O        O                         |
  1.7e+10 ++O              O O                  O                           |
          |      O    O                    O                                |
  1.6e+10 ++----------------------------------------------------------------+


                          time.involuntary_context_switches

  10000 ++----------------------------------O-------------------------------+
   9000 ++                                                                  |
        |         O    O   O    O    O    O    O O                          |
   8000 O+O  O                O    O    O                                   |
   7000 ++     O    O    O                                                  |
        |                                                                   |
   6000 ++                                                                  |
   5000 ++                                                                  |
   4000 ++                                                                  |
        |                                                                   |
   3000 ++                                                                  |
   2000 ++*..*        .*.*                                                  *
        *     +  .*.*.    +  .*.*..*.*.. .*.*..*.*..    .*.*.*.. .*..      +|
   1000 ++     *.          *.           *           *.*.        *    *.*..* |
      0 ++------------------------------------------------------------------+


qperf:
                          time.involuntary_context_switches

  25000 ++------------------------------------------------------------------+
        |                                                                   |
        |                        O    O OO OO O OO                          |
  20000 O+O  OO    O O  O  O OO O                   O  O O  O OO O O  OO OO |
        |  O     O    O  O                                                  O
        |                                                                   |
  15000 ++                         OO              O  O             O       |
        |       O                                          O                |
  10000 ++                                                                  |
        |                                                                   |
        |                                                                   |
   5000 ++                                                                  |
        |.**.* .**.*.* .* .*. *.* .* .*.         *.**.**                    |
        *     *       *  *   *   *  *   **.**.*.*                           |
      0 ++------------------------------------------------------------------+


                                   qperf.udp.send_bw

  2.2e+09 *+**--*----*--**----**-*-----*-**----*---*------------------------+
          |    *  **  *    **      **.*     **  *.*  *.**                   |
    2e+09 ++                                                                |
  1.8e+09 ++                                                                |
          |                                 O                       O    O  O
  1.6e+09 ++                          O   O  O OO OO O OO OO  O  O     O  O |
          |                            O O                   O  O  O  O     |
  1.4e+09 ++                                                                |
          |                                                                 |
  1.2e+09 ++                                                                |
    1e+09 ++                                                                |
          | O                                                               |
    8e+08 O+       O    O  O  O    O                                        |
          |  O OO O  OO  O  O  O O  O                                       |
    6e+08 ++----------------------------------------------------------------+


                                   qperf.udp.recv_bw

  2.2e+09 *+**--*----*--**----**-*-----*-**----*---*------------------------+
          |    *  **  *    **      **.*     **  *.*  *.**                   |
    2e+09 ++                                                                |
  1.8e+09 ++                                                                |
          |                                                         O    O  O
  1.6e+09 ++                          O   O OO OO OO O OO OO  O  O     O  O |
          |                            O O                   O  O  O  O     |
  1.4e+09 ++                                                                |
          |                                                                 |
  1.2e+09 ++                                                                |
    1e+09 ++                                                                |
          | O                                                               |
    8e+08 O+       O    O  O  O    O                                        |
          |  O OO O  OO  O  O  O O  O                                       |
    6e+08 ++----------------------------------------------------------------+


will-it-scale unlink1:

                           time.voluntary_context_switches

  40000 ++--O---------O-----------------------------------------------------+
        |          O                                                        |
  35000 O+     O          O          O  O      O       O                    |
  30000 ++                   O   O                        O   O      O  O   |
        |                                   O      O             O          O
  25000 ++                                                                  |
        |                                                                   |
  20000 ++                                                                  |
        |                                                                   |
  15000 ++                                                                  |
  10000 ++                                           ..*..*..               |
        |            .*...*..*...             .*...*.        .     ..*..*...|
   5000 *+..*..*...*.            *...*..*...*.                *..*.         *
        |                                                                   |
      0 ++------------------------------------------------------------------+


                          time.involuntary_context_switches

  60000 ++------------------------------------------------------------------+
        |                                      O          O   O      O      |
  50000 O+  O  O   O  O   O  O   O   O  O   O      O   O         O      O   O
        |                                                                   |
        |                                                                   |
  40000 ++                                                                  |
        |                                                                   |
  30000 ++                                                                  |
        |                                                                   |
  20000 ++                                                                  |
        |                                                                   |
        |                                              *..                  |
  10000 ++                                           ..   *..               |
        |                                           .        .              |
      0 *+--*--*---*--*---*--*---*---*--*---*--*---*----------*--*---*--*---*

Thanks,
Fengguang
