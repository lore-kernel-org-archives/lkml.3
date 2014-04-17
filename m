Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaDQQVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:21:37 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:53642 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaDQQVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:21:30 -0400
Date: Thu, 17 Apr 2014 12:21:28 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        rjw@rjwysocki.net, linux-pm@vger.kernel.org, alex.shi@linaro.org,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 3/3] sched/fair: use the idle state info to choose
 the idlest cpu
In-Reply-To: <534FFBB3.8050601@linaro.org>
Message-ID: <alpine.LFD.2.11.1404171207531.980@knanqh.ubzr>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org> <1396009796-31598-4-git-send-email-daniel.lezcano@linaro.org> <alpine.LFD.2.11.1404012208110.1571@knanqh.ubzr> <534FDCDC.6000806@linaro.org> <alpine.LFD.2.11.1404171138470.980@knanqh.ubzr>
 <534FFBB3.8050601@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014, Daniel Lezcano wrote:

> On 04/17/2014 05:53 PM, Nicolas Pitre wrote:
> > On Thu, 17 Apr 2014, Daniel Lezcano wrote:
> >
> > > Ok, refreshed the patchset but before sending it out I would to discuss
> > > about
> > > the rational of the changes and the policy, and change the patchset
> > > consequently.
> > >
> > > What order to choose if the cpu is idle ?
> > >
> > > Let's assume all cpus are idle on a dual socket quad core.
> > >
> > > Also, we can reasonably do the hypothesis if the cluster is in low power
> > > mode,
> > > the cpus belonging to the same cluster are in the same idle state (putting
> > > apart the auto-promote where we don't have control on).
> > >
> > > If the policy you talk above is 'aggressive power saving', we can follow
> > > the
> > > rules with decreasing priority:
> > >
> > > 1. We want to prevent to wakeup the entire cluster
> > > => as the cpus are in the same idle state, by choosing a cpu in
> > > => shallow
> > > state, we should have the guarantee we won't wakeup a cluster (except if
> > > no
> > > shallowest idle cpu are found).
> >
> > This is unclear to me.  Obviously, if an entire cluster is down, that
> > means all the CPUs it contains have been idle for a long time.  And
> > therefore they shouldn't be subject to selection unless there is no
> > other CPUs available.  Is that what you mean?
> 
> Yes, this is what I meant. But also what I meant is we can get rid for the
> moment of the cpu topology and the coupling idle state because if we do this
> described approach, as the idle state will be the same for the cpus belonging
> to the same cluster we won't select a cluster down (except if there is no
> other CPUs available).

CPU topology is needed to properly describe scheduling domains.  Whether 
we balance across domains or pack using as few domains as possible is a 
separate issue.  In other words, you shouldn't have to care in this 
patch series.

And IMHO coupled C-state is a low-level mechanism that should remain 
private to cpuidle which the scheduler shouldn't be aware of.

> > > 2. We want to prevent to wakeup a cpu which did not reach the target
> > > residency
> > > time (will need some work to unify cpuidle idle time and idle task run
> > > time)
> > > => with the target residency and, as a first step, with the idle
> > > => stamp,
> > > we can determine if the cpu slept enough
> >
> > Agreed. However, right now, the scheduler does not have any
> > consideration for that.  So this should be done as a separate patch.
> 
> Yes, I thought as a very first step we can rely on the idle stamp until we
> unify the times with a big comment. Or I can first unify the idle times and
> then take into account the target residency. It is to comply with Rafael's
> request to have the 'big picture'.

I agree, but that should be done incrementally.  Even without this 
consideration, what you proposed is already an improvement over the 
current state of affairs.


Nicolas
