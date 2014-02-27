Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaB0Jkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 04:40:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45257 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaB0Jki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:40:38 -0500
Date: Thu, 27 Feb 2014 10:40:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: don't use nutty scale_rt_power() output
Message-ID: <20140227094035.GZ9987@twins.programming.kicks-ass.net>
References: <1393229211.5599.72.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393229211.5599.72.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 09:06:51AM +0100, Mike Galbraith wrote:
> Hi Peter,
> 
> I wonder if the below makes sense for mainline.
> 
> Background: I received some rather surprising news recently, a user of
> old 2.6.32 kernels regularly receive log spam stemming from old 208 day
> era warnings/protections inserted to prevent explosions from what was at
> the time unknown bad juju happening (but don't report logs that look
> like graffiti artist with an unlimited supply of spray paint gone mad).
> 
> The kernel that emitted the below does NOT contain..
> 9993bc63 sched/x86: Fix overflow in cyc2ns_offset
> ..though these folks use kexec fwtw.  They're one of those "You update
> your kernel IFF world stops spinning" users, so will likely not be
> terribly interested in me making their boxen say BUG(), and may even be
> doing something naughty that induces it for all I know.
> 
> In any case, NOT using nutty output from the intentionally racy function
> seems like a good plan no matter who or what makes weird unreproducible
> (elsewhere) sh*t happen.  Wedging a bent 64 bit peg into 32 bit hole
> could make boom, on top of doing funny things to balancing. 
> 
> sched: don't use nutty scale_rt_power() output
> 
> Boxen instructed to gripe if they see nutty cpu_power catch us
> trashing it while seriously dazed and confused for an unknown reason.
> 
> Dec 18 05:50:56 kernel: [40091179.401405] update_group_power: cpu_power = 3148183471
> Dec 18 05:51:01 /usr/sbin/cron[2279]: (root) CMD (/opt/blah/fix_cdr_bin.job >> /opt/blah/fix_cdr_bin.out 2>&1)
> Dec 18 05:51:06 kernel: [40091189.455713] update_cpu_power: cpu_power = 19495027282; scale_rt = 19495027282
> Dec 18 05:51:16 kernel: [22076800.665578] update_cpu_power: cpu_power = 2671067611; scale_rt = 18428729677871137243
> Dec 18 05:51:16 kernel: [40091199.188773] update_cpu_power: cpu_power = 2675064501; scale_rt = 18428729677875134133
> 
> Don't do that, make a scary warning instead.
> 

Yeah, I'm in two minds about that. Crappy clocks can make a whole lot of
missery. Then again, we usually guard against them going backwards.

How about something like so? Most other sites don't complain about
clocks going backwards either, they just deal with it.

---
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5564,6 +5564,7 @@ static unsigned long scale_rt_power(int
 {
 	struct rq *rq = cpu_rq(cpu);
 	u64 total, available, age_stamp, avg;
+	s64 delta;
 
 	/*
 	 * Since we're reading these variables without serialization make sure
@@ -5572,7 +5573,11 @@ static unsigned long scale_rt_power(int
 	age_stamp = ACCESS_ONCE(rq->age_stamp);
 	avg = ACCESS_ONCE(rq->rt_avg);
 
-	total = sched_avg_period() + (rq_clock(rq) - age_stamp);
+	delta = rq_clock(rq) - age_stamp;
+	if (unlikely(delta < 0))
+		delta = 0;
+
+	total = sched_avg_period() + delta;
 
 	if (unlikely(total < avg)) {
 		/* Ensures that power won't end up being negative */
