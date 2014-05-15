Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaEOMyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:54:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:49719 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbaEOMyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:54:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1059,1389772800"; 
   d="scan'208";a="532394125"
Date: Thu, 15 May 2014 20:54:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [uprobes/x86] 8ad8e9d3fd6: -7.5% aim7.2000.jobs-per-min, -45.7%
 turbostat.%c1
Message-ID: <20140515125433.GA8959@localhost>
References: <53743B03.7030404@intel.com>
 <20140515123332.GA15139@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515123332.GA15139@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Thu, May 15, 2014 at 02:33:32PM +0200, Oleg Nesterov wrote:
> Hi Jet,
> 
> On 05/15, Jet Chen wrote:
> >
> > we noticed the below changes on
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > commit 8ad8e9d3fd64f101eed6652964670672d699e563 ("uprobes/x86: Introduce uprobe_xol_ops and arch_uprobe->ops")
> >
> > Test case: lkp-snb01/aim7/signal_test
> >
> > 34e7317d6ae8f61  8ad8e9d3fd64f101eed665296
> > ---------------  -------------------------
> >     230689 ~ 0%      -7.5%     213485 ~ 0%  TOTAL aim7.2000.jobs-per-min
> >       0.51 ~30%     -45.7%       0.28 ~10%  TOTAL turbostat.%c1
> >        430 ~17%     +27.8%        549 ~15%  TOTAL vmstat.procs.r
> >       0.83 ~14%     +38.1%       1.15 ~12%  TOTAL perf-profile.cpu-cycles.copy_pte_range.copy_page_range.copy_process.do_fork.sys_clone
> >     106076 ~ 4%     +22.4%     129816 ~ 3%  TOTAL softirqs.RCU
> >      12117 ~ 6%      -9.9%      10914 ~ 6%  TOTAL slabinfo.kmalloc-256.active_objs
> >      32163 ~17%     +39.4%      44824 ~12%  TOTAL time.voluntary_context_switches
> >     276487 ~ 1%     +16.5%     322091 ~ 1%  TOTAL time.involuntary_context_switches
> >      83.14 ~ 0%     +13.3%      94.21 ~ 0%  TOTAL time.user_time
> >     108800 ~ 2%      +9.4%     119014 ~ 3%  TOTAL time.minor_page_faults
> >       1255 ~ 0%      +9.9%       1379 ~ 0%  TOTAL time.system_time
> >       6774 ~ 1%      +8.8%       7373 ~ 1%  TOTAL vmstat.system.cs
> >      52.15 ~ 0%      +8.0%      56.34 ~ 0%  TOTAL time.elapsed_time
> >      25185 ~ 0%      +2.4%      25784 ~ 0%  TOTAL vmstat.system.in
> >      79.23 ~ 0%      +2.0%      80.80 ~ 0%  TOTAL turbostat.%c0
> >       2567 ~ 0%      +1.9%       2615 ~ 0%  TOTAL time.percent_of_cpu_this_job_got
> >        112 ~ 0%      +1.3%        113 ~ 0%  TOTAL turbostat.Cor_W
> >        138 ~ 0%      +1.0%        139 ~ 0%  TOTAL turbostat.Pkg_W
> 
> Cough... this looks simply impossible ;)
> 
> Not only this patch "obviously can not" cause any noticable difference
> performance-wise, the code changed by this patch is not executed unless
> you play with uprobes?

Yes this is interesting. From bisect POV, we do find kernels
before/after this commit have some clearly different behavior,
as you can see in some of the below graphs. For example, the
"time.user_time" numbers are clearly separable before/after the
first bad commit.

