Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab3KGEbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:31:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64248 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3KGEbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:31:19 -0500
Message-ID: <1383798668.5441.25.camel@marge.simpson.net>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
From: Mike Galbraith <bitbucket@online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Date: Thu, 07 Nov 2013 05:31:08 +0100
In-Reply-To: <1383794799.5441.16.camel@marge.simpson.net>
References: <1383228427.5272.36.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
	 <1383794799.5441.16.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:WtOaWv1/Z+HevG1NQQSSOyNZCQ1swyNF6l/8229UFmT
 oujb7i+fGyKySmWu8ZVOicRSmtHLFZ9YOp+wM4MUBhcUN8VUFI
 sIRV6SfmmTq9ce9tcq9wRmD2T8WkJJm+3r7zrq7v/SDxnUYbWS
 GCyP8OFWpYD7IV/9d+ve5VYb4eKEESNTdu1TmIXibEDpNoo3Ga
 jeZ9G0WfjUuvlhEaYT5x9qYAutTSg5lEkGoWktdwTMo9GjVxkK
 gNHe4htbgc83enu/W71FI8zDM9wMRnsQZLg4rIjnptntnQLnu5
 CGGdiR4QPzUBQvOeTJD26Qaq4syIGiDndGN5n+Viu3VemjnKHe
 fLqd1Y5JRhoNp9jzA6pYADsQVDoaH9nPFishwvWUkGG7TfNeCD
 ZOCKu7CCmeMSA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-07 at 04:26 +0100, Mike Galbraith wrote: 
> On Wed, 2013-11-06 at 18:49 +0100, Thomas Gleixner wrote: 

> > I bet you are trying to work around some of the side effects of the
> > occasional tick which is still necessary despite of full nohz, right?
> 
> Nope, I wanted to check out cost of nohz_full for rt, and found that it
> doesn't work at all instead, looked, and found that the sole running
> task has just awakened ksoftirqd when it wants to shut the tick down, so
> that shutdown never happens. 

Like so in virgin 3.10-rt.  Box is x3550 M3 booted nowatchdog
rcu_nocbs=1-3 nohz_full=1-3, and CPUs1-3 are completely isolated via
cpusets as well.

