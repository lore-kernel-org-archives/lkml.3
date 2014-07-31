Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbaGaIyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:54:39 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:29556 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932250AbaGaIyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:54:36 -0400
Date: Thu, 31 Jul 2014 09:54:21 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "arjan.van.de.ven@intel.com" <arjan.van.de.ven@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan.cox@intel.com" <alan.cox@intel.com>,
        "mark.gross@intel.com" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140731085421.GD3001@e103034-lin>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <20140718153931.GJ8700@e103034-lin>
 <20140727190237.GB22986@intel.com>
 <20140730101331.GB15761@e103687>
 <20140730191739.GD28673@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730191739.GD28673@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 08:17:39PM +0100, Yuyang Du wrote:
> Hi Morten,
> 
> On Wed, Jul 30, 2014 at 11:13:31AM +0100, Morten Rasmussen wrote:
> > > > 2. runnable_load_avg and blocked_load_avg are combined
> > > > 
> > > > runnable_load_avg currently represents the sum of load_avg_contrib of
> > > > all tasks on the rq, while blocked_load_avg is the sum of those tasks
> > > > not on a runqueue. It makes perfect sense to consider the sum of both
> > > > when calculating the load of a cpu, but we currently don't include
> > > > blocked_load_avg. The reason for that is the priority scaling of the
> > > > task load_avg_contrib may lead to under-utilization of cpus that
> > > > occasionally have tiny high priority task running. You can easily have a
> > > > task that takes 5% of cpu time but has a load_avg_contrib several times
> > > > larger than a default priority task runnable 100% of the time.
> > > 
> > > So this is the effect of historical averaging and weight scaling, both of which
> > > are just generally good, but may have bad cases.
> > 
> > I don't agree that weight scaling is generally good. There has been
> > several threads discussing that topic over the last half year or so. It
> > is there to ensure smp niceness, but it makes load-balancing on systems
> > which are not fully utilized sub-optimal. You may end up with some cpus
> > not being fully utilized while others are over-utilized when you have
> > multiple tasks running at different priorities.
> > 
> > It is a very real problem when user-space uses priorities extensively
> > like Android does. Tasks related to audio run at very high priorities
> > but only for a very short amount of time, but due the to priority
> > scaling their load ends up being several times higher than tasks running
> > all the time at normal priority. Hence task load is a very poor
> > indicator of utilization.
>  
> I understand the problem you said, but the problem is not described crystal clear.
> 
> You are saying tasks with big weight contribute too much, even they are running
> short time. But is it unfair or does it lead to imbalance? It is hard to say if
> not no. They have big weight, so are supposed to be "unfair" vs. small weight
> tasks for the sake of fairness. In addition, since they are running short time,
> their runnable weight/load is offset by this factor.

It does lead to imbalance and the problem is indeed very real as I
already said. It has been discussed numerous times before:

https://lkml.org/lkml/2014/5/28/264
https://lkml.org/lkml/2014/1/8/251

Summary:

Default priority (nice=0) has a weight of 1024. nice=-20 has a weight of
88761. So a nice=-20 that runs ~10% of the time has a load contribution
of ~8876, which is >8x the weight of a nice=0 task that runs 100% of the
time. Load contibution is used for load-balancing, which means that you
will put at least eight 100% nice=0 tasks on a cpu before you start
putting any additional tasks on the cpu with the nice=-20 task. So you
over-subscribe one cpu by 700% while another is idle 90% of the time.

You may argue that this is 'fair', but it is very much waste of
resources. Putting nice=0 tasks on the same cpu as the nice=-20 task
will have nearly no effect on the cpu time allocated to nice=-20 task
due to the vruntime scaling. Hence there is virtually no downside in
term of giving priority and a lot to be gained in term of throughput.

Generally, we don't have to care about priority as long as no cpu is
fully utilized. All tasks get the cpu time they need.

The problem with considering blocked priority scaled load is that the
blocked load doesn't disappear when it is blocked, so it effectively
reserves too much cpu time for high priority tasks. 

A real work use-case where this happens is described here:

https://lkml.org/lkml/2014/1/7/358

> I think I am saying from pure fairness ponit of view, which is just generally good
> in the sense that we can't think of a more "generally good" thing to replace it.

Unweighted utilization. As said above, we only need to care about
priority when cpus are fully utilized. It doesn't break any fairness.

> And you are saying when big weight task is not runnable, but already contributes
> "too much" load, then leads to under utilization. So this is the matter of our
> predicting algorithm. I am afraid I will say again the pridiction is generally
> good. For the audio example, which is strictly periodic, it just can't be better.

I disagree. The priority scaled prediction is generally bad. Why reserve
up to 88x times more cpu time to a task than is actually needed, when
the unweighted load tracking (utilization) is readily available?

> FWIW, I am really not sure how serious this under utilization problem is in real
> world.

Again, it is indeed a real world problem. We have experienced it first
hand and have been experimenting with this over the last 2-3 years. I'm
not making this up.

We have included unweighted load (utilization) in our RFC patch set for
the same reason. And the out-of-tree big.LITTLE solution carries similar
patches too.

> I am not saying your argument does not make sense. It makes every sense from specific
> case ponit from view. I do think there absolutely can be sub-optimal cases. But as
> I said, I just don't think the problem description is clear enough so that we know
> it is worth solving (by pros and cons comparison) and how to solve it, either
> generally or specifically.

I didn't repeat the whole history in my first response as I thought this
had already been debated several times and we had reached agreement that
is indeed a problem. You are not the first one to propose including
priority scaled blocked load in the load estimation.

> Plus, as Peter said, we have to live with user space uses big weight, and do it as
> what weight is supposed to be.

I don't follow. Are you saying it is fine to intentionally make
load-balancing worse for any user-space that uses task priorities other
than default?

You can't just ignore users of task priority. You may have the point of
view that you don't care about under-utilization, but there are lots of
users who do. Optimizing for energy consumption is a primary goal for
the mobile space (and servers seems to be moving that way too). This
requires more accurate estimates of cpu utilization to manage how many
cpus are needed. Ignoring priority scaling is moving in the exact
opposite direction an conflicts with other ongoing efforts.

Overall, it is not clear to me why it is necessary to rewrite the
per-entity load-tracking. The code is somewhat simpler, but I don't see
any functional additions/improvements. If we have to go through a long
review and testing process, why not address some of the most obvious
issues with the existing implementation while we are at it? I don't see
the point in replacing something sub-optimal with equally sub-optimal
(or worse).

Morten
