Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaKLPjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:39:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:44796 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaKLPjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:39:14 -0500
Date: Wed, 12 Nov 2014 16:39:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@arm.com>
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] sched/deadline: support dl task migration during cpu
 hotplug
Message-ID: <20141112153906.GL29390@twins.programming.kicks-ass.net>
References: <1415754413-13988-1-git-send-email-wanpeng.li@linux.intel.com>
 <546377FC.4090408@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546377FC.4090408@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 03:08:44PM +0000, Juri Lelli wrote:
> > @@ -1185,8 +1223,9 @@ static int find_later_rq(struct task_struct *task)
> >  	 * We have to consider system topology and task affinity
> >  	 * first, then we can look for a suitable cpu.
> >  	 */
> > -	cpumask_copy(later_mask, task_rq(task)->rd->span);
> > -	cpumask_and(later_mask, later_mask, cpu_active_mask);
> > +	cpumask_copy(later_mask, cpu_active_mask);
> > +	if (likely(task_rq(task)->online))
> > +		cpumask_and(later_mask, later_mask, task_rq(task)->rd->span);
> 
> So, here you consider the span only when the task_rq is online,
> but there might be others cpus still online belonging to the same
> rd->span. And you have to consider them when migrating. Actually,
> migration must still be restricted to the online cpus of task's
> original rd->span, or I fear you can break clustered scheduling.

Ah, good point that, we must somehow find the right root domain to
'restore' the task to. Now I'm not entirely sure we still have this.
Lemme ponder that.
