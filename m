Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaG1Bih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 21:38:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:34153 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbaG1Bif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 21:38:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,745,1400050800"; 
   d="scan'208";a="568109198"
Date: Mon, 28 Jul 2014 01:36:16 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        arjan.van.de.ven@intel.com, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, alan.cox@intel.com,
        "Gross, Mark" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140727173616.GA22986@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
 <CAKfTPtAoer-c7Hynr-VhvF112MaoUybM8zhaQKrc+n0CJ3Z47g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtAoer-c7Hynr-VhvF112MaoUybM8zhaQKrc+n0CJ3Z47g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On Fri, Jul 18, 2014 at 11:43:00AM +0200, Vincent Guittot wrote:
> > @@ -2291,23 +2299,24 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
> >         delta >>= 10;
> >         if (!delta)
> >                 return 0;
> > -       sa->last_runnable_update = now;
> > +       sa->last_update_time = now;
> >
> >         /* delta_w is the amount already accumulated against our next period */
> > -       delta_w = sa->runnable_avg_period % 1024;
> > +       delta_w = sa->period_contrib;
> >         if (delta + delta_w >= 1024) {
> > -               /* period roll-over */
> >                 decayed = 1;
> >
> > +               /* how much left for next period will start over, we don't know yet */
> > +               sa->period_contrib = 0;
> > +
> >                 /*
> >                  * Now that we know we're crossing a period boundary, figure
> >                  * out how much from delta we need to complete the current
> >                  * period and accrue it.
> >                  */
> >                 delta_w = 1024 - delta_w;
> > -               if (runnable)
> > -                       sa->runnable_avg_sum += delta_w;
> > -               sa->runnable_avg_period += delta_w;
> > +               if (w)
> > +                       sa->load_sum += w * delta_w;
> 
> Do you really need to have *w for computing the load_sum ? can't you
> only use it when computing the load_avg ?
> 
> sa->load_avg = div_u64(sa->load_sum * w , LOAD_AVG_MAX)
> 

For task, assuming its load.weight does not change much, yes, we can. But in theory, task's
load.weight can change, and *w in load_sum can take into that change. For group entity
and cfs_rq, its load.weight changes all the time, I don't know how to do it without *w
for load_sum.

Sorry for my irresponsiveness for last week. I was on vacation and unfortunately failed to
connect VPN from where I was.

Thanks,
Yuyang
