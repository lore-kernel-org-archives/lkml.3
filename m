Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaCVRBX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 13:01:23 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:58824 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaCVRBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 13:01:21 -0400
Date: Sat, 22 Mar 2014 18:01:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/3] workqueue: Add anon workqueue sysfs hierarchy
Message-ID: <20140322170114.GA20038@localhost.localdomain>
References: <1394815131-17271-1-git-send-email-fweisbec@gmail.com>
 <1394815131-17271-4-git-send-email-fweisbec@gmail.com>
 <7ha9csionc.fsf@paris.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ha9csionc.fsf@paris.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 12:08:39PM -0700, Kevin Hilman wrote:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> 
> > We call "anon workqueues" the set of unbound workqueues that don't
> > carry the WQ_SYSFS flag.
> >
> > They are a problem nowaday because people who work on CPU isolation
> > (HPC, Real time, etc...) want to be able to migrate all the unbound
> > workqueues away to a single CPU. This control is possible through sysfs
> > but only with WQ_SYSFS workqueues.
> >
> > Now we need to deal with the other unbound workqueues. There is two
> > possible solutions:
> >
> > 1) Implement a sysfs directory for each unbound !WQ_SYSFS. This could
> > be done with a specific Kconfig to make sure that these workqueue
> > won't be considered as a stable ABI. But we all know that all distros
> > will enable this Kconfig symbol and that a warning in the Kconfig help
> > text won't protect against anything.
> >
> > 2) Implement a single sysfs directory containing only the cpumask file
> > to the control the affinity of all the !WQ_SYSFS workqueues.
> >
> > This patch implements the second solution.
> >
> > Two issues I have seen though:
> >
> > * This triggers the following warning in apply_workqueue_attrs():
> >
> > 	/* creating multiple pwqs breaks ordering guarantee */
> > 	if (WARN_ON((wq->flags & __WQ_ORDERED) && !list_empty(&wq->pwqs)))
> > 		return -EINVAL;
> >
> >   I haven't yet checked into the details.
> 
> I tried to test this series and ran into this too for the kmmcd
> workqueue.  Looking at the commit that introduced this check, it looks
> changing attributes will break the ordering constraints[1], so it's
> prevented all together.  hmmm...

So I stared at this and it's indeed hard to get it correct. On workqueue creation
creation, apply_workqueue_attr() is called a first time to attach the worker pool
to it.

Non ordered workqueues seem to have a worker per NUMA while ordered workqueues
have the same worker for all CPUs (due to the no_numa forced to true). That's what
enforce the ordering.

So if we apply new attrs, the worker is replaced. But in the replacement process,
a work can be queued on the new worker while other work may execute on the old worker.

I have some random ideas to solve that but all of them imply performance issues:

1) Call a per workqueue mutex when a work execute on an ordered workqueue. Although
  contention should be very rare (only while we replace the workqueue attrs and
  switch to a new worker), frequent locking may have a visible impact.

2) Have a seperate worker for all ordered workqueues. But we may lose a bit of
  serialization with other workqueues along the way.

Actually the second solution could work since only ordered workqueue should use
the default global worker most of the time. Ah no wait, non-ordered workqueues
only allocate per node workers on NUMA...

Grrr.
