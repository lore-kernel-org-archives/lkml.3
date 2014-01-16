Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaAPBXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:23:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:53167 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaAPBXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:23:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,666,1384329600"; 
   d="scan'208";a="459547466"
Date: Thu, 16 Jan 2014 09:23:01 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        lkp@linux.intel.com
Subject: Re: [sched] 73628fba4: +69% context switches
Message-ID: <20140116012301.GA2535@localhost>
References: <20140111101956.GA11150@localhost>
 <52D3804A.8060700@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D3804A.8060700@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 01:57:30PM +0800, Alex Shi wrote:
> On 01/11/2014 06:19 PM, Fengguang Wu wrote:
> > Alex,
> > 
> > FYI, we find much increased interrupts and context switches introduced
> > by commit 73628fba4 ("sched: unify imbalance bias for target group")
> > in your noload branch:
> 
> Many thanks for the generous and quick testing! :)
> 
> few questions for the results and give a testing patch for try. it also push on github. 
> 
> What's about the aim7 shell_rtns_1 and shared throughput?

The throughputs remain the same.  We only report changed numbers.

> > 7bea8c18805a5f1  73628fba451ae72221b155696  
> > ---------------  -------------------------  
> >      14979 ~ 4%   +1304.8%     210434 ~ 1%  lkp-ne04/micro/aim7/shell_rtns_1
> >       2748 ~ 5%    +977.4%      29607 ~ 0%  nhm-white/micro/aim7/shared
> >      17727        +1254.1%     240041       TOTAL interrupts.RES
> 
> RES interrupt increased about 200,000, but vmstat's interrupt
> increased a little. guess the vmstat data is per seconds, right? If

Yes.

> so, it is better give how long time the vmstat running.

vmstat runs throughout the aim7 test run.

> The same problem on the time.involuntary_context_switches and vmstat cs.

ditto.

> According to involuntary CS definition in time, RES interrupt will cause involuntary CS. but here 29607 RES of aim7/shared cause 233218 time inv CS, does sth I missed or the data is incorrect?
> 
> > 
> > 7bea8c18805a5f1  73628fba451ae72221b155696  
> > ---------------  -------------------------  
> >       3617 ~ 0%     +69.2%       6118 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
> >       3617          +69.2%       6118       TOTAL vmstat.system.in
> > 
> > 7bea8c18805a5f1  73628fba451ae72221b155696  
> > ---------------  -------------------------  
> >     132746 ~ 0%     +69.0%     224346 ~ 1%  lkp-ne04/micro/aim7/shell_rtns_1
> >     220038 ~ 0%      +6.0%     233218 ~ 0%  nhm-white/micro/aim7/shared
> >     352785          +29.7%     457564       TOTAL time.involuntary_context_switches
> > 
> > 7bea8c18805a5f1  73628fba451ae72221b155696  
> > ---------------  -------------------------  
> >    1424581 ~ 0%      +8.6%    1546786 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
> >    1424581           +8.6%    1546786       TOTAL time.voluntary_context_switches
> > 
> > 7bea8c18805a5f1  73628fba451ae72221b155696  
> > ---------------  -------------------------  
> >      20982 ~ 0%     +12.5%      23599 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
> >       6005 ~ 0%      +4.2%       6256 ~ 0%  nhm-white/micro/aim7/shared
> >      26988          +10.6%      29856       TOTAL vmstat.system.cs
> > 
> >                                   vmstat.system.cs
> > 
> 
> commit c5a8778a132cfa882609fbccb4ee6542eac9866d
> Author: Alex Shi <alex.shi@linaro.org>
> Date:   Mon Jan 13 13:54:30 2014 +0800
> 
>     more bias towards local cpu group


In your rebased tree, there are still much increased interrupts and
context switches:

