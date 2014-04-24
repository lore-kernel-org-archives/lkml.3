Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbaDXTHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:07:07 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:45193 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758992AbaDXTHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:07:04 -0400
Message-ID: <1398366420.5324.13.camel@marge.simpson.net>
Subject: Re: [PATCH 3/3] sched, fair: Stop searching for tasks in newidle
 balance if there are runnable tasks
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        daniel.lezcano@linaro.org, alex.shi@linaro.org,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com, chegu_vinod@hp.com
Date: Thu, 24 Apr 2014 21:07:00 +0200
In-Reply-To: <1398357472.3509.2.camel@j-VirtualBox>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
	 <1398303035-18255-4-git-send-email-jason.low2@hp.com>
	 <1398307888.26653.18.camel@marge.simpson.net>
	 <1398357472.3509.2.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 09:37 -0700, Jason Low wrote: 
> On Thu, 2014-04-24 at 04:51 +0200, Mike Galbraith wrote:
> > On Wed, 2014-04-23 at 18:30 -0700, Jason Low wrote: 
> > > It was found that when running some workloads (such as AIM7) on large systems
> > > with many cores, CPUs do not remain idle for long. Thus, tasks can
> > > wake/get enqueued while doing idle balancing.
> > > 
> > > In this patch, while traversing the domains in idle balance, in addition to
> > > checking for pulled_task, we add an extra check for this_rq->nr_running for
> > > determining if we should stop searching for tasks to pull. If there are
> > > runnable tasks on this rq, then we will stop traversing the domains. This
> > > reduces the chance that idle balance delays a task from running.
> > > 
> > > This patch resulted in approximately a 6% performance improvement when
> > > running a Java Server workload on an 8 socket machine.
> > 
> > Checking rq->lock for contention before ever going to idle balancing as
> > well should give you a bit more.  No need to run around looking for work
> > that's trying to arrive.  By not going there, perhaps stacking tasks,
> > you may head off a future bounce as well.
> 
> Are you thinking of something along the lines of this:
> 
> @@ -6658,7 +6658,8 @@ static int idle_balance(struct rq *this_rq)
>          */
>         this_rq->idle_stamp = rq_clock(this_rq);
>  
> -       if (this_rq->avg_idle < sysctl_sched_migration_cost)
> +       if (this_rq->avg_idle < sysctl_sched_migration_cost ||
> +           spin_is_contended(&this_rq->lock))
>                 goto out;
> 

More or less, yes, that's what I was thinking, because the wakeup you
are watching for, and encountering in reality could very well be that
very one.  But as noted, my reaction to that wakeup couldn't possibly
have been further off the mark.

-Mike

