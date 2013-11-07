Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3KGNHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:07:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63364 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3KGNHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:07:22 -0500
Message-ID: <1383829634.5441.146.camel@marge.simpson.net>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
From: Mike Galbraith <bitbucket@online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 07 Nov 2013 14:07:14 +0100
In-Reply-To: <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
References: <1383228427.5272.36.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
	 <1383794799.5441.16.camel@marge.simpson.net>
	 <1383798668.5441.25.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:LxgN8qZwH8x/KgdtQz40GN+w7rNSukEjIqJNXavGwb1
 /E1iePpo+xWd3MmMWggxfpDvvHrxFyCSgsf0vuFiTYPG2Ys07+
 sv/MZtQWW/x9o1/njg5lKuy+khHXL1kIbE27PTzIIyl1ol2/Ww
 wPyPUGWxDpuicNULNVgH1jLb2dXnEiWrh2ynlICsahimme20oV
 ZgsLPHiu7mC9BpKwo8lKfXufyCWiFfo7103ZFBk8ZC2B++AnKi
 rs6wR7/mb7Gt5xIjlJ4zC+ZvBEdbh/Erz2rlBuWV5LXxsV3OLJ
 x7jlVbRzLzYSlw0vodB7tz1ZBM9/4S4t54bNXWSR8Fkhatmoa0
 uN9xl/49cX0kSKPkSk1NzAfQiD69p0O8ZQcqXtDngQ3anyniB2
 kPhNEuO6HgRNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-07 at 12:21 +0100, Thomas Gleixner wrote: 
> Mike,
> 
> On Thu, 7 Nov 2013, Mike Galbraith wrote:
> 
> > On Thu, 2013-11-07 at 04:26 +0100, Mike Galbraith wrote: 
> > > On Wed, 2013-11-06 at 18:49 +0100, Thomas Gleixner wrote: 
> > 
> > > > I bet you are trying to work around some of the side effects of the
> > > > occasional tick which is still necessary despite of full nohz, right?
> > > 
> > > Nope, I wanted to check out cost of nohz_full for rt, and found that it
> > > doesn't work at all instead, looked, and found that the sole running
> > > task has just awakened ksoftirqd when it wants to shut the tick down, so
> > > that shutdown never happens. 
> > 
> > Like so in virgin 3.10-rt.  Box is x3550 M3 booted nowatchdog
> > rcu_nocbs=1-3 nohz_full=1-3, and CPUs1-3 are completely isolated via
> > cpusets as well.
> 
> well, that very same problem is in mainline if you add "threadirqs" to
> the command line. But we can be smart about this. The untested patch
> below should address that issue. If that works on mainline we can
> adapt it for RT (needs a trylock(&base->lock) there).

Oops, in haste I wedged it straight into 3.10-rt as is.  First pert
attempt was a bit weird, but it eventually worked.

