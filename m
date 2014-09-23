Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbaIWN6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:58:48 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36030 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbaIWN6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:58:44 -0400
Date: Tue, 23 Sep 2014 14:59:05 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: "bsegall@google.com" <bsegall@google.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] sched: Track sched_entity usage contributions
Message-ID: <20140923135905.GU23693@e103034-lin>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
 <1411403047-32010-8-git-send-email-morten.rasmussen@arm.com>
 <xm267g0vlgyx.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xm267g0vlgyx.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 06:09:42PM +0100, bsegall@google.com wrote:
> Morten Rasmussen <morten.rasmussen@arm.com> writes:
> 
> > Adds usage contribution tracking for both task and group entities.
> > Maintains a non-priority scaled se->avg.usage_avg_contrib for each
> > sched_entity and cfs_rq.usage_util_avg sum of all entity contributions.
> > The latter provides a more accurate estimate of the true cpu utilization
> > than the existing cfs_rq.runnable_load_avg (+blocked_load_avg).
> >
> > Unlike se->avg.load_avg_contrib, se->avg.usage_avg_contrib for group
> > entities is the sum of se->avg.usage_avg_contrib for all entities on the
> > group runqueue. It is _not_ influenced in any way by the task group
> > h_load. Hence it is representing the actual cpu usage of the group, not
> > its intended load contribution which may differ significantly from the
> > usage on lightly utilized systems.
> >
> > The cpu usage tracking is available as cpu_rq(cpu)->cfs.usage_util_avg.
> > No tracking of blocked usage has been implemented.
> 
> Isn't cfs_rq->usage_util_avg basically just
> se->avg.usage_avg_sum * 1024 / se->avg.runnable_avg_period, where
> se->group_cfs_rq == cfs_rq? (and for the rq as a whole, rq->avg)

Almost, but not quite :)

cfs_rq->usage_util_avg is updated when a sched_entity is
enqueued/dequeued by adding/subtracting se->avg.usage_avg_contrib
similar to cfs_rq->runnable_avg_load and se->avg.load_avg_contrib. So it
is an instantaneous usage approximation. se->avg.usage_avg_sum * 1024 /
se->avg.runnable_avg_period for the group entity (or rq->avg) has to ramp
up/decay, so the approximation is lagging a bit behind when tasks are
migrated. On a stable system they should be the same.

> The fact that usage_util_avg doesn't track blocked usage seems more
> likely to be a problem than an advantage, but maybe not?

Yes. I think it was agreed at Ksummit that taking blocked load (and
usage) into account is the right thing to do as long as
{runnable,running}+blocked is used correctly in load-balancing
decisions.

I will look into adding blocked usage for the next version.

Thanks,
Morten
