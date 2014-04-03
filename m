Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaDCP7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:59:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65480 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbaDCP7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:59:43 -0400
Date: Thu, 3 Apr 2014 17:59:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 4/4] workqueue: Include ordered workqueues in anon
 workqueue sysfs interface
Message-ID: <20140403155917.GI23338@localhost.localdomain>
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
 <1395940862-31428-5-git-send-email-fweisbec@gmail.com>
 <533964AE.9070503@cn.fujitsu.com>
 <53396A6E.4030607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53396A6E.4030607@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 09:15:26PM +0800, Lai Jiangshan wrote:
> On 03/31/2014 08:50 PM, Lai Jiangshan wrote:
> 
> Sorry, I'm wrong.
> Tejun had told there is only one default worker pool for ordered workqueues.
> 
> It is true. But this pool may share with other non-ordered workqueues which
> maybe have WQ_SYSFS. we should split this pool into two pools.
> one for ordered wqs, one for the rest.

Ah good point, there is a side effect here. Ok the idea of a low level unbound cpumask
should solve that issue as we want every unbound workqueues to be concerned.

[...]
> >> +/* Must be called with wq_unbound_mutex held */
> >> +static int wq_anon_cpumask_set_all(cpumask_var_t cpumask)
> >> +{
> >>  	struct workqueue_struct *wq;
> >>  	int ret;
> >>  
> >> @@ -3343,15 +3393,9 @@ static int wq_anon_cpumask_set(cpumask_var_t cpumask)
> >>  			continue;
> >>  		/* Ordered workqueues need specific treatment */
> >>  		if (wq->flags & __WQ_ORDERED)
> >> -			continue;
> >> -
> >> -		attrs = wq_sysfs_prep_attrs(wq);
> >> -		if (!attrs)
> >> -			return -ENOMEM;
> >> -
> >> -		cpumask_copy(attrs->cpumask, cpumask);
> >> -		ret = apply_workqueue_attrs(wq, attrs);
> >> -		free_workqueue_attrs(attrs);
> >> +			ret = wq_ordered_cpumask_set(wq, cpumask);
> 
> 
> 
> After the pool is split. wq_ordered_cpumask_set() should only be called once.
> once is enough for all ordered wqs.

True. I was just worried that the implementation changes in the future and some
ordered unbound workqueues get their own private pool in case we have problems
with works of a workqueue blocking works of another workqueue while they wait on
heavy resources.

The workqueue subsystem usually deals with that by launching new workers on demand
to handle waiting works in the queue. But it doesn't seem to apply on ordered unbound
workqueues because they have max_active=1, so they can't spawn another worker if there
is a work blocking the others. So I wouldn't be surprised if such an issue is resolved
by using private pools on some ordered workqueues.

IIUC.
