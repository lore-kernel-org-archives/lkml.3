Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3LURZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 12:25:06 -0500
Received: from plane.gmane.org ([80.91.229.3]:41887 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab3LURZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 12:25:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Muli Baron <muli.baron@gmail.com>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
Date: Sat, 21 Dec 2013 19:21:13 +0200
Message-ID: <52B5CE09.5030908@gmail.com>
References: <1383228427.5272.36.camel@marge.simpson.net>	 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>	 <1383794799.5441.16.camel@marge.simpson.net>	 <1383798668.5441.25.camel@marge.simpson.net>	 <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>	 <20131220154146.GA18672@breakpoint.cc> <1387617104.30230.7.camel@marge.simpson.net>
Reply-To: muli.baron@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 109.65.115.166
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
In-Reply-To: <1387617104.30230.7.camel@marge.simpson.net>
Cc: linux-rt-users@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/12/2013 11:11, Mike Galbraith wrote:
>
> Works, modulo noisy workqueues.
>
> rtbox:~ # sleep 35 && killall pert& cgexec -g cpuset:rtcpus taskset -c 3 pert 5
> [1] 5660
> 2400.05 MHZ CPU
> perturbation threshold 0.018 usecs.
> pert/s:       33 >15.75us:        2 min:  0.04 max: 24.14 avg:  2.51 sum/s:    84us overhead: 0.01%
> pert/s:       35 >15.54us:        3 min:  0.04 max: 24.89 avg:  2.39 sum/s:    84us overhead: 0.01%
> pert/s:       30 >15.27us:        2 min:  0.04 max: 23.03 avg:  2.64 sum/s:    80us overhead: 0.01%
> pert/s:       34 >15.12us:        3 min:  0.04 max: 25.03 avg:  2.51 sum/s:    86us overhead: 0.01%
> pert/s:       31 >14.93us:        2 min:  0.04 max: 23.86 avg:  2.60 sum/s:    83us overhead: 0.01%
> Terminated
>

I can confirm this works for me as well, but I have noticed some strange behavior under certain 
conditions.

If I run a process with SCHED_OTHER priority and pin it to a specific CPU like Mike did then all is 
well and everything functions as expected. If however I mask the execution of ksoftirqd by running 
that process as SCHED_FIFO for too long (say a few seconds) and later I free the CPU, then what I'm 
seeing is that the tick is never turned off again even though the CPU is completely idle, and 
running that same SCHED_OTHER process from before now gets 1K timer interrupts/s. I suspect this has 
something to do with the timer softirq never running on that CPU again as a result of this patch.

Following is trace output during this condition for two consecutive ticks, when the CPU is 
completely idle (shielded by isolcpus, HZ=1000):

<idle>-0     [003] d..h3..   355.620760: hrtimer_cancel: hrtimer=ffff88011fd8b720
<idle>-0     [003] d..h2..   355.620760: hrtimer_expire_entry: hrtimer=ffff88011fd8b720 
function=tick_sched_timer now=355487000349
<idle>-0     [003] d..h2..   355.620761: hrtimer_expire_exit: hrtimer=ffff88011fd8b720
<idle>-0     [003] d..h3..   355.620761: hrtimer_start: hrtimer=ffff88011fd8b720 
function=tick_sched_timer expires=355488000000 softexpires=355488000000
<idle>-0     [003] ....2..   355.620762: cpu_idle: state=4294967295 cpu_id=3
<idle>-0     [003] d...2..   355.620762: cpu_idle: state=1 cpu_id=3

<idle>-0     [003] d..h3..   355.621760: hrtimer_cancel: hrtimer=ffff88011fd8b720
<idle>-0     [003] d..h2..   355.621761: hrtimer_expire_entry: hrtimer=ffff88011fd8b720 
function=tick_sched_timer now=355488000330
<idle>-0     [003] d..h2..   355.621761: hrtimer_expire_exit: hrtimer=ffff88011fd8b720
<idle>-0     [003] d..h3..   355.621761: hrtimer_start: hrtimer=ffff88011fd8b720 
function=tick_sched_timer expires=355489000000 softexpires=355489000000
<idle>-0     [003] ....2..   355.621762: cpu_idle: state=4294967295 cpu_id=3
<idle>-0     [003] d...2..   355.621762: cpu_idle: state=1 cpu_id=3

--Muli


