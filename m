Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaG2JND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:13:03 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:61079 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbaG2JM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:12:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140727173616.GA22986@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com> <CAKfTPtAoer-c7Hynr-VhvF112MaoUybM8zhaQKrc+n0CJ3Z47g@mail.gmail.com>
 <20140727173616.GA22986@intel.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 29 Jul 2014 11:12:37 +0200
Message-ID: <CAKfTPtBR1dK-8nFGAMvEa2AC6ByZgOskkZpWEOXwzDrUD6xBDg@mail.gmail.com>
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average tracking
To: Yuyang Du <yuyang.du@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        arjan.van.de.ven@intel.com, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, alan.cox@intel.com,
        "Gross, Mark" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 July 2014 19:36, Yuyang Du <yuyang.du@intel.com> wrote:
> Hi Vincent,
>
> On Fri, Jul 18, 2014 at 11:43:00AM +0200, Vincent Guittot wrote:
>> > @@ -2291,23 +2299,24 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
>> >         delta >>= 10;
>> >         if (!delta)
>> >                 return 0;
>> > -       sa->last_runnable_update = now;
>> > +       sa->last_update_time = now;
>> >
>> >         /* delta_w is the amount already accumulated against our next period */
>> > -       delta_w = sa->runnable_avg_period % 1024;
>> > +       delta_w = sa->period_contrib;
>> >         if (delta + delta_w >= 1024) {
>> > -               /* period roll-over */
>> >                 decayed = 1;
>> >
>> > +               /* how much left for next period will start over, we don't know yet */
>> > +               sa->period_contrib = 0;
>> > +
>> >                 /*
>> >                  * Now that we know we're crossing a period boundary, figure
>> >                  * out how much from delta we need to complete the current
>> >                  * period and accrue it.
>> >                  */
>> >                 delta_w = 1024 - delta_w;
>> > -               if (runnable)
>> > -                       sa->runnable_avg_sum += delta_w;
>> > -               sa->runnable_avg_period += delta_w;
>> > +               if (w)
>> > +                       sa->load_sum += w * delta_w;
>>
>> Do you really need to have *w for computing the load_sum ? can't you
>> only use it when computing the load_avg ?
>>
>> sa->load_avg = div_u64(sa->load_sum * w , LOAD_AVG_MAX)
>>
>
> For task, assuming its load.weight does not change much, yes, we can. But in theory, task's

I would even say that the load_avg of a task should not be impacted by
an old priority value. Once, the priority of a task is changed, we
should only take into account this new priority to weight the load_avg
of the task

> load.weight can change, and *w in load_sum can take into that change. For group entity
> and cfs_rq, its load.weight changes all the time, I don't know how to do it without *w
> for load_sum.

IMHO, we should apply the same policy than the one i mentioned for
task. So the load_avg of an entity or a cfs_rq will not be disturbed
by an old but no more valid weight

Vincent
>
> Sorry for my irresponsiveness for last week. I was on vacation and unfortunately failed to
> connect VPN from where I was.
>
> Thanks,
> Yuyang
