Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbaFCPo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:44:56 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:38481 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172AbaFCPoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:44:55 -0400
Date: Tue, 3 Jun 2014 07:17:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jet Chen <jet.chen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [rcu] 5057f55e543: -23.5% qperf.udp.recv_bw
Message-ID: <20140603141720.GN22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <538D9EA9.6070406@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538D9EA9.6070406@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060315-0928-0000-0000-0000026E07BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 06:08:41PM +0800, Jet Chen wrote:
> Hi Paul,
> 
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/fixes
> commit 5057f55e543b7859cfd26bc281291795eac93f8a ("rcu: Bind RCU grace-period kthreads if NO_HZ_FULL")

My guess would be that some of these workloads generated enough callbacks
that binding all the rcuo callback-offloading kthreads to CPU 0 resulted
in a bottleneck.  If that was the case, CPU 0 would often hit 100%
CPU utilization, and there would be more wait time on other CPUs because
callback execution was delayed.

Does that match what you are seeing?

							Thanx, Paul

> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>  2.127e+09 ~ 0%     -23.5%  1.628e+09 ~ 4%  bens/qperf/600s
>  2.127e+09 ~ 0%     -23.5%  1.628e+09 ~ 4%  TOTAL qperf.udp.recv_bw
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>  2.128e+09 ~ 0%     -23.3%  1.633e+09 ~ 4%  bens/qperf/600s
>  2.128e+09 ~ 0%     -23.3%  1.633e+09 ~ 4%  TOTAL qperf.udp.send_bw
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>  2.101e+10 ~ 2%     -18.7%  1.707e+10 ~ 2%  bens/iperf/300s-tcp
>  2.101e+10 ~ 2%     -18.7%  1.707e+10 ~ 2%  TOTAL iperf.tcp.sender.bps
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>  2.101e+10 ~ 2%     -18.7%  1.707e+10 ~ 2%  bens/iperf/300s-tcp
>  2.101e+10 ~ 2%     -18.7%  1.707e+10 ~ 2%  TOTAL iperf.tcp.receiver.bps
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>  1.331e+09 ~ 2%      -5.8%  1.255e+09 ~ 2%  bens/qperf/600s
>    2.4e+09 ~ 6%     -30.4%  1.671e+09 ~12%  brickland3/qperf/600s
>  2.384e+09 ~ 7%     -12.1%  2.096e+09 ~ 3%  lkp-sb03/qperf/600s
>  6.115e+09 ~ 5%     -17.9%  5.022e+09 ~ 6%  TOTAL qperf.sctp.bw
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>   2.83e+09 ~ 1%     -12.5%  2.476e+09 ~ 3%  bens/qperf/600s
>   2.83e+09 ~ 1%     -12.5%  2.476e+09 ~ 3%  TOTAL qperf.tcp.bw
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>  2.272e+08 ~ 1%     -13.3%   1.97e+08 ~ 2%  bens/qperf/600s
>  2.272e+08 ~ 1%     -13.3%   1.97e+08 ~ 2%  TOTAL proc-vmstat.pgalloc_dma32
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>      53062 ~ 2%     -35.1%      34464 ~ 3%  bens/qperf/600s
>     109531 ~13%     +46.9%     160928 ~ 5%  brickland3/qperf/600s
>      67902 ~ 1%     +13.8%      77302 ~ 3%  lkp-sb03/qperf/600s
>     230496 ~ 7%     +18.3%     272694 ~ 4%  TOTAL softirqs.RCU
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>      80344 ~ 1%     -26.2%      59325 ~ 2%  bens/qperf/600s
>      80344 ~ 1%     -26.2%      59325 ~ 2%  TOTAL softirqs.SCHED
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>       1036 ~ 4%     -17.6%        853 ~ 4%  brickland3/qperf/600s
>       1036 ~ 4%     -17.6%        853 ~ 4%  TOTAL proc-vmstat.nr_page_table_pages
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>      48.12 ~ 0%     -11.7%      42.46 ~ 6%  brickland3/qperf/600s
>      48.12 ~ 0%     -11.7%      42.46 ~ 6%  TOTAL turbostat.%pc2
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>   74689352 ~ 1%     -13.3%   64771743 ~ 2%  bens/qperf/600s
>   74689352 ~ 1%     -13.3%   64771743 ~ 2%  TOTAL proc-vmstat.pgalloc_normal
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>  3.019e+08 ~ 1%     -13.3%  2.618e+08 ~ 2%  bens/qperf/600s
>  3.019e+08 ~ 1%     -13.3%  2.618e+08 ~ 2%  TOTAL proc-vmstat.pgfree
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>   23538414 ~ 0%     -12.9%   20506157 ~ 2%  bens/qperf/600s
>   23538414 ~ 0%     -12.9%   20506157 ~ 2%  TOTAL proc-vmstat.numa_local
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>   23538414 ~ 0%     -12.9%   20506157 ~ 2%  bens/qperf/600s
>   23538414 ~ 0%     -12.9%   20506157 ~ 2%  TOTAL proc-vmstat.numa_hit
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>      12789 ~ 1%     -10.9%      11391 ~ 2%  bens/qperf/600s
>      12789 ~ 1%     -10.9%      11391 ~ 2%  TOTAL softirqs.HRTIMER
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>     481253 ~ 0%      -8.9%     438624 ~ 0%  bens/qperf/600s
>     481253 ~ 0%      -8.9%     438624 ~ 0%  TOTAL softirqs.TIMER
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>       1297 ~33%    +565.9%       8640 ~ 7%  bens/iperf/300s-tcp
>       2788 ~ 3%    +588.8%      19204 ~ 4%  bens/qperf/600s
>       1191 ~ 5%   +1200.9%      15493 ~ 4%  brickland3/qperf/600s
>       1135 ~26%   +1195.9%      14709 ~ 4%  lkp-sb03/qperf/600s
>       6411 ~13%    +805.3%      58047 ~ 4%  TOTAL time.involuntary_context_switches
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>      72398 ~ 1%      -5.4%      68503 ~ 0%  bens/qperf/600s
>       8789 ~ 4%     +22.3%      10749 ~15%  lkp-sb03/qperf/600s
>      81187 ~ 1%      -2.4%      79253 ~ 2%  TOTAL vmstat.system.in
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>     141174 ~ 1%      -5.4%     133551 ~ 0%  bens/qperf/600s
>     143982 ~ 1%      -4.4%     137600 ~ 0%  brickland3/qperf/600s
>     285156 ~ 1%      -4.9%     271152 ~ 0%  TOTAL vmstat.system.cs
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>   42351859 ~ 0%      -5.3%   40114932 ~ 0%  bens/qperf/600s
>   43015383 ~ 1%      -4.4%   41143092 ~ 0%  brickland3/qperf/600s
>   85367242 ~ 1%      -4.8%   81258025 ~ 0%  TOTAL time.voluntary_context_switches
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>        146 ~ 0%      -2.2%        143 ~ 0%  bens/qperf/600s
>        147 ~ 1%      -4.8%        140 ~ 1%  brickland3/qperf/600s
>        293 ~ 0%      -3.5%        283 ~ 0%  TOTAL time.percent_of_cpu_this_job_got
> 
> 71a9b26963f8c2d  5057f55e543b7859cfd26bc28
> ---------------  -------------------------
>        872 ~ 0%      -2.3%        853 ~ 0%  bens/qperf/600s
>        874 ~ 1%      -4.6%        834 ~ 1%  brickland3/qperf/600s
>       1747 ~ 0%      -3.4%       1687 ~ 0%  TOTAL time.system_time
> 
> 
> Legend:
> 	~XX%    - stddev percent
> 	[+-]XX% - change percent
> 
> 
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> Thanks,
> Jet
> 
> 

> echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
> ./runtest.py unlink1 32 1 2 3 4