... 
            pert-5229  [003] d..h2..   684.481615: hrtimer_cancel: hrtimer=ffff88017fccbac0
            pert-5229  [003] d..h1..   684.481616: hrtimer_expire_entry: hrtimer=ffff88017fccbac0 function=tick_sched_timer now=683820187877
            pert-5229  [003] d..h2..   684.481616: sched_stat_runtime: comm=pert pid=5229 runtime=993917 [ns] vruntime=179048871558 [ns]
            pert-5229  [003] d..h1..   684.481616: softirq_raise: vec=1 [action=TIMER]
            pert-5229  [003] d..h1..   684.481616: hrtimer_expire_exit: hrtimer=ffff88017fccbac0
            pert-5229  [003] d..h2..   684.481617: hrtimer_start: hrtimer=ffff88017fccbac0 function=tick_sched_timer expires=683821187500 softexpires=683821187500
            pert-5229  [003] d...3..   684.481618: sched_stat_runtime: comm=pert pid=5229 runtime=1634 [ns] vruntime=179048873192 [ns]
            pert-5229  [003] d.L.3..   684.481618: sched_wakeup: comm=ksoftirqd/3 pid=49 prio=120 success=1 target_cpu=003
            pert-5229  [003] d.L.1..   684.481618: tick_stop: success=no msg=more than 1 task in runqueue

            pert-5229  [003] d.L.1..   684.481619: tick_stop: success=no msg=more than 1 task in runqueue

            pert-5229  [003] d.L.3..   684.481620: sched_stat_runtime: comm=pert pid=5229 runtime=2096 [ns] vruntime=179048875288 [ns]
            pert-5229  [003] d...3..   684.481620: sched_switch: prev_comm=pert prev_pid=5229 prev_prio=120 prev_state=R+ ==> next_comm=ksoftirqd/3 next_pid=49 next_prio=120
     ksoftirqd/3-49    [003] ....111   684.481621: softirq_entry: vec=1 [action=TIMER]
     ksoftirqd/3-49    [003] ....111   684.481621: softirq_exit: vec=1 [action=TIMER]
     ksoftirqd/3-49    [003] d...3..   684.481622: sched_stat_runtime: comm=ksoftirqd/3 pid=49 runtime=1934 [ns] vruntime=179039875126 [ns]
     ksoftirqd/3-49    [003] d...3..   684.481622: sched_switch: prev_comm=ksoftirqd/3 prev_pid=49 prev_prio=120 prev_state=S ==> next_comm=pert next_pid=5229 next_prio=120
            pert-5229  [003] d...3..   684.481623: sched_stat_runtime: comm=pert pid=5229 runtime=1289 [ns] vruntime=179048876577 [ns]
            pert-5229  [003] d..h2..   684.482616: hrtimer_cancel: hrtimer=ffff88017fccbac0
            pert-5229  [003] d..h1..   684.482617: hrtimer_expire_entry: hrtimer=ffff88017fccbac0 function=tick_sched_timer now=683821188024
            pert-5229  [003] d..h2..   684.482617: sched_stat_runtime: comm=pert pid=5229 runtime=994281 [ns] vruntime=179049870858 [ns]
            pert-5229  [003] d..h1..   684.482617: softirq_raise: vec=1 [action=TIMER]
            pert-5229  [003] d..h1..   684.482618: softirq_raise: vec=9 [action=RCU]
            pert-5229  [003] d..h1..   684.482618: hrtimer_expire_exit: hrtimer=ffff88017fccbac0
            pert-5229  [003] d..h2..   684.482618: hrtimer_start: hrtimer=ffff88017fccbac0 function=tick_sched_timer expires=683822187500 softexpires=683822187500
            pert-5229  [003] d...3..   684.482619: sched_stat_runtime: comm=pert pid=5229 runtime=1719 [ns] vruntime=179049872577 [ns]
            pert-5229  [003] d.L.3..   684.482619: sched_wakeup: comm=ksoftirqd/3 pid=49 prio=120 success=1 target_cpu=003
            pert-5229  [003] d.L.1..   684.482619: tick_stop: success=no msg=more than 1 task in runqueue

            pert-5229  [003] d.L.1..   684.482620: tick_stop: success=no msg=more than 1 task in runqueue

            pert-5229  [003] d.L.3..   684.482621: sched_stat_runtime: comm=pert pid=5229 runtime=2204 [ns] vruntime=179049874781 [ns]
            pert-5229  [003] d...3..   684.482621: sched_switch: prev_comm=pert prev_pid=5229 prev_prio=120 prev_state=R+ ==> next_comm=ksoftirqd/3 next_pid=49 next_prio=120
     ksoftirqd/3-49    [003] ....111   684.482622: softirq_entry: vec=1 [action=TIMER]
     ksoftirqd/3-49    [003] ....111   684.482623: softirq_exit: vec=1 [action=TIMER]
     ksoftirqd/3-49    [003] ....111   684.482623: softirq_entry: vec=9 [action=RCU]
     ksoftirqd/3-49    [003] ....111   684.482624: softirq_exit: vec=9 [action=RCU]
     ksoftirqd/3-49    [003] d...3..   684.482624: sched_stat_runtime: comm=ksoftirqd/3 pid=49 runtime=3049 [ns] vruntime=179040875626 [ns]
     ksoftirqd/3-49    [003] d...3..   684.482624: sched_switch: prev_comm=ksoftirqd/3 prev_pid=49 prev_prio=120 prev_state=S ==> next_comm=pert next_pid=5229 next_prio=120
            pert-5229  [003] d...3..   684.482626: sched_stat_runtime: comm=pert pid=5229 runtime=1422 [ns] vruntime=179049876203 [ns]
            pert-5229  [003] d..h2..   684.483617: hrtimer_cancel: hrtimer=ffff88017fccbac0
            pert-5229  [003] d..h1..   684.483617: hrtimer_expire_entry: hrtimer=ffff88017fccbac0 function=tick_sched_timer now=683822187923
            pert-5229  [003] d..h2..   684.483618: sched_stat_runtime: comm=pert pid=5229 runtime=992021 [ns] vruntime=179050868224 [ns]
            pert-5229  [003] d..h1..   684.483618: softirq_raise: vec=1 [action=TIMER]
            pert-5229  [003] d..h1..   684.483618: softirq_raise: vec=9 [action=RCU]
            pert-5229  [003] d..h1..   684.483618: hrtimer_expire_exit: hrtimer=ffff88017fccbac0
            pert-5229  [003] d..h2..   684.483618: hrtimer_start: hrtimer=ffff88017fccbac0 function=tick_sched_timer expires=683823187500 softexpires=683823187500
            pert-5229  [003] d...3..   684.483619: sched_stat_runtime: comm=pert pid=5229 runtime=1778 [ns] vruntime=179050870002 [ns]
            pert-5229  [003] d.L.3..   684.483620: sched_wakeup: comm=ksoftirqd/3 pid=49 prio=120 success=1 target_cpu=003
            pert-5229  [003] d.L.1..   684.483620: tick_stop: success=no msg=more than 1 task in runqueue

            pert-5229  [003] d.L.1..   684.483621: tick_stop: success=no msg=more than 1 task in runqueue

            pert-5229  [003] d.L.3..   684.483621: sched_stat_runtime: comm=pert pid=5229 runtime=2096 [ns] vruntime=179050872098 [ns]
            pert-5229  [003] d...3..   684.483622: sched_switch: prev_comm=pert prev_pid=5229 prev_prio=120 prev_state=R+ ==> next_comm=ksoftirqd/3 next_pid=49 next_prio=120
     ksoftirqd/3-49    [003] ....111   684.483623: softirq_entry: vec=1 [action=TIMER]
     ksoftirqd/3-49    [003] ....111   684.483623: softirq_exit: vec=1 [action=TIMER]
     ksoftirqd/3-49    [003] ....111   684.483623: softirq_entry: vec=9 [action=RCU]
     ksoftirqd/3-49    [003] ....111   684.483624: softirq_exit: vec=9 [action=RCU]
     ksoftirqd/3-49    [003] d...3..   684.483625: sched_stat_runtime: comm=ksoftirqd/3 pid=49 runtime=3187 [ns] vruntime=179041873189 [ns]
     ksoftirqd/3-49    [003] d...3..   684.483625: sched_switch: prev_comm=ksoftirqd/3 prev_pid=49 prev_prio=120 prev_state=S ==> next_comm=pert next_pid=5229 next_prio=120
            pert-5229  [003] d...3..   684.483626: sched_stat_runtime: comm=pert pid=5229 runtime=1331 [ns] vruntime=179050873429 [ns]


