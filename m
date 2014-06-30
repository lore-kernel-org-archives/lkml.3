Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaF3J1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:27:37 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35361 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaF3J1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:27:36 -0400
Message-ID: <1404120453.5132.194.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jun 2014 11:27:33 +0200
In-Reply-To: <53B12417.9060904@linux.vnet.ibm.com>
References: <53A11A89.5000602@linux.vnet.ibm.com>
	 <53B11387.9020001@linux.vnet.ibm.com>
	 <1404115601.5132.156.camel@marge.simpson.net>
	 <53B12417.9060904@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-30 at 16:47 +0800, Michael wang wrote: 
> Hi, Mike :)
> 
> On 06/30/2014 04:06 PM, Mike Galbraith wrote:
> > On Mon, 2014-06-30 at 15:36 +0800, Michael wang wrote: 
> >> On 06/18/2014 12:50 PM, Michael wang wrote:
> >>> By testing we found that after put benchmark (dbench) in to deep cpu-group,
> >>> tasks (dbench routines) start to gathered on one CPU, which lead to that the
> >>> benchmark could only get around 100% CPU whatever how big it's task-group's
> >>> share is, here is the link of the way to reproduce the issue:
> >>
> >> Hi, Peter
> >>
> >> We thought that involved too much factors will make things too
> >> complicated, we are trying to start over and get rid of the concepts of
> >> 'deep-group' and 'GENTLE_FAIR_SLEEPERS' in the idea, wish this could
> >> make things more easier...
> > 
> > While you're getting rid of the concept of 'GENTLE_FAIR_SLEEPERS', don't
> > forget to also get rid of the concept of 'over-scheduling' :)
> 
> I'm new to this word... could you give more details on that?

Massive context switching.  When heavily overloaded, wakeup preemption
tends to hurt.  Trouble being that when overloaded, that's when
fast/light tasks also need to get in and back out quickly the most. 

> > That gentle thing isn't perfect (is the enemy of good), but preemption
> > model being based upon sleep, while nice and simple, has the unfortunate
> > weakness that as contention increases, so does the quantity of sleep in
> > the system.  Would be nice to come up with an alternative preemption
> > model as dirt simple as this one, but lacking the inherent weakness.
> 
> The preemtion based on vruntime sounds fair enough, but vruntime-bonus
> for wakee do need few more thinking... although I don't want to count
> the gentle-stuff in any more, but disable it do help dbench a lot...

It's scaled, but that's not really enough.  Zillion tasks can sleep in
parallel, and when they are doing that, sleep time becomes a rather
meaningless preemption yardstick.  It's only meaningful when there is a
significant delta between task behaviors.  When running a homogeneous
load of sleepers, eg a zillion java threads all doing the same damn
thing, you're better off turning wakeup preemption off, because trying
to smooth out microscopic vruntime deltas via wakeup preemption then
does nothing but trashes caches.

-Mike