rtbox:/sys/kernel/debug/tracing # !cgexec
cgexec -g cpuset:rtcpus taskset -c 3 pert 5
2400.01 MHZ CPU
perturbation threshold 0.018 usecs.
pert/s:      807 >8.52us:        2 min:  0.04 max: 10.80 avg:  5.56 sum/s:  4485us overhead: 0.45%
pert/s:      707 >8.54us:        4 min:  2.85 max: 11.78 avg:  5.63 sum/s:  3981us overhead: 0.40%
pert/s:      807 >8.51us:        2 min:  0.04 max: 10.86 avg:  5.58 sum/s:  4502us overhead: 0.45%
pert/s:      707 >8.48us:        3 min:  0.04 max: 10.82 avg:  5.59 sum/s:  3959us overhead: 0.40%
pert/s:      630 >8.73us:        5 min:  0.04 max: 16.65 avg:  5.29 sum/s:  3335us overhead: 0.33%
pert/s:      152 >9.50us:        4 min:  0.04 max: 32.58 avg:  0.37 sum/s:    56us overhead: 0.01%
pert/s:       28 >9.74us:        3 min:  0.04 max: 22.31 avg:  1.41 sum/s:    40us overhead: 0.00%
pert/s:        8 >10.02us:        4 min:  1.75 max: 20.56 avg:  4.54 sum/s:    36us overhead: 0.00%
pert/s:        7 >10.23us:        3 min:  1.82 max: 19.94 avg:  4.33 sum/s:    34us overhead: 0.00%
pert/s:        9 >10.45us:        5 min:  0.04 max: 20.79 avg:  4.11 sum/s:    38us overhead: 0.00%
pert/s:       31 >10.57us:        5 min:  0.04 max: 22.13 avg:  1.22 sum/s:    38us overhead: 0.00%
pert/s:       10 >10.77us:        5 min:  0.04 max: 21.40 avg:  3.68 sum/s:    38us overhead: 0.00%
^C
rtbox:/sys/kernel/debug/tracing # cgexec -g cpuset:rtcpus taskset -c 3 pert 5
2400.02 MHZ CPU
perturbation threshold 0.018 usecs.
pert/s:        8 >14.06us:        2 min:  1.70 max: 19.66 avg:  4.24 sum/s:    35us overhead: 0.00%
pert/s:        8 >13.97us:        3 min:  1.80 max: 21.81 avg:  4.48 sum/s:    37us overhead: 0.00%
pert/s:        8 >13.77us:        2 min:  1.77 max: 19.64 avg:  4.35 sum/s:    35us overhead: 0.00%
pert/s:        9 >13.72us:        3 min:  0.04 max: 22.03 avg:  4.35 sum/s:    39us overhead: 0.00%
pert/s:        8 >13.55us:        2 min:  1.75 max: 19.88 avg:  4.16 sum/s:    35us overhead: 0.00%
pert/s:        8 >13.43us:        3 min:  0.04 max: 20.55 avg:  4.21 sum/s:    36us overhead: 0.00%
pert/s:        8 >13.28us:        2 min:  1.74 max: 19.53 avg:  4.34 sum/s:    35us overhead: 0.00%
pert/s:        8 >13.22us:        3 min:  1.76 max: 20.96 avg:  4.35 sum/s:    37us overhead: 0.00%
pert/s:        8 >13.10us:        2 min:  1.72 max: 19.64 avg:  4.38 sum/s:    36us overhead: 0.00%
^C
rtbox:/sys/kernel/debug/tracing # cgexec -g cpuset:rtcpus taskset -c 3 pert 5
2400.03 MHZ CPU
perturbation threshold 0.018 usecs.
pert/s:        9 >14.55us:        2 min:  0.04 max: 20.93 avg:  4.11 sum/s:    37us overhead: 0.00%
pert/s:        8 >14.36us:        3 min:  1.72 max: 20.75 avg:  4.42 sum/s:    36us overhead: 0.00%
pert/s:        8 >14.14us:        2 min:  1.74 max: 20.02 avg:  4.28 sum/s:    35us overhead: 0.00%
pert/s:        8 >13.98us:        3 min:  1.77 max: 20.54 avg:  4.51 sum/s:    36us overhead: 0.00%
pert/s:        8 >13.76us:        2 min:  1.72 max: 19.57 avg:  4.17 sum/s:    35us overhead: 0.00%
pert/s:        8 >13.63us:        3 min:  1.79 max: 20.42 avg:  4.38 sum/s:    36us overhead: 0.00%
pert/s:        9 >13.51us:        2 min:  0.04 max: 20.78 avg:  4.09 sum/s:    37us overhead: 0.00%

> What worries me more is this one:
> 
>   pert-5229  [003] d..h1..   684.482618: softirq_raise: vec=9 [action=RCU]
> 
> The CPU has no callbacks as you shoved them over to cpu 0, so why is
> the RCU softirq raised?

Dunno, but it's repeatable.  Workqueues are perturbation sources too,
update_vmstat, drain_caches (or such, didn't save all traces).

-Mike

