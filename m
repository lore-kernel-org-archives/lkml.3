Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaFGJ4F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 05:56:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46532 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaFGJ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 05:56:03 -0400
Date: Sat, 7 Jun 2014 11:55:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, svaidy@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: governor: Be friendly towards
 latency-sensitive bursty workloads
Message-ID: <20140607095559.GA23815@amd.pavel.ucw.cz>
References: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> We just want to avoid the stupidity of dropping down the frequency to a minimum
> and then enduring a needless (and long) delay before ramping it up back again.
> So, let us simply carry forward the previous load - that is, let us just pretend
> that the 'load' for the current time-window is the same as the load for the
> previous window. That way, the frequency and voltage will continue to be set
> to whatever values they were set at previously. This means that bursty workloads
> will get a chance to influence the CPU frequency at which they wake up from
> cpu-idle, based on their past execution history. Thus, they might be able to
> avoid suffering from slow wakeups and long response-times.
> 
> [ The right way to solve this problem is to teach the CPU frequency governors
> to track load on a per-task basis, not a per-CPU basis, and set the appropriate
> frequency on whichever CPU the task executes. But that involves redesigning
> the cpufreq subsystem, so this patch should make the situation bearable until
> then. ]

Are you sure? For example "./configure" load consists of a lot of
short-lived tasks. Per-task basis may not be option for that.

> A rudimentary and somewhat approximately latency-sensitive workload such as
> sleeping-ebizzy itself showed a consistent, noticeable performance improvement
> with this patch. Hence, workloads that are truly latency-sensitive will benefit
> quite a bit from this change. Moreover, this is an overall win-win since this
> patch does not hurt power-savings at all (because, this patch does not reduce
> the idle time or idle residency; and the high frequency of the CPU when it goes
> to cpu-idle does not affect/hurt the power-savings of deep idle
> states).

Are you sure about win-win?

AFAICT, your patch helps

##########.........#########.........###########...........##########............

case (not surprising, that's why you wrote the patch :-), but what happens in

##########.........#.................#.....................#.....................

case? (That is idle system, with some tasks taking very small ammounts
of CPU).

AFAICT, it will remember the (high) prev_load over the idle period,
and use too high frequency for mostly idle system, no?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