Legend:

        [*] bisect-good sample
        [O] bisect-bad  sample

                                 time.user_time

  98 ++--------------------------------O------------------------------------+
     |     O   O O O O O   O     O   O    O   O                 O           |
  96 O+O O   O           O   O O   O        O                     O         |
  94 ++                                           O O O O O   O       O O   O
     |                                          O           O       O     O |
  92 ++                                                                     |
     |                                                                      |
  90 ++                                                                     |
     |                                                                      |
  88 ++                                                                     |
  86 ++                                                                     |
     |              .*                                                      |
  84 *+ .*.   .*. .*  +                                                     |
     | *   *.*   *     *.*.*.*.*.*.*.*.*..*.*                               |
  82 ++---------------------------------------------------------------------+


                                 time.system_time

  1420 ++-------------------------------------------------------------------+
       |                                                        O           |
  1400 O+O O O O                                                  O         |
  1380 ++                                OO     O O         O       O O O O O
       |         O O   O O O   O O O O O            O O O O   O             |
  1360 ++            O                                                      |
  1340 ++                    O              O O                             |
       |                                                                    |
  1320 ++                                                                   |
  1300 ++                                                                   |
       |                                                                    |
  1280 ++                                                                   |
  1260 ++            *.                                                     |
       *.*.*.*.*.   +  *.*.*.*.*.*.*.*.*.**.*                               |
  1240 ++--------*-*--------------------------------------------------------+


                         time.percent_of_cpu_this_job_got

  2630 ++-------------------------------------------------------------------+
       |                                                        O O         |
  2620 O+O O O O                         OO                           O O   O
  2610 ++        O O     O     O O O O O        O O O O O O O O     O     O |
       |             O O   O O                O                             |
  2600 ++                                   O                               |
       |                                                                    |
  2590 ++                                                                   |
       |                                                                    |
  2580 ++                                                                   |
  2570 ++                                                                   |
       |            .*.*.*.*.*.*. .*.*.*.**.*                               |
  2560 *+*.*.*.*.*.*             *                                          |
       |                                                                    |
  2550 ++-------------------------------------------------------------------+


                                time.elapsed_time

  58 ++---------------------------------------------------------------------+
     |                                                                      |
  57 ++O O O                                                    O O         |
     O       O                         O  O                 O       O O O O O
  56 ++        O O   O O O   O O O O O          O O O O O O   O             |
     |             O       O                O O                             |
  55 ++                                                                     |
     |                                                                      |
  54 ++                                                                     |
     |                                                                      |
  53 ++                                                                     |
     |            .*.*.                                                     |
  52 *+*.*.*.*.*.*     *.*.*.*.*.*.*.*.*..*.*                               |
     |                                                                      |
  51 ++---------------------------------------------------------------------+


                          time.involuntary_context_switches

  340000 ++-----------------------------------------------------------------+
  330000 ++                         O   O OO                     O      O   |
         O         O          O   O   O          O                O O O     |
  320000 ++    O                                   O O   O                O O
  310000 ++  O   O  O   O O     O                      O   O                |
  300000 ++O                                   O               O            |
  290000 ++                 O                O               O              |
         |            O         *      .*                                   |
  280000 ++           *.    *  : :   .*  + *.                               |
  270000 ++          :  *  : + : : .*     *  *                              |
  260000 ++       .* :   + :  *   *                                         |
  250000 ++   .*.*  *     *                                                 |
         |.*.*                                                              |
  240000 *+                                                                 |
  230000 ++-----------------------------------------------------------------+


                                    softirqs.RCU

  140000 ++-------------------------O---O-----------------------------------+
         |                    O                        O   O          O     |
  130000 ++                                      O                  O     O |
         O                                 O                                O
         |   O   O                                 O              O     O   |
  120000 ++    O   O    O       O                    O   O   O              |
         |          O     O       O   O   O    O                 O          |
  110000 ++                 O   *.   .*. .**                                |
         | O          O        :  *.*   *   :                  O            |
  100000 ++             *      :            :O                              |
         |     *.*  *. + + .*.*              *                              |
         |    :   + : *   *                                                 |
   90000 ++*. :    *                                                        |
         |+  *                                                              |
   80000 *+-----------------------------------------------------------------+


                               aim7.2000.jobs-per-min

  235000 ++-----------------------------------------------------------------+
         |                                                                  |
         *.*.*.*.*.**.   .*.*. .*.*.*.*.*. *.*                              |
  230000 ++           *.*     *           *                                 |
         |                                                                  |
         |                                                                  |
  225000 ++                                                                 |
         |                                                                  |
  220000 ++                                                                 |
         |                                                                  |
         |                    O              O O                            |
  215000 ++        OO O O O O   O                                           |
         |                        O O O O        O O O O O O O O    O O O O O
         O O O O O                        OO                      O         |
  210000 ++------------------------------------------------------O----------+


                                  vmstat.system.in

  26200 ++O-----------------------------------------------------------------+
        O   O O O                                                 O         |
  26000 ++          O    O     O         O O                                |
        |         O                                             O           |
  25800 ++                 O       O   O                            O O O O O
        |             O O    O   O   O       O   O O O   O  O               |
  25600 ++                                     O       O   O  O             |
        |                  *        .*                                      |
  25400 ++*. .*.*. .*      :       *  :                                     |
        | : *     *  +    : :      :  :                                     |
  25200 ++            *.* : :     :    :.*.                                 |
        |:               :   :.*. :    *   *.*                              |
  25000 ++               *   *   *                                          |
        *                                                                   |
  24800 ++------------------------------------------------------------------+


                                   turbostat.%c0

  81.5 ++-------------------------------------------------------------------+
       |                                                                    |
    81 ++                                                       O O         |
       O O O O O                 O O O O OO     O O                   O O O O
       |         O O   O O O   O                    O O O O O O     O       |
  80.5 ++            O       O              O O                             |
       |                                                                    |
    80 ++                                                                   |
       |                                                                    |
  79.5 ++                                                                   |
       |             *.       .*.   .*.   *.                                |
       *. .*. .*.*. +  *.*.*.*   *.*   *.*  *                               |
    79 ++*   *     *                                                        |
       |                                                                    |
  78.5 ++-------------------------------------------------------------------+


                                   turbostat.Pkg_W

    141 ++------------------------------------------------------------------+
        |                                    O                              |
  140.5 ++                                             O   O                |
    140 ++    O              O   O O O O O O                O   O           |
        O O O   O O O O        O               O O            O   O     O   |
  139.5 ++              O  O         *             O O   O            O   O O
        |                O          : :                             O       |
    139 ++                          : :                                     |
        |                  *      .*   :                                    |
  138.5 ++                + :  *.*     *.                                   |
    138 ++*.*.*      .*. *  : +          *                                  |
        *      + .*.*   *    *            +                                 |
  137.5 ++      *                          *.*                              |
        |                                                                   |
    137 ++------------------------------------------------------------------+


                                   turbostat.Cor_W

  114.5 ++-----------------------------------O------------------------------+
        |                                              O   O                |
    114 ++                                                      O           |
        | O O O                  O   O   O O     O          O     O     O   |
        O       O O O        O     O   O       O     O   O    O     O     O O
  113.5 ++            O O  O   O                   O                  O     |
        |                O           *                                      |
    113 ++                           ::                                     |
        |                  *        : :                                     |
  112.5 ++                : :    *. :  :                                    |
        |                 : :   +  *   *.                                   |
        |     *          *   :.*         *                                  |
    112 *+   + :     .*. :   *            +                                 |
        | *.*  : .*.*   *                  *.*                              |
  111.5 ++------*-----------------------------------------------------------+


                           proc-vmstat.numa_pte_updates

  7000 ++--O----------------------------------------------------------------+
       |                                                                    |
  6000 ++O                                                                  |
       |       O                                                  O         |
  5000 ++            O                                                      |
       |                   O                          O   O               O |
  4000 ++                                     O             O               |
       O                                 O                    O             |
  3000 ++    O                                                              |
       |                                  O                     O   O       |
  2000 ++                *   * O * O * O                              O     |
       |         * O    :O: : : :O+ +O:     O     O O   O               O   |
  1000 ++       +O+ .*.O: : :O: :  *  : .*      O                           O
       |  .*. .*   *   *   *   *       *  *.                                |
     0 *+*---*------------------------------*-------------------------------+


                           proc-vmstat.numa_hint_faults

  2500 ++-------------------------------------------------------------------+
       |                                                                    |
       |   O                                                                |
  2000 ++O                                                                  |
       |       O                                                  O         |
       |             O                                                      |
  1500 ++                  O                          O   O O             O |
       O                                 O    O                             |
  1000 ++                                                     O             |
       |     O                            O                     O   O       |
       |                 *   * O   O   O                                    |
   500 ++        * O    :O: : :  O. .O      O     O O   O             O O   |
       |        +O+    O: : :O: +  *  + .*      O                           O
       |  .*. .*   *.*.*   *   *       *  *.                                |
     0 *+*---*------------------------------*-------------------------------+

Thanks,
Fengguang
