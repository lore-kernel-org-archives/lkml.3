Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab3JVOla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:41:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:48267 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab3JVOlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:41:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,548,1378882800"; 
   d="scan'208";a="415205359"
Date: Tue, 22 Oct 2013 15:40:59 +0100
From: Fengguang Wu <fengguang.wu@intel.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, bitbucket@online.de, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, lkp@01.org,
        Huang Ying <ying.huang@intel.com>
Subject: Re: [tip:sched/core] sched, idle: Fix the idle polling state logic
Message-ID: <20131022144059.GB27175@localhost>
References: <tip-nc03imb0etuefmzybzj7sprf@git.kernel.org>
 <20131021031450.GA29682@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131021031450.GA29682@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 11:14:50AM +0800, Yuanhan Liu wrote:
> On Wed, Sep 25, 2013 at 09:38:19AM -0700, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  ea8117478918a4734586d35ff530721b682425be
> > Gitweb:     http://git.kernel.org/tip/ea8117478918a4734586d35ff530721b682425be
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Wed, 11 Sep 2013 12:43:13 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Wed, 25 Sep 2013 13:53:10 +0200
> > 
> > sched, idle: Fix the idle polling state logic
> > 
> > Mike reported that commit 7d1a9417 ("x86: Use generic idle loop")
> > regressed several workloads and caused excessive reschedule
> > interrupts.
> 
> Hi,
> 
> JFYI, this patch does reduce interruptes in our test:

