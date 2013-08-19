Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198Ab3HSKas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:30:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56420 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab3HSKar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:30:47 -0400
Date: Mon, 19 Aug 2013 12:30:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 5/6] sched, fair: Make group power more consitent
Message-ID: <20130819103031.GC24092@twins.programming.kicks-ass.net>
References: <20130816101221.028189677@chello.nl>
 <20130816101545.290832815@infradead.org>
 <52119C6B.1090009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52119C6B.1090009@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 09:47:47AM +0530, Preeti U Murthy wrote:
> Hi Peter,
> 
> On 08/16/2013 03:42 PM, Peter Zijlstra wrote:
> 
> I have a few comments and clarification to seek.
> 
> 1. How are you ensuring from this patch that sgs->group_power does not
> change over the course of load balancing?

Well, we only set it the one time when creating the sgs data.

>     The only path to update_group_power() where sg->sgp->power gets
> updated, is from update_sg_lb_stats(). You are updating sgs->group_power
> in update_sg_lb_stats(). Any change to group->sgp->power will get
> reflected in sgs->group_power as well right?

Nope, we set it to whatever value group->sgp->power is at the time of
sgs 'creation' and live with that value from then on. We do this after
the possible update_group_power() call.

That said, it is very rare to have group->sgp->power change during the
load-balance pass, we would have to trigger the time_after case for
NEWLY_IDLE and then get a concurrent !NEWLY_IDLE load-balance pass.

This patch takes away that possibility and uses a consistent group power
reading for the entire load-balance invocation as well as does away with
that double dereference all the time.

> 2. This point is aside from your patch. In the current implementation,
> each time the cpu power gets updated in update_cpu_power(), should not
> the power of the sched_groups comprising of that cpu also get updated?
> Why wait till the load balancing is done at the sched_domain level of
> that group, to update its group power?

What would be the advantage of doing so? We also take snapshots of
cpu/group/domain load, we don't update those either. Having all that
dynamically update during the load-balance pass would make it an
impossible situation. 

You'd fail to meet progress guarantees that way since you'd never be
able to pin-point a 'busiest' group/cpu because by the time you've made
any decision you have to go back to make it again because things might
have changed again.

So instead what we do is we take a snapshot and live with that state. If
the values change so fast that our load-balance pass is invalid by the
time we're finished, too bad, better luck next time.