Comparing 91dd08bd65052b483f96f75ab ("sched: more bias towards local
cpu group") with upstream:

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
        48 ~13%    +485.4%        281 ~ 1%  lkp-ne04/micro/aim7/shell_rtns_1
        48         +485.4%        281       TOTAL numa-vmstat.node1.nr_shmem

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     10142 ~ 4%   +2737.8%     287830 ~ 2%  lkp-ne04/micro/aim7/shell_rtns_1
      1349 ~16%   +1479.3%      21319 ~ 4%  nhm-white/micro/aim7/dbase
     11492        +2590.0%     309149       TOTAL interrupts.RES

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
       194 ~12%    +472.9%       1115 ~ 2%  lkp-ne04/micro/aim7/shell_rtns_1
       194         +472.9%       1115       TOTAL numa-meminfo.node1.Shmem

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
    118634 ~ 2%     -73.0%      32081 ~ 0%  nhm-white/micro/aim7/dbase
    118634          -73.0%      32081       TOTAL interrupts.IWI

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
       327 ~ 1%     -71.0%         95 ~ 4%  lkp-ne04/micro/aim7/shell_rtns_1
       327          -71.0%         95       TOTAL numa-vmstat.node0.nr_shmem

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
      1312 ~ 1%     -70.8%        383 ~ 4%  lkp-ne04/micro/aim7/shell_rtns_1
      1312          -70.8%        383       TOTAL numa-meminfo.node0.Shmem

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     11786 ~ 9%    +141.4%      28451 ~ 3%  lkp-ne04/micro/aim7/shell_rtns_1
     11786         +141.4%      28451       TOTAL sched_debug.cfs_rq[10]:/.min_vruntime

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     30715 ~ 0%     -50.4%      15249 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
     30715          -50.4%      15249       TOTAL numa-meminfo.node0.KernelStack

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
      3823 ~ 0%     -50.1%       1908 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
      3823          -50.1%       1908       TOTAL numa-vmstat.node0.nr_kernel_stack

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     22270 ~ 3%     +91.0%      42527 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
     22270          +91.0%      42527       TOTAL sched_debug.cfs_rq[10]:/.blocked_load_avg

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
      1967 ~ 0%     +90.5%       3749 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
      1967          +90.5%       3749       TOTAL numa-vmstat.node1.nr_kernel_stack

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     15819 ~ 1%     +89.1%      29910 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
     15819          +89.1%      29910       TOTAL numa-meminfo.node1.KernelStack

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     41191 ~ 4%     +75.7%      72359 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
     41191          +75.7%      72359       TOTAL numa-meminfo.node1.SUnreclaim

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     10264 ~ 3%     +76.5%      18121 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
     10264          +76.5%      18121       TOTAL numa-vmstat.node1.nr_slab_unreclaimable

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     17782 ~ 2%     -40.0%      10670 ~ 1%  lkp-ne04/micro/aim7/shell_rtns_1
     17782          -40.0%      10670       TOTAL numa-vmstat.node0.nr_slab_unreclaimable

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     71301 ~ 1%     -40.0%      42766 ~ 1%  lkp-ne04/micro/aim7/shell_rtns_1
     71301          -40.0%      42766       TOTAL numa-meminfo.node0.SUnreclaim

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     59103 ~ 3%     +49.8%      88528 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
     59103          +49.8%      88528       TOTAL numa-meminfo.node1.Slab

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     89141 ~ 1%     -30.2%      62248 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
     89141          -30.2%      62248       TOTAL numa-meminfo.node0.Slab

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     38773 ~ 2%     +29.7%      50304 ~ 1%  lkp-ne04/micro/aim7/shell_rtns_1
     38773          +29.7%      50304       TOTAL sched_debug.cpu#10.nr_switches

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     35293 ~ 1%     +24.8%      44029 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
     35293          +24.8%      44029       TOTAL sched_debug.cpu#15.nr_switches

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     35772 ~ 1%     +23.9%      44317 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
     35772          +23.9%      44317       TOTAL sched_debug.cpu#14.nr_switches

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
    946595 ~ 0%     -14.2%     812568 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
    946595          -14.2%     812568       TOTAL numa-meminfo.node0.MemUsed

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
      5966 ~ 0%     +11.1%       6627 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
      5966          +11.1%       6627       TOTAL slabinfo.mm_struct.active_objs

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
    131624 ~ 0%     +99.0%     261914 ~ 1%  lkp-ne04/micro/aim7/shell_rtns_1
    131624          +99.0%     261914       TOTAL time.involuntary_context_switches

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
      3542 ~ 0%    +104.2%       7233 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
      2407 ~ 0%     -10.4%       2156 ~ 0%  nhm-white/micro/aim7/dbase
      5950          +57.8%       9389       TOTAL vmstat.system.in

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
     20993 ~ 0%     +17.1%      24588 ~ 1%  lkp-ne04/micro/aim7/shell_rtns_1
      2166 ~ 0%      +7.8%       2335 ~ 0%  nhm-white/micro/aim7/dbase
     23159          +16.3%      26923       TOTAL vmstat.system.cs

      v3.13-rc8  91dd08bd65052b483f96f75ab
---------------  -------------------------
   1423954 ~ 0%     +12.2%    1598169 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
   1423954          +12.2%    1598169       TOTAL time.voluntary_context_switches

Comparing e69bd3470ef8ab10bcb9d6ad4 ("sched: unify imbalance bias for
target group") with its parent:

64651525f152c05  e69bd3470ef8ab10bcb9d6ad4  
---------------  -------------------------  
     15604 ~ 3%   +1268.6%     213573 ~ 1%  lkp-ne04/micro/aim7/shell_rtns_1
      1532 ~16%    +647.7%      11455 ~ 6%  nhm-white/micro/aim7/dbase
     17136        +1213.1%     225029       TOTAL interrupts.RES

64651525f152c05  e69bd3470ef8ab10bcb9d6ad4  
---------------  -------------------------  
    107861 ~ 1%     -63.0%      39865 ~ 2%  nhm-white/micro/aim7/dbase
    107861          -63.0%      39865       TOTAL interrupts.IWI

64651525f152c05  e69bd3470ef8ab10bcb9d6ad4  
---------------  -------------------------  
    133536 ~ 0%     +69.4%     226257 ~ 1%  lkp-ne04/micro/aim7/shell_rtns_1
    133536          +69.4%     226257       TOTAL time.involuntary_context_switches

64651525f152c05  e69bd3470ef8ab10bcb9d6ad4  
---------------  -------------------------  
      2359 ~ 0%      -9.5%       2134 ~ 0%  nhm-white/micro/aim7/dbase
      2359           -9.5%       2134       TOTAL vmstat.system.in

64651525f152c05  e69bd3470ef8ab10bcb9d6ad4  
---------------  -------------------------  
   1431362 ~ 0%      +8.5%    1552345 ~ 0%  lkp-ne04/micro/aim7/shell_rtns_1
   1431362           +8.5%    1552345       TOTAL time.voluntary_context_switches

64651525f152c05  e69bd3470ef8ab10bcb9d6ad4  
---------------  -------------------------  
      2162 ~ 0%      +5.2%       2274 ~ 0%  nhm-white/micro/aim7/dbase
      2162           +5.2%       2274       TOTAL vmstat.system.cs