Even better, there are up to 2x performance increases in the
will-it-scale context_switch1 test case and +19.5% increase in
aim7.2000.jobs-per-min-per-task:

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               510842.67      +221.7%   1643368.00  lkp-snb01/micro/will-it-scale/context_switch1
               510842.67      +221.7%   1643368.00  TOTAL will-it-scale.context_switch1.8.linear

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2043370.67      +221.7%   6573472.00  lkp-snb01/micro/will-it-scale/context_switch1
              2043370.67      +221.7%   6573472.00  TOTAL will-it-scale.context_switch1.32.linear

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1021685.33      +221.7%   3286736.00  lkp-snb01/micro/will-it-scale/context_switch1
              1021685.33      +221.7%   3286736.00  TOTAL will-it-scale.context_switch1.16.linear

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1532528.00      +221.7%   4930104.00  lkp-snb01/micro/will-it-scale/context_switch1
              1532528.00      +221.7%   4930104.00  TOTAL will-it-scale.context_switch1.24.linear

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                11978.00      +174.6%     32888.67  lkp-a03/micro/will-it-scale/context_switch1
                63855.33      +221.7%    205421.00  lkp-snb01/micro/will-it-scale/context_switch1
                75833.33      +214.3%    238309.67  TOTAL will-it-scale.context_switch1.1.linear

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                11978.00      +174.6%     32888.67  lkp-a03/micro/will-it-scale/context_switch1
                63855.33      +221.7%    205421.00  lkp-snb01/micro/will-it-scale/context_switch1
                75833.33      +214.3%    238309.67  TOTAL will-it-scale.context_switch1.1.processes

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                11527.33      +174.4%     31625.33  lkp-a03/micro/will-it-scale/context_switch1
                60716.33      +219.2%    193791.67  lkp-snb01/micro/will-it-scale/context_switch1
                72243.67      +212.0%    225417.00  TOTAL will-it-scale.context_switch1.1.threads

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                40631.00      +184.6%    115627.33  lkp-a03/micro/will-it-scale/context_switch1
                40631.00      +184.6%    115627.33  TOTAL will-it-scale.context_switch1.4.threads

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                41266.00      +182.0%    116380.33  lkp-a03/micro/will-it-scale/context_switch1
                41266.00      +182.0%    116380.33  TOTAL will-it-scale.context_switch1.4.processes

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                23681.00      +177.9%     65806.00  lkp-a03/micro/will-it-scale/context_switch1
                23681.00      +177.9%     65806.00  TOTAL will-it-scale.context_switch1.2.processes

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                33848.33      +176.6%     93623.67  lkp-a03/micro/will-it-scale/context_switch1
                33848.33      +176.6%     93623.67  TOTAL will-it-scale.context_switch1.3.processes

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                23956.00      +174.6%     65777.33  lkp-a03/micro/will-it-scale/context_switch1
                23956.00      +174.6%     65777.33  TOTAL will-it-scale.context_switch1.2.linear

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                35934.00      +174.6%     98666.00  lkp-a03/micro/will-it-scale/context_switch1
                35934.00      +174.6%     98666.00  TOTAL will-it-scale.context_switch1.3.linear

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                47912.00      +174.6%    131554.67  lkp-a03/micro/will-it-scale/context_switch1
                47912.00      +174.6%    131554.67  TOTAL will-it-scale.context_switch1.4.linear

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                32822.00      +175.7%     90475.67  lkp-a03/micro/will-it-scale/context_switch1
                32822.00      +175.7%     90475.67  TOTAL will-it-scale.context_switch1.3.threads

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                23425.33      +175.0%     64424.67  lkp-a03/micro/will-it-scale/context_switch1
                23425.33      +175.0%     64424.67  TOTAL will-it-scale.context_switch1.2.threads

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                    0.40       -63.3%         0.15  lkp-snb01/micro/will-it-scale/context_switch1
                    0.40       -63.3%         0.15  TOTAL will-it-scale.context_switch1.32.threads_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                    0.23       -55.7%         0.10  lkp-a03/micro/will-it-scale/context_switch1
                    0.23       -55.7%         0.10  TOTAL will-it-scale.context_switch1.4.threads_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1080797.67       +28.7%   1391420.33  lkp-snb01/micro/will-it-scale/context_switch1
              1080797.67       +28.7%   1391420.33  TOTAL will-it-scale.context_switch1.8.processes

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1046744.00       +24.5%   1303033.00  lkp-snb01/micro/will-it-scale/context_switch1
              1046744.00       +24.5%   1303033.00  TOTAL will-it-scale.context_switch1.8.threads

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   32.35       -18.2%        26.45  lkp-snb01/micro/will-it-scale/context_switch1
                   32.35       -18.2%        26.45  TOTAL will-it-scale.context_switch1.16.processes_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                    7.35       +19.5%         8.78  lkp-snb01/micro/aim7/creat-clo
                    7.35       +19.5%         8.78  TOTAL aim7.2000.jobs-per-min-per-task

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  816.53       -16.3%       683.49  lkp-snb01/micro/aim7/creat-clo
                  816.53       -16.3%       683.49  TOTAL aim7.2000.real

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   15.91       -16.8%        13.24  lkp-snb01/micro/will-it-scale/context_switch1
                   15.91       -16.8%        13.24  TOTAL will-it-scale.context_switch1.24.processes_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                    7.68       +14.8%         8.82  lkp-a03/micro/will-it-scale/context_switch1
                    7.68       +14.8%         8.82  TOTAL will-it-scale.context_switch1.3.threads_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   11.66       -13.0%        10.15  lkp-snb01/micro/will-it-scale/context_switch1
                   11.66       -13.0%        10.15  TOTAL will-it-scale.context_switch1.24.threads_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   25.43        -9.8%        22.95  lkp-snb01/micro/will-it-scale/context_switch1
                   25.43        -9.8%        22.95  TOTAL will-it-scale.context_switch1.16.threads_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   10.82       +10.5%        11.95  lkp-a03/micro/will-it-scale/context_switch1
                   10.82       +10.5%        11.95  TOTAL will-it-scale.context_switch1.3.processes_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               227809.78        +2.5%    233419.91  lkp-ne04/micro/aim7/disk_src
                14699.10       +19.5%     17560.21  lkp-snb01/micro/aim7/creat-clo
                46695.60        +4.6%     48858.67  nhm-white/micro/aim7/link_test
               289204.48        +3.7%    299838.80  TOTAL aim7.2000.jobs-per-min

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1456695.67        +9.1%   1589175.33  lkp-snb01/micro/will-it-scale/context_switch1
              1456695.67        +9.1%   1589175.33  TOTAL will-it-scale.context_switch1.16.threads

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   20.54        +8.5%        22.28  lkp-a03/micro/will-it-scale/context_switch1
                   20.54        +8.5%        22.28  TOTAL will-it-scale.context_switch1.2.threads_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   60.46        +8.4%        65.53  lkp-a03/micro/will-it-scale/context_switch1
                   60.46        +8.4%        65.53  TOTAL will-it-scale.context_switch1.1.processes_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                    3.47        -6.1%         3.26  lkp-snb01/micro/will-it-scale/context_switch1
                    3.47        -6.1%         3.26  TOTAL will-it-scale.context_switch1.32.processes_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              3957298.33        +6.2%   4200895.33  lkp-snb01/micro/will-it-scale/context_switch1
              3957298.33        +6.2%   4200895.33  TOTAL will-it-scale.context_switch1.32.processes

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   60.25        +5.2%        63.37  lkp-a03/micro/will-it-scale/context_switch1
                   60.25        +5.2%        63.37  TOTAL will-it-scale.context_switch1.1.threads_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   24.60        +5.6%        25.97  lkp-a03/micro/will-it-scale/context_switch1
                   24.60        +5.6%        25.97  TOTAL will-it-scale.context_switch1.2.processes_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1719601.67        +5.1%   1806779.00  lkp-snb01/micro/will-it-scale/context_switch1
              1719601.67        +5.1%   1806779.00  TOTAL will-it-scale.context_switch1.16.processes

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1965.20        -3.7%      1891.60  lkp-t410/micro/netperf/120s-200%-TCP_SENDFILE
                 1965.20        -3.7%      1891.60  TOTAL netperf.Throughput_Mbps

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   71.89        -3.2%        69.59  lkp-snb01/micro/will-it-scale/context_switch1
                   71.89        -3.2%        69.59  TOTAL will-it-scale.context_switch1.8.processes_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              3530289.67        +5.6%   3728175.67  lkp-snb01/micro/will-it-scale/context_switch1
              3530289.67        +5.6%   3728175.67  TOTAL will-it-scale.context_switch1.32.threads

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   69.18        -2.3%        67.56  lkp-snb01/micro/will-it-scale/context_switch1
                   69.18        -2.3%        67.56  TOTAL will-it-scale.context_switch1.8.threads_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                    2.61        -3.4%         2.52  lkp-a03/micro/will-it-scale/context_switch1
                    2.61        -3.4%         2.52  TOTAL will-it-scale.context_switch1.4.processes_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1413.20        +1.2%      1430.60  lkp-t410/micro/netperf/120s-200%-TCP_CRR
                 8384.40        +1.5%      8511.60  lkp-t410/micro/netperf/120s-200%-TCP_RR
                 9797.60        +1.5%      9942.20  TOTAL netperf.Throughput_tps

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4345.14        +0.5%      4365.88  nhm8/micro/dbench/100%
                 4345.14        +0.5%      4365.88  TOTAL dbench.throughput-MB/sec

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               279632.20       -82.4%     49238.40  lkp-snb01/micro/aim7/creat-clo
              5861389.33       -83.6%    961046.00  lkp-snb01/micro/will-it-scale/context_switch1
              6141021.53       -83.5%   1010284.40  TOTAL interrupts.CPU27.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   13.33      +282.5%        51.00  lkp-ne04/micro/aim7/disk_src
                   13.33      +282.5%        51.00  TOTAL sched_debug.cpu#12.cpu_load[0]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                    0.01     +1419.5%         0.12  lkp-ne04/micro/aim7/disk_src
                    0.01     +1419.5%         0.12  TOTAL sched_debug.cfs_rq[15]:/.spread

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               268263.60       -81.1%     50776.80  lkp-snb01/micro/aim7/creat-clo
              5406636.00       -81.7%    990768.33  lkp-snb01/micro/will-it-scale/context_switch1
              5674899.60       -81.6%   1041545.13  TOTAL interrupts.CPU25.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               289388.20       -82.4%     50820.60  lkp-snb01/micro/aim7/creat-clo
              5258081.67       -81.1%    994806.00  lkp-snb01/micro/will-it-scale/context_switch1
              5547469.87       -81.2%   1045626.60  TOTAL interrupts.CPU30.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               271190.20       -81.9%     48989.80  lkp-snb01/micro/aim7/creat-clo
              5317373.00       -81.4%    991036.33  lkp-snb01/micro/will-it-scale/context_switch1
              5588563.20       -81.4%   1040026.13  TOTAL interrupts.CPU28.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               269982.60       -82.2%     48167.20  lkp-snb01/micro/aim7/creat-clo
              5321232.33       -81.4%    992225.00  lkp-snb01/micro/will-it-scale/context_switch1
              5591214.93       -81.4%   1040392.20  TOTAL interrupts.CPU24.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               297729.40       -82.4%     52349.40  lkp-snb01/micro/aim7/creat-clo
              5301385.00       -80.9%   1014965.00  lkp-snb01/micro/will-it-scale/context_switch1
              5599114.40       -80.9%   1067314.40  TOTAL interrupts.CPU31.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               289022.40       -82.5%     50628.40  lkp-snb01/micro/aim7/creat-clo
              5277718.33       -80.8%   1014483.67  lkp-snb01/micro/will-it-scale/context_switch1
              5566740.73       -80.9%   1065112.07  TOTAL interrupts.CPU29.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               265565.60       -81.2%     49804.20  lkp-snb01/micro/aim7/creat-clo
              5295584.33       -80.3%   1044024.00  lkp-snb01/micro/will-it-scale/context_switch1
              5561149.93       -80.3%   1093828.20  TOTAL interrupts.CPU26.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               351375.67       -44.9%    193570.00  lkp-ne04/micro/aim7/disk_src
              5473780.80       -91.7%    453248.80  lkp-snb01/micro/aim7/creat-clo
              5440567.67       -81.7%    994100.33  lkp-snb01/micro/will-it-scale/context_switch1
             11265724.13       -85.4%   1640919.13  TOTAL interrupts.CPU10.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               354604.67       -44.0%    198473.67  lkp-ne04/micro/aim7/disk_src
              5547212.80       -91.5%    469462.40  lkp-snb01/micro/aim7/creat-clo
              5380697.33       -81.7%    984511.67  lkp-snb01/micro/will-it-scale/context_switch1
             11282514.80       -85.4%   1652447.73  TOTAL interrupts.CPU13.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               355342.33       -44.2%    198166.33  lkp-ne04/micro/aim7/disk_src
              5576661.00       -91.5%    473421.20  lkp-snb01/micro/aim7/creat-clo
              5379945.00       -81.5%    997814.00  lkp-snb01/micro/will-it-scale/context_switch1
             11311948.33       -85.2%   1669401.53  TOTAL interrupts.CPU9.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               355629.33       -44.3%    198234.33  lkp-ne04/micro/aim7/disk_src
              5500052.80       -91.6%    460878.20  lkp-snb01/micro/aim7/creat-clo
              5269905.00       -81.2%    989113.67  lkp-snb01/micro/will-it-scale/context_switch1
             11125587.13       -85.2%   1648226.20  TOTAL interrupts.CPU11.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               349455.33       -44.8%    192840.33  lkp-ne04/micro/aim7/disk_src
              5585881.40       -91.4%    478085.40  lkp-snb01/micro/aim7/creat-clo
              5357022.00       -81.5%    992234.33  lkp-snb01/micro/will-it-scale/context_switch1
             11292358.73       -85.3%   1663160.07  TOTAL interrupts.CPU12.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               351529.33       -45.0%    193236.33  lkp-ne04/micro/aim7/disk_src
              7650891.20       -94.0%    462204.60  lkp-snb01/micro/aim7/creat-clo
              4898386.67       -79.2%   1016656.67  lkp-snb01/micro/will-it-scale/context_switch1
             12900807.20       -87.0%   1672097.60  TOTAL interrupts.CPU8.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               355617.67       -44.1%    198650.33  lkp-ne04/micro/aim7/disk_src
              5595944.60       -91.4%    478928.40  lkp-snb01/micro/aim7/creat-clo
              5307782.33       -80.8%   1018604.67  lkp-snb01/micro/will-it-scale/context_switch1
             11259344.60       -84.9%   1696183.40  TOTAL interrupts.CPU15.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               348394.67       -44.9%    192057.67  lkp-ne04/micro/aim7/disk_src
              5614971.80       -91.4%    481991.00  lkp-snb01/micro/aim7/creat-clo
              5272266.67       -80.5%   1027442.67  lkp-snb01/micro/will-it-scale/context_switch1
             11235633.13       -84.9%   1701491.33  TOTAL interrupts.CPU14.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                    0.09       -84.0%         0.01  lkp-ne04/micro/aim7/disk_src
                    0.09       -84.0%         0.01  TOTAL sched_debug.cfs_rq[4]:/.spread

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2215938.00       +84.0%   4076577.67  lkp-a03/micro/will-it-scale/context_switch1
              6640621.67       -43.1%   3779595.33  lkp-ne04/micro/aim7/disk_src
            103832811.60       -92.1%   8165967.00  lkp-snb01/micro/aim7/creat-clo
            181559614.00       -62.7%  67761879.00  lkp-snb01/micro/will-it-scale/context_switch1
             28003774.90       -98.3%    470740.00  nhm-white/micro/aim7/link_test
              3592250.60       -99.4%     22578.20  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
              3417494.60       -99.2%     26754.20  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
            329262505.37       -74.4%  84304091.40  TOTAL interrupts.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               505673.00       +99.7%   1010071.67  lkp-a03/micro/will-it-scale/context_switch1
               478557.00       -42.0%    277603.00  lkp-ne04/micro/aim7/disk_src
              6779085.00       -93.2%    458576.00  lkp-snb01/micro/aim7/creat-clo
              5850672.67       -52.4%   2787216.33  lkp-snb01/micro/will-it-scale/context_switch1
              2391523.20       -99.6%     10574.30  nhm-white/micro/aim7/link_test
               771618.40       -99.3%      5566.60  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               834364.20       -99.2%      6685.60  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
             17611493.47       -74.1%   4556293.50  TOTAL interrupts.CPU1.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               585943.67       +80.0%   1054508.00  lkp-a03/micro/will-it-scale/context_switch1
               483049.00       -42.7%    276565.67  lkp-ne04/micro/aim7/disk_src
              6744043.00       -93.5%    440221.00  lkp-snb01/micro/aim7/creat-clo
              5834361.67       -58.0%   2451161.00  lkp-snb01/micro/will-it-scale/context_switch1
              6099873.40       -98.3%    104531.20  nhm-white/micro/aim7/link_test
               969336.40       -99.4%      5525.80  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               932684.60       -99.4%      5806.20  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
             21649291.73       -80.0%   4338318.87  TOTAL interrupts.CPU3.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               499173.00       +87.8%    937598.33  lkp-a03/micro/will-it-scale/context_switch1
               475670.33       -42.0%    275859.67  lkp-ne04/micro/aim7/disk_src
              6742512.20       -93.4%    448089.00  lkp-snb01/micro/aim7/creat-clo
              5723992.00       -49.7%   2882016.33  lkp-snb01/micro/will-it-scale/context_switch1
              6135556.70       -98.3%    105822.50  nhm-white/micro/aim7/link_test
               937573.80       -99.4%      5515.20  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               913896.20       -99.3%      6044.00  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
             21428374.23       -78.2%   4660945.03  TOTAL interrupts.CPU2.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               369349.00       -87.3%     47048.80  lkp-snb01/micro/aim7/creat-clo
              5781232.33       -51.6%   2795377.33  lkp-snb01/micro/will-it-scale/context_switch1
              6150581.33       -53.8%   2842426.13  TOTAL interrupts.CPU22.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               350442.80       -87.2%     44997.40  lkp-snb01/micro/aim7/creat-clo
              5749871.00       -33.7%   3813107.33  lkp-snb01/micro/will-it-scale/context_switch1
              6100313.80       -36.8%   3858104.73  TOTAL interrupts.CPU16.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               365737.60       -86.7%     48610.60  lkp-snb01/micro/aim7/creat-clo
              5824103.00       -49.9%   2918987.33  lkp-snb01/micro/will-it-scale/context_switch1
              6189840.60       -52.1%   2967597.93  TOTAL interrupts.CPU21.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               314508.60       -86.5%     42516.80  lkp-snb01/micro/aim7/creat-clo
              5678652.33       -50.3%   2823087.33  lkp-snb01/micro/will-it-scale/context_switch1
              5993160.93       -52.2%   2865604.13  TOTAL interrupts.CPU17.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               332897.20       -86.8%     44096.80  lkp-snb01/micro/aim7/creat-clo
              5753534.33       -49.2%   2922662.33  lkp-snb01/micro/will-it-scale/context_switch1
              6086431.53       -51.3%   2966759.13  TOTAL interrupts.CPU20.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               361246.00       -87.4%     45691.60  lkp-snb01/micro/aim7/creat-clo
              5726209.67       -48.8%   2930253.67  lkp-snb01/micro/will-it-scale/context_switch1
              6087455.67       -51.1%   2975945.27  TOTAL interrupts.CPU23.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               625148.33       +71.9%   1074399.67  lkp-a03/micro/will-it-scale/context_switch1
               476163.67       -41.8%    277088.00  lkp-ne04/micro/aim7/disk_src
              4769050.40       -90.5%    454357.40  lkp-snb01/micro/aim7/creat-clo
              8219279.00       -26.5%   6040396.00  lkp-snb01/micro/will-it-scale/context_switch1
              6100956.90       -98.4%     99287.00  nhm-white/micro/aim7/link_test
               913722.00       -99.3%      5970.60  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               736549.60       -98.9%      8218.40  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
             21840869.90       -63.6%   7959717.07  TOTAL interrupts.CPU0.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               343431.80       -86.0%     48181.60  lkp-snb01/micro/aim7/creat-clo
              6384301.00       -39.6%   3855728.00  lkp-snb01/micro/will-it-scale/context_switch1
              6727732.80       -42.0%   3903909.60  TOTAL interrupts.CPU19.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               338421.60       -86.4%     45999.80  lkp-snb01/micro/aim7/creat-clo
              6239347.67       -37.2%   3919599.33  lkp-snb01/micro/will-it-scale/context_switch1
              6577769.27       -39.7%   3965599.13  TOTAL interrupts.CPU18.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               478859.00       -42.3%    276362.67  lkp-ne04/micro/aim7/disk_src
              6794075.60       -93.2%    461642.20  lkp-snb01/micro/aim7/creat-clo
              5893689.00       -50.8%   2898485.33  lkp-snb01/micro/will-it-scale/context_switch1
               936969.90       -98.2%     16640.90  nhm-white/micro/aim7/link_test
             14103593.50       -74.1%   3653131.10  TOTAL interrupts.CPU5.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               476521.00       -42.0%    276483.33  lkp-ne04/micro/aim7/disk_src
              6842515.20       -93.3%    459985.20  lkp-snb01/micro/aim7/creat-clo
              5818092.33       -50.2%   2898710.00  lkp-snb01/micro/will-it-scale/context_switch1
               920646.40       -98.2%     16944.10  nhm-white/micro/aim7/link_test
             14057774.93       -74.0%   3652122.63  TOTAL interrupts.CPU6.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               470177.00       -41.1%    277139.00  lkp-ne04/micro/aim7/disk_src
              6783986.80       -93.3%    456291.80  lkp-snb01/micro/aim7/creat-clo
              5889044.33       -51.4%   2859254.00  lkp-snb01/micro/will-it-scale/context_switch1
              4492253.80       -97.8%    100445.10  nhm-white/micro/aim7/link_test
             17635461.93       -79.1%   3693129.90  TOTAL interrupts.CPU4.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               479675.67       -42.2%    277265.00  lkp-ne04/micro/aim7/disk_src
              6825338.20       -93.3%    460666.20  lkp-snb01/micro/aim7/creat-clo
              5847259.00       -49.7%   2942005.00  lkp-snb01/micro/will-it-scale/context_switch1
               925994.60       -98.2%     16494.90  nhm-white/micro/aim7/link_test
             14078267.47       -73.7%   3696431.10  TOTAL interrupts.CPU7.RES

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   37.33      +336.6%       163.00  lkp-ne04/micro/aim7/disk_src
                  389.80       -18.2%       318.80  lkp-snb01/micro/aim7/creat-clo
                  427.13       +12.8%       481.80  TOTAL sched_debug.cfs_rq[15]:/.nr_spread_over

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   12.33      +181.1%        34.67  lkp-ne04/micro/aim7/disk_src
                   12.33      +181.1%        34.67  TOTAL sched_debug.cpu#15.cpu_load[1]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  293.69       -40.3%       175.28  lkp-ne04/micro/aim7/disk_src
                   63.08       -55.8%        27.90  lkp-snb01/micro/aim7/creat-clo
                  356.77       -43.1%       203.17  TOTAL sched_debug.cfs_rq[4]:/.max_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  293.60       -40.3%       175.26  lkp-ne04/micro/aim7/disk_src
                   63.08       -55.8%        27.90  lkp-snb01/micro/aim7/creat-clo
                  356.68       -43.0%       203.16  TOTAL sched_debug.cfs_rq[4]:/.MIN_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 7399.40       -47.5%      3881.02  lkp-ne04/micro/aim7/disk_src
                 7399.40       -47.5%      3881.02  TOTAL sched_debug.cfs_rq[14]:/.min_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   48.67      +183.6%       138.00  lkp-ne04/micro/aim7/disk_src
                   48.67      +183.6%       138.00  TOTAL sched_debug.cfs_rq[13]:/.nr_spread_over

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   32.33      +106.2%        66.67  lkp-ne04/micro/aim7/disk_src
                   32.33      +106.2%        66.67  TOTAL sched_debug.cfs_rq[9]:/.nr_spread_over

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   16.60       +71.1%        28.40  lkp-snb01/micro/aim7/creat-clo
                   16.60       +71.1%        28.40  TOTAL sched_debug.cfs_rq[29]:/.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   20.00      +105.0%        41.00  lkp-ne04/micro/aim7/disk_src
                   20.00      +105.0%        41.00  TOTAL sched_debug.cfs_rq[14]:/.runnable_load_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  187.66      +107.8%       390.04  lkp-ne04/micro/aim7/disk_src
                  187.66      +107.8%       390.04  TOTAL sched_debug.cfs_rq[15]:/.max_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  187.66      +107.8%       389.91  lkp-ne04/micro/aim7/disk_src
                  187.66      +107.8%       389.91  TOTAL sched_debug.cfs_rq[15]:/.MIN_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   12.00      +122.2%        26.67  lkp-ne04/micro/aim7/disk_src
                   12.00      +122.2%        26.67  TOTAL sched_debug.cpu#15.cpu_load[2]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1851.78       +48.6%      2750.96  lkp-ne04/micro/aim7/disk_src
                 1851.78       +48.6%      2750.96  TOTAL sched_debug.cfs_rq[7]:/.min_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               202616.60       -16.4%    169370.00  lkp-snb01/micro/aim7/creat-clo
               140921.67       -37.9%     87547.67  lkp-snb01/micro/will-it-scale/context_switch1
               343538.27       -25.2%    256917.67  TOTAL interrupts.CPU6.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   14.00       +72.9%        24.20  lkp-snb01/micro/aim7/creat-clo
                   14.00       +72.9%        24.20  TOTAL sched_debug.cpu#24.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                14116.00       -38.8%      8643.20  lkp-snb01/micro/aim7/creat-clo
                14116.00       -38.8%      8643.20  TOTAL softirqs.CPU10.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   83.20       +84.4%       153.40  lkp-snb01/micro/aim7/creat-clo
                   83.20       +84.4%       153.40  TOTAL sched_debug.cpu#24.curr->pid

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   16.20       +82.7%        29.60  lkp-snb01/micro/aim7/creat-clo
                   16.20       +82.7%        29.60  TOTAL sched_debug.cpu#29.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  107.00       -34.6%        70.00  lkp-ne04/micro/aim7/disk_src
                  107.00       -34.6%        70.00  TOTAL sched_debug.cpu#3.cpu_load[1]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   69.70       -45.3%        38.10  nhm-white/micro/aim7/link_test
                   69.70       -45.3%        38.10  TOTAL sched_debug.cpu#1.cpu_load[0]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               152934.33       -44.4%     85048.33  lkp-snb01/micro/will-it-scale/context_switch1
               152934.33       -44.4%     85048.33  TOTAL numa-vmstat.node1.numa_other

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  136.20       +59.5%       217.20  lkp-snb01/micro/aim7/creat-clo
                  136.20       +59.5%       217.20  TOTAL sched_debug.cfs_rq[28]:/.tg_load_contrib

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   41.22       -49.7%        20.72  lkp-snb01/micro/aim7/creat-clo
                   41.22       -49.7%        20.72  TOTAL sched_debug.cfs_rq[8]:/.MIN_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   41.22       -49.7%        20.72  lkp-snb01/micro/aim7/creat-clo
                   41.22       -49.7%        20.72  TOTAL sched_debug.cfs_rq[8]:/.max_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  135.20       +58.4%       214.20  lkp-snb01/micro/aim7/creat-clo
                  135.20       +58.4%       214.20  TOTAL sched_debug.cfs_rq[28]:/.blocked_load_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   38.60       -43.8%        21.70  nhm-white/micro/aim7/link_test
                   38.60       -43.8%        21.70  TOTAL sched_debug.cpu#1.cpu_load[1]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   48.00       -45.1%        26.33  lkp-ne04/micro/aim7/disk_src
                  273.80       -19.1%       221.40  lkp-snb01/micro/aim7/creat-clo
                  321.80       -23.0%       247.73  TOTAL sched_debug.cfs_rq[10]:/.runnable_load_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 2029.83       +59.9%      3246.26  lkp-ne04/micro/aim7/disk_src
                 2029.83       +59.9%      3246.26  TOTAL sched_debug.cfs_rq[15]:/.min_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   10.67       +81.2%        19.33  lkp-ne04/micro/aim7/disk_src
                   10.67       +81.2%        19.33  TOTAL sched_debug.cpu#15.cpu_load[3]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   38.33       +36.5%        52.33  lkp-ne04/micro/aim7/disk_src
                    5.80       -44.8%         3.20  lkp-snb01/micro/aim7/creat-clo
                   44.13       +25.8%        55.53  TOTAL sched_debug.cpu#4.cpu_load[3]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                15222.40       -38.1%      9427.00  lkp-snb01/micro/aim7/creat-clo
                15222.40       -38.1%      9427.00  TOTAL softirqs.CPU11.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   15.00       +53.3%        23.00  lkp-snb01/micro/aim7/creat-clo
                   15.00       +53.3%        23.00  TOTAL sched_debug.cpu#28.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  286.20       -36.2%       182.60  lkp-snb01/micro/aim7/creat-clo
                  286.20       -36.2%       182.60  TOTAL buddyinfo.Node.1.zone.Normal.0

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   29.00       +34.5%        39.00  lkp-ne04/micro/aim7/disk_src
                    3.60       -50.0%         1.80  lkp-snb01/micro/aim7/creat-clo
                   32.60       +25.2%        40.80  TOTAL sched_debug.cpu#4.cpu_load[4]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                14142.80       -34.2%      9300.40  lkp-snb01/micro/aim7/creat-clo
                14142.80       -34.2%      9300.40  TOTAL softirqs.CPU15.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   14.80       +52.7%        22.60  lkp-snb01/micro/aim7/creat-clo
                   14.80       +52.7%        22.60  TOTAL sched_debug.cfs_rq[26]:/.tg_runnable_contrib

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   16.60       +45.8%        24.20  lkp-snb01/micro/aim7/creat-clo
                   16.60       +45.8%        24.20  TOTAL sched_debug.cfs_rq[25]:/.tg_runnable_contrib

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  135.00       +60.6%       216.80  lkp-snb01/micro/aim7/creat-clo
                  135.00       +60.6%       216.80  TOTAL sched_debug.cfs_rq[26]:/.tg_load_contrib

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                    8.67       +65.4%        14.33  lkp-ne04/micro/aim7/disk_src
                    8.67       +65.4%        14.33  TOTAL sched_debug.cpu#15.cpu_load[4]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  134.00       +60.6%       215.20  lkp-snb01/micro/aim7/creat-clo
                  134.00       +60.6%       215.20  TOTAL sched_debug.cfs_rq[26]:/.blocked_load_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                13313.60       -29.0%      9450.40  lkp-snb01/micro/aim7/creat-clo
                13313.60       -29.0%      9450.40  TOTAL softirqs.CPU12.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               160640.20       +41.4%    227186.40  lkp-snb01/micro/aim7/creat-clo
               160640.20       +41.4%    227186.40  TOTAL sched_debug.cpu#24.ttwu_count

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   22.90       -43.2%        13.00  nhm-white/micro/aim7/link_test
                   22.90       -43.2%        13.00  TOTAL sched_debug.cpu#1.cpu_load[2]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                14410.00       -33.5%      9578.60  lkp-snb01/micro/aim7/creat-clo
                14410.00       -33.5%      9578.60  TOTAL softirqs.CPU13.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  806.00       +44.9%      1167.80  lkp-snb01/micro/aim7/creat-clo
                  806.00       +44.9%      1167.80  TOTAL sched_debug.cfs_rq[25]:/.avg->runnable_avg_sum

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                14707.60       -34.3%      9659.20  lkp-snb01/micro/aim7/creat-clo
                14707.60       -34.3%      9659.20  TOTAL softirqs.CPU14.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  804.00       +37.7%      1107.00  lkp-snb01/micro/aim7/creat-clo
                  804.00       +37.7%      1107.00  TOTAL sched_debug.cfs_rq[27]:/.avg->runnable_avg_sum

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   53.33       -48.1%        27.67  lkp-ne04/micro/aim7/disk_src
                  332.60       -21.0%       262.80  lkp-snb01/micro/aim7/creat-clo
                  385.93       -24.7%       290.47  TOTAL numa-vmstat.node0.nr_written

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                14395.20       -32.7%      9690.00  lkp-snb01/micro/aim7/creat-clo
                14395.20       -32.7%      9690.00  TOTAL softirqs.CPU0.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  292.40       -23.3%       224.40  lkp-snb01/micro/aim7/creat-clo
                  292.40       -23.3%       224.40  TOTAL slabinfo.nfsd4_stateids.num_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  301.00       -23.3%       231.00  lkp-snb01/micro/aim7/creat-clo
                  301.00       -23.3%       231.00  TOTAL slabinfo.xfs_buf_item.active_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   14.80       +63.5%        24.20  lkp-snb01/micro/aim7/creat-clo
                   14.80       +63.5%        24.20  TOTAL sched_debug.cpu#30.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  292.40       -23.3%       224.40  lkp-snb01/micro/aim7/creat-clo
                  292.40       -23.3%       224.40  TOTAL slabinfo.nfsd4_stateids.active_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  301.00       -23.3%       231.00  lkp-snb01/micro/aim7/creat-clo
                  301.00       -23.3%       231.00  TOTAL slabinfo.xfs_buf_item.num_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   16.20       +46.9%        23.80  lkp-snb01/micro/aim7/creat-clo
                   16.20       +46.9%        23.80  TOTAL sched_debug.cfs_rq[30]:/.tg_runnable_contrib

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  735.40       +46.3%      1075.60  lkp-snb01/micro/aim7/creat-clo
                  735.40       +46.3%      1075.60  TOTAL sched_debug.cfs_rq[26]:/.avg->runnable_avg_sum

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   97.20       +43.6%       139.60  lkp-snb01/micro/aim7/creat-clo
                   97.20       +43.6%       139.60  TOTAL sched_debug.cpu#25.curr->pid

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                12795.40       -30.6%      8875.80  lkp-snb01/micro/aim7/creat-clo
                12795.40       -30.6%      8875.80  TOTAL sched_debug.cpu#5.ttwu_local

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  156.80       +44.0%       225.80  lkp-snb01/micro/aim7/creat-clo
                  156.80       +44.0%       225.80  TOTAL sched_debug.cfs_rq[29]:/.tg_load_contrib

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               138543.33       +49.4%    206931.67  lkp-snb01/micro/will-it-scale/context_switch1
               138543.33       +49.4%    206931.67  TOTAL numa-vmstat.node0.numa_other

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   87.20       +59.9%       139.40  lkp-snb01/micro/aim7/creat-clo
                   87.20       +59.9%       139.40  TOTAL sched_debug.cpu#30.curr->pid

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               159242.80       +44.7%    230366.80  lkp-snb01/micro/aim7/creat-clo
               159242.80       +44.7%    230366.80  TOTAL sched_debug.cpu#26.ttwu_count

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  156.00       +44.0%       224.60  lkp-snb01/micro/aim7/creat-clo
                  156.00       +44.0%       224.60  TOTAL sched_debug.cfs_rq[29]:/.blocked_load_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               200890.00       -16.2%    168270.60  lkp-snb01/micro/aim7/creat-clo
               164584.67       +63.2%    268669.00  lkp-snb01/micro/will-it-scale/context_switch1
               365474.67       +19.6%    436939.60  TOTAL interrupts.CPU19.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               165543.40       +39.1%    230269.60  lkp-snb01/micro/aim7/creat-clo
               165543.40       +39.1%    230269.60  TOTAL sched_debug.cpu#28.ttwu_count

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   16.20       +39.5%        22.60  lkp-snb01/micro/aim7/creat-clo
                   16.20       +39.5%        22.60  TOTAL sched_debug.cfs_rq[29]:/.tg_runnable_contrib

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                12436.40       -25.6%      9247.40  lkp-snb01/micro/aim7/creat-clo
                12436.40       -25.6%      9247.40  TOTAL softirqs.CPU9.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  796.20       +42.3%      1133.00  lkp-snb01/micro/aim7/creat-clo
                  796.20       +42.3%      1133.00  TOTAL sched_debug.cfs_rq[30]:/.avg->runnable_avg_sum

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   15.80       +45.6%        23.00  lkp-snb01/micro/aim7/creat-clo
                   15.80       +45.6%        23.00  TOTAL sched_debug.cfs_rq[28]:/.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   75.00       -28.4%        53.67  lkp-ne04/micro/aim7/disk_src
                   75.00       -28.4%        53.67  TOTAL sched_debug.cpu#3.cpu_load[2]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                12139.00       -29.7%      8537.40  lkp-snb01/micro/aim7/creat-clo
                12139.00       -29.7%      8537.40  TOTAL sched_debug.cpu#8.ttwu_local

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  207.20       +39.5%       289.00  lkp-snb01/micro/aim7/creat-clo
                  207.20       +39.5%       289.00  TOTAL sched_debug.cfs_rq[0]:/.tg_runnable_contrib

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               165138.60       +37.6%    227204.00  lkp-snb01/micro/aim7/creat-clo
               165138.60       +37.6%    227204.00  TOTAL sched_debug.cpu#27.ttwu_count

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 9533.40       +39.3%     13278.40  lkp-snb01/micro/aim7/creat-clo
                 9533.40       +39.3%     13278.40  TOTAL sched_debug.cfs_rq[0]:/.avg->runnable_avg_sum

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                13344.80       -29.1%      9461.40  lkp-snb01/micro/aim7/creat-clo
                13344.80       -29.1%      9461.40  TOTAL sched_debug.cpu#2.ttwu_local

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               162160.60       +42.7%    231465.60  lkp-snb01/micro/aim7/creat-clo
               162160.60       +42.7%    231465.60  TOTAL sched_debug.cpu#25.ttwu_count

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  792.20       +36.5%      1081.00  lkp-snb01/micro/aim7/creat-clo
                  792.20       +36.5%      1081.00  TOTAL sched_debug.cfs_rq[29]:/.avg->runnable_avg_sum

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  155.00       +31.6%       204.00  lkp-ne04/micro/aim7/disk_src
                  155.00       +31.6%       204.00  TOTAL sched_debug.cpu#4.cpu_load[0]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  341.00       +25.1%       426.67  lkp-snb01/micro/will-it-scale/context_switch1
                  341.00       +25.1%       426.67  TOTAL slabinfo.taskstats.num_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  341.00       +25.1%       426.67  lkp-snb01/micro/will-it-scale/context_switch1
                  341.00       +25.1%       426.67  TOTAL slabinfo.taskstats.active_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   21.33       -25.0%        16.00  lkp-ne04/micro/aim7/disk_src
                   21.33       -25.0%        16.00  TOTAL sched_debug.cpu#11.cpu_load[4]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               170843.60       +36.1%    232513.00  lkp-snb01/micro/aim7/creat-clo
               170843.60       +36.1%    232513.00  TOTAL sched_debug.cpu#30.ttwu_count

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                11494.40       -28.4%      8231.00  lkp-snb01/micro/aim7/creat-clo
                11494.40       -28.4%      8231.00  TOTAL sched_debug.cpu#7.ttwu_local

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   28.67       -24.4%        21.67  lkp-ne04/micro/aim7/disk_src
                   28.67       -24.4%        21.67  TOTAL sched_debug.cpu#11.cpu_load[3]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 8760.67       +13.4%      9936.67  lkp-ne04/micro/aim7/disk_src
                13632.00       -24.8%     10246.40  lkp-snb01/micro/aim7/creat-clo
                22392.67        -9.9%     20183.07  TOTAL sched_debug.cpu#3.ttwu_local

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               323755.20       +29.4%    418800.00  lkp-snb01/micro/aim7/creat-clo
               323755.20       +29.4%    418800.00  TOTAL sched_debug.cpu#26.nr_switches

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               160870.60       +29.4%    208182.80  lkp-snb01/micro/aim7/creat-clo
               160870.60       +29.4%    208182.80  TOTAL sched_debug.cpu#26.sched_goidle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               323790.00       +29.4%    418825.60  lkp-snb01/micro/aim7/creat-clo
               323790.00       +29.4%    418825.60  TOTAL sched_debug.cpu#26.sched_count

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   37.70       +35.8%        51.20  nhm-white/micro/aim7/link_test
                   37.70       +35.8%        51.20  TOTAL sched_debug.cpu#5.cpu_load[0]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 5367.15       +48.0%      7944.85  lkp-ne04/micro/aim7/disk_src
                 5367.15       +48.0%      7944.85  TOTAL sched_debug.cfs_rq[13]:/.min_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1147.75       -24.0%       872.75  lkp-snb01/micro/aim7/creat-clo
                 1147.75       -24.0%       872.75  TOTAL sched_debug.cfs_rq[8]:/.min_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 2826.40       -18.9%      2292.20  lkp-snb01/micro/aim7/creat-clo
                 2826.40       -18.9%      2292.20  TOTAL sched_debug.cfs_rq[10]:/.nr_spread_over

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                11570.80       -26.4%      8521.20  lkp-snb01/micro/aim7/creat-clo
                11570.80       -26.4%      8521.20  TOTAL sched_debug.cpu#6.ttwu_local

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              7566941.80       -21.3%   5957205.80  lkp-snb01/micro/aim7/creat-clo
              7566941.80       -21.3%   5957205.80  TOTAL sched_debug.cpu#8.sched_count

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              7566802.20       -21.3%   5957140.80  lkp-snb01/micro/aim7/creat-clo
              7566802.20       -21.3%   5957140.80  TOTAL sched_debug.cpu#8.nr_switches

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              3778086.20       -21.3%   2975132.80  lkp-snb01/micro/aim7/creat-clo
              3778086.20       -21.3%   2975132.80  TOTAL sched_debug.cpu#8.sched_goidle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              3793901.40       -21.8%   2967445.20  lkp-snb01/micro/aim7/creat-clo
              3793901.40       -21.8%   2967445.20  TOTAL sched_debug.cpu#8.ttwu_count

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               107806.80       +31.1%    141368.80  lkp-snb01/micro/aim7/creat-clo
               107806.80       +31.1%    141368.80  TOTAL sched_debug.cpu#4.avg_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  528.00       +30.6%       689.33  lkp-snb01/micro/will-it-scale/context_switch1
                  528.00       +30.6%       689.33  TOTAL slabinfo.blkdev_requests.active_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  528.00       +30.6%       689.33  lkp-snb01/micro/will-it-scale/context_switch1
                  528.00       +30.6%       689.33  TOTAL slabinfo.blkdev_requests.num_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   17.40       +40.2%        24.40  lkp-snb01/micro/aim7/creat-clo
                   17.40       +40.2%        24.40  TOTAL sched_debug.cfs_rq[28]:/.tg_runnable_contrib

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                    5.20       +53.8%         8.00  lkp-snb01/micro/aim7/creat-clo
                    5.20       +53.8%         8.00  TOTAL sched_debug.cpu#20.cpu_load[1]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1015.40       +31.0%      1330.00  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
                  682.20       +30.7%       891.80  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
                 1697.60       +30.9%      2221.80  TOTAL proc-vmstat.kswapd_low_wmark_hit_quickly

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  845.60       +38.1%      1168.00  lkp-snb01/micro/aim7/creat-clo
                  845.60       +38.1%      1168.00  TOTAL sched_debug.cfs_rq[28]:/.avg->runnable_avg_sum

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                26681.00       -36.2%     17030.00  lkp-a03/micro/will-it-scale/context_switch1
              1225234.40       -19.6%    985630.60  lkp-snb01/micro/aim7/creat-clo
                22339.80       +11.2%     24832.20  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
              1274255.20       -19.4%   1027492.80  TOTAL softirqs.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  620.00       -16.0%       520.67  lkp-ne04/micro/aim7/disk_src
                  620.00       -16.0%       520.67  TOTAL sched_debug.cpu#11.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               202170.60       -16.5%    168770.20  lkp-snb01/micro/aim7/creat-clo
               142278.67       -44.0%     79663.67  lkp-snb01/micro/will-it-scale/context_switch1
               344449.27       -27.9%    248433.87  TOTAL interrupts.CPU7.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   87.67       -30.0%        61.33  lkp-ne04/micro/aim7/disk_src
                   87.67       -30.0%        61.33  TOTAL sched_debug.cfs_rq[2]:/.runnable_load_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               493945.00       -31.1%    340371.40  lkp-snb01/micro/aim7/creat-clo
                12139.00       -12.5%     10616.67  lkp-snb01/micro/will-it-scale/context_switch1
               506084.00       -30.6%    350988.07  TOTAL softirqs.CPU8.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  744.33       -20.6%       591.00  lkp-ne04/micro/aim7/disk_src
                  233.00       +32.5%       308.80  lkp-snb01/micro/aim7/creat-clo
                  977.33        -7.9%       899.80  TOTAL sched_debug.cfs_rq[0]:/.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  230.00       -25.9%       170.33  lkp-ne04/micro/aim7/disk_src
                  230.00       -25.9%       170.33  TOTAL sched_debug.cpu#15.nr_uninterruptible

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 3467.33       -20.4%      2758.33  lkp-ne04/micro/aim7/disk_src
                 3467.33       -20.4%      2758.33  TOTAL sched_debug.cpu#4.curr->pid

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                12489.00       -24.7%      9403.80  lkp-snb01/micro/aim7/creat-clo
                12489.00       -24.7%      9403.80  TOTAL sched_debug.cpu#4.ttwu_local

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               171287.60       +33.5%    228607.80  lkp-snb01/micro/aim7/creat-clo
               171287.60       +33.5%    228607.80  TOTAL sched_debug.cpu#29.ttwu_count

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                64847.40       -21.0%     51242.60  lkp-snb01/micro/aim7/creat-clo
                64847.40       -21.0%     51242.60  TOTAL softirqs.CPU31.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                66470.20       -21.5%     52190.60  lkp-snb01/micro/aim7/creat-clo
                66470.20       -21.5%     52190.60  TOTAL softirqs.CPU26.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  580.00       +24.9%       724.40  lkp-snb01/micro/aim7/creat-clo
                  580.00       +24.9%       724.40  TOTAL sched_debug.cfs_rq[0]:/.blocked_load_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  319.33       +72.6%       551.21  lkp-ne04/micro/aim7/disk_src
                  319.33       +72.6%       551.21  TOTAL sched_debug.cfs_rq[7]:/.MIN_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                65089.80       -20.7%     51616.40  lkp-snb01/micro/aim7/creat-clo
                65089.80       -20.7%     51616.40  TOTAL softirqs.CPU30.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  319.49       +72.5%       551.24  lkp-ne04/micro/aim7/disk_src
                  319.49       +72.5%       551.24  TOTAL sched_debug.cfs_rq[7]:/.max_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               285768.00       -23.2%    219611.67  lkp-snb01/micro/will-it-scale/context_switch1
               285768.00       -23.2%    219611.67  TOTAL numa-vmstat.node0.numa_local

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   16.40       +45.1%        23.80  lkp-snb01/micro/aim7/creat-clo
                   16.40       +45.1%        23.80  TOTAL sched_debug.cpu#25.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  340.80       -27.3%       247.80  lkp-snb01/micro/aim7/creat-clo
                  340.80       -27.3%       247.80  TOTAL sched_debug.cfs_rq[1]:/.nr_spread_over

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                65736.40       -20.9%     51981.00  lkp-snb01/micro/aim7/creat-clo
                65736.40       -20.9%     51981.00  TOTAL softirqs.CPU27.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  596.40       +24.7%       743.60  lkp-snb01/micro/aim7/creat-clo
                  596.40       +24.7%       743.60  TOTAL sched_debug.cfs_rq[0]:/.tg_load_contrib

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  346.20       -20.5%       275.20  lkp-snb01/micro/aim7/creat-clo
                  346.20       -20.5%       275.20  TOTAL numa-vmstat.node0.nr_dirtied

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                64669.40       -20.6%     51375.40  lkp-snb01/micro/aim7/creat-clo
                64669.40       -20.6%     51375.40  TOTAL softirqs.CPU24.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 2012.67       -18.5%      1639.33  lkp-ne04/micro/aim7/disk_src
                 2012.67       -18.5%      1639.33  TOTAL sched_debug.cpu#11.curr->pid

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                65203.00       -20.5%     51862.20  lkp-snb01/micro/aim7/creat-clo
                65203.00       -20.5%     51862.20  TOTAL softirqs.CPU29.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                67369.40       -22.8%     52010.40  lkp-snb01/micro/aim7/creat-clo
                67369.40       -22.8%     52010.40  TOTAL softirqs.CPU25.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                13464.33       -20.8%     10661.67  lkp-snb01/micro/will-it-scale/context_switch1
                13464.33       -20.8%     10661.67  TOTAL softirqs.CPU14.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                24236.33       -19.0%     19634.67  lkp-a03/micro/will-it-scale/context_switch1
               242725.40       +36.6%    331444.80  lkp-snb01/micro/aim7/creat-clo
                18116.00       -10.5%     16220.67  lkp-snb01/micro/will-it-scale/context_switch1
               285077.73       +28.8%    367300.13  TOTAL softirqs.CPU0.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                65770.20       -22.3%     51134.60  lkp-snb01/micro/aim7/creat-clo
                65770.20       -22.3%     51134.60  TOTAL softirqs.CPU28.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  320.20       -21.4%       251.60  lkp-snb01/micro/aim7/creat-clo
                  320.20       -21.4%       251.60  TOTAL sched_debug.cfs_rq[0]:/.nr_spread_over

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   15.67       +38.3%        21.67  lkp-ne04/micro/aim7/disk_src
                   15.67       +38.3%        21.67  TOTAL sched_debug.cpu#14.cpu_load[2]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                15266.67       -20.9%     12074.33  lkp-snb01/micro/will-it-scale/context_switch1
                15266.67       -20.9%     12074.33  TOTAL softirqs.CPU11.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  583.80       -18.8%       474.00  lkp-snb01/micro/aim7/creat-clo
                  583.80       -18.8%       474.00  TOTAL sched_debug.cfs_rq[14]:/.nr_spread_over

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1060314.60       -16.8%    881716.00  lkp-snb01/micro/aim7/creat-clo
              1060314.60       -16.8%    881716.00  TOTAL numa-numastat.node1.local_node

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1060314.60       -16.8%    881716.00  lkp-snb01/micro/aim7/creat-clo
              1060314.60       -16.8%    881716.00  TOTAL numa-numastat.node1.numa_hit

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 8519.02        -8.9%      7764.07  lkp-ne04/micro/aim7/disk_src
               126078.96       -25.6%     93828.03  lkp-snb01/micro/aim7/creat-clo
               134597.98       -24.5%    101592.10  TOTAL sched_debug.cfs_rq[8]:/.exec_clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  756.67       -20.3%       603.33  lkp-ne04/micro/aim7/disk_src
                  235.00       +28.9%       303.00  lkp-snb01/micro/aim7/creat-clo
                  991.67        -8.6%       906.33  TOTAL sched_debug.cpu#0.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                42138.67       -22.2%     32771.67  lkp-a03/micro/will-it-scale/context_switch1
               103092.20       -15.7%     86919.80  lkp-snb01/micro/aim7/creat-clo
               145230.87       -17.6%    119691.47  TOTAL softirqs.CPU2.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  545.33       -17.2%       451.33  lkp-ne04/micro/aim7/disk_src
                  376.40       -18.2%       307.80  lkp-snb01/micro/aim7/creat-clo
                  921.73       -17.6%       759.13  TOTAL sched_debug.cfs_rq[8]:/.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                22667.00       -19.8%     18169.00  lkp-a03/micro/will-it-scale/context_switch1
                15494.67       -13.1%     13468.33  lkp-snb01/micro/will-it-scale/context_switch1
                38161.67       -17.1%     31637.33  TOTAL softirqs.CPU3.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                44193.67       -18.7%     35930.00  lkp-a03/micro/will-it-scale/context_switch1
               102960.40       -16.1%     86373.00  lkp-snb01/micro/aim7/creat-clo
               147154.07       -16.9%    122303.00  TOTAL softirqs.CPU1.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4670.28       -34.1%      3077.87  lkp-snb01/micro/aim7/creat-clo
                 4670.28       -34.1%      3077.87  TOTAL sched_debug.cfs_rq[31]:/.min_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                62200.80       -16.3%     52052.40  lkp-snb01/micro/aim7/creat-clo
                62200.80       -16.3%     52052.40  TOTAL softirqs.CPU19.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               272895.33       +26.0%    343914.00  lkp-snb01/micro/will-it-scale/context_switch1
               272895.33       +26.0%    343914.00  TOTAL numa-vmstat.node1.numa_local

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  914.60       -17.0%       759.40  lkp-snb01/micro/aim7/creat-clo
                  914.60       -17.0%       759.40  TOTAL sched_debug.cfs_rq[8]:/.tg_load_contrib

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  889.80       -16.5%       743.40  lkp-snb01/micro/aim7/creat-clo
                  889.80       -16.5%       743.40  TOTAL sched_debug.cfs_rq[8]:/.blocked_load_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  825.00       -13.7%       711.67  lkp-ne04/micro/aim7/disk_src
                  825.00       -13.7%       711.67  TOTAL sched_debug.cfs_rq[4]:/.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 5629.60       -16.3%      4711.00  lkp-snb01/micro/aim7/creat-clo
                 5629.60       -16.3%      4711.00  TOTAL sched_debug.cpu#10.curr->pid

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                21828.33       -20.3%     17403.67  lkp-a03/micro/will-it-scale/context_switch1
                21828.33       -20.3%     17403.67  TOTAL softirqs.CPU2.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 2160.67       -14.8%      1841.00  lkp-snb01/micro/will-it-scale/context_switch1
                 2160.67       -14.8%      1841.00  TOTAL slabinfo.kmalloc-512.active_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               329192.40       +29.1%    425059.40  lkp-snb01/micro/aim7/creat-clo
               329192.40       +29.1%    425059.40  TOTAL sched_debug.cpu#25.nr_switches

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               329223.60       +29.1%    425087.00  lkp-snb01/micro/aim7/creat-clo
               329223.60       +29.1%    425087.00  TOTAL sched_debug.cpu#25.sched_count

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  371.20       -18.2%       303.60  lkp-snb01/micro/aim7/creat-clo
                  371.20       -18.2%       303.60  TOTAL sched_debug.cpu#8.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  177.20       -20.1%       141.60  lkp-snb01/micro/aim7/creat-clo
                  177.20       -20.1%       141.60  TOTAL sched_debug.cpu#10.cpu_load[1]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  102.80       -19.3%        83.00  lkp-snb01/micro/aim7/creat-clo
                  102.80       -19.3%        83.00  TOTAL sched_debug.cpu#10.cpu_load[2]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               163398.60       +29.0%    210820.80  lkp-snb01/micro/aim7/creat-clo
               163398.60       +29.0%    210820.80  TOTAL sched_debug.cpu#25.sched_goidle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1156.60       -17.1%       958.40  lkp-snb01/micro/aim7/creat-clo
                 1156.60       -17.1%       958.40  TOTAL proc-vmstat.nr_written

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   57.80       -18.0%        47.40  lkp-snb01/micro/aim7/creat-clo
                   57.80       -18.0%        47.40  TOTAL sched_debug.cpu#10.cpu_load[3]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                61404.20       -15.7%     51789.40  lkp-snb01/micro/aim7/creat-clo
                61404.20       -15.7%     51789.40  TOTAL softirqs.CPU16.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102033.00       -16.4%     85315.60  lkp-snb01/micro/aim7/creat-clo
               102033.00       -16.4%     85315.60  TOTAL sched_debug.cpu#1.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               201918.20       -16.5%    168620.80  lkp-snb01/micro/aim7/creat-clo
               201918.20       -16.5%    168620.80  TOTAL interrupts.CPU15.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  831.00       -19.7%       667.00  lkp-ne04/micro/aim7/disk_src
                  831.00       -19.7%       667.00  TOTAL sched_debug.cpu#4.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               201829.20       -16.3%    168872.80  lkp-snb01/micro/aim7/creat-clo
               201829.20       -16.3%    168872.80  TOTAL interrupts.CPU9.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               202414.00       -16.4%    169243.00  lkp-snb01/micro/aim7/creat-clo
               202414.00       -16.4%    169243.00  TOTAL interrupts.CPU5.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               202030.00       -16.5%    168646.00  lkp-snb01/micro/aim7/creat-clo
               202030.00       -16.5%    168646.00  TOTAL interrupts.CPU8.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               202081.40       -16.4%    168846.20  lkp-snb01/micro/aim7/creat-clo
               202081.40       -16.4%    168846.20  TOTAL interrupts.CPU14.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               202655.80       -16.4%    169344.00  lkp-snb01/micro/aim7/creat-clo
               202655.80       -16.4%    169344.00  TOTAL interrupts.CPU11.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               202026.20       -16.5%    168778.20  lkp-snb01/micro/aim7/creat-clo
               202026.20       -16.5%    168778.20  TOTAL interrupts.CPU12.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               201875.80       -16.2%    169188.20  lkp-snb01/micro/aim7/creat-clo
               201875.80       -16.2%    169188.20  TOTAL interrupts.CPU0.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 2015.00       -19.7%      1617.80  lkp-snb01/micro/aim7/creat-clo
                 2015.00       -19.7%      1617.80  TOTAL sched_debug.cpu#8.curr->pid

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               202419.80       -16.4%    169255.40  lkp-snb01/micro/aim7/creat-clo
               202419.80       -16.4%    169255.40  TOTAL interrupts.CPU2.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               202670.40       -16.5%    169137.60  lkp-snb01/micro/aim7/creat-clo
               202670.40       -16.5%    169137.60  TOTAL interrupts.CPU4.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               202947.40       -16.4%    169736.60  lkp-snb01/micro/aim7/creat-clo
               202947.40       -16.4%    169736.60  TOTAL interrupts.CPU13.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               202387.00       -16.6%    168739.80  lkp-snb01/micro/aim7/creat-clo
               202387.00       -16.6%    168739.80  TOTAL interrupts.CPU1.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101395.20       -16.3%     84899.00  lkp-snb01/micro/aim7/creat-clo
               101395.20       -16.3%     84899.00  TOTAL sched_debug.cpu#22.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102645.40       -16.2%     86000.80  lkp-snb01/micro/aim7/creat-clo
               102645.40       -16.2%     86000.80  TOTAL sched_debug.cpu#5.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               103460.60       -16.0%     86862.40  lkp-snb01/micro/aim7/creat-clo
               103460.60       -16.0%     86862.40  TOTAL softirqs.CPU5.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   20.00       +25.0%        25.00  lkp-snb01/micro/aim7/creat-clo
                   20.00       +25.0%        25.00  TOTAL sched_debug.cfs_rq[24]:/.tg_runnable_contrib

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               203627.60       -16.5%    169968.80  lkp-snb01/micro/aim7/creat-clo
               203627.60       -16.5%    169968.80  TOTAL interrupts.CPU3.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               176856.67       -17.6%    145656.33  lkp-a03/micro/will-it-scale/context_switch1
              3273694.20       -15.6%   2763350.20  lkp-snb01/micro/aim7/creat-clo
              3450550.87       -15.7%   2909006.53  TOTAL softirqs.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                12530.80       -26.9%      9165.60  lkp-snb01/micro/aim7/creat-clo
                12530.80       -26.9%      9165.60  TOTAL softirqs.CPU5.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               117133.40       -17.7%     96402.80  lkp-snb01/micro/aim7/creat-clo
               117133.40       -17.7%     96402.80  TOTAL sched_debug.cpu#0.avg_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101837.40       -16.3%     85216.20  lkp-snb01/micro/aim7/creat-clo
               101837.40       -16.3%     85216.20  TOTAL sched_debug.cpu#7.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               201130.40       -16.3%    168299.80  lkp-snb01/micro/aim7/creat-clo
               201130.40       -16.3%    168299.80  TOTAL interrupts.CPU22.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101480.60       -16.2%     85028.80  lkp-snb01/micro/aim7/creat-clo
               101480.60       -16.2%     85028.80  TOTAL sched_debug.cpu#15.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               103484.00       -16.1%     86838.00  lkp-snb01/micro/aim7/creat-clo
               103484.00       -16.1%     86838.00  TOTAL sched_debug.cpu#3.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102516.60       -16.3%     85757.20  lkp-snb01/micro/aim7/creat-clo
               102516.60       -16.3%     85757.20  TOTAL sched_debug.cpu#13.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102697.20       -16.1%     86125.80  lkp-snb01/micro/aim7/creat-clo
               102697.20       -16.1%     86125.80  TOTAL softirqs.CPU7.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               200647.60       -16.1%    168317.20  lkp-snb01/micro/aim7/creat-clo
               200647.60       -16.1%    168317.20  TOTAL interrupts.CPU18.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101666.40       -16.2%     85161.00  lkp-snb01/micro/aim7/creat-clo
               101666.40       -16.2%     85161.00  TOTAL sched_debug.cpu#8.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102412.20       -16.1%     85971.40  lkp-snb01/micro/aim7/creat-clo
               102412.20       -16.1%     85971.40  TOTAL softirqs.CPU15.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               103333.40       -16.2%     86558.20  lkp-snb01/micro/aim7/creat-clo
               103333.40       -16.2%     86558.20  TOTAL softirqs.CPU13.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102567.80       -16.0%     86117.40  lkp-snb01/micro/aim7/creat-clo
               102567.80       -16.0%     86117.40  TOTAL softirqs.CPU8.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               103689.00       -16.1%     87016.60  lkp-snb01/micro/aim7/creat-clo
               103689.00       -16.1%     87016.60  TOTAL sched_debug.cpu#10.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               203908.60       -16.5%    170288.40  lkp-snb01/micro/aim7/creat-clo
               101519.00       -28.2%     72896.00  lkp-snb01/micro/will-it-scale/context_switch1
               305427.60       -20.4%    243184.40  TOTAL interrupts.CPU10.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               201008.80       -16.3%    168307.00  lkp-snb01/micro/aim7/creat-clo
               201008.80       -16.3%    168307.00  TOTAL interrupts.CPU21.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102576.80       -16.0%     86148.60  lkp-snb01/micro/aim7/creat-clo
               102576.80       -16.0%     86148.60  TOTAL softirqs.CPU14.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101349.80       -16.3%     84803.80  lkp-snb01/micro/aim7/creat-clo
               101349.80       -16.3%     84803.80  TOTAL sched_debug.cpu#20.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101721.60       -16.2%     85275.60  lkp-snb01/micro/aim7/creat-clo
               101721.60       -16.2%     85275.60  TOTAL sched_debug.cpu#14.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101979.60       -16.4%     85269.00  lkp-snb01/micro/aim7/creat-clo
               101979.60       -16.4%     85269.00  TOTAL sched_debug.cpu#9.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               201394.60       -16.1%    168871.00  lkp-snb01/micro/aim7/creat-clo
               201394.60       -16.1%    168871.00  TOTAL interrupts.CPU17.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               104089.80       -16.2%     87261.20  lkp-snb01/micro/aim7/creat-clo
               104089.80       -16.2%     87261.20  TOTAL softirqs.CPU4.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               104270.80       -15.9%     87673.00  lkp-snb01/micro/aim7/creat-clo
               104270.80       -15.9%     87673.00  TOTAL softirqs.CPU10.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101518.20       -15.9%     85360.00  lkp-snb01/micro/aim7/creat-clo
               101518.20       -15.9%     85360.00  TOTAL sched_debug.cpu#16.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102828.80       -15.9%     86474.80  lkp-snb01/micro/aim7/creat-clo
               102828.80       -15.9%     86474.80  TOTAL softirqs.CPU17.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               103007.00       -16.3%     86267.20  lkp-snb01/micro/aim7/creat-clo
               103007.00       -16.3%     86267.20  TOTAL softirqs.CPU9.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                63258.80       -15.3%     53567.40  lkp-snb01/micro/aim7/creat-clo
                63258.80       -15.3%     53567.40  TOTAL softirqs.CPU18.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               103427.80       -16.3%     86536.80  lkp-snb01/micro/aim7/creat-clo
               103427.80       -16.3%     86536.80  TOTAL sched_debug.cpu#4.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               103328.40       -15.9%     86915.00  lkp-snb01/micro/aim7/creat-clo
               103328.40       -15.9%     86915.00  TOTAL sched_debug.cpu#11.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101230.40       -16.1%     84917.60  lkp-snb01/micro/aim7/creat-clo
               101230.40       -16.1%     84917.60  TOTAL sched_debug.cpu#21.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               200599.20       -16.0%    168528.00  lkp-snb01/micro/aim7/creat-clo
               200599.20       -16.0%    168528.00  TOTAL interrupts.CPU16.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              7139519.20       -15.6%   6028443.00  lkp-snb01/micro/aim7/creat-clo
              7139519.20       -15.6%   6028443.00  TOTAL proc-vmstat.pgfault

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               198682.60       -15.2%    168440.80  lkp-snb01/micro/aim7/creat-clo
               198682.60       -15.2%    168440.80  TOTAL interrupts.CPU25.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102102.40       -16.0%     85784.60  lkp-snb01/micro/aim7/creat-clo
               102102.40       -16.0%     85784.60  TOTAL sched_debug.cpu#0.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102821.20       -16.5%     85902.00  lkp-snb01/micro/aim7/creat-clo
               102821.20       -16.5%     85902.00  TOTAL sched_debug.cpu#17.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               200508.60       -16.1%    168260.20  lkp-snb01/micro/aim7/creat-clo
               200508.60       -16.1%    168260.20  TOTAL interrupts.CPU20.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               103893.80       -15.8%     87520.40  lkp-snb01/micro/aim7/creat-clo
               103893.80       -15.8%     87520.40  TOTAL softirqs.CPU11.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102025.20       -15.9%     85809.40  lkp-snb01/micro/aim7/creat-clo
               102025.20       -15.9%     85809.40  TOTAL softirqs.CPU22.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                12529.67       -21.0%      9893.67  lkp-snb01/micro/will-it-scale/context_switch1
                12529.67       -21.0%      9893.67  TOTAL softirqs.CPU15.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                61165.60       -14.5%     52277.60  lkp-snb01/micro/aim7/creat-clo
                61165.60       -14.5%     52277.60  TOTAL softirqs.CPU23.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101870.20       -15.5%     86055.80  lkp-snb01/micro/aim7/creat-clo
               101870.20       -15.5%     86055.80  TOTAL softirqs.CPU16.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               103033.20       -16.0%     86548.20  lkp-snb01/micro/aim7/creat-clo
               103033.20       -16.0%     86548.20  TOTAL softirqs.CPU6.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              6431696.60       -16.0%   5401202.60  lkp-snb01/micro/aim7/creat-clo
              6431696.60       -16.0%   5401202.60  TOTAL interrupts.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102231.60       -16.1%     85723.60  lkp-snb01/micro/aim7/creat-clo
               102231.60       -16.1%     85723.60  TOTAL sched_debug.cpu#6.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101438.60       -16.4%     84794.60  lkp-snb01/micro/aim7/creat-clo
               101438.60       -16.4%     84794.60  TOTAL sched_debug.cpu#19.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  596.34       -14.3%       511.17  lkp-a03/micro/will-it-scale/context_switch1
                24188.18       -18.7%     19671.07  lkp-snb01/micro/aim7/creat-clo
                24784.53       -18.6%     20182.25  TOTAL uptime.idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               199342.80       -15.5%    168346.20  lkp-snb01/micro/aim7/creat-clo
               199342.80       -15.5%    168346.20  TOTAL interrupts.CPU30.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102248.00       -15.8%     86076.00  lkp-snb01/micro/aim7/creat-clo
               102248.00       -15.8%     86076.00  TOTAL sched_debug.cpu#2.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               200034.60       -15.8%    168345.00  lkp-snb01/micro/aim7/creat-clo
               200034.60       -15.8%    168345.00  TOTAL interrupts.CPU23.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               100681.00       -14.9%     85662.60  lkp-snb01/micro/aim7/creat-clo
               100681.00       -14.9%     85662.60  TOTAL sched_debug.cpu#25.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101720.60       -15.8%     85647.80  lkp-snb01/micro/aim7/creat-clo
               101720.60       -15.8%     85647.80  TOTAL softirqs.CPU20.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               456144.61       -18.1%    373456.31  lkp-snb01/micro/aim7/creat-clo
               456144.61       -18.1%    373456.31  TOTAL sched_debug.ktime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                98953.20       -15.2%     83906.80  lkp-snb01/micro/aim7/creat-clo
                98953.20       -15.2%     83906.80  TOTAL softirqs.CPU22.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               197658.40       -14.8%    168311.40  lkp-snb01/micro/aim7/creat-clo
               197658.40       -14.8%    168311.40  TOTAL interrupts.CPU26.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               197951.40       -15.0%    168326.20  lkp-snb01/micro/aim7/creat-clo
               197951.40       -15.0%    168326.20  TOTAL interrupts.CPU29.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457514.93       -18.2%    374323.58  lkp-snb01/micro/aim7/creat-clo
               457514.93       -18.2%    374323.58  TOTAL sched_debug.cpu#27.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457518.03       -18.2%    374329.83  lkp-snb01/micro/aim7/creat-clo
               457518.03       -18.2%    374329.83  TOTAL sched_debug.cpu#22.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457525.45       -18.2%    374336.88  lkp-snb01/micro/aim7/creat-clo
               457525.45       -18.2%    374336.88  TOTAL sched_debug.cpu#21.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457518.34       -18.2%    374322.20  lkp-snb01/micro/aim7/creat-clo
               457518.34       -18.2%    374322.20  TOTAL sched_debug.cpu#23.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457515.32       -18.2%    374330.25  lkp-snb01/micro/aim7/creat-clo
               457515.32       -18.2%    374330.25  TOTAL sched_debug.cpu#26.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457515.34       -18.2%    374324.58  lkp-snb01/micro/aim7/creat-clo
               457515.34       -18.2%    374324.58  TOTAL sched_debug.cpu#30.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457524.44       -18.2%    374357.67  lkp-snb01/micro/aim7/creat-clo
               457524.44       -18.2%    374357.67  TOTAL sched_debug.cpu#25.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457507.98       -18.2%    374314.62  lkp-snb01/micro/aim7/creat-clo
               457507.98       -18.2%    374314.62  TOTAL sched_debug.cpu#31.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457524.52       -18.2%    374338.50  lkp-snb01/micro/aim7/creat-clo
               457524.52       -18.2%    374338.50  TOTAL sched_debug.cpu#19.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457526.19       -18.2%    374347.44  lkp-snb01/micro/aim7/creat-clo
               457526.19       -18.2%    374347.44  TOTAL sched_debug.cpu#18.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457526.72       -18.2%    374355.16  lkp-snb01/micro/aim7/creat-clo
               457526.72       -18.2%    374355.16  TOTAL sched_debug.cpu#16.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457535.58       -18.2%    374368.32  lkp-snb01/micro/aim7/creat-clo
               457535.58       -18.2%    374368.32  TOTAL sched_debug.cpu#15.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457514.51       -18.2%    374343.84  lkp-snb01/micro/aim7/creat-clo
               457514.51       -18.2%    374343.84  TOTAL sched_debug.cpu#29.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457551.93       -18.2%    374372.14  lkp-snb01/micro/aim7/creat-clo
               457551.93       -18.2%    374372.14  TOTAL sched_debug.cpu#6.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457531.59       -18.2%    374361.47  lkp-snb01/micro/aim7/creat-clo
               457531.59       -18.2%    374361.47  TOTAL sched_debug.cpu#2.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457521.68       -18.2%    374352.34  lkp-snb01/micro/aim7/creat-clo
               457521.68       -18.2%    374352.34  TOTAL sched_debug.cpu#9.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457537.94       -18.2%    374356.02  lkp-snb01/micro/aim7/creat-clo
               457537.94       -18.2%    374356.02  TOTAL sched_debug.cpu#1.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457548.24       -18.2%    374376.78  lkp-snb01/micro/aim7/creat-clo
               457548.24       -18.2%    374376.78  TOTAL sched_debug.cpu#5.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457551.85       -18.2%    374373.37  lkp-snb01/micro/aim7/creat-clo
               457551.85       -18.2%    374373.37  TOTAL sched_debug.cpu#7.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457552.69       -18.2%    374381.92  lkp-snb01/micro/aim7/creat-clo
               457552.69       -18.2%    374381.92  TOTAL sched_debug.cpu#3.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457552.17       -18.2%    374381.45  lkp-snb01/micro/aim7/creat-clo
               457552.17       -18.2%    374381.45  TOTAL sched_debug.sched_clk

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457552.17       -18.2%    374381.45  lkp-snb01/micro/aim7/creat-clo
               457552.17       -18.2%    374381.45  TOTAL sched_debug.cpu_clk

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457552.92       -18.2%    374380.13  lkp-snb01/micro/aim7/creat-clo
               457552.92       -18.2%    374380.13  TOTAL sched_debug.cpu#4.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457554.44       -18.2%    374383.89  lkp-snb01/micro/aim7/creat-clo
               457554.44       -18.2%    374383.89  TOTAL sched_debug.cpu#10.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457539.55       -18.2%    374377.53  lkp-snb01/micro/aim7/creat-clo
               457539.55       -18.2%    374377.53  TOTAL sched_debug.cpu#14.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457555.20       -18.2%    374384.61  lkp-snb01/micro/aim7/creat-clo
               457555.20       -18.2%    374384.61  TOTAL sched_debug.cpu#11.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457544.97       -18.2%    374370.74  lkp-snb01/micro/aim7/creat-clo
               457544.97       -18.2%    374370.74  TOTAL sched_debug.cpu#17.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457552.65       -18.2%    374381.70  lkp-snb01/micro/aim7/creat-clo
               457552.65       -18.2%    374381.70  TOTAL sched_debug.cpu#12.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457541.53       -18.2%    374369.92  lkp-snb01/micro/aim7/creat-clo
               457541.53       -18.2%    374369.92  TOTAL sched_debug.cpu#20.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457550.30       -18.2%    374359.24  lkp-snb01/micro/aim7/creat-clo
               457550.30       -18.2%    374359.24  TOTAL sched_debug.cpu#24.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457542.97       -18.2%    374369.73  lkp-snb01/micro/aim7/creat-clo
               457542.97       -18.2%    374369.73  TOTAL sched_debug.cpu#8.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457545.21       -18.2%    374376.96  lkp-snb01/micro/aim7/creat-clo
               457545.21       -18.2%    374376.96  TOTAL sched_debug.cpu#13.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457540.45       -18.2%    374363.26  lkp-snb01/micro/aim7/creat-clo
               457540.45       -18.2%    374363.26  TOTAL sched_debug.cpu#28.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               457508.95       -18.2%    374364.21  lkp-snb01/micro/aim7/creat-clo
               457508.95       -18.2%    374364.21  TOTAL sched_debug.cpu#0.clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101274.80       -14.6%     86461.60  lkp-snb01/micro/aim7/creat-clo
               101274.80       -14.6%     86461.60  TOTAL softirqs.CPU25.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                13388.67       -19.9%     10721.00  lkp-snb01/micro/will-it-scale/context_switch1
                13388.67       -19.9%     10721.00  TOTAL softirqs.CPU12.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                97643.40       -13.6%     84344.60  lkp-snb01/micro/aim7/creat-clo
                13237.00       -23.5%     10120.33  lkp-snb01/micro/will-it-scale/context_switch1
               110880.40       -14.8%     94464.93  TOTAL softirqs.CPU25.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1159.80       -16.3%       971.20  lkp-snb01/micro/aim7/creat-clo
                 1159.80       -16.3%       971.20  TOTAL proc-vmstat.nr_dirtied

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                15377.33       -14.0%     13222.33  lkp-snb01/micro/will-it-scale/context_switch1
                15377.33       -14.0%     13222.33  TOTAL softirqs.CPU4.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               100321.80       -15.4%     84891.00  lkp-snb01/micro/aim7/creat-clo
               100321.80       -15.4%     84891.00  TOTAL sched_debug.cpu#29.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               100948.60       -16.1%     84708.60  lkp-snb01/micro/aim7/creat-clo
               100948.60       -16.1%     84708.60  TOTAL sched_debug.cpu#23.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102567.20       -15.9%     86242.20  lkp-snb01/micro/aim7/creat-clo
               102567.20       -15.9%     86242.20  TOTAL sched_debug.cpu#12.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101554.80       -16.0%     85346.80  lkp-snb01/micro/aim7/creat-clo
               101554.80       -16.0%     85346.80  TOTAL sched_debug.cpu#18.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                99936.60       -15.1%     84866.00  lkp-snb01/micro/aim7/creat-clo
                99936.60       -15.1%     84866.00  TOTAL sched_debug.cpu#26.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102040.80       -16.0%     85746.20  lkp-snb01/micro/aim7/creat-clo
               102040.80       -16.0%     85746.20  TOTAL softirqs.CPU19.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                61365.60       -16.8%     51079.80  lkp-snb01/micro/aim7/creat-clo
                61365.60       -16.8%     51079.80  TOTAL softirqs.CPU20.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               103361.40       -15.8%     87063.20  lkp-snb01/micro/aim7/creat-clo
               103361.40       -15.8%     87063.20  TOTAL softirqs.CPU12.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101854.40       -15.7%     85862.00  lkp-snb01/micro/aim7/creat-clo
               101854.40       -15.7%     85862.00  TOTAL softirqs.CPU21.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 2752.00       -11.9%      2425.00  lkp-ne04/micro/aim7/disk_src
                 1339.00       +21.8%      1631.40  lkp-snb01/micro/aim7/creat-clo
                 4091.00        -0.8%      4056.40  TOTAL sched_debug.cpu#0.curr->pid

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               197503.80       -14.8%    168315.60  lkp-snb01/micro/aim7/creat-clo
               197503.80       -14.8%    168315.60  TOTAL interrupts.CPU27.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                46925.33       -14.2%     40264.67  lkp-a03/micro/will-it-scale/context_switch1
               103281.60       -15.8%     86918.20  lkp-snb01/micro/aim7/creat-clo
               150206.93       -15.3%    127182.87  TOTAL softirqs.CPU0.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101379.00       -15.5%     85667.80  lkp-snb01/micro/aim7/creat-clo
               101379.00       -15.5%     85667.80  TOTAL softirqs.CPU23.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                14203.00       -18.4%     11584.00  lkp-snb01/micro/will-it-scale/context_switch1
                14203.00       -18.4%     11584.00  TOTAL softirqs.CPU10.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               100473.00       -14.5%     85872.60  lkp-snb01/micro/aim7/creat-clo
               100473.00       -14.5%     85872.60  TOTAL softirqs.CPU29.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               100095.80       -15.2%     84890.20  lkp-snb01/micro/aim7/creat-clo
               100095.80       -15.2%     84890.20  TOTAL sched_debug.cpu#30.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               100277.80       -14.5%     85780.00  lkp-snb01/micro/aim7/creat-clo
               100277.80       -14.5%     85780.00  TOTAL softirqs.CPU26.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                98503.40       -15.0%     83752.60  lkp-snb01/micro/aim7/creat-clo
                98503.40       -15.0%     83752.60  TOTAL softirqs.CPU19.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2057913.00       -15.0%   1749394.40  lkp-snb01/micro/aim7/creat-clo
              2057913.00       -15.0%   1749394.40  TOTAL proc-vmstat.numa_local

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2057913.00       -15.0%   1749394.40  lkp-snb01/micro/aim7/creat-clo
              2057913.00       -15.0%   1749394.40  TOTAL proc-vmstat.numa_hit

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                99190.00       -15.4%     83902.20  lkp-snb01/micro/aim7/creat-clo
                99190.00       -15.4%     83902.20  TOTAL softirqs.CPU18.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                99716.80       -14.8%     84999.80  lkp-snb01/micro/aim7/creat-clo
                99716.80       -14.8%     84999.80  TOTAL sched_debug.cpu#27.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               100021.80       -15.2%     84773.40  lkp-snb01/micro/aim7/creat-clo
               100021.80       -15.2%     84773.40  TOTAL sched_debug.cpu#31.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102311.20       -15.6%     86325.00  lkp-snb01/micro/aim7/creat-clo
               102311.20       -15.6%     86325.00  TOTAL softirqs.CPU18.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  268.20       -19.8%       215.00  lkp-snb01/micro/aim7/creat-clo
                  268.20       -19.8%       215.00  TOTAL sched_debug.cpu#10.cpu_load[0]

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                98716.80       -14.8%     84069.80  lkp-snb01/micro/aim7/creat-clo
                98716.80       -14.8%     84069.80  TOTAL softirqs.CPU16.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                98699.00       -15.1%     83827.80  lkp-snb01/micro/aim7/creat-clo
                98699.00       -15.1%     83827.80  TOTAL softirqs.CPU21.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               198500.20       -15.2%    168335.00  lkp-snb01/micro/aim7/creat-clo
               198500.20       -15.2%    168335.00  TOTAL interrupts.CPU31.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                96756.60       -13.4%     83799.60  lkp-snb01/micro/aim7/creat-clo
                12284.00       -21.9%      9587.67  lkp-snb01/micro/will-it-scale/context_switch1
               109040.60       -14.4%     93387.27  TOTAL softirqs.CPU26.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               198542.40       -15.2%    168337.80  lkp-snb01/micro/aim7/creat-clo
               198542.40       -15.2%    168337.80  TOTAL interrupts.CPU28.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                98857.60       -15.0%     84006.00  lkp-snb01/micro/aim7/creat-clo
                98857.60       -15.0%     84006.00  TOTAL softirqs.CPU17.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               197722.60       -14.6%    168784.80  lkp-snb01/micro/aim7/creat-clo
               197722.60       -14.6%    168784.80  TOTAL interrupts.CPU24.LOC

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               100607.00       -15.5%     85031.60  lkp-snb01/micro/aim7/creat-clo
               100607.00       -15.5%     85031.60  TOTAL sched_debug.cpu#28.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1481.67       +14.8%      1700.33  lkp-snb01/micro/will-it-scale/context_switch1
                 1481.67       +14.8%      1700.33  TOTAL numa-meminfo.node1.PageTables

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               100421.40       -14.4%     85976.00  lkp-snb01/micro/aim7/creat-clo
               100421.40       -14.4%     85976.00  TOTAL softirqs.CPU27.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                43598.00       -15.8%     36689.00  lkp-a03/micro/will-it-scale/context_switch1
               104056.20       -16.0%     87442.40  lkp-snb01/micro/aim7/creat-clo
               147654.20       -15.9%    124131.40  TOTAL softirqs.CPU3.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               100942.00       -15.0%     85839.80  lkp-snb01/micro/aim7/creat-clo
               100942.00       -15.0%     85839.80  TOTAL softirqs.CPU30.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                14655.00       -14.0%     12597.00  lkp-snb01/micro/will-it-scale/context_switch1
                14655.00       -14.0%     12597.00  TOTAL softirqs.CPU13.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               100912.00       -15.0%     85769.00  lkp-snb01/micro/aim7/creat-clo
               100912.00       -15.0%     85769.00  TOTAL softirqs.CPU31.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                98068.80       -14.5%     83815.20  lkp-snb01/micro/aim7/creat-clo
                98068.80       -14.5%     83815.20  TOTAL softirqs.CPU23.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                56116.00       -14.1%     48216.00  lkp-snb01/micro/aim7/creat-clo
                56116.00       -14.1%     48216.00  TOTAL proc-vmstat.nr_tlb_local_flush_all

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                62606.20       -16.4%     52356.40  lkp-snb01/micro/aim7/creat-clo
                62606.20       -16.4%     52356.40  TOTAL softirqs.CPU17.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  967.40       +23.1%      1191.20  lkp-snb01/micro/aim7/creat-clo
                  967.40       +23.1%      1191.20  TOTAL sched_debug.cfs_rq[24]:/.avg->runnable_avg_sum

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                61128.60       -14.4%     52301.40  lkp-snb01/micro/aim7/creat-clo
                61128.60       -14.4%     52301.40  TOTAL softirqs.CPU22.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                98527.00       -15.1%     83648.60  lkp-snb01/micro/aim7/creat-clo
                13864.00        -9.4%     12562.33  lkp-snb01/micro/will-it-scale/context_switch1
               112391.00       -14.4%     96210.93  TOTAL softirqs.CPU20.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101133.00       -15.3%     85644.40  lkp-snb01/micro/aim7/creat-clo
               101133.00       -15.3%     85644.40  TOTAL sched_debug.cpu#24.nr_load_updates

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                19527.28       -61.3%      7548.85  nhm-white/micro/aim7/link_test
                19527.28       -61.3%      7548.85  TOTAL sched_debug.cfs_rq[1]:/.exec_clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               100632.00       -14.2%     86293.60  lkp-snb01/micro/aim7/creat-clo
               100632.00       -14.2%     86293.60  TOTAL softirqs.CPU24.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                60997.40       -14.6%     52078.00  lkp-snb01/micro/aim7/creat-clo
                60997.40       -14.6%     52078.00  TOTAL softirqs.CPU21.SCHED

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  370.67       +14.7%       425.33  lkp-snb01/micro/will-it-scale/context_switch1
                  370.67       +14.7%       425.33  TOTAL numa-vmstat.node1.nr_page_table_pages

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                97173.20       -13.6%     83944.80  lkp-snb01/micro/aim7/creat-clo
                97173.20       -13.6%     83944.80  TOTAL softirqs.CPU31.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                97636.40       -14.1%     83841.40  lkp-snb01/micro/aim7/creat-clo
                97636.40       -14.1%     83841.40  TOTAL softirqs.CPU30.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 3555.15       -24.0%      2702.98  lkp-snb01/micro/aim7/creat-clo
                 3555.15       -24.0%      2702.98  TOTAL sched_debug.cfs_rq[23]:/.min_vruntime

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                14164.67       -12.1%     12448.33  lkp-snb01/micro/will-it-scale/context_switch1
                14164.67       -12.1%     12448.33  TOTAL softirqs.CPU7.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                91149.33       -17.9%     74790.00  lkp-a03/micro/will-it-scale/context_switch1
              7465550.80       -10.1%   6710220.20  lkp-snb01/micro/aim7/creat-clo
               439829.00       -13.8%    379349.67  lkp-snb01/micro/will-it-scale/context_switch1
              7996529.13       -10.4%   7164359.87  TOTAL softirqs.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               100628.80       -14.5%     85989.80  lkp-snb01/micro/aim7/creat-clo
               100628.80       -14.5%     85989.80  TOTAL softirqs.CPU28.TIMER

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               757508.80       -11.4%    671268.60  lkp-snb01/micro/aim7/creat-clo
               757508.80       -11.4%    671268.60  TOTAL numa-vmstat.node1.numa_hit

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               256618.33        -8.3%    235415.33  lkp-ne04/micro/aim7/disk_src
               256618.33        -8.3%    235415.33  TOTAL sched_debug.cpu#3.avg_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               132014.60       -16.1%    110716.20  lkp-snb01/micro/aim7/creat-clo
               132014.60       -16.1%    110716.20  TOTAL sched_debug.cpu#10.avg_idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                96877.80       -13.2%     84043.60  lkp-snb01/micro/aim7/creat-clo
                96877.80       -13.2%     84043.60  TOTAL softirqs.CPU29.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  388.25       -10.1%       349.07  lkp-a03/micro/will-it-scale/context_switch1
                  864.63       -17.3%       715.48  lkp-snb01/micro/aim7/creat-clo
                 1252.88       -15.0%      1064.55  TOTAL uptime.boot

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               276481.00       -13.2%    240066.60  lkp-snb01/micro/aim7/creat-clo
               276481.00       -13.2%    240066.60  TOTAL proc-vmstat.numa_miss

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               276481.00       -13.2%    240066.60  lkp-snb01/micro/aim7/creat-clo
               276481.00       -13.2%    240066.60  TOTAL proc-vmstat.numa_other

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  669.80       -20.2%       534.80  lkp-snb01/micro/aim7/creat-clo
                  669.80       -20.2%       534.80  TOTAL sched_debug.cfs_rq[11]:/.nr_spread_over

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               276475.20       -13.2%    240090.00  lkp-snb01/micro/aim7/creat-clo
               276475.20       -13.2%    240090.00  TOTAL proc-vmstat.numa_foreign

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2856705.40       -12.7%   2493223.80  lkp-snb01/micro/aim7/creat-clo
              2856705.40       -12.7%   2493223.80  TOTAL proc-vmstat.pgalloc_normal

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              3136734.40       -12.8%   2736681.40  lkp-snb01/micro/aim7/creat-clo
              3136734.40       -12.8%   2736681.40  TOTAL proc-vmstat.pgfree

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                14229.67       -10.7%     12700.33  lkp-snb01/micro/will-it-scale/context_switch1
                14229.67       -10.7%     12700.33  TOTAL softirqs.CPU5.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               286378.80       -12.7%    250025.60  lkp-snb01/micro/aim7/creat-clo
               286378.80       -12.7%    250025.60  TOTAL proc-vmstat.pgalloc_dma32

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4096.00       -12.5%      3584.00  lkp-t410/micro/netperf/120s-200%-TCP_CRR
                 4096.00       -12.5%      3584.00  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
                 4096.00       -12.5%      3584.00  lkp-t410/micro/netperf/120s-200%-TCP_RR
                 4096.00       -12.5%      3584.00  lkp-t410/micro/netperf/120s-200%-TCP_SENDFILE
                 4096.00       -12.5%      3584.00  lkp-t410/micro/netperf/120s-200%-TCP_STREAM
                20480.00       -12.5%     17920.00  TOTAL slabinfo.kmalloc-8.num_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4096.00       -12.5%      3584.00  lkp-t410/micro/netperf/120s-200%-TCP_CRR
                 4096.00       -12.5%      3584.00  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
                 4096.00       -12.5%      3584.00  lkp-t410/micro/netperf/120s-200%-TCP_RR
                 4096.00       -12.5%      3584.00  lkp-t410/micro/netperf/120s-200%-TCP_SENDFILE
                 4096.00       -12.5%      3584.00  lkp-t410/micro/netperf/120s-200%-TCP_STREAM
                20480.00       -12.5%     17920.00  TOTAL slabinfo.kmalloc-8.active_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               676136.80       -12.8%    589747.60  lkp-snb01/micro/aim7/creat-clo
               676136.80       -12.8%    589747.60  TOTAL proc-vmstat.nr_tlb_local_flush_one

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                97062.60       -13.3%     84179.00  lkp-snb01/micro/aim7/creat-clo
                12359.00       -18.7%     10050.33  lkp-snb01/micro/will-it-scale/context_switch1
               109421.60       -13.9%     94229.33  TOTAL softirqs.CPU24.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1001861.40       -12.9%    872148.40  lkp-snb01/micro/aim7/creat-clo
              1001861.40       -12.9%    872148.40  TOTAL numa-numastat.node0.local_node

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1001861.40       -12.9%    872148.40  lkp-snb01/micro/aim7/creat-clo
              1001861.40       -12.9%    872148.40  TOTAL numa-numastat.node0.numa_hit

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                22417.00       -12.6%     19582.00  lkp-a03/micro/will-it-scale/context_switch1
                13862.00        -8.8%     12644.33  lkp-snb01/micro/will-it-scale/context_switch1
                36279.00       -11.2%     32226.33  TOTAL softirqs.CPU1.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  632.33       +19.7%       757.00  lkp-ne04/micro/aim7/disk_src
                  632.33       +19.7%       757.00  TOTAL sched_debug.cfs_rq[1]:/.load

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                96712.80       -13.3%     83822.80  lkp-snb01/micro/aim7/creat-clo
                13025.67       -25.0%      9774.33  lkp-snb01/micro/will-it-scale/context_switch1
               109738.47       -14.7%     93597.13  TOTAL softirqs.CPU27.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                11624.60       -12.8%     10131.20  lkp-snb01/micro/aim7/creat-clo
                11624.60       -12.8%     10131.20  TOTAL sched_debug.cpu#13.ttwu_local

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                97041.40       -13.4%     84062.60  lkp-snb01/micro/aim7/creat-clo
                12772.00       -14.1%     10974.67  lkp-snb01/micro/will-it-scale/context_switch1
               109813.40       -13.5%     95037.27  TOTAL softirqs.CPU28.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1640.67       +15.0%      1886.00  lkp-ne04/micro/aim7/disk_src
                 1640.67       +15.0%      1886.00  TOTAL sched_debug.cfs_rq[2]:/.blocked_load_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                14912.67       -12.2%     13099.00  lkp-snb01/micro/will-it-scale/context_switch1
                14912.67       -12.2%     13099.00  TOTAL softirqs.CPU6.RCU

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1885.00       +13.1%      2132.00  lkp-ne04/micro/aim7/disk_src
                 1885.00       +13.1%      2132.00  TOTAL slabinfo.buffer_head.active_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1885.00       +13.1%      2132.00  lkp-ne04/micro/aim7/disk_src
                 1885.00       +13.1%      2132.00  TOTAL slabinfo.buffer_head.num_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1058.33        +9.7%      1161.33  lkp-ne04/micro/aim7/disk_src
                 1058.33        +9.7%      1161.33  TOTAL sched_debug.cfs_rq[9]:/.blocked_load_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  993.80       -12.6%       868.40  lkp-snb01/micro/aim7/creat-clo
                  993.80       -12.6%       868.40  TOTAL proc-vmstat.nr_tlb_remote_flush

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               475904.20       -11.1%    423131.50  nhm-white/micro/aim7/link_test
               475904.20       -11.1%    423131.50  TOTAL sched_debug.cpu#7.sched_goidle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               956177.30       -11.0%    850688.10  nhm-white/micro/aim7/link_test
               956177.30       -11.0%    850688.10  TOTAL sched_debug.cpu#7.sched_count

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               956144.50       -11.0%    850662.40  nhm-white/micro/aim7/link_test
               956144.50       -11.0%    850662.40  TOTAL sched_debug.cpu#7.nr_switches

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                11110.06        +9.4%     12150.31  lkp-ne04/micro/aim7/disk_src
                11110.06        +9.4%     12150.31  TOTAL sched_debug.cfs_rq[7]:/.exec_clock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1025.60        +9.7%      1125.40  lkp-snb01/micro/aim7/creat-clo
                 1025.60        +9.7%      1125.40  TOTAL sched_debug.cfs_rq[13]:/.blocked_load_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4651.60        +9.9%      5110.80  lkp-snb01/micro/aim7/creat-clo
                 4651.60        +9.9%      5110.80  TOTAL sched_debug.cfs_rq[7]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4644.00        +9.8%      5101.40  lkp-snb01/micro/aim7/creat-clo
                 4644.00        +9.8%      5101.40  TOTAL sched_debug.cfs_rq[6]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4630.00        +9.8%      5083.00  lkp-snb01/micro/aim7/creat-clo
                 4630.00        +9.8%      5083.00  TOTAL sched_debug.cfs_rq[4]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4657.20        +9.9%      5118.00  lkp-snb01/micro/aim7/creat-clo
                 4657.20        +9.9%      5118.00  TOTAL sched_debug.cfs_rq[8]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4638.40        +9.8%      5094.00  lkp-snb01/micro/aim7/creat-clo
                 4638.40        +9.8%      5094.00  TOTAL sched_debug.cfs_rq[5]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4607.20        +9.8%      5058.00  lkp-snb01/micro/aim7/creat-clo
                 4607.20        +9.8%      5058.00  TOTAL sched_debug.cfs_rq[0]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4664.60        +9.9%      5125.80  lkp-snb01/micro/aim7/creat-clo
                 4664.60        +9.9%      5125.80  TOTAL sched_debug.cfs_rq[9]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4624.80        +9.8%      5076.40  lkp-snb01/micro/aim7/creat-clo
                 4624.80        +9.8%      5076.40  TOTAL sched_debug.cfs_rq[3]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4677.80        +9.9%      5140.40  lkp-snb01/micro/aim7/creat-clo
                 4677.80        +9.9%      5140.40  TOTAL sched_debug.cfs_rq[11]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4670.20        +9.9%      5132.40  lkp-snb01/micro/aim7/creat-clo
                 4670.20        +9.9%      5132.40  TOTAL sched_debug.cfs_rq[10]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4691.60        +9.9%      5155.20  lkp-snb01/micro/aim7/creat-clo
                 4691.60        +9.9%      5155.20  TOTAL sched_debug.cfs_rq[13]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4616.00        +9.7%      5065.20  lkp-snb01/micro/aim7/creat-clo
                 4616.00        +9.7%      5065.20  TOTAL sched_debug.cfs_rq[2]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4715.40        +9.9%      5181.60  lkp-snb01/micro/aim7/creat-clo
                 4715.40        +9.9%      5181.60  TOTAL sched_debug.cfs_rq[17]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4684.00        +9.9%      5147.60  lkp-snb01/micro/aim7/creat-clo
                 4684.00        +9.9%      5147.60  TOTAL sched_debug.cfs_rq[12]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4610.40        +9.7%      5059.00  lkp-snb01/micro/aim7/creat-clo
                 4610.40        +9.7%      5059.00  TOTAL sched_debug.cfs_rq[1]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4697.20        +9.9%      5162.00  lkp-snb01/micro/aim7/creat-clo
                 4697.20        +9.9%      5162.00  TOTAL sched_debug.cfs_rq[14]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4708.80        +9.9%      5175.40  lkp-snb01/micro/aim7/creat-clo
                 4708.80        +9.9%      5175.40  TOTAL sched_debug.cfs_rq[16]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4726.20        +9.9%      5192.40  lkp-snb01/micro/aim7/creat-clo
                 4726.20        +9.9%      5192.40  TOTAL sched_debug.cfs_rq[19]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1902.00       +13.8%      2165.00  lkp-snb01/micro/will-it-scale/context_switch1
                 1902.00       +13.8%      2165.00  TOTAL slabinfo.task_xstate.num_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1902.00       +13.8%      2165.00  lkp-snb01/micro/will-it-scale/context_switch1
                 1902.00       +13.8%      2165.00  TOTAL slabinfo.task_xstate.active_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4720.40        +9.8%      5185.00  lkp-snb01/micro/aim7/creat-clo
                 4720.40        +9.8%      5185.00  TOTAL sched_debug.cfs_rq[18]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4704.00        +9.9%      5169.40  lkp-snb01/micro/aim7/creat-clo
                 4704.00        +9.9%      5169.40  TOTAL sched_debug.cfs_rq[15]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4730.60        +9.9%      5196.80  lkp-snb01/micro/aim7/creat-clo
                 4730.60        +9.9%      5196.80  TOTAL sched_debug.cfs_rq[20]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4736.00        +9.8%      5202.40  lkp-snb01/micro/aim7/creat-clo
                 4736.00        +9.8%      5202.40  TOTAL sched_debug.cfs_rq[21]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               720571.80        -9.5%    652027.40  lkp-snb01/micro/aim7/creat-clo
               720571.80        -9.5%    652027.40  TOTAL numa-vmstat.node0.numa_hit

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4751.80        +9.7%      5214.60  lkp-snb01/micro/aim7/creat-clo
                 4751.80        +9.7%      5214.60  TOTAL sched_debug.cfs_rq[24]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4762.80        +9.8%      5227.40  lkp-snb01/micro/aim7/creat-clo
                 4762.80        +9.8%      5227.40  TOTAL sched_debug.cfs_rq[26]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4740.40        +9.8%      5205.80  lkp-snb01/micro/aim7/creat-clo
                 4740.40        +9.8%      5205.80  TOTAL sched_debug.cfs_rq[22]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4768.80        +9.8%      5234.60  lkp-snb01/micro/aim7/creat-clo
                 4768.80        +9.8%      5234.60  TOTAL sched_debug.cfs_rq[27]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4774.60        +9.7%      5239.60  lkp-snb01/micro/aim7/creat-clo
                 4774.60        +9.7%      5239.60  TOTAL sched_debug.cfs_rq[28]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                18788.00       +11.4%     20926.40  lkp-snb01/micro/aim7/creat-clo
                18788.00       +11.4%     20926.40  TOTAL slabinfo.filp.num_objs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4747.00        +9.8%      5210.00  lkp-snb01/micro/aim7/creat-clo
                 4747.00        +9.8%      5210.00  TOTAL sched_debug.cfs_rq[23]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4757.60        +9.7%      5221.00  lkp-snb01/micro/aim7/creat-clo
                 4757.60        +9.7%      5221.00  TOTAL sched_debug.cfs_rq[25]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4785.80        +9.7%      5251.60  lkp-snb01/micro/aim7/creat-clo
                 4785.80        +9.7%      5251.60  TOTAL sched_debug.cfs_rq[30]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4781.20        +9.7%      5245.60  lkp-snb01/micro/aim7/creat-clo
                 4781.20        +9.7%      5245.60  TOTAL sched_debug.cfs_rq[29]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4792.80        +9.7%      5256.20  lkp-snb01/micro/aim7/creat-clo
                 4792.80        +9.7%      5256.20  TOTAL sched_debug.cfs_rq[31]:/.tg->runnable_avg

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                61538.88       -90.4%      5882.75  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
                61538.88       -90.4%      5882.75  TOTAL lock_stat.(&tp->wk.work).holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 8574.71       -91.6%       719.48  lkp-a03/micro/will-it-scale/context_switch1
                 8574.71       -91.6%       719.48  TOTAL lock_stat.(&task->u.tk_work).holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  322.51      +435.3%      1726.54  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
                  322.51      +435.3%      1726.54  TOTAL lock_stat.&type->i_mutex_dir_key#2.waittime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 2273.26       -81.7%       415.60  lkp-snb01/micro/aim7/creat-clo
                 2273.26       -81.7%       415.60  TOTAL lock_stat.&(&bh->lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1675.82       -80.4%       327.83  lkp-snb01/micro/aim7/creat-clo
                 1675.82       -80.4%       327.83  TOTAL lock_stat.semaphore->lock#2.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                29385.00       -79.2%      6104.25  lkp-snb01/micro/aim7/creat-clo
                29385.00       -79.2%      6104.25  TOTAL lock_stat.&(&dev->event_lock)->rlock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                38947.39       -82.0%      7019.03  lkp-snb01/micro/aim7/creat-clo
                38947.39       -82.0%      7019.03  TOTAL lock_stat.&(&ehci->lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1916.84       -81.6%       352.73  lkp-snb01/micro/aim7/creat-clo
                 1916.84       -81.6%       352.73  TOTAL lock_stat.hcd_urb_list_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               172830.80      +546.1%   1116705.00  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               172830.80      +546.1%   1116705.00  TOTAL lock_stat.&sb->s_type->i_lock_key#1.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               169927.60      +555.5%   1113821.60  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               169927.60      +555.5%   1113821.60  TOTAL lock_stat.&ei->i_es_lock-R.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 8579.04       -91.6%       721.06  lkp-a03/micro/will-it-scale/context_switch1
                 8579.04       -91.6%       721.06  TOTAL lock_stat.rpciod-R.holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 5224.49       -61.2%      2025.98  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
                 5224.49       -61.2%      2025.98  TOTAL lock_stat.(&tp->wk.work).holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                61528.61       -90.4%      5881.80  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
                61528.61       -90.4%      5881.80  TOTAL lock_stat.&tp->wk.mutex.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  322.51      +435.3%      1726.54  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
                  322.51      +435.3%      1726.54  TOTAL lock_stat.&type->i_mutex_dir_key#2.waittime-min

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               194751.20      +483.9%   1137152.80  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               194751.20      +483.9%   1137152.80  TOTAL lock_stat.&journal->j_state_lock-R.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                14052.12       -90.7%      1307.52  lkp-a03/micro/will-it-scale/context_switch1
                14052.12       -90.7%      1307.52  TOTAL lock_stat.&sb->s_type->i_mutex_key#2.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 8309.37       -87.4%      1048.33  lkp-a03/micro/will-it-scale/context_switch1
                 8309.37       -87.4%      1048.33  TOTAL lock_stat.&sb->s_type->i_mutex_key#2.waittime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                16512.46       -73.6%      4351.49  lkp-a03/micro/will-it-scale/context_switch1
                16512.46       -73.6%      4351.49  TOTAL lock_stat.&mapping->i_mmap_mutex.waittime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 2829.52       -77.3%       641.72  nhm-white/micro/aim7/link_test
                 2829.52       -77.3%       641.72  TOTAL lock_stat.&mm->mmap_sem-R.holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 9302.48       -79.1%      1945.64  lkp-snb01/micro/aim7/creat-clo
                 9302.48       -79.1%      1945.64  TOTAL lock_stat.&(&dev->event_lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               169749.60      +556.0%   1113637.60  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               169749.60      +556.0%   1113637.60  TOTAL lock_stat.&(&(ei->i_block_reservation_lock))->r.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               168613.80      +559.8%   1112445.20  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               168613.80      +559.8%   1112445.20  TOTAL lock_stat.&ei->i_data_sem-R.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               332714.80      +567.3%   2220230.40  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               332714.80      +567.3%   2220230.40  TOTAL lock_stat.&sb->s_type->i_mutex_key#1.contentions.generic_file_aio_write

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  322.51      +435.3%      1726.54  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
                  322.51      +435.3%      1726.54  TOTAL lock_stat.&type->i_mutex_dir_key#2.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 3462.41       -90.9%       316.37  lkp-snb01/micro/will-it-scale/context_switch1
                 3462.41       -90.9%       316.37  TOTAL lock_stat.sysfs_mutex.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 5223.65       -61.2%      2025.64  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
                 5223.65       -61.2%      2025.64  TOTAL lock_stat.&tp->wk.mutex.holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 3961.29       -71.7%      1120.88  lkp-a03/micro/will-it-scale/context_switch1
                 3961.29       -71.7%      1120.88  TOTAL lock_stat.&pool->manager_mutex.holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 3967.61       -71.7%      1123.13  lkp-a03/micro/will-it-scale/context_switch1
                 3967.61       -71.7%      1123.13  TOTAL lock_stat.&pool->manager_arb.holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               166339.20      +567.4%   1110095.20  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               197907.60      +255.5%    703599.60  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
               364246.80      +397.9%   1813694.80  TOTAL lock_stat.&sb->s_type->i_mutex_key#1.con-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               166357.40      +567.3%   1110115.20  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               197938.40      +255.5%    703622.40  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
               364295.80      +397.9%   1813737.60  TOTAL lock_stat.&sb->s_type->i_mutex_key#1.contentions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                25164.44       -76.5%      5906.75  lkp-a03/micro/will-it-scale/context_switch1
                25164.44       -76.5%      5906.75  TOTAL lock_stat.(&task->u.tk_work).holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                25273.30       -76.5%      5950.65  lkp-a03/micro/will-it-scale/context_switch1
                25273.30       -76.5%      5950.65  TOTAL lock_stat.rpciod-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               169957.00      +555.3%   1113718.60  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               202041.20      +250.1%    707440.00  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
               371998.20      +389.6%   1821158.60  TOTAL lock_stat.&sb->s_type->i_mutex_key#1.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               172465.40      +547.2%   1116152.20  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               203541.40      +248.4%    709072.60  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
               376006.80      +385.4%   1825224.80  TOTAL lock_stat.&(&mapping->private_lock)->rlock.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               177120.40      +534.3%   1123387.60  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               207244.60      +244.0%    712861.20  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
               384365.00      +377.7%   1836248.80  TOTAL lock_stat.&(&mapping->tree_lock)->rlock.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                46701.00      +282.9%    178829.40  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
                46701.00      +282.9%    178829.40  TOTAL lock_stat.key#1.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 3078.96       -61.0%      1199.66  lkp-a03/micro/will-it-scale/context_switch1
                  967.25      +232.4%      3215.29  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
                 4046.21        +9.1%      4414.95  TOTAL lock_stat.&mm->mmap_sem/1.holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 3091.83       -61.0%      1206.17  lkp-a03/micro/will-it-scale/context_switch1
                  969.40      +231.9%      3217.13  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
                 4061.23        +8.9%      4423.29  TOTAL lock_stat.&dup_mmap_sem-R.holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               121854.40      +271.6%    452866.20  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               121854.40      +271.6%    452866.20  TOTAL lock_stat.key#4.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                16088.63       -73.4%      4277.94  lkp-a03/micro/will-it-scale/context_switch1
                16088.63       -73.4%      4277.94  TOTAL lock_stat.sk_lock-AF_INET-RPC.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               395876.80      +255.5%   1407244.80  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
               395876.80      +255.5%   1407244.80  TOTAL lock_stat.&sb->s_type->i_mutex_key#1.contentions.xfs_file_buffered_aio_write

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 8407.20      +312.8%     34707.80  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
                 8407.20      +312.8%     34707.80  TOTAL lock_stat.&journal->j_wait_updates.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               200257.20      +252.4%    705762.20  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
               200257.20      +252.4%    705762.20  TOTAL lock_stat.&(&ip->i_iolock)->mr_lock.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               201472.00      +250.9%    707042.00  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
               201472.00      +250.9%    707042.00  TOTAL lock_stat.&(&ip->i_lock)->mr_lock-W.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               368612.67       -62.8%    137272.33  lkp-ne04/micro/aim7/disk_src
              3015033.60       -72.2%    839407.80  lkp-snb01/micro/aim7/creat-clo
               340172.00      +247.3%   1181414.00  lkp-snb01/micro/will-it-scale/context_switch1
              3723818.27       -42.0%   2158094.13  TOTAL lock_stat.&rq->lock.contentions.try_to_wake_up

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                22474.06       -71.3%      6454.66  lkp-a03/micro/will-it-scale/context_switch1
                22474.06       -71.3%      6454.66  TOTAL lock_stat.&mm->mmap_sem-W.holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1667.54       -72.1%       465.94  lkp-a03/micro/will-it-scale/context_switch1
                 1667.54       -72.1%       465.94  TOTAL lock_stat.&(&mm->page_table_lock)->rlock.holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 5032.81       -67.9%      1615.53  lkp-a03/micro/will-it-scale/context_switch1
                 5032.81       -67.9%      1615.53  TOTAL lock_stat.&rq->lock/1.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1735.40       -69.3%       532.47  lkp-a03/micro/will-it-scale/context_switch1
                 1735.40       -69.3%       532.47  TOTAL lock_stat.&(&list->lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 5733.54       -70.0%      1720.32  lkp-a03/micro/will-it-scale/context_switch1
                 5733.54       -70.0%      1720.32  TOTAL lock_stat.&pool->manager_mutex.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 5750.28       -70.0%      1727.51  lkp-a03/micro/will-it-scale/context_switch1
                 5750.28       -70.0%      1727.51  TOTAL lock_stat.&pool->manager_arb.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1760.67       -81.1%       331.97  lkp-a03/micro/will-it-scale/context_switch1
                61909.48       -22.8%     47810.03  lkp-snb01/micro/aim7/creat-clo
                63670.14       -24.4%     48142.00  TOTAL lock_stat.&(&zone->lock)->rlock.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                66082.55       -76.7%     15401.07  lkp-a03/micro/will-it-scale/context_switch1
                 4523.80       -55.6%      2007.93  lkp-snb01/micro/will-it-scale/context_switch1
                70606.34       -75.3%     17409.00  TOTAL lock_stat.&p->pi_lock.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 3954.16       -65.8%      1353.08  lkp-snb01/micro/will-it-scale/context_switch1
                 3954.16       -65.8%      1353.08  TOTAL lock_stat.&sb->s_type->i_lock_key.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                12392.56       -65.2%      4307.09  lkp-snb01/micro/will-it-scale/context_switch1
                12392.56       -65.2%      4307.09  TOTAL lock_stat.s_active#6-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                21133.68       -64.4%      7530.76  lkp-snb01/micro/will-it-scale/context_switch1
                21133.68       -64.4%      7530.76  TOTAL lock_stat.s_active#5-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              8347781.00      +178.4%  23242729.33  lkp-a03/micro/will-it-scale/context_switch1
              8347781.00      +178.4%  23242729.33  TOTAL lock_stat.&fsnotify_mark_srcu-R.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              8386225.67      +177.4%  23260701.33  lkp-a03/micro/will-it-scale/context_switch1
              8386225.67      +177.4%  23260701.33  TOTAL lock_stat.&p->pi_lock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               385713.33      +183.0%   1091728.33  lkp-a03/micro/will-it-scale/context_switch1
               385713.33      +183.0%   1091728.33  TOTAL lock_stat.&(&info->si_lock)->rlock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               225570.74       -94.5%     12473.26  lkp-a03/micro/will-it-scale/context_switch1
                43553.76       -58.1%     18264.62  lkp-snb01/micro/aim7/creat-clo
                44032.78       -27.8%     31792.07  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
               313157.28       -80.0%     62529.95  TOTAL lock_stat.&mapping->i_mmap_mutex.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4112.85       -62.0%      1561.37  lkp-a03/micro/will-it-scale/context_switch1
                 4112.85       -62.0%      1561.37  TOTAL lock_stat.((&adapter->watchdog_timer)).holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4089.01       -61.6%      1569.68  lkp-a03/micro/will-it-scale/context_switch1
                 4089.01       -61.6%      1569.68  TOTAL lock_stat.cpu_hotplug.lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1744.73       -58.7%       720.98  lkp-a03/micro/will-it-scale/context_switch1
                 1744.73       -58.7%       720.98  TOTAL lock_stat.&(&intf->seq_lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                35212.79       -72.1%      9826.25  lkp-a03/micro/will-it-scale/context_switch1
                 5230.14       -38.6%      3209.10  lkp-snb01/micro/will-it-scale/context_switch1
                40442.94       -67.8%     13035.35  TOTAL lock_stat.rcu_read_lock_bh-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 2560.05       -61.4%       989.35  lkp-snb01/micro/will-it-scale/context_switch1
                 2560.05       -61.4%       989.35  TOTAL lock_stat.inode_hash_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 7316.78       -60.7%      2872.29  lkp-a03/micro/will-it-scale/context_switch1
                 7316.78       -60.7%      2872.29  TOTAL lock_stat.&(&f->f_lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 2258.01       -58.8%       929.46  lkp-a03/micro/will-it-scale/context_switch1
                 2258.01       -58.8%       929.46  TOTAL lock_stat.&type->s_umount_key#2-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                66017.08       -58.7%     27247.14  lkp-a03/micro/will-it-scale/context_switch1
                25045.21       -62.3%      9446.58  lkp-snb01/micro/will-it-scale/context_switch1
                91062.29       -59.7%     36693.72  TOTAL lock_stat.&type->i_mutex_dir_key.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4517.52       -58.3%      1884.95  lkp-a03/micro/will-it-scale/context_switch1
                11846.82       -61.6%      4546.45  lkp-snb01/micro/will-it-scale/context_switch1
                16364.35       -60.7%      6431.40  TOTAL lock_stat.sysfs_open_dirent_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1538552.00       -44.2%    859128.20  lkp-snb01/micro/aim7/creat-clo
               735046.67      +177.0%   2036230.67  lkp-snb01/micro/will-it-scale/context_switch1
                14209.20      +122.0%     31545.40  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
              2287807.87       +27.9%   2926904.27  TOTAL lock_stat.&rq->lock.contentions.__schedule

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 6927.33       -52.8%      3267.00  lkp-snb01/micro/will-it-scale/context_switch1
                 6927.33       -52.8%      3267.00  TOTAL lock_stat.hrtimer_bases.lock#1.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                16333.02       -70.3%      4850.59  lkp-a03/micro/will-it-scale/context_switch1
                 2537.51       -37.3%      1590.20  lkp-snb01/micro/will-it-scale/context_switch1
                18870.52       -65.9%      6440.80  TOTAL lock_stat._xmit_ETHER#2.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 2819.34       -59.0%      1155.17  lkp-a03/micro/will-it-scale/context_switch1
                 2819.34       -59.0%      1155.17  TOTAL lock_stat.&rt_rq->rt_runtime_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 3450.57       -58.4%      1435.87  lkp-a03/micro/will-it-scale/context_switch1
                 3450.57       -58.4%      1435.87  TOTAL lock_stat.&rt_b->rt_runtime_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                25394.63       -69.6%      7710.55  lkp-a03/micro/will-it-scale/context_switch1
                 4710.97       -32.7%      3171.35  lkp-snb01/micro/will-it-scale/context_switch1
                30105.60       -63.9%     10881.90  TOTAL lock_stat.&rq->lock/1.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 9036.88       -57.9%      3805.97  lkp-a03/micro/will-it-scale/context_switch1
                 9036.88       -57.9%      3805.97  TOTAL lock_stat.((&ipmi_timer)).holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 9654.57       -58.3%      4021.79  lkp-a03/micro/will-it-scale/context_switch1
                 9654.57       -58.3%      4021.79  TOTAL lock_stat.&irq_desc_lock_class.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 6804.13       -64.9%      2388.50  lkp-a03/micro/will-it-scale/context_switch1
                 4803.65       -37.2%      3016.66  lkp-snb01/micro/will-it-scale/context_switch1
                11607.78       -53.4%      5405.16  TOTAL lock_stat.&mm->mmap_sem-W.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 3288.31       -58.3%      1370.58  lkp-a03/micro/will-it-scale/context_switch1
                 3288.31       -58.3%      1370.58  TOTAL lock_stat.&(&dev->tx_global_lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 2539.77       -57.8%      1072.05  lkp-a03/micro/will-it-scale/context_switch1
                 2539.77       -57.8%      1072.05  TOTAL lock_stat.clock-AF_INET-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4947.73       -59.3%      2012.55  lkp-a03/micro/will-it-scale/context_switch1
                 4947.73       -59.3%      2012.55  TOTAL lock_stat.&tz->lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 5122.68       -59.3%      2086.20  lkp-a03/micro/will-it-scale/context_switch1
                 5122.68       -59.3%      2086.20  TOTAL lock_stat.(&(&(tz->poll_queue))->work).holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 5282.49       -59.2%      2153.68  lkp-a03/micro/will-it-scale/context_switch1
                 5282.49       -59.2%      2153.68  TOTAL lock_stat.events_freezable-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 3560.43       -57.9%      1498.20  lkp-a03/micro/will-it-scale/context_switch1
                 3560.43       -57.9%      1498.20  TOTAL lock_stat.((&dev->watchdog_timer)).holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 2611.22       -56.7%      1131.43  lkp-a03/micro/will-it-scale/context_switch1
                 2611.22       -56.7%      1131.43  TOTAL lock_stat.(&(&wb->dwork)->timer).holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                12807.49       -58.7%      5285.30  lkp-a03/micro/will-it-scale/context_switch1
                 8906.12       -55.2%      3993.47  lkp-snb01/micro/will-it-scale/context_switch1
                21713.61       -57.3%      9278.77  TOTAL lock_stat.&rsp->gp_wq.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 8848.15       -56.1%      3885.72  lkp-a03/micro/will-it-scale/context_switch1
                 8848.15       -56.1%      3885.72  TOTAL lock_stat.s_active#7-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4501.15       -55.9%      1983.51  lkp-a03/micro/will-it-scale/context_switch1
                 4501.15       -55.9%      1983.51  TOTAL lock_stat.&pool->lock/1.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                25526.62       -65.8%      8731.97  lkp-a03/micro/will-it-scale/context_switch1
                10187.61       -19.3%      8219.00  lkp-t410/micro/netperf/120s-200%-TCP_SENDFILE
                35714.23       -52.5%     16950.98  TOTAL lock_stat.&sig->cred_guard_mutex.holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 2159.89       -55.8%       955.03  lkp-a03/micro/will-it-scale/context_switch1
                 2159.89       -55.8%       955.03  TOTAL lock_stat.&p->lock.holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4222.93       -55.4%      1881.87  lkp-a03/micro/will-it-scale/context_switch1
                 4222.93       -55.4%      1881.87  TOTAL lock_stat.&sb->s_type->i_lock_key#1.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                51930.80       +99.7%    103714.80  lkp-snb01/micro/aim7/creat-clo
                51930.80       +99.7%    103714.80  TOTAL lock_stat.&(&n->list_lock)->rlock.contentions.get_partial_node

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 5094.49       -70.6%      1498.30  lkp-a03/micro/will-it-scale/context_switch1
                 5094.49       -70.6%      1498.30  TOTAL lock_stat.&mm->mmap_sem-R.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 1864.02       -52.9%       878.87  lkp-a03/micro/will-it-scale/context_switch1
                 1864.02       -52.9%       878.87  TOTAL lock_stat.&sem->wait_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                29536.47       -62.3%     11132.87  lkp-a03/micro/will-it-scale/context_switch1
                29536.47       -62.3%     11132.87  TOTAL lock_stat.&pipe->mutex/1.waittime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1585763.25       -60.4%    627548.62  lkp-a03/micro/will-it-scale/context_switch1
               398312.98       -46.0%    215277.72  lkp-snb01/micro/will-it-scale/context_switch1
              1984076.23       -57.5%    842826.34  TOTAL lock_stat.&(&dentry->d_lockref.lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 6591.01       -53.1%      3090.46  lkp-a03/micro/will-it-scale/context_switch1
                 6591.01       -53.1%      3090.46  TOTAL lock_stat.s_active#8-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               513786.31       -61.8%    196153.03  lkp-a03/micro/will-it-scale/context_switch1
               116688.57       -21.9%     91101.74  lkp-snb01/micro/aim7/creat-clo
               219792.61       -57.1%     94382.54  lkp-snb01/micro/will-it-scale/context_switch1
               850267.49       -55.1%    381637.31  TOTAL lock_stat.sysfs_mutex.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               103396.17       -66.7%     34466.12  lkp-a03/micro/will-it-scale/context_switch1
               253842.12       -19.6%    204184.26  lkp-snb01/micro/aim7/creat-clo
                31572.83       -48.8%     16149.97  lkp-snb01/micro/will-it-scale/context_switch1
               388811.13       -34.5%    254800.35  TOTAL lock_stat.rcu_sched_state.onoff_mutex.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2496588.00      +214.3%   7846129.00  lkp-a03/micro/will-it-scale/context_switch1
               402159.00       -15.9%    338384.60  lkp-snb01/micro/aim7/creat-clo
              2898747.00      +182.3%   8184513.60  TOTAL lock_stat.hrtimer_bases.lock#4.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              6310873.67      +196.9%  18737878.67  lkp-a03/micro/will-it-scale/context_switch1
            443652761.00       +16.0% 514596918.33  lkp-snb01/micro/will-it-scale/context_switch1
            449963634.67       +18.5% 533334797.00  TOTAL lock_stat.&rq->lock.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 5843.91       -51.7%      2820.85  lkp-snb01/micro/will-it-scale/context_switch1
                 5843.91       -51.7%      2820.85  TOTAL lock_stat.sb_writers#5-R.holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 5843.91       -51.7%      2820.85  lkp-snb01/micro/will-it-scale/context_switch1
                 5843.91       -51.7%      2820.85  TOTAL lock_stat.sb_writers#5-R.holdtime-min

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 5843.91       -51.7%      2820.85  lkp-snb01/micro/will-it-scale/context_switch1
                 5843.91       -51.7%      2820.85  TOTAL lock_stat.sb_writers#5-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               336319.63       -58.2%    140480.57  lkp-a03/micro/will-it-scale/context_switch1
                86101.41       -40.8%     50940.31  lkp-snb01/micro/will-it-scale/context_switch1
               422421.03       -54.7%    191420.88  TOTAL lock_stat.&(&newf->file_lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1804760.54       -58.9%    741256.19  lkp-a03/micro/will-it-scale/context_switch1
               383738.72       -38.0%    237886.40  lkp-snb01/micro/will-it-scale/context_switch1
              2188499.26       -55.3%    979142.58  TOTAL lock_stat.&vfsmount_lock-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                16899.33       -65.2%      5874.31  lkp-a03/micro/will-it-scale/context_switch1
                76270.54       -25.1%     57140.64  lkp-snb01/micro/aim7/creat-clo
                 8578.19       -43.6%      4838.94  lkp-snb01/micro/will-it-scale/context_switch1
               101748.06       -33.3%     67853.88  TOTAL lock_stat.&rnp->nocb_gp_wq[0].holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               662223.44       -65.6%    227539.87  lkp-a03/micro/will-it-scale/context_switch1
               410692.97       -24.8%    308845.96  lkp-snb01/micro/aim7/creat-clo
                46166.85       -41.1%     27178.36  lkp-snb01/micro/will-it-scale/context_switch1
              1119083.26       -49.6%    563564.19  TOTAL lock_stat.rcu_node_0.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                16692.82       -65.1%      5833.59  lkp-a03/micro/will-it-scale/context_switch1
                78489.85       -24.2%     59522.71  lkp-snb01/micro/aim7/creat-clo
                 8729.08       -42.2%      5042.90  lkp-snb01/micro/will-it-scale/context_switch1
               103911.75       -32.3%     70399.20  TOTAL lock_stat.&rnp->nocb_gp_wq[1].holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             24958221.00      +179.0%  69627944.67  lkp-a03/micro/will-it-scale/context_switch1
               268580.60       -15.6%    226571.40  lkp-snb01/micro/aim7/creat-clo
             25226801.60      +176.9%  69854516.07  TOTAL lock_stat.&pipe->wait.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             24961047.67      +179.0%  69630931.67  lkp-a03/micro/will-it-scale/context_switch1
               286944.60       -15.6%    242287.00  lkp-snb01/micro/aim7/creat-clo
             25247992.27      +176.7%  69873218.67  TOTAL lock_stat.&pipe->mutex/1.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              3145503.00      +165.6%   8355407.00  lkp-a03/micro/will-it-scale/context_switch1
              4467709.20       -16.3%   3738161.00  lkp-snb01/micro/aim7/creat-clo
              7613212.20       +58.8%  12093568.00  TOTAL lock_stat.hrtimer_bases.lock#2.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                49979.02       -56.8%     21587.44  lkp-a03/micro/will-it-scale/context_switch1
                71080.53       -16.6%     59289.40  lkp-snb01/micro/aim7/creat-clo
               132935.16       -58.3%     55438.54  lkp-snb01/micro/will-it-scale/context_switch1
               253994.70       -46.3%    136315.38  TOTAL lock_stat.&buffer->mutex.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             35382928.00      +180.9%  99377214.33  lkp-a03/micro/will-it-scale/context_switch1
           2360549682.33       +11.0% 2620341104.67  lkp-snb01/micro/will-it-scale/context_switch1
           2395932610.33       +13.5% 2719718319.00  TOTAL lock_stat.&rq->lock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1013077.05       -67.2%    332565.89  lkp-a03/micro/will-it-scale/context_switch1
               748941.07       -22.5%    580279.70  lkp-snb01/micro/aim7/creat-clo
               155233.65       -35.0%    100948.61  lkp-snb01/micro/will-it-scale/context_switch1
              1917251.77       -47.1%   1013794.20  TOTAL lock_stat.((&timer)).holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               389411.44       -65.6%    133907.29  lkp-a03/micro/will-it-scale/context_switch1
               262036.65       -26.2%    193457.19  lkp-snb01/micro/aim7/creat-clo
                56171.96       -33.3%     37445.40  lkp-snb01/micro/will-it-scale/context_switch1
               707620.05       -48.4%    364809.88  TOTAL lock_stat.&rsp->gp_wq.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                63669.54       -62.1%     24149.16  lkp-a03/micro/will-it-scale/context_switch1
                10580.23       -22.3%      8217.41  lkp-snb01/micro/aim7/creat-clo
                 5706.46       -42.0%      3312.24  lkp-snb01/micro/will-it-scale/context_switch1
                79956.23       -55.4%     35678.81  TOTAL lock_stat.&(&k->k_lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1249876.55       -61.6%    479526.22  lkp-a03/micro/will-it-scale/context_switch1
               741812.95       -12.0%    652742.88  lkp-snb01/micro/will-it-scale/context_switch1
              1991689.50       -43.2%   1132269.10  TOTAL lock_stat.sb_writers#3-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4599.41      +697.2%     36667.21  lkp-t410/micro/netperf/120s-200%-TCP_RR
                 4599.41      +697.2%     36667.21  TOTAL lock_stat.&type->i_mutex_dir_key#2.holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               123360.06       -59.7%     49733.91  lkp-a03/micro/will-it-scale/context_switch1
               125284.39       -22.7%     96845.78  lkp-snb01/micro/aim7/creat-clo
                50077.68       -43.7%     28186.43  lkp-snb01/micro/will-it-scale/context_switch1
               298722.13       -41.5%    174766.11  TOTAL lock_stat.&x->wait#2.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4609.90     +1251.7%     62312.42  lkp-t410/micro/netperf/120s-200%-TCP_RR
                 4609.90     +1251.7%     62312.42  TOTAL lock_stat.sb_writers#7-R.holdtime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             33460620.33      +157.1%  86012924.67  lkp-a03/micro/will-it-scale/context_switch1
           1944724367.33       +10.7% 2153513244.67  lkp-snb01/micro/will-it-scale/context_switch1
           1978184987.67       +13.2% 2239526169.33  TOTAL lock_stat.rcu_read_lock-R.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                27076.41       -58.3%     11282.62  lkp-a03/micro/will-it-scale/context_switch1
                 8388.40       -21.5%      6588.95  lkp-snb01/micro/aim7/creat-clo
                35464.81       -49.6%     17871.57  TOTAL lock_stat.&(&ent->pde_unload_lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4981.50       -64.0%      1793.05  lkp-a03/micro/will-it-scale/context_switch1
              1658712.45       +29.6%   2150516.45  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
              1617970.78       +14.4%   1851526.70  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
              3281664.73       +22.0%   4003836.19  TOTAL lock_stat.&(&dma_entry_hash[i].lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               323758.76       -59.7%    130620.56  lkp-a03/micro/will-it-scale/context_switch1
               182217.44       -19.3%    147082.52  lkp-snb01/micro/aim7/creat-clo
                75725.03       -40.6%     44994.36  lkp-snb01/micro/will-it-scale/context_switch1
               581701.23       -44.5%    322697.44  TOTAL lock_stat.&(&fs->lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                19385.47       -44.3%     10806.83  lkp-a03/micro/will-it-scale/context_switch1
                19385.47       -44.3%     10806.83  TOTAL lock_stat.bdev_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               108659.60      +104.2%    221909.00  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               123337.00       +49.3%    184168.60  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
               231996.60       +75.0%    406077.60  TOTAL lock_stat.&(&zone->lock)->rlock.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               923407.17       -60.5%    365071.30  lkp-a03/micro/will-it-scale/context_switch1
               386233.65       -19.9%    309437.23  lkp-snb01/micro/aim7/creat-clo
               134917.77       -35.8%     86572.74  lkp-snb01/micro/will-it-scale/context_switch1
              1444558.59       -47.3%    761081.27  TOTAL lock_stat.slab_mutex.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              6263394.67      +198.5%  18693714.33  lkp-a03/micro/will-it-scale/context_switch1
               175005.80       -15.1%    148663.80  lkp-snb01/micro/aim7/creat-clo
            443296477.33       +16.0% 514210326.33  lkp-snb01/micro/will-it-scale/context_switch1
            449734877.80       +18.5% 533052704.47  TOTAL lock_stat.&pipe->wait.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              6263974.67      +198.4%  18694415.00  lkp-a03/micro/will-it-scale/context_switch1
               181894.40       -15.0%    154567.00  lkp-snb01/micro/aim7/creat-clo
            443297125.33       +16.0% 514210949.33  lkp-snb01/micro/will-it-scale/context_switch1
            449742994.40       +18.5% 533059931.33  TOTAL lock_stat.&pipe->mutex/1.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              8700621.95       -60.1%   3469034.94  lkp-a03/micro/will-it-scale/context_switch1
              4836826.89       -19.5%   3891950.22  lkp-snb01/micro/aim7/creat-clo
              1805368.87       -36.4%   1148205.91  lkp-snb01/micro/will-it-scale/context_switch1
             15342817.71       -44.5%   8509191.07  TOTAL lock_stat.&mm->mmap_sem-W.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                22716.55       -53.4%     10579.36  lkp-a03/micro/will-it-scale/context_switch1
        1562872093539.00       -14.7% 1333872576763.80  lkp-snb01/micro/aim7/creat-clo
                 4182.72       -50.2%      2084.94  lkp-snb01/micro/will-it-scale/context_switch1
        1562872120438.27       -14.7% 1333872589428.10  TOTAL lock_stat.sb_writers#4-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 6843.93       -55.4%      3052.84  lkp-a03/micro/will-it-scale/context_switch1
                 7434.67       -16.7%      6193.14  lkp-snb01/micro/aim7/creat-clo
                14278.60       -35.2%      9245.98  TOTAL lock_stat.writeback-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                65376.77       -59.2%     26696.77  lkp-a03/micro/will-it-scale/context_switch1
                20979.41       -21.6%     16451.55  lkp-snb01/micro/aim7/creat-clo
                 7225.31       -35.6%      4654.00  lkp-snb01/micro/will-it-scale/context_switch1
                93581.49       -48.9%     47802.32  TOTAL lock_stat.&sb->s_type->i_lock_key#4.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 6389.43       -55.1%      2866.24  lkp-a03/micro/will-it-scale/context_switch1
                 7223.49       -16.9%      6000.69  lkp-snb01/micro/aim7/creat-clo
                13612.91       -34.9%      8866.93  TOTAL lock_stat.(&(&wb->dwork)->work).holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                59307.80       +66.6%     98833.00  lkp-snb01/micro/aim7/creat-clo
                59307.80       +66.6%     98833.00  TOTAL lock_stat.&(&n->list_lock)->rlock.contentions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                58864.60       +66.8%     98179.20  lkp-snb01/micro/aim7/creat-clo
                58864.60       +66.8%     98179.20  TOTAL lock_stat.&(&n->list_lock)->rlock.con-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                13647.05       -60.3%      5414.64  lkp-a03/micro/will-it-scale/context_switch1
                 9452.25       -15.1%      8029.08  lkp-snb01/micro/aim7/creat-clo
                 3289.35       -35.5%      2121.15  lkp-snb01/micro/will-it-scale/context_switch1
                26388.65       -41.0%     15564.87  TOTAL lock_stat.&child->perf_event_mutex.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1650599.33       -58.7%    681703.30  lkp-a03/micro/will-it-scale/context_switch1
               940784.72       -19.3%    759135.12  lkp-snb01/micro/aim7/creat-clo
               348850.59       -37.5%    217940.82  lkp-snb01/micro/will-it-scale/context_switch1
              2940234.65       -43.6%   1658779.25  TOTAL lock_stat.&anon_vma->rwsem.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2492674.67      +195.3%   7361392.00  lkp-a03/micro/will-it-scale/context_switch1
              1614107.20       -15.6%   1363007.80  lkp-snb01/micro/aim7/creat-clo
              3752297.80        -9.9%   3380655.40  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
              7859079.67       +54.0%  12105055.20  TOTAL lock_stat.hrtimer_bases.lock#3.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                50215.60       -58.2%     20981.93  lkp-a03/micro/will-it-scale/context_switch1
                25700.68       -19.3%     20747.51  lkp-snb01/micro/aim7/creat-clo
                10328.80       -38.7%      6331.56  lkp-snb01/micro/will-it-scale/context_switch1
                86245.08       -44.3%     48061.00  TOTAL lock_stat.&sb->s_type->i_lock_key#9.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                11114.64       -55.7%      4927.15  lkp-a03/micro/will-it-scale/context_switch1
                 6538.72       -17.9%      5371.15  lkp-snb01/micro/aim7/creat-clo
                17653.36       -41.7%     10298.31  TOTAL lock_stat.random_write_wait.lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               677654.34       -58.1%    283744.70  lkp-a03/micro/will-it-scale/context_switch1
               399349.07       -19.7%    320587.71  lkp-snb01/micro/aim7/creat-clo
               161337.86       -36.5%    102401.10  lkp-snb01/micro/will-it-scale/context_switch1
              1238341.27       -42.9%    706733.51  TOTAL lock_stat.&(&zone->lru_lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               163932.36       -57.6%     69524.48  lkp-a03/micro/will-it-scale/context_switch1
               101698.54       -17.8%     83637.29  lkp-snb01/micro/aim7/creat-clo
                38974.80       -38.1%     24131.02  lkp-snb01/micro/will-it-scale/context_switch1
               304605.70       -41.8%    177292.79  TOTAL lock_stat.nonblocking_pool.lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              3590904.09       -59.1%   1469938.91  lkp-a03/micro/will-it-scale/context_switch1
              2190376.28       -17.4%   1809187.58  lkp-snb01/micro/aim7/creat-clo
               752865.70       -35.0%    489708.54  lkp-snb01/micro/will-it-scale/context_switch1
              6534146.06       -42.3%   3768835.02  TOTAL lock_stat.&dup_mmap_sem-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              3535931.20       -59.1%   1445480.99  lkp-a03/micro/will-it-scale/context_switch1
              2150309.24       -17.4%   1776812.91  lkp-snb01/micro/aim7/creat-clo
               738572.90       -34.8%    481309.57  lkp-snb01/micro/will-it-scale/context_switch1
              6424813.34       -42.4%   3703603.47  TOTAL lock_stat.&mm->mmap_sem/1.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               176562.33       -58.0%     74130.29  lkp-a03/micro/will-it-scale/context_switch1
               147515.93       -21.6%    115701.85  lkp-snb01/micro/aim7/creat-clo
                50917.60       -35.1%     33034.04  lkp-snb01/micro/will-it-scale/context_switch1
               374995.86       -40.6%    222866.18  TOTAL lock_stat.&sig->wait_chldexit.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             13435696.89       -60.3%   5338403.95  lkp-a03/micro/will-it-scale/context_switch1
              8314636.97       -18.9%   6743421.14  lkp-snb01/micro/aim7/creat-clo
              3621140.24       -30.2%   2527416.58  lkp-snb01/micro/will-it-scale/context_switch1
             25371474.10       -42.4%  14609241.67  TOTAL lock_stat.&(&mm->page_table_lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             30165232.86       -60.1%  12046072.37  lkp-a03/micro/will-it-scale/context_switch1
             16701516.26       -18.9%  13542038.75  lkp-snb01/micro/aim7/creat-clo
              6804609.00       -30.5%   4731963.15  lkp-snb01/micro/will-it-scale/context_switch1
             53671358.12       -43.5%  30320074.27  TOTAL lock_stat.&mm->mmap_sem-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               398344.20       -35.0%    258970.00  lkp-snb01/micro/aim7/creat-clo
               398344.20       -35.0%    258970.00  TOTAL lock_stat.&rq->lock.contentions.update_blocked_averages

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                36424.66       -56.2%     15958.04  lkp-a03/micro/will-it-scale/context_switch1
                19978.64       -19.5%     16085.76  lkp-snb01/micro/aim7/creat-clo
                 7693.57       -37.0%      4847.22  lkp-snb01/micro/will-it-scale/context_switch1
                64096.87       -42.4%     36891.02  TOTAL lock_stat.binfmt_lock-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                13514.75       -59.3%      5499.36  lkp-a03/micro/will-it-scale/context_switch1
                 9668.23       -15.0%      8220.70  lkp-snb01/micro/aim7/creat-clo
                 4689.54       -32.9%      3144.74  lkp-snb01/micro/will-it-scale/context_switch1
                27872.52       -39.5%     16864.80  TOTAL lock_stat.&sig->group_rwsem-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 9074.13       -53.4%      4231.11  lkp-a03/micro/will-it-scale/context_switch1
                 6013.87       -22.5%      4658.68  lkp-snb01/micro/aim7/creat-clo
                15088.00       -41.1%      8889.79  TOTAL lock_stat.watchdog_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 3786.80       -27.1%      2759.40  lkp-snb01/micro/aim7/creat-clo
                 3786.80       -27.1%      2759.40  TOTAL lock_stat.&rt_rq->rt_runtime_lock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 9631.16       -57.0%      4144.36  lkp-a03/micro/will-it-scale/context_switch1
                56626.78        -8.2%     51969.47  lkp-snb01/micro/aim7/creat-clo
                66257.94       -15.3%     56113.83  TOTAL lock_stat.&(&mapping->tree_lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                12465.70       -53.6%      5778.47  lkp-a03/micro/will-it-scale/context_switch1
                 9423.30       -18.8%      7654.92  lkp-snb01/micro/aim7/creat-clo
                21888.99       -38.6%     13433.39  TOTAL lock_stat.&(kretprobe_table_locks[i].lock).holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               129877.72       -55.4%     57970.41  lkp-a03/micro/will-it-scale/context_switch1
               924614.60       -11.5%    818598.85  lkp-snb01/micro/aim7/creat-clo
                18483.41       -42.7%     10596.24  lkp-snb01/micro/will-it-scale/context_switch1
              1072975.73       -17.3%    887165.49  TOTAL lock_stat.sb_writers#2-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               106731.39       -55.0%     48050.40  lkp-a03/micro/will-it-scale/context_switch1
                84165.35       -19.7%     67543.66  lkp-snb01/micro/aim7/creat-clo
                32789.92       -38.5%     20168.05  lkp-snb01/micro/will-it-scale/context_switch1
               223686.66       -39.3%    135762.12  TOTAL lock_stat.&(&stopper->lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                11647.09       -53.9%      5371.76  lkp-a03/micro/will-it-scale/context_switch1
                 7324.07       -20.6%      5813.81  lkp-snb01/micro/aim7/creat-clo
                18971.16       -41.0%     11185.58  TOTAL lock_stat.(&watchdog_timer).holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               472640.13       -57.8%    199625.81  lkp-a03/micro/will-it-scale/context_switch1
               883897.30       -14.9%    752365.78  lkp-snb01/micro/aim7/creat-clo
               102647.75       -35.0%     66769.48  lkp-snb01/micro/will-it-scale/context_switch1
              1459185.19       -30.2%   1018761.07  TOTAL lock_stat.&sb->s_type->i_mutex_key#2.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                63053.48       -53.5%     29326.83  lkp-a03/micro/will-it-scale/context_switch1
               311912.00       -24.2%    236318.56  lkp-snb01/micro/will-it-scale/context_switch1
               374965.47       -29.2%    265645.40  TOTAL lock_stat.jiffies_lock.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                32048.83       -56.0%     14088.25  lkp-a03/micro/will-it-scale/context_switch1
                47749.56       -20.8%     37819.67  lkp-snb01/micro/aim7/creat-clo
                50171.25       -39.1%     30532.36  lkp-snb01/micro/will-it-scale/context_switch1
               129969.65       -36.6%     82440.28  TOTAL lock_stat.rcu_node_0.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2017764.48       -55.7%    894473.64  lkp-a03/micro/will-it-scale/context_switch1
              1492826.01       -21.2%   1176119.00  lkp-snb01/micro/aim7/creat-clo
               446436.07       -34.0%    294428.18  lkp-snb01/micro/will-it-scale/context_switch1
              3957026.56       -40.2%   2365020.81  TOTAL lock_stat.&mapping->i_mmap_mutex.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                15380.47       -55.2%      6895.39  lkp-a03/micro/will-it-scale/context_switch1
                10778.84       -20.6%      8561.22  lkp-snb01/micro/aim7/creat-clo
                 3506.78       -35.2%      2273.99  lkp-snb01/micro/will-it-scale/context_switch1
                29666.09       -40.2%     17730.61  TOTAL lock_stat.entries_lock-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             17338534.22       -58.2%   7255689.36  lkp-a03/micro/will-it-scale/context_switch1
              7113609.92       -19.8%   5705935.09  lkp-snb01/micro/aim7/creat-clo
              3727112.65       -27.3%   2709436.01  lkp-snb01/micro/will-it-scale/context_switch1
             28179256.79       -44.4%  15671060.46  TOTAL lock_stat.&sig->cred_guard_mutex.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2728884.00       -58.7%   1126840.93  lkp-a03/micro/will-it-scale/context_switch1
             10798504.13       -17.8%   8880520.60  lkp-snb01/micro/aim7/creat-clo
              1018659.38       -28.6%    727464.95  lkp-snb01/micro/will-it-scale/context_switch1
             14546047.52       -26.2%  10734826.49  TOTAL lock_stat.&p->lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               265297.95       -55.2%    118899.14  lkp-a03/micro/will-it-scale/context_switch1
               200289.00       -18.8%    162710.21  lkp-snb01/micro/aim7/creat-clo
                72127.41       -36.9%     45495.07  lkp-snb01/micro/will-it-scale/context_switch1
               537714.36       -39.2%    327104.43  TOTAL lock_stat.&(&p->alloc_lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                27991.11       -55.7%     12395.91  lkp-a03/micro/will-it-scale/context_switch1
                24731.88       -18.7%     20110.50  lkp-snb01/micro/aim7/creat-clo
                 7880.93       -34.6%      5153.81  lkp-snb01/micro/will-it-scale/context_switch1
                60603.92       -37.9%     37660.22  TOTAL lock_stat.pidmap_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                30604.00       -58.0%     12865.81  lkp-a03/micro/will-it-scale/context_switch1
               153677.01       -25.8%    113967.32  lkp-snb01/micro/aim7/creat-clo
                36500.20       -21.8%     28542.28  lkp-snb01/micro/will-it-scale/context_switch1
               220781.20       -29.6%    155375.41  TOTAL lock_stat.(&(work)->work).holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               587734.13       -54.8%    265670.22  lkp-a03/micro/will-it-scale/context_switch1
               454923.92       -19.4%    366454.26  lkp-snb01/micro/aim7/creat-clo
               157313.15       -35.0%    102259.87  lkp-snb01/micro/will-it-scale/context_switch1
              1199971.20       -38.8%    734384.35  TOTAL lock_stat.tasklist_lock-W.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                54387.50       -55.3%     24322.05  lkp-a03/micro/will-it-scale/context_switch1
                35710.28       -19.8%     28635.44  lkp-snb01/micro/aim7/creat-clo
                11168.50       -32.7%      7515.89  lkp-snb01/micro/will-it-scale/context_switch1
               101266.28       -40.3%     60473.38  TOTAL lock_stat.input_pool.lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               137834.63       -55.7%     61048.39  lkp-a03/micro/will-it-scale/context_switch1
                63183.32       -18.2%     51693.24  lkp-snb01/micro/aim7/creat-clo
                17310.45       -31.0%     11938.98  lkp-snb01/micro/will-it-scale/context_switch1
               218328.40       -42.9%    124680.61  TOTAL lock_stat.&sb->s_type->i_mutex_key.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 4597.14       -36.3%      2926.59  lkp-a03/micro/will-it-scale/context_switch1
                 4597.14       -36.3%      2926.59  TOTAL lock_stat.slock-AF_INET-RPC/1.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               173268.01       -61.3%     67071.97  lkp-a03/micro/will-it-scale/context_switch1
              1999998.23       -46.7%   1065181.46  lkp-snb01/micro/aim7/creat-clo
               538953.15       +38.3%    745347.01  lkp-snb01/micro/will-it-scale/context_switch1
                43653.53       +15.2%     50289.78  nhm-white/micro/aim7/link_test
                13668.11       +18.8%     16231.73  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
              2769541.03       -29.8%   1944121.96  TOTAL lock_stat.&rq->lock.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               186355.65       -55.2%     83555.10  lkp-a03/micro/will-it-scale/context_switch1
              7889323.49       -16.6%   6582667.96  lkp-snb01/micro/aim7/creat-clo
                51203.54       -34.8%     33396.96  lkp-snb01/micro/will-it-scale/context_switch1
              8126882.68       -17.6%   6699620.02  TOTAL lock_stat.tasklist_lock-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               102015.13       -56.8%     44083.90  lkp-a03/micro/will-it-scale/context_switch1
                22640.04       -30.2%     15803.97  lkp-snb01/micro/will-it-scale/context_switch1
                96635.82       +21.9%    117762.18  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               221290.99       -19.7%    177650.04  TOTAL lock_stat.&(&n->list_lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                84342.44       -51.1%     41203.30  lkp-a03/micro/will-it-scale/context_switch1
                57671.74       -20.4%     45908.93  lkp-snb01/micro/aim7/creat-clo
                17069.01       -38.9%     10431.15  lkp-snb01/micro/will-it-scale/context_switch1
               159083.19       -38.7%     97543.38  TOTAL lock_stat.pgd_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               109957.20       -20.8%     87114.60  lkp-snb01/micro/aim7/creat-clo
               230221.60      +113.8%    492124.00  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               253835.80       +54.8%    392878.60  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
               594014.60       +63.7%    972117.20  TOTAL lock_stat.&(&zone->lru_lock)->rlock.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                21847.22       -51.4%     10623.49  lkp-a03/micro/will-it-scale/context_switch1
                16263.09       -15.5%     13743.80  lkp-snb01/micro/aim7/creat-clo
                38110.31       -36.1%     24367.29  TOTAL lock_stat.&sb->s_type->i_mutex_key#1.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                53569.25       -57.3%     22852.18  lkp-a03/micro/will-it-scale/context_switch1
               163416.18       -21.3%    128580.58  lkp-snb01/micro/aim7/creat-clo
                36794.57       -24.0%     27980.98  lkp-snb01/micro/will-it-scale/context_switch1
               253780.00       -29.3%    179413.74  TOTAL lock_stat.&(&pool->lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               863753.18       -56.1%    378874.21  lkp-a03/micro/will-it-scale/context_switch1
              1736957.39       -11.2%   1543209.74  lkp-snb01/micro/aim7/creat-clo
               224048.85       -33.0%    150178.35  lkp-snb01/micro/will-it-scale/context_switch1
              2824759.41       -26.6%   2072262.30  TOTAL lock_stat.&(&sighand->siglock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               307982.20       -55.2%    137837.62  lkp-a03/micro/will-it-scale/context_switch1
               238923.52       -17.7%    196529.03  lkp-snb01/micro/aim7/creat-clo
                85896.86       -31.1%     59198.77  lkp-snb01/micro/will-it-scale/context_switch1
               632802.58       -37.8%    393565.42  TOTAL lock_stat.&(&mm->page_table_lock)->rlock/1.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                40164.50       -56.5%     17471.44  lkp-a03/micro/will-it-scale/context_switch1
               142268.67       -21.1%    112245.29  lkp-snb01/micro/aim7/creat-clo
                31413.08       -22.3%     24417.74  lkp-snb01/micro/will-it-scale/context_switch1
               213846.26       -27.9%    154134.47  TOTAL lock_stat.(&(work)->timer).holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1538823.09       +64.9%   2538225.18  lkp-a03/micro/will-it-scale/context_switch1
              1538823.09       +64.9%   2538225.18  TOTAL lock_stat.&(&info->si_lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              3979107.80       -48.1%   2066233.00  lkp-snb01/micro/aim7/creat-clo
              1197154.67       +71.2%   2049983.00  lkp-snb01/micro/will-it-scale/context_switch1
                96302.90       +27.1%    122440.80  nhm-white/micro/aim7/link_test
                40060.80       +29.2%     51749.00  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
              5312626.17       -19.2%   4290405.80  TOTAL lock_stat.&rq->lock.con-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               973350.09       -61.2%    377447.05  lkp-a03/micro/will-it-scale/context_switch1
                24517.67       -14.1%     21070.01  lkp-ne04/micro/aim7/disk_src
               692135.11       -21.0%    546538.60  lkp-snb01/micro/aim7/creat-clo
               245779.70       -25.0%    184354.53  lkp-snb01/micro/will-it-scale/context_switch1
              1935782.57       -41.7%   1129410.19  TOTAL lock_stat.jiffies_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               124914.49       -46.6%     66711.03  lkp-a03/micro/will-it-scale/context_switch1
                92451.98       -20.5%     73509.34  lkp-snb01/micro/aim7/creat-clo
                11333.17       -37.4%      7098.43  lkp-snb01/micro/will-it-scale/context_switch1
               228699.64       -35.6%    147318.80  TOTAL lock_stat.vmap_area_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                97142.20       +54.7%    150298.20  lkp-snb01/micro/aim7/creat-clo
              1819970.10       -35.7%   1170983.70  nhm-white/micro/aim7/link_test
              1917112.30       -31.1%   1321281.90  TOTAL lock_stat.&(&dentry->d_lockref.lock)->rlock.contentions.d_alloc

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              3119568.33      +174.9%   8575197.00  lkp-a03/micro/will-it-scale/context_switch1
               404859.20       -16.1%    339614.20  lkp-snb01/micro/aim7/creat-clo
             28159523.00       +17.1%  32967386.67  lkp-snb01/micro/will-it-scale/context_switch1
              2984829.00       -11.4%   2643163.60  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
             34668779.53       +28.4%  44525361.47  TOTAL lock_stat.hrtimer_bases.lock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              3193299.33      +170.9%   8649068.00  lkp-a03/micro/will-it-scale/context_switch1
              6535783.40       -15.1%   5549023.20  lkp-snb01/micro/aim7/creat-clo
            208662703.00       +16.1% 242281999.33  lkp-snb01/micro/will-it-scale/context_switch1
              4595480.40       +14.5%   5264023.00  lkp-t410/micro/netperf/120s-200%-TCP_CRR
            222987266.13       +17.4% 261744113.53  TOTAL lock_stat.&(&base->lock)->rlock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                19145.60       -47.7%     10007.64  lkp-a03/micro/will-it-scale/context_switch1
                12372.15       -16.6%     10319.12  lkp-snb01/micro/aim7/creat-clo
                31517.75       -35.5%     20326.76  TOTAL lock_stat.proc_subdir_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               517397.40       -61.5%    199424.93  lkp-a03/micro/will-it-scale/context_switch1
                14114.97       -15.0%     12002.72  lkp-ne04/micro/aim7/disk_src
               373277.17       -20.3%    297650.79  lkp-snb01/micro/aim7/creat-clo
               119373.38       -19.0%     96680.29  lkp-snb01/micro/will-it-scale/context_switch1
                29822.30       -11.7%     26342.91  lkp-t410/micro/netperf/120s-200%-TCP_RR
              1053985.21       -40.0%    632101.62  TOTAL lock_stat.timekeeper_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                42949.84       +43.8%     61777.47  lkp-snb01/micro/aim7/creat-clo
                42949.84       +43.8%     61777.47  TOTAL lock_stat.&(&n->list_lock)->rlock.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             52439868.80       +39.4%  73106484.20  lkp-snb01/micro/aim7/creat-clo
              1928354.10       -32.8%   1295597.10  nhm-white/micro/aim7/link_test
             54368222.90       +36.8%  74402081.30  TOTAL lock_stat.&(&dentry->d_lockref.lock)->rlock.con-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               554174.33        -2.0%    543263.00  lkp-ne04/micro/aim7/disk_src
              3981406.00       -48.0%   2069109.60  lkp-snb01/micro/aim7/creat-clo
              1197827.33       +71.2%   2050117.33  lkp-snb01/micro/will-it-scale/context_switch1
                96334.60       +27.1%    122462.90  nhm-white/micro/aim7/link_test
                40121.20       +29.2%     51842.20  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
              5869863.47       -17.6%   4836795.03  TOTAL lock_stat.&rq->lock.contentions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               594720.60       -53.0%    279637.02  lkp-a03/micro/will-it-scale/context_switch1
              1670322.23       -20.2%   1333628.09  lkp-snb01/micro/aim7/creat-clo
               546572.31       -25.8%    405745.98  lkp-snb01/micro/will-it-scale/context_switch1
              2267099.92        +8.8%   2467185.35  lkp-t410/micro/netperf/120s-200%-TCP_STREAM
              5078715.05       -11.7%   4486196.44  TOTAL lock_stat.&(&zone->lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             60070228.40       +37.8%  82776413.60  lkp-snb01/micro/aim7/creat-clo
              1971643.40       -31.0%   1359709.40  nhm-white/micro/aim7/link_test
             62041871.80       +35.6%  84136123.00  TOTAL lock_stat.&(&dentry->d_lockref.lock)->rlock.contentions.lockref_get_not_dead

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             52453566.60       +39.4%  73116430.80  lkp-snb01/micro/aim7/creat-clo
              1980413.10       -30.9%   1367788.60  nhm-white/micro/aim7/link_test
             54433979.70       +36.8%  74484219.40  TOTAL lock_stat.&(&dentry->d_lockref.lock)->rlock.contentions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                65676.09       -48.0%     34128.10  lkp-a03/micro/will-it-scale/context_switch1
               269750.32       -22.1%    210055.95  lkp-snb01/micro/aim7/creat-clo
                72788.82       -13.5%     62927.56  lkp-snb01/micro/will-it-scale/context_switch1
               408215.23       -24.8%    307111.61  TOTAL lock_stat.events-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                56977.81       -15.7%     48055.13  lkp-snb01/micro/aim7/creat-clo
                27429.35       -40.9%     16198.38  lkp-snb01/micro/will-it-scale/context_switch1
                84407.16       -23.9%     64253.51  TOTAL lock_stat.s_active#4-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                33127.91       -38.9%     20253.59  lkp-a03/micro/will-it-scale/context_switch1
                22044.30       -14.8%     18788.93  lkp-snb01/micro/aim7/creat-clo
                55172.20       -29.2%     39042.52  TOTAL lock_stat.sb_writers#7-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                65025.60       +41.8%     92231.40  lkp-snb01/micro/aim7/creat-clo
                65025.60       +41.8%     92231.40  TOTAL lock_stat.&(&n->list_lock)->rlock.contentions.unfreeze_partials

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             26574405.80       +42.4%  37846677.60  lkp-snb01/micro/aim7/creat-clo
             26574405.80       +42.4%  37846677.60  TOTAL lock_stat.&(&newf->file_lock)->rlock.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               246541.11       -26.1%    182139.18  lkp-snb01/micro/aim7/creat-clo
               246541.11       -26.1%    182139.18  TOTAL lock_stat.hrtimer_bases.lock#9.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                22314.19       -30.6%     15487.88  nhm-white/micro/aim7/link_test
                22314.19       -30.6%     15487.88  TOTAL lock_stat.tick_broadcast_lock.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               239592.80       -26.0%    177298.30  lkp-snb01/micro/aim7/creat-clo
               239592.80       -26.0%    177298.30  TOTAL lock_stat.hrtimer_bases.lock#7.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             13500787.40       +17.1%  15809087.00  lkp-snb01/micro/aim7/creat-clo
               102290.20       +70.1%    174014.60  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               104138.00       +28.2%    133500.40  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
             13707215.60       +17.6%  16116602.00  TOTAL lock_stat.&(&n->list_lock)->rlock.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               372791.98       -26.7%    273083.56  nhm-white/micro/aim7/link_test
               372791.98       -26.7%    273083.56  TOTAL lock_stat.&(&dentry->d_lockref.lock)->rlock.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               237433.58       -24.6%    178980.78  lkp-snb01/micro/aim7/creat-clo
               237433.58       -24.6%    178980.78  TOTAL lock_stat.hrtimer_bases.lock#6.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                26222.61       -32.3%     17761.67  lkp-a03/micro/will-it-scale/context_switch1
                87611.02       -17.6%     72222.74  lkp-snb01/micro/aim7/creat-clo
               113833.63       -21.0%     89984.41  TOTAL lock_stat.(&adapter->watchdog_task).holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              3000234.95       -23.5%   2295369.14  lkp-snb01/micro/aim7/creat-clo
               336550.34       -28.5%    240495.31  lkp-snb01/micro/will-it-scale/context_switch1
              3336785.29       -24.0%   2535864.45  TOTAL lock_stat.rcu_node_1.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               220057.59       -27.6%    159248.44  lkp-snb01/micro/aim7/creat-clo
                38676.94       -25.7%     28728.91  lkp-snb01/micro/will-it-scale/context_switch1
               258734.54       -27.3%    187977.34  TOTAL lock_stat.balancing.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               602033.40       -21.0%    475575.40  lkp-snb01/micro/aim7/creat-clo
               602033.40       -21.0%    475575.40  TOTAL lock_stat.balancing.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               109215.00       +48.9%    162589.40  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               123033.80       +15.9%    142573.80  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
               232248.80       +31.4%    305163.20  TOTAL lock_stat.&p->pi_lock.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
           1573161413.01       -21.8% 1229608023.92  lkp-snb01/micro/aim7/creat-clo
           1573161413.01       -21.8% 1229608023.92  TOTAL lock_stat.&sb->s_type->i_mutex_key#7/1.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             44730352.80       +41.5%  63305045.40  lkp-snb01/micro/aim7/creat-clo
               167970.60       +21.6%    204328.00  nhm-white/micro/aim7/link_test
             44898323.40       +41.5%  63509373.40  TOTAL lock_stat.&(&dentry->d_lockref.lock)->rlock.contentions.lockref_put_or_lock

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2378869.61       -24.1%   1806234.24  lkp-snb01/micro/aim7/creat-clo
              2378869.61       -24.1%   1806234.24  TOTAL lock_stat.hrtimer_bases.lock#1.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               241356.29       -25.6%    179449.58  lkp-snb01/micro/aim7/creat-clo
                49168.55       -15.5%     41567.05  nhm-white/micro/aim7/link_test
               290524.84       -23.9%    221016.62  TOTAL lock_stat.hrtimer_bases.lock#8.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               333502.00       +25.7%    419335.80  lkp-snb01/micro/aim7/creat-clo
               333502.00       +25.7%    419335.80  TOTAL lock_stat.&sb->s_type->i_mutex_key#7.contentions.do_unlinkat

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1395120.96       -39.7%    840965.98  lkp-a03/micro/will-it-scale/context_switch1
              1376165.91       -11.4%   1219953.09  lkp-snb01/micro/will-it-scale/context_switch1
                28655.98       +15.0%     32945.05  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
              2799942.85       -25.2%   2093864.12  TOTAL lock_stat.&pipe->mutex/1.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2489531.66       -22.8%   1921479.76  lkp-snb01/micro/aim7/creat-clo
              2489531.66       -22.8%   1921479.76  TOTAL lock_stat.&(&base->lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               241671.27       -27.6%    175089.61  lkp-snb01/micro/aim7/creat-clo
                48692.21       -10.3%     43681.85  nhm-white/micro/aim7/link_test
               290363.48       -24.7%    218771.45  TOTAL lock_stat.hrtimer_bases.lock#5.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               244005.54       -25.6%    181596.07  lkp-snb01/micro/aim7/creat-clo
                48096.78       -11.3%     42642.45  nhm-white/micro/aim7/link_test
               292102.32       -23.2%    224238.52  TOTAL lock_stat.hrtimer_bases.lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               190043.40       -19.9%    152254.60  lkp-snb01/micro/aim7/creat-clo
               190043.40       -19.9%    152254.60  TOTAL lock_stat.rcu_node_1.contentions.rcu_gp_kthread

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               424452.40       -21.0%    335280.60  lkp-snb01/micro/aim7/creat-clo
               424452.40       -21.0%    335280.60  TOTAL lock_stat.&mapping->i_mmap_mutex.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               201145.00       -19.2%    162599.40  lkp-snb01/micro/aim7/creat-clo
               201145.00       -19.2%    162599.40  TOTAL lock_stat.rcu_node_1.contentions.force_qs_rnp

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               793498.85       +30.5%   1035316.69  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               763823.96       +16.0%    885712.45  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
              1557322.81       +23.4%   1921029.14  TOTAL lock_stat.free_entries_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                73463.39       -21.9%     57342.99  lkp-snb01/micro/aim7/creat-clo
                73463.39       -21.9%     57342.99  TOTAL lock_stat.tasklist_lock-W.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              6735044.80       +28.9%   8679663.60  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
              6443551.80       +15.8%   7462924.20  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
             13178596.60       +22.5%  16142587.80  TOTAL lock_stat.free_entries_lock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             15151048.20       +17.1%  17737709.80  lkp-snb01/micro/aim7/creat-clo
                84559.00       +39.1%    117601.00  lkp-t410/micro/netperf/120s-200%-TCP_STREAM
               356415.80       +16.7%    415903.80  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
             15592023.00       +17.2%  18271214.60  TOTAL lock_stat.&(&n->list_lock)->rlock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                84296.00       -17.7%     69379.00  lkp-snb01/micro/aim7/creat-clo
                84296.00       -17.7%     69379.00  TOTAL lock_stat.&rnp->nocb_gp_wq[1].acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              6867858.20       +28.3%   8812482.40  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
              6579420.80       +15.5%   7598787.40  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
             13447279.00       +22.0%  16411269.80  TOTAL lock_stat.&(&dma_entry_hash[i].lock)->rlock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                87853.00       -14.5%     75077.33  lkp-a03/micro/will-it-scale/context_switch1
               470323.80       -15.6%    397066.00  lkp-snb01/micro/aim7/creat-clo
               102467.00       -24.3%     77577.67  lkp-snb01/micro/will-it-scale/context_switch1
               660643.80       -16.8%    549721.00  TOTAL lock_stat.&rsp->gp_wq.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               202298.33       -11.4%    179150.67  lkp-a03/micro/will-it-scale/context_switch1
               811978.60       -15.0%    690008.20  lkp-snb01/micro/aim7/creat-clo
                93557.33       -28.1%     67264.00  lkp-snb01/micro/will-it-scale/context_switch1
              1107834.27       -15.5%    936422.87  TOTAL lock_stat.rcu_node_0.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                70942.33       -16.3%     59406.33  lkp-a03/micro/will-it-scale/context_switch1
               373939.40       -15.6%    315587.60  lkp-snb01/micro/aim7/creat-clo
                78804.67       -22.3%     61227.00  lkp-snb01/micro/will-it-scale/context_switch1
               523686.40       -16.7%    436220.93  TOTAL lock_stat.((&timer)).acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              3370711.40       +27.8%   4309252.20  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
              3425711.80       +14.7%   3929646.60  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
              6796423.20       +21.2%   8238898.80  TOTAL lock_stat.io_tlb_lock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                84109.00       -17.4%     69469.00  lkp-snb01/micro/aim7/creat-clo
                84109.00       -17.4%     69469.00  TOTAL lock_stat.&rnp->nocb_gp_wq[0].acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               404414.00       -16.8%    336669.60  lkp-snb01/micro/aim7/creat-clo
               404414.00       -16.8%    336669.60  TOTAL lock_stat.hrtimer_bases.lock#5.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               592509.44       +28.0%    758535.28  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
               614180.36       +13.5%    696808.20  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
              1206689.80       +20.6%   1455343.48  TOTAL lock_stat.io_tlb_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                27205.41       -19.2%     21983.03  lkp-snb01/micro/aim7/creat-clo
                27205.41       -19.2%     21983.03  TOTAL lock_stat.&sb->s_type->i_mutex_key#7/1.waittime-max

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               202616.20       -16.4%    169359.80  lkp-snb01/micro/aim7/creat-clo
               202616.20       -16.4%    169359.80  TOTAL lock_stat.jiffies_lock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               202596.80       -16.4%    169353.00  lkp-snb01/micro/aim7/creat-clo
               202596.80       -16.4%    169353.00  TOTAL lock_stat.timekeeper_lock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                92553.80       -16.6%     77206.80  lkp-snb01/micro/aim7/creat-clo
                92553.80       -16.6%     77206.80  TOTAL lock_stat.pgd_lock.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              9464609.78       +21.4%  11489479.48  lkp-a03/micro/will-it-scale/context_switch1
               241386.75       -24.9%    181214.60  lkp-snb01/micro/aim7/creat-clo
                50522.16       -12.0%     44444.98  nhm-white/micro/aim7/link_test
              9756518.69       +20.1%  11715139.06  TOTAL lock_stat.hrtimer_bases.lock#4.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               121948.00       -16.2%    102140.00  lkp-snb01/micro/aim7/creat-clo
               121948.00       -16.2%    102140.00  TOTAL lock_stat.&(&stopper->lock)->rlock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               371500.20       -16.3%    311060.40  lkp-snb01/micro/aim7/creat-clo
               371500.20       -16.3%    311060.40  TOTAL lock_stat.sysfs_mutex.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                73164.00       -16.2%     61281.20  lkp-snb01/micro/aim7/creat-clo
                73164.00       -16.2%     61281.20  TOTAL lock_stat.&x->wait#2.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                73174.60       -16.2%     61290.40  lkp-snb01/micro/aim7/creat-clo
                73174.60       -16.2%     61290.40  TOTAL lock_stat.binfmt_lock-R.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                65887.00       -16.2%     55196.80  lkp-snb01/micro/aim7/creat-clo
                65887.00       -16.2%     55196.80  TOTAL lock_stat.&sb->s_type->i_lock_key#9.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               405693.20       -16.6%    338365.20  lkp-snb01/micro/aim7/creat-clo
               405693.20       -16.6%    338365.20  TOTAL lock_stat.hrtimer_bases.lock#9.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              7783426.98       -16.3%   6512480.55  lkp-snb01/micro/aim7/creat-clo
              7783426.98       -16.3%   6512480.55  TOTAL lock_stat.sched_debug_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               755653.20       -16.2%    633614.20  lkp-snb01/micro/aim7/creat-clo
               755653.20       -16.2%    633614.20  TOTAL lock_stat.&mm->mmap_sem-W.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               253150.60       -16.0%    212739.40  lkp-snb01/micro/aim7/creat-clo
               253150.60       -16.0%    212739.40  TOTAL lock_stat.&(&fs->lock)->rlock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                79811.00       -16.1%     66964.40  lkp-snb01/micro/aim7/creat-clo
                79811.00       -16.1%     66964.40  TOTAL lock_stat.&(&pool->lock)->rlock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                69747.20       -16.2%     58440.60  lkp-snb01/micro/aim7/creat-clo
                69747.20       -16.2%     58440.60  TOTAL lock_stat.&(&fs->lock)->rlock.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                25849.40       -16.1%     21687.80  lkp-snb01/micro/aim7/creat-clo
                25849.40       -16.1%     21687.80  TOTAL lock_stat.(&(work)->timer).acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               150366.40       -15.8%    126598.80  lkp-snb01/micro/aim7/creat-clo
               150366.40       -15.8%    126598.80  TOTAL lock_stat.nonblocking_pool.lock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              4050963.80       -16.3%   3389654.60  lkp-snb01/micro/aim7/creat-clo
              4050963.80       -16.3%   3389654.60  TOTAL lock_stat.hrtimer_bases.lock#1.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2068258.60       -15.7%   1743482.80  lkp-snb01/micro/aim7/creat-clo
              2068258.60       -15.7%   1743482.80  TOTAL lock_stat.&mapping->i_mmap_mutex.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               115827.40       -15.7%     97648.00  lkp-snb01/micro/aim7/creat-clo
               115827.40       -15.7%     97648.00  TOTAL lock_stat.tasklist_lock-R.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               234199.00       -15.6%    197631.00  lkp-snb01/micro/aim7/creat-clo
               234199.00       -15.6%    197631.00  TOTAL lock_stat.&rnp->nocb_gp_wq[0].acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                93679.20       -15.6%     79053.00  lkp-snb01/micro/aim7/creat-clo
                93679.20       -15.6%     79053.00  TOTAL lock_stat.rcu_sched_state.onoff_mutex.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               234198.00       -15.6%    197634.00  lkp-snb01/micro/aim7/creat-clo
               234198.00       -15.6%    197634.00  TOTAL lock_stat.&rnp->nocb_gp_wq[1].acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               101555.00       -15.6%     85710.80  lkp-snb01/micro/aim7/creat-clo
               101555.00       -15.6%     85710.80  TOTAL lock_stat.pgd_lock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              7184913.60       -15.6%   6062043.80  lkp-snb01/micro/aim7/creat-clo
              7184913.60       -15.6%   6062043.80  TOTAL lock_stat.&mm->mmap_sem-R.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2257593.00       -15.5%   1906643.60  lkp-snb01/micro/aim7/creat-clo
              2257593.00       -15.5%   1906643.60  TOTAL lock_stat.&anon_vma->rwsem.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             11125613.20       -15.6%   9391327.60  lkp-snb01/micro/aim7/creat-clo
             11125613.20       -15.6%   9391327.60  TOTAL lock_stat.&(&mm->page_table_lock)->rlock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               402323.80       -15.7%    339164.60  lkp-snb01/micro/aim7/creat-clo
               402323.80       -15.7%    339164.60  TOTAL lock_stat.hrtimer_bases.lock#7.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               127933.00       -15.5%    108132.80  lkp-snb01/micro/aim7/creat-clo
               127933.00       -15.5%    108132.80  TOTAL lock_stat.&sig->wait_chldexit.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              5621510.00       -16.9%   4671908.20  lkp-snb01/micro/aim7/creat-clo
               764832.33       -16.2%    641272.67  lkp-snb01/micro/will-it-scale/context_switch1
              6386342.33       -16.8%   5313180.87  TOTAL lock_stat.rcu_node_1.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                77201.60       -15.4%     65317.00  lkp-snb01/micro/aim7/creat-clo
                77201.60       -15.4%     65317.00  TOTAL lock_stat.input_pool.lock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               400496.60       -15.7%    337603.60  lkp-snb01/micro/aim7/creat-clo
               400496.60       -15.7%    337603.60  TOTAL lock_stat.hrtimer_bases.lock#8.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               401552.40       -15.8%    338013.60  lkp-snb01/micro/aim7/creat-clo
               401552.40       -15.8%    338013.60  TOTAL lock_stat.hrtimer_bases.lock#6.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                13537.49       -13.5%     11712.37  lkp-a03/micro/will-it-scale/context_switch1
                84609.17       -17.5%     69772.11  lkp-snb01/micro/aim7/creat-clo
                98146.67       -17.0%     81484.49  TOTAL lock_stat.&(&adapter->stats64_lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               233688.60       -15.3%    198031.40  lkp-snb01/micro/aim7/creat-clo
               233688.60       -15.3%    198031.40  TOTAL lock_stat.&(&p->alloc_lock)->rlock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               443310.40       -15.1%    376416.60  lkp-snb01/micro/aim7/creat-clo
               443310.40       -15.1%    376416.60  TOTAL lock_stat.&(&mm->page_table_lock)->rlock/1.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               593795.00       -15.1%    503979.60  lkp-snb01/micro/aim7/creat-clo
               593795.00       -15.1%    503979.60  TOTAL lock_stat.&anon_vma->rwsem.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2535193.99       -19.1%   2051807.62  lkp-snb01/micro/aim7/creat-clo
               744983.05       +14.4%    851921.95  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
              3280177.05       -11.5%   2903729.57  TOTAL lock_stat.hrtimer_bases.lock#2.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               105604.80       -15.0%     89762.20  lkp-snb01/micro/aim7/creat-clo
               105604.80       -15.0%     89762.20  TOTAL lock_stat.tasklist_lock-W.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              3085299.23       -19.9%   2472174.28  lkp-snb01/micro/aim7/creat-clo
               226210.93       -12.5%    197990.94  lkp-snb01/micro/will-it-scale/context_switch1
              3311510.16       -19.4%   2670165.23  TOTAL lock_stat.rcu_node_1.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                14250.79        -8.7%     13017.15  lkp-ne04/micro/aim7/disk_src
               311935.76       -19.6%    250797.57  lkp-snb01/micro/aim7/creat-clo
               326186.55       -19.1%    263814.72  TOTAL lock_stat.&pipe->wait.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               276021.48       -16.2%    231386.54  lkp-snb01/micro/aim7/creat-clo
               276021.48       -16.2%    231386.54  TOTAL lock_stat.&pipe->mutex/1.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               588073.80       -15.0%    500020.40  lkp-snb01/micro/aim7/creat-clo
               588073.80       -15.0%    500020.40  TOTAL lock_stat.&(&zone->lru_lock)->rlock.acquisitions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
        1559822196978.40       -14.7% 1331253979535.20  lkp-snb01/micro/aim7/creat-clo
           1745070966.14       -16.0% 1466045562.67  nhm-white/micro/aim7/link_test
        1561567267944.54       -14.7% 1332720025097.86  TOTAL lock_stat.&sb->s_type->i_mutex_key#7.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1651376.60       -16.6%   1376845.60  lkp-snb01/micro/aim7/creat-clo
               150409.33       -13.7%    129870.67  lkp-snb01/micro/will-it-scale/context_switch1
              1801785.93       -16.4%   1506716.27  TOTAL lock_stat.rcu_node_1.con-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1666033.20       -16.7%   1388147.60  lkp-snb01/micro/aim7/creat-clo
               151715.00       -13.6%    131038.33  lkp-snb01/micro/will-it-scale/context_switch1
              1817748.20       -16.4%   1519185.93  TOTAL lock_stat.rcu_node_1.contentions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             25730954.73       +16.9%  30071146.45  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
             25730954.73       +16.9%  30071146.45  TOTAL lock_stat.&(&host->lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              9543239.03       +11.3%  10622584.52  lkp-a03/micro/will-it-scale/context_switch1
               953349.58       -21.6%    747350.37  lkp-snb01/micro/aim7/creat-clo
                50657.73        -8.0%     46628.48  nhm-white/micro/aim7/link_test
             10547246.34        +8.2%  11416563.37  TOTAL lock_stat.hrtimer_bases.lock#3.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                81028.80       -14.4%     69344.60  lkp-snb01/micro/aim7/creat-clo
                81028.80       -14.4%     69344.60  TOTAL lock_stat.&(&mm->page_table_lock)->rlock.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2940878.00       -16.3%   2461441.20  lkp-snb01/micro/aim7/creat-clo
               253392.00       -12.7%    221164.00  lkp-snb01/micro/will-it-scale/context_switch1
              3194270.00       -16.0%   2682605.20  TOTAL lock_stat.rcu_node_1.contentions.rcu_process_callbacks

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2785958.60       -16.9%   2316251.00  lkp-snb01/micro/aim7/creat-clo
               373695.00       -11.4%    331174.67  lkp-snb01/micro/will-it-scale/context_switch1
              3159653.60       -16.2%   2647425.67  TOTAL lock_stat.rcu_node_1.acq-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
            324006799.85       -13.3% 280759217.97  lkp-snb01/micro/aim7/creat-clo
            324006799.85       -13.3% 280759217.97  TOTAL lock_stat.&p->pi_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                14043.90       -10.2%     12608.19  lkp-snb01/micro/will-it-scale/context_switch1
                14043.90       -10.2%     12608.19  TOTAL lock_stat.&(&sighand->siglock)->rlock.waittime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                54828.80       +12.6%     61721.02  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
                54828.80       +12.6%     61721.02  TOTAL lock_stat.key#1.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             84623150.80       +11.5%  94396351.40  lkp-snb01/micro/aim7/creat-clo
                94112.40       -11.8%     83014.50  nhm-white/micro/aim7/link_test
             84717263.20       +11.5%  94479365.90  TOTAL lock_stat.&sb->s_type->i_mutex_key#7.con-bounces

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
            304905641.39       -10.9% 271561613.56  lkp-snb01/micro/aim7/creat-clo
            304905641.39       -10.9% 271561613.56  TOTAL lock_stat.&rq->lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1748471.69        -9.1%   1589430.02  nhm-white/micro/aim7/link_test
              1748471.69        -9.1%   1589430.02  TOTAL lock_stat.tick_broadcast_lock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                28466.22        -8.7%     25989.21  lkp-ne04/micro/aim7/disk_src
                28466.22        -8.7%     25989.21  TOTAL lock_stat.&fsnotify_mark_srcu-R.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                61344.03       -10.9%     54658.92  lkp-snb01/micro/aim7/creat-clo
                61344.03       -10.9%     54658.92  TOTAL lock_stat.&(&info->lock)->rlock.holdtime-total

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               164858.67       -11.8%    145424.00  lkp-snb01/micro/will-it-scale/context_switch1
               164858.67       -11.8%    145424.00  TOTAL lock_stat.jiffies_lock.contentions.tick_do_update_jiffies64

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2747025.00        +1.3%   2782041.00  lkp-ne04/micro/aim7/disk_src
             84623150.80       +11.5%  94396351.40  lkp-snb01/micro/aim7/creat-clo
                94112.40       -11.8%     83014.50  nhm-white/micro/aim7/link_test
             87464288.20       +11.2%  97261406.90  TOTAL lock_stat.&sb->s_type->i_mutex_key#7.contentions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              4351540.00        +1.4%   4412361.67  lkp-ne04/micro/aim7/disk_src
            168912799.60       +11.5% 188373367.00  lkp-snb01/micro/aim7/creat-clo
                95270.10       -11.7%     84143.80  nhm-white/micro/aim7/link_test
            173359609.70       +11.3% 192869872.47  TOTAL lock_stat.&sb->s_type->i_mutex_key#7.contentions.do_last

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               220137.70        +5.3%    231837.00  nhm-white/micro/aim7/link_test
               220137.70        +5.3%    231837.00  TOTAL lock_stat.clockevents_lock.contentions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               440275.40        +5.3%    463674.00  nhm-white/micro/aim7/link_test
               440275.40        +5.3%    463674.00  TOTAL lock_stat.clockevents_lock.contentions.clockevents_notify

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             26639051.10        +2.6%  27338413.50  nhm-white/micro/aim7/link_test
             26639051.10        +2.6%  27338413.50  TOTAL lock_stat.&sb->s_type->i_mutex_key#7/1.contentions.do_unlinkat

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1897621.67        +2.3%   1941030.33  lkp-ne04/micro/aim7/disk_src
              1897621.67        +2.3%   1941030.33  TOTAL lock_stat.inode_sb_list_lock.contentions.inode_sb_list_add

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1881919.67        +2.4%   1927713.33  lkp-ne04/micro/aim7/disk_src
              1881919.67        +2.4%   1927713.33  TOTAL lock_stat.inode_sb_list_lock.contentions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              1866217.67        +2.6%   1914396.33  lkp-ne04/micro/aim7/disk_src
              1866217.67        +2.6%   1914396.33  TOTAL lock_stat.inode_sb_list_lock.contentions.evict

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2181043.67        +1.6%   2216495.33  lkp-ne04/micro/aim7/disk_src
              2181043.67        +1.6%   2216495.33  TOTAL lock_stat.&(&sbinfo->stat_lock)->rlock.contentions.shmem_reserve_inode

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             26806992.60        +1.1%  27093012.10  nhm-white/micro/aim7/link_test
             26806992.60        +1.1%  27093012.10  TOTAL lock_stat.&sb->s_type->i_mutex_key#7/1.contentions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2130129.67        +1.5%   2161681.67  lkp-ne04/micro/aim7/disk_src
              2130129.67        +1.5%   2161681.67  TOTAL lock_stat.&(&sbinfo->stat_lock)->rlock.contentions

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2079215.67        +1.3%   2106868.00  lkp-ne04/micro/aim7/disk_src
              2079215.67        +1.3%   2106868.00  TOTAL lock_stat.&(&sbinfo->stat_lock)->rlock.contentions.shmem_free_inode

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
             26811566.20        -0.5%  26684824.90  nhm-white/micro/aim7/link_test
             26811566.20        -0.5%  26684824.90  TOTAL lock_stat.&sb->s_type->i_mutex_key#7/1.contentions.kern_path_create

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                 8039.67       +74.3%     14010.33  lkp-a03/micro/will-it-scale/context_switch1
               123502.00       -40.5%     73428.33  lkp-ne04/micro/aim7/disk_src
               134697.00       -85.3%     19780.40  lkp-snb01/micro/aim7/creat-clo
               582219.33       -61.3%    225266.00  lkp-snb01/micro/will-it-scale/context_switch1
               110090.10       -96.3%      4064.30  nhm-white/micro/aim7/link_test
                 6361.80       -92.2%       493.60  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
                 6077.40       -91.8%       497.80  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
               970987.30       -65.2%    337540.77  TOTAL vmstat.system.in

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   67.60       -53.1%        31.69  lkp-a03/micro/will-it-scale/context_switch1
                   17.85       +18.7%        21.18  lkp-ne04/micro/aim7/disk_src
                   23.27       -15.6%        19.63  lkp-snb01/micro/will-it-scale/context_switch1
                   17.88        +2.7%        18.36  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
                  126.60       -28.2%        90.87  TOTAL boottime.boot

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
              2570860.67      +175.5%   7081746.67  lkp-a03/micro/will-it-scale/context_switch1
            105632123.40        -2.4% 103102368.40  lkp-snb01/micro/aim7/creat-clo
            156820191.33       +12.2% 175913775.33  lkp-snb01/micro/will-it-scale/context_switch1
              3575725.60        -3.9%   3437307.20  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
              3455612.80        -2.2%   3378685.80  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
            272054513.80        +7.7% 292913883.40  TOTAL time.voluntary_context_switches

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  189.98       -52.1%        91.10  lkp-a03/micro/will-it-scale/context_switch1
                  263.17       +18.9%       312.84  lkp-ne04/micro/aim7/disk_src
                  687.33       -18.6%       559.44  lkp-snb01/micro/will-it-scale/context_switch1
                    2.68       +14.0%         3.05  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
                  284.28        +0.6%       285.85  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
                 1427.45       -12.3%      1252.28  TOTAL boottime.idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   46.57       -52.5%        22.11  lkp-a03/micro/will-it-scale/context_switch1
                   17.67        -7.9%        16.27  lkp-snb01/micro/will-it-scale/context_switch1
                    8.30        +5.6%         8.77  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
                    7.87        +1.3%         7.97  nhm-white/micro/aim7/link_test
                   80.41       -31.5%        55.12  TOTAL boottime.dhcp

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                37396.33      +181.9%    105405.67  lkp-a03/micro/will-it-scale/context_switch1
               259541.33        +3.0%    267244.67  lkp-ne04/micro/aim7/disk_src
               259371.40       +16.5%    302096.20  lkp-snb01/micro/aim7/creat-clo
              2467674.67       +11.4%   2748154.33  lkp-snb01/micro/will-it-scale/context_switch1
                11440.00        +1.4%     11604.80  lkp-t410/micro/netperf/120s-200%-TCP_CRR
                33085.20        +1.3%     33517.80  lkp-t410/micro/netperf/120s-200%-TCP_RR
                22220.20        +3.7%     23046.60  lkp-t410/micro/netperf/120s-200%-TCP_SENDFILE
               217332.80        +4.7%    227573.50  nhm-white/micro/aim7/link_test
                12201.60        -3.8%     11742.00  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
                11821.60        -2.0%     11581.00  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
              3332085.13       +12.3%   3741966.57  TOTAL vmstat.system.cs

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   27.98        +1.4%        28.36  lkp-ne04/micro/aim7/disk_src
                  192.84       -12.1%       169.51  lkp-snb01/micro/aim7/creat-clo
                    2.49       +24.1%         3.09  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
                  223.31       -10.0%       200.96  TOTAL time.user_time

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                    3.36       -19.4%         2.71  lkp-a03/micro/will-it-scale/context_switch1
                    2.74        +4.2%         2.85  lkp-ne04/micro/aim7/disk_src
                    1.64        -3.0%         1.59  lkp-snb01/micro/will-it-scale/context_switch1
                    3.28        +4.9%         3.44  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
                    2.75        +5.9%         2.91  lkp-t410/micro/netperf/120s-200%-TCP_SENDFILE
                    1.67        +6.8%         1.78  nhm-white/micro/aim7/link_test
                   15.43        -1.0%        15.27  TOTAL iostat.cpu.user

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  309.96        -0.4%       308.71  lkp-a03/micro/will-it-scale/context_switch1
                   52.91        -2.4%        51.62  lkp-ne04/micro/aim7/disk_src
                  817.04       -16.3%       683.99  lkp-snb01/micro/aim7/creat-clo
                  316.42        -0.3%       315.55  lkp-snb01/micro/will-it-scale/context_switch1
                  257.19        -4.4%       245.81  nhm-white/micro/aim7/link_test
                 1753.51        -8.4%      1605.68  TOTAL time.elapsed_time

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   73.03        -1.5%        71.91  lkp-a03/micro/will-it-scale/context_switch1
                   12.48       +11.0%        13.85  lkp-snb01/micro/aim7/creat-clo
                   55.62        +3.2%        57.42  lkp-snb01/micro/will-it-scale/context_switch1
                   95.30        -0.2%        95.14  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
                   95.83        -0.2%        95.65  lkp-t410/micro/netperf/120s-200%-TCP_SENDFILE
                   17.28        +2.6%        17.74  nhm-white/micro/aim7/link_test
                    3.86        -8.7%         3.52  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
                  353.41        +0.5%       355.24  TOTAL iostat.cpu.system

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   23.00        +8.7%        25.00  lkp-a03/micro/will-it-scale/context_switch1
                   86.40        -1.6%        85.00  lkp-snb01/micro/aim7/creat-clo
                   42.00        -4.8%        40.00  lkp-snb01/micro/will-it-scale/context_switch1
                   80.90        -1.1%        80.00  nhm-white/micro/aim7/link_test
                  232.30        -1.0%       230.00  TOTAL vmstat.cpu.id

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   94.33        +2.8%        97.00  lkp-a03/micro/will-it-scale/context_switch1
                  433.60        +9.7%       475.60  lkp-snb01/micro/aim7/creat-clo
                  634.00        +0.4%       636.33  lkp-snb01/micro/will-it-scale/context_switch1
                  161.60        +1.3%       163.70  nhm-white/micro/aim7/link_test
                 1323.53        +3.7%      1372.63  TOTAL time.percent_of_cpu_this_job_got

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                  284.38        +2.5%       291.44  lkp-a03/micro/will-it-scale/context_switch1
                  320.73        -2.3%       313.29  lkp-ne04/micro/aim7/disk_src
                 3355.50        -8.0%      3086.35  lkp-snb01/micro/aim7/creat-clo
                 1945.23        +0.1%      1947.45  lkp-snb01/micro/will-it-scale/context_switch1
                  375.83        -3.4%       362.89  nhm-white/micro/aim7/link_test
                  101.37        +4.8%       106.21  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
                   69.27        +0.8%        69.81  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
                 6452.31        -4.3%      6177.44  TOTAL time.system_time

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   23.61        +7.4%        25.36  lkp-a03/micro/will-it-scale/context_switch1
                   86.79        -1.6%        85.38  lkp-snb01/micro/aim7/creat-clo
                   42.74        -4.1%        41.00  lkp-snb01/micro/will-it-scale/context_switch1
                   81.04        -0.7%        80.47  nhm-white/micro/aim7/link_test
                   50.78        +2.3%        51.94  snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
                  284.97        -0.3%       284.15  TOTAL iostat.cpu.idle

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
                   73.00        -1.4%        72.00  lkp-a03/micro/will-it-scale/context_switch1
                   55.00        +3.6%        57.00  lkp-snb01/micro/will-it-scale/context_switch1
                  128.00        +0.8%       129.00  TOTAL vmstat.cpu.sy

    3150398626466c6cc626      ea8117478918a4734586  
------------------------  ------------------------  
               476599.33        +0.1%    477275.67  lkp-ne04/micro/aim7/disk_src
               476599.33        +0.1%    477275.67  TOTAL time.minor_page_faults

