Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3BUGMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 01:12:00 -0500
Received: from mout.gmx.net ([212.227.15.18]:55306 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab3BUGL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 01:11:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/D5Z0Pe3PD4VBCyz42w3L0M8J90yPhi2R7QEkeGy
	9nvM2kgo3Emn2K
Message-ID: <1361427108.5861.41.camel@marge.simpson.net>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 21 Feb 2013 07:11:48 +0100
In-Reply-To: <5125A7C8.8020308@linux.vnet.ibm.com>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 12:51 +0800, Michael Wang wrote: 
> On 02/20/2013 06:49 PM, Ingo Molnar wrote:
> [snip]
> > 
> > The changes look clean and reasoable, any ideas exactly *why* it 
> > speeds up?
> > 
> > I.e. are there one or two key changes in the before/after logic 
> > and scheduling patterns that you can identify as causing the 
> > speedup?
> 
> Hi, Ingo
> 
> Thanks for your reply, please let me point out the key changes here
> (forgive me for haven't wrote a good description in cover).
> 
> The performance improvement from this patch set is:
> 1. delay the invoke on wake_affine().
> 2. save the circle to gain proper sd.
> 
> The second point is obviously, and will benefit a lot when the sd
> topology is deep (NUMA is suppose to make it deeper on large system).
> 
> So in my testing on a 12 cpu box, actually most of the benefit comes
> from the first point, and please let me introduce it in detail.
> 
> The old logical when locate affine_sd is:
> 
> 	if prev_cpu != curr_cpu
> 		if wake_affine()
> 			prev_cpu = curr_cpu
> 	new_cpu = select_idle_sibling(prev_cpu)
> 	return new_cpu
> 
> The new logical is same to the old one if prev_cpu == curr_cpu, so let's
> simplify the old logical like:
> 
> 	if wake_affine()
> 		new_cpu = select_idle_sibling(curr_cpu)
> 	else
> 		new_cpu = select_idle_sibling(prev_cpu)
> 
> 	return new_cpu
> 
> Actually that doesn't make sense.
> 
> I think wake_affine() is trying to check whether move a task from
> prev_cpu to curr_cpu will break the balance in affine_sd or not, but why
> won't break balance means curr_cpu is better than prev_cpu for searching
> the idle cpu?

You could argue that it's impossible to break balance by moving any task
to any idle cpu, but that would mean bouncing tasks cross node on every
wakeup is fine, which it isn't.

> So the new logical in this patch set is:
> 
> 	new_cpu = select_idle_sibling(prev_cpu)
> 	if idle_cpu(new_cpu)
> 		return new_cpu

So you tilted the scales in favor of leaving tasks in their current
package, which should benefit large footprint tasks, but should also
penalize light communicating tasks.

I suspect that much of the pgbench improvement comes from the preemption
mitigation from keeping 1:N load maximally spread, which is the perfect
thing to do with such loads.  In all the testing I ever did with it in
1:N mode, preemption dominated performance numbers.  Keep server away
from clients, it has fewer fair competition worries, can consume more
CPU preemption free, pushing the load collapse point strongly upward.

-Mike

