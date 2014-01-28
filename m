Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbaA1C7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 21:59:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:7366 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbaA1C7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 21:59:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,733,1384329600"; 
   d="scan'208";a="465718459"
Date: Tue, 28 Jan 2014 10:59:15 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [rcu] c0f4dfd4f9: -65% softirqs.RCU
Message-ID: <20140128025915.GB15282@localhost>
References: <20140119121608.GB2859@localhost>
 <20140119231114.GE10038@linux.vnet.ibm.com>
 <20140120122912.GA18137@localhost>
 <20140121044100.GS10038@linux.vnet.ibm.com>
 <20140124111130.GA24254@localhost>
 <20140127170602.GO9012@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140127170602.GO9012@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 09:06:02AM -0800, Paul E. McKenney wrote:
> On Fri, Jan 24, 2014 at 07:11:30PM +0800, Fengguang Wu wrote:
> > On Mon, Jan 20, 2014 at 08:41:00PM -0800, Paul E. McKenney wrote:
> > > On Mon, Jan 20, 2014 at 08:29:12PM +0800, Fengguang Wu wrote:
> > > > On Sun, Jan 19, 2014 at 03:11:14PM -0800, Paul E. McKenney wrote:
> > > > > On Sun, Jan 19, 2014 at 08:16:08PM +0800, Fengguang Wu wrote:
> > > > > > Hi Paul,
> > > > > > 
> > > > > > Just FYI, we noticed the following changes (which looks good) on old commit
> > > > > > c0f4dfd4f9 ("rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks") 
> > > > > > in test case dd-write/4HDD-JBOD-cfq-btrfs-1dd:
> > > > > > 
> > > > > > b11cc5 (parent)  c0f4dfd4f90f1667d234d21f1  
> > > > > > ---------------  -------------------------  
> > > > > >     213757 ~ 4%     -65.4%      73929 ~ 3%  softirqs.RCU
> > > > > >      21193 ~ 5%     -36.5%      13451 ~ 4%  softirqs.SCHED
> > > > > >       2036 ~ 4%     -59.4%        825 ~ 3%  vmstat.system.cs
> > > > > >    1304520 ~ 4%     -59.2%     532451 ~ 3%  perf-stat.context-switches
> > > > > >      95685 ~ 4%     -44.0%      53598 ~ 2%  perf-stat.cpu-migrations
> > > > > 
> > > > > Glad it helped!  IIRC, this same commit increased latencies due to
> > > > > synchronize_rcu() latency increasing.  So this is the good side of
> > > > > that other not-so-good result.  ;-)
> > > > 
> > > > If you care it and there is a low cost way for user space to get that
> > > > synchronize_rcu() latency, I'd be eager to collect it in my tests. :)
> > > 
> > > Would a kernel module that measured the latency be OK, or do you need
> > > some system call that is exposed to synchronize_rcu() latency?
> > 
> > Kernel module should be good enough for me. Perhaps something like
> > kernel/latencytop.c?
> 
> So you are looking for something that measures synchronize_rcu() latency
> for the synchronize_rcu() calls that occur naturally in the kernel, rather
> than having a focused microbenchmark?

Yes, then I can measure the synchronize_rcu() latency in all the tests
I run, including the possible focused microbenchmarks on RCU. :)

btw, I've measured the overheads of CONFIG_SCHEDSTATS which is
required for running latencytop, and it seems acceptable:

     x86_64-lkp  x86_64-lkp+CONFIG_SCHEDST
---------------  -------------------------
    174190 ~ 0%      -4.1%     167062 ~ 0%  lkp-snb01/micro/hackbench/1600%-threads-pipe
    158995 ~ 1%      -3.1%     154094 ~ 0%  lkp-snb01/micro/hackbench/1600%-threads-socket
    333186 ~ 1%      -3.6%     321156 ~ 0%  TOTAL hackbench.throughput

     x86_64-lkp  x86_64-lkp+CONFIG_SCHEDST
---------------  -------------------------
       278 ~ 0%      -3.4%        269 ~ 0%  lkp-a04/micro/netperf/120s-200%-TCP_MAERTS
       632 ~ 1%      -2.9%        613 ~ 1%  lkp-a04/micro/netperf/120s-200%-TCP_SENDFILE
       280 ~ 1%      -3.7%        270 ~ 0%  lkp-a04/micro/netperf/120s-200%-TCP_STREAM
      1191 ~ 1%      -3.2%       1153 ~ 1%  TOTAL netperf.Throughput_Mbps

     x86_64-lkp  x86_64-lkp+CONFIG_SCHEDST
---------------  -------------------------
       386 ~ 0%      -2.1%        378 ~ 0%  lkp-a04/micro/netperf/120s-200%-TCP_CRR
      2057 ~ 0%      -3.6%       1982 ~ 0%  lkp-a04/micro/netperf/120s-200%-TCP_RR
      2518 ~ 0%      -1.4%       2482 ~ 0%  lkp-a04/micro/netperf/120s-200%-UDP_RR
      4962 ~ 0%      -2.4%       4843 ~ 0%  TOTAL netperf.Throughput_tps

     x86_64-lkp  x86_64-lkp+CONFIG_SCHEDST
---------------  -------------------------
  37316711 ~ 0%      -0.9%   36976450 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
  37316711 ~ 0%      -0.9%   36976450 ~ 0%  TOTAL oltp.rw_requets
                    
     x86_64-lkp  x86_64-lkp+CONFIG_SCHEDST
---------------  -------------------------
   2665479 ~ 0%      -0.9%    2641175 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
   2665479 ~ 0%      -0.9%    2641175 ~ 0%  TOTAL oltp.transactions
                    
     x86_64-lkp  x86_64-lkp+CONFIG_SCHEDST
---------------  -------------------------
     68.50 ~ 0%      -0.2%      68.39 ~ 0%  xps2/micro/pigz/100%
     68.50 ~ 0%      -0.2%      68.39 ~ 0%  TOTAL pigz.throughput

Thanks,
Fengguang
