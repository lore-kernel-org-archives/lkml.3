Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3BUIKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:10:42 -0500
Received: from mout.gmx.net ([212.227.15.19]:64929 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab3BUIKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:10:41 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Pk6x+9VbPizThHobFpP9DKudIVwOMVgT079jxzF
	NYGNvYDkg+rqdq
Message-ID: <1361434231.5861.61.camel@marge.simpson.net>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 21 Feb 2013 09:10:31 +0100
In-Reply-To: <5125C607.8090909@linux.vnet.ibm.com>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com>
	 <1361427108.5861.41.camel@marge.simpson.net>
	 <5125C607.8090909@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 15:00 +0800, Michael Wang wrote: 
> On 02/21/2013 02:11 PM, Mike Galbraith wrote:
> > On Thu, 2013-02-21 at 12:51 +0800, Michael Wang wrote: 
> >> On 02/20/2013 06:49 PM, Ingo Molnar wrote:
> >> [snip]
> [snip]
> >>
> >> 	if wake_affine()
> >> 		new_cpu = select_idle_sibling(curr_cpu)
> >> 	else
> >> 		new_cpu = select_idle_sibling(prev_cpu)
> >>
> >> 	return new_cpu
> >>
> >> Actually that doesn't make sense.
> >>
> >> I think wake_affine() is trying to check whether move a task from
> >> prev_cpu to curr_cpu will break the balance in affine_sd or not, but why
> >> won't break balance means curr_cpu is better than prev_cpu for searching
> >> the idle cpu?
> > 
> > You could argue that it's impossible to break balance by moving any task
> > to any idle cpu, but that would mean bouncing tasks cross node on every
> > wakeup is fine, which it isn't.
> 
> I don't get it... could you please give me more detail on how
> wake_affine() related with bouncing?

If we didn't ever ask if it's ok, we'd always pull, and stack load up on
one package if there's the tiniest of holes to stuff a task into,
periodic balance forcibly rips buddies back apart, repeat.  At least
with wake_affine() in the loop, there's somewhat of a damper. 

> >> So the new logical in this patch set is:
> >>
> >> 	new_cpu = select_idle_sibling(prev_cpu)
> >> 	if idle_cpu(new_cpu)
> >> 		return new_cpu
> > 
> > So you tilted the scales in favor of leaving tasks in their current
> > package, which should benefit large footprint tasks, but should also
> > penalize light communicating tasks.
> 
> Yes, I'd prefer to wakeup the task on a cpu which:
> 1. idle
> 2. close to prev_cpu
> 
> So if both curr_cpu and prev_cpu have idle cpu in their topology, which
> one is better? that depends on how task benefit from cache and the
> balance situation, whatever, I don't think the benefit worth the high
> cost of wake_affine() in most cases...

We've always used wake_affine() before, yet been able to schedule at
high frequency, so I don't see that it can be _that_ expensive.  I
haven't actually measured lately (loooong time) though.

WRT cost/benefit of migration, yeah, it depends entirely on the tasks,
some will gain, some will lose.  On a modern single processor box, it
just doesn't matter, there's only one llc (two s_i_s() calls = oopsie),
but on my beloved old Q6600 or a big box, it'll matter a lot to
something.  NUMA balance will deal with big boxen, my trusty old Q6600
will likely get all upset with some localhost stuff.

-Mike

