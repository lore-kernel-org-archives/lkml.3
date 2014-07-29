Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaG2JjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:39:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51515 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaG2JjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:39:15 -0400
Date: Tue, 29 Jul 2014 11:39:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Yuyang Du <yuyang.du@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        arjan.van.de.ven@intel.com, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, alan.cox@intel.com,
        "Gross, Mark" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140729093911.GU20603@laptop.programming.kicks-ass.net>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
 <CAKfTPtAoer-c7Hynr-VhvF112MaoUybM8zhaQKrc+n0CJ3Z47g@mail.gmail.com>
 <20140727173616.GA22986@intel.com>
 <CAKfTPtBR1dK-8nFGAMvEa2AC6ByZgOskkZpWEOXwzDrUD6xBDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtBR1dK-8nFGAMvEa2AC6ByZgOskkZpWEOXwzDrUD6xBDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 11:12:37AM +0200, Vincent Guittot wrote:
> On 27 July 2014 19:36, Yuyang Du <yuyang.du@intel.com> wrote:
> > Hi Vincent,
> >
> > On Fri, Jul 18, 2014 at 11:43:00AM +0200, Vincent Guittot wrote:
> >> > @@ -2291,23 +2299,24 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
> >> >         delta >>= 10;
> >> >         if (!delta)
> >> >                 return 0;
> >> > -       sa->last_runnable_update = now;
> >> > +       sa->last_update_time = now;
> >> >
> >> >         /* delta_w is the amount already accumulated against our next period */
> >> > -       delta_w = sa->runnable_avg_period % 1024;
> >> > +       delta_w = sa->period_contrib;
> >> >         if (delta + delta_w >= 1024) {
> >> > -               /* period roll-over */
> >> >                 decayed = 1;
> >> >
> >> > +               /* how much left for next period will start over, we don't know yet */
> >> > +               sa->period_contrib = 0;
> >> > +
> >> >                 /*
> >> >                  * Now that we know we're crossing a period boundary, figure
> >> >                  * out how much from delta we need to complete the current
> >> >                  * period and accrue it.
> >> >                  */
> >> >                 delta_w = 1024 - delta_w;
> >> > -               if (runnable)
> >> > -                       sa->runnable_avg_sum += delta_w;
> >> > -               sa->runnable_avg_period += delta_w;
> >> > +               if (w)
> >> > +                       sa->load_sum += w * delta_w;
> >>
> >> Do you really need to have *w for computing the load_sum ? can't you
> >> only use it when computing the load_avg ?
> >>
> >> sa->load_avg = div_u64(sa->load_sum * w , LOAD_AVG_MAX)
> >>
> >
> > For task, assuming its load.weight does not change much, yes, we can. But in theory, task's
> 
> I would even say that the load_avg of a task should not be impacted by
> an old priority value. Once, the priority of a task is changed, we
> should only take into account this new priority to weight the load_avg
> of the task

So for tasks I would immediately agree, and I think for groups too,
seeing how the group weight is based off of this avg, if you then
include the old weight we'll get a feedback loop. This might not be
desired as it would counteract the SMP movement of tasks.
