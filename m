Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaJCOrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:47:00 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43728 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaJCOq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:46:57 -0400
Date: Fri, 3 Oct 2014 16:46:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH RFC] sched,idle: teach select_idle_sibling about idle
 states
Message-ID: <20141003144651.GI10583@worktop.programming.kicks-ass.net>
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org>
 <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org>
 <542B277D.7050103@redhat.com>
 <alpine.LFD.2.11.1409301904150.5311@knanqh.ubzr>
 <20141002131548.6cd377d5@cuia.bos.redhat.com>
 <1412317384.5149.19.camel@marge.simpson.net>
 <20141003075012.GF10583@worktop.programming.kicks-ass.net>
 <542EB29A.2050704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542EB29A.2050704@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 10:28:42AM -0400, Rik van Riel wrote:
> We have 3 different goals when selecting a runqueue for a task:
> 1) locality: get the task running close to where it has stuff cached
> 2) work preserving: get the task running ASAP, and preferably on a
>    fully idle core
> 3) idle state latency: place the task on a CPU that can start running
>    it ASAP

3 can also be considered part of power aware, seeing how it will try and
let CPUs reach their deep idle potential.

> We may also consider the interplay of the above 3 to have an impact on
> 4) power use: pack tasks on some CPUs so other CPUs can go into deeper
>    idle states
> 
> The current implementation is a "compromise" between (1) and (2),
> with a strong preference for (2), falling back to (1) if no fully
> idle core is found.
> 
> My ugly hack isn't any better, trading off (1) in order to be better
> at (2) and (3). Whether it even affects (4) remains to be seen.
> 
> I know my patch is probably unacceptable, but I do think it is important
> that we talk about the problem, and hopefully agree on exactly what the
> problem is that we want to solve.

Yeah, we've been through this several times, it basically boils down to
the amount of fail vs win on 'various' workloads. The endless problem is
of course that the fail vs win ratio is entirely workload dependent and
as ever there is no comprehensive set.

The last time this came up was when Mike tried to do his cache buddy
idea, which basically reduced things to only looking at 2 cpus. That
make some things fly and some things tank.

> One big question in my mind is, when is locality more important, and
> when is work preserving more important?  Do we have an answer to that
> question?

Typically 2) is important when there's lots of short running tasks
around, any queueing typically destroys throughput in that case.

> The current code has the potential to be quite painful on systems with
> a large number of cores per chip, so we will have to change things
> anyway...

What I said.. so far we've failed at coming up with anything sane
though, so far we've found that 2 cpus is too small a slice to look at
and we're fairly sure 18/36 is too large :-)
