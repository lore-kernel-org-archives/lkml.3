Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab3HPKe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:34:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44490 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3HPKex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:34:53 -0400
Date: Fri, 16 Aug 2013 12:34:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH 6/6] sched, fair: Rework and comment the group_imb code
Message-ID: <20130816103438.GX3008@twins.programming.kicks-ass.net>
References: <20130816101221.028189677@chello.nl>
 <20130816101545.356818143@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816101545.356818143@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 12:12:27PM +0200, Peter Zijlstra wrote:
> +/*
> + * Group imbalance indicates (and tries to solve) the problem where balancing
> + * groups is inadequate due to tsk_cpus_allowed() constraints.
> + *
> + * Imagine a situation of two groups of 4 cpus each and 4 tasks each with a
> + * cpumask covering 1 cpu of the first group and 3 cpus of the second group.
> + * Something like:
> + *
> + * 	{ 0 1 2 3 } { 4 5 6 7 }
> + * 	        *     * * *

And yes, people think this is a reasonable thing to do :/

> + *
> + * If we were to balance group-wise we'd place two tasks in the first group and
> + * two tasks in the second group. Clearly this is undesired as it will overload
> + * cpu 3 and leave one of the cpus in the second group unused.
> + *
> + * The current solution to this issue is detecting the skew in the first group
> + * by noticing it has a cpu that is overloaded while the remaining cpus are
> + * idle -- or rather, there's a distinct imbalance in the cpus; see
> + * sg_imbalanced().
> + *
> + * When this is so detected; this group becomes a candidate for busiest; see
> + * update_sd_pick_busiest(). And calculcate_imbalance() and
> + * find_busiest_group() avoid some of the usual balance conditional to allow it
> + * to create an effective group imbalance.
> + *
> + * This is a somewhat tricky proposition since the next run might not find the
> + * group imbalance and decide the groups need to be balanced again. A most
> + * subtle and fragile situation.
> + */

One of the things that I know about which can (and does) go wrong with
this is that we typically pull 'all' tasks to the balance cpu only to
then let future (lower) load-balance passes spread that out again.

But until its spread out, we have this spike in the task distribution
that will trigger the group_imb condition.
