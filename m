Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaDYHNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:13:15 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:21115 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaDYHNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:13:12 -0400
Message-ID: <1398409990.12047.27.camel@j-VirtualBox>
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
From: Jason Low <jason.low2@hp.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com, chegu_vinod@hp.com
Date: Fri, 25 Apr 2014 00:13:10 -0700
In-Reply-To: <5359EEBE.2030808@linux.vnet.ibm.com>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
	 <1398303035-18255-2-git-send-email-jason.low2@hp.com>
	 <5358E417.8090503@linux.vnet.ibm.com>
	 <20140424120415.GS11096@twins.programming.kicks-ass.net>
	 <20140424124438.GT13658@twins.programming.kicks-ass.net>
	 <1398358417.3509.11.camel@j-VirtualBox>
	 <20140424171453.GZ11096@twins.programming.kicks-ass.net>
	 <1398377917.3509.32.camel@j-VirtualBox>
	 <5359EEBE.2030808@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 10:42 +0530, Preeti U Murthy wrote:
> I agree with this. However I am concerned with an additional point that
> I have mentioned in my reply to Peter's mail on this thread.
> 
> Should we verify if rq->next_balance update is independent of
> pulled_tasks? sd->balance_interval is changed during load_balance() and
> rq->next_balance should perhaps consider that?

Hi Preeti,

I agree that we may want to consider having rq->next balance update be
independent of pulled_task. As you mentioned, load_balance() can modify
the balance_interval.

There are a few things I'm wondering if we would need to also add then:

1. In the case that this_rq->avg_idle < sysctl_sched_migration_cost, we
   would need to also traverse the domains to properly compute
   next_balance (without the sd->busy_factor) as we would be going idle.
   Otherwise, next_balance could get set to jiffies + HZ while the
   CPU goes idle.

2. In the domain traversal, when we pulled_task, we might want to
   multiply interval by sd->busy_factor because the rq will remain busy.

3. If this_rq->avg_idle < curr_cost + sd->max_newidle_lb_cost, then we
   may still want to compute next_balance, rather than simply break out
   of the sched domain traversal loop. This is also to avoid having
   the next_balance = jiffies + HZ when a domain should rebalance
   less than 1 second later.


