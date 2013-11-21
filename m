Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab3KUPD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:03:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49787 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab3KUPD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:03:56 -0500
Date: Thu, 21 Nov 2013 16:03:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:sched/urgent] sched: Check sched_domain before computing
 group power
Message-ID: <20131121150344.GG10022@twins.programming.kicks-ass.net>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net>
 <tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
 <CAE9FiQUk2Mr+4WypL41tCp3+54Aa+CT-17ga9+RffscUxwWAAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUk2Mr+4WypL41tCp3+54Aa+CT-17ga9+RffscUxwWAAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 03:36:12PM -0800, Yinghai Lu wrote:
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -5379,10 +5379,31 @@ void update_group_power(struct sched_domain *sd, int cpu)
> >                  */
> >
> >                 for_each_cpu(cpu, sched_group_cpus(sdg)) {
> > -                       struct sched_group *sg = cpu_rq(cpu)->sd->groups;
> > +                       struct sched_group_power *sgp;
> > +                       struct rq *rq = cpu_rq(cpu);
> >
> > -                       power_orig += sg->sgp->power_orig;
> > -                       power += sg->sgp->power;
> > +                       /*
> > +                        * build_sched_domains() -> init_sched_groups_power()
> > +                        * gets here before we've attached the domains to the
> > +                        * runqueues.
> > +                        *
> > +                        * Use power_of(), which is set irrespective of domains
> > +                        * in update_cpu_power().
> > +                        *
> > +                        * This avoids power/power_orig from being 0 and
> > +                        * causing divide-by-zero issues on boot.
> > +                        *
> > +                        * Runtime updates will correct power_orig.
> > +                        */
> > +                       if (unlikely(!rq->sd)) {
> > +                               power_orig += power_of(cpu);
> > +                               power += power_of(cpu);
> > +                               continue;
> > +                       }
> > +
> > +                       sgp = rq->sd->groups->sgp;
> > +                       power_orig += sgp->power_orig;
> > +                       power += sgp->power;
> >                 }
> >         } else  {
> >                 /*
> 
> This one seems fix NULL reference in compute_group_power.
> 
> but get following on current Linus tree plus tip/sched/urgent.
> 
> divide error: 0000 [#1]  SMP
> [   28.190477] Modules linked in:
> [   28.192012] CPU: 11 PID: 484 Comm: kworker/u324:0 Not tainted
> 3.12.0-yh-10487-g4b94e59-dirty #2044
> [   28.210488] Hardware name: Oracle Corporation  Sun Fire
> [   28.229877] task: ffff88ff25205140 ti: ffff88ff2520a000 task.ti:
> ffff88ff2520a000
> [   28.236139] RIP: 0010:[<ffffffff810d9ff4>]  [<ffffffff810d9ff4>]
> find_busiest_group+0x2b4/0x8a0

Hurmph.. what kind of hardware is that? and is there anything funny you
do to make it do this?
