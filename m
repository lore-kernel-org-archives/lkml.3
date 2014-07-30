Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbaGaDTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 23:19:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:50127 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbaGaDTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 23:19:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,769,1400050800"; 
   d="scan'208";a="463423871"
Date: Thu, 31 Jul 2014 03:17:39 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Morten Rasmussen <morten.rasmussen@arm.com>
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
Message-ID: <20140730191739.GD28673@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <20140718153931.GJ8700@e103034-lin>
 <20140727190237.GB22986@intel.com>
 <20140730101331.GB15761@e103687>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730101331.GB15761@e103687>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morten,

On Wed, Jul 30, 2014 at 11:13:31AM +0100, Morten Rasmussen wrote:
> > > 2. runnable_load_avg and blocked_load_avg are combined
> > > 
> > > runnable_load_avg currently represents the sum of load_avg_contrib of
> > > all tasks on the rq, while blocked_load_avg is the sum of those tasks
> > > not on a runqueue. It makes perfect sense to consider the sum of both
> > > when calculating the load of a cpu, but we currently don't include
> > > blocked_load_avg. The reason for that is the priority scaling of the
> > > task load_avg_contrib may lead to under-utilization of cpus that
> > > occasionally have tiny high priority task running. You can easily have a
> > > task that takes 5% of cpu time but has a load_avg_contrib several times
> > > larger than a default priority task runnable 100% of the time.
> > 
> > So this is the effect of historical averaging and weight scaling, both of which
> > are just generally good, but may have bad cases.
> 
> I don't agree that weight scaling is generally good. There has been
> several threads discussing that topic over the last half year or so. It
> is there to ensure smp niceness, but it makes load-balancing on systems
> which are not fully utilized sub-optimal. You may end up with some cpus
> not being fully utilized while others are over-utilized when you have
> multiple tasks running at different priorities.
> 
> It is a very real problem when user-space uses priorities extensively
> like Android does. Tasks related to audio run at very high priorities
> but only for a very short amount of time, but due the to priority
> scaling their load ends up being several times higher than tasks running
> all the time at normal priority. Hence task load is a very poor
> indicator of utilization.
 
I understand the problem you said, but the problem is not described crystal clear.

You are saying tasks with big weight contribute too much, even they are running
short time. But is it unfair or does it lead to imbalance? It is hard to say if
not no. They have big weight, so are supposed to be "unfair" vs. small weight
tasks for the sake of fairness. In addition, since they are running short time,
their runnable weight/load is offset by this factor.

I think I am saying from pure fairness ponit of view, which is just generally good
in the sense that we can't think of a more "generally good" thing to replace it.

And you are saying when big weight task is not runnable, but already contributes
"too much" load, then leads to under utilization. So this is the matter of our
predicting algorithm. I am afraid I will say again the pridiction is generally
good. For the audio example, which is strictly periodic, it just can't be better.

FWIW, I am really not sure how serious this under utilization problem is in real
world.

I am not saying your argument does not make sense. It makes every sense from specific
case ponit from view. I do think there absolutely can be sub-optimal cases. But as
I said, I just don't think the problem description is clear enough so that we know
it is worth solving (by pros and cons comparison) and how to solve it, either
generally or specifically.

Plus, as Peter said, we have to live with user space uses big weight, and do it as
what weight is supposed to be.

Thanks,
Yuyang
