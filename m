Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbaCNTIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:08:44 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59624 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbaCNTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:08:42 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/3] workqueue: Add anon workqueue sysfs hierarchy
References: <1394815131-17271-1-git-send-email-fweisbec@gmail.com>
	<1394815131-17271-4-git-send-email-fweisbec@gmail.com>
Date: Fri, 14 Mar 2014 12:08:39 -0700
In-Reply-To: <1394815131-17271-4-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Fri, 14 Mar 2014 17:38:51 +0100")
Message-ID: <7ha9csionc.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> We call "anon workqueues" the set of unbound workqueues that don't
> carry the WQ_SYSFS flag.
>
> They are a problem nowaday because people who work on CPU isolation
> (HPC, Real time, etc...) want to be able to migrate all the unbound
> workqueues away to a single CPU. This control is possible through sysfs
> but only with WQ_SYSFS workqueues.
>
> Now we need to deal with the other unbound workqueues. There is two
> possible solutions:
>
> 1) Implement a sysfs directory for each unbound !WQ_SYSFS. This could
> be done with a specific Kconfig to make sure that these workqueue
> won't be considered as a stable ABI. But we all know that all distros
> will enable this Kconfig symbol and that a warning in the Kconfig help
> text won't protect against anything.
>
> 2) Implement a single sysfs directory containing only the cpumask file
> to the control the affinity of all the !WQ_SYSFS workqueues.
>
> This patch implements the second solution.
>
> Two issues I have seen though:
>
> * This triggers the following warning in apply_workqueue_attrs():
>
> 	/* creating multiple pwqs breaks ordering guarantee */
> 	if (WARN_ON((wq->flags & __WQ_ORDERED) && !list_empty(&wq->pwqs)))
> 		return -EINVAL;
>
>   I haven't yet checked into the details.

I tried to test this series and ran into this too for the kmmcd
workqueue.  Looking at the commit that introduced this check, it looks
changing attributes will break the ordering constraints[1], so it's
prevented all together.  hmmm...

Kevin

[1]
commit 8719dceae2f98a578507c0f6b49c93f320bd729c
Author: Tejun Heo <tj@kernel.org>
Date:   Tue Mar 12 11:30:04 2013 -0700

workqueue: reject adjusting max_active or applying attrs to ordered
workqueues

Adjusting max_active of or applying new workqueue_attrs to an ordered
workqueue breaks its ordering guarantee.  The former is obvious.  The
latter is because applying attrs creates a new pwq (pool_workqueue) and
there is no ordering constraint between the old and new pwqs.

Make apply_workqueue_attrs() and workqueue_set_max_active() trigger
WARN_ON() if those operations are requested on an ordered workqueue
and fail / ignore respectively.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
