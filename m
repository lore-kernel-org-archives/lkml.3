Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162556AbaDCIC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:02:27 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36505 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162417AbaDCICV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:02:21 -0400
Message-ID: <1396512138.5404.32.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: update_rq_clock() must skip ONE update
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 03 Apr 2014 10:02:18 +0200
In-Reply-To: <20140401095548.GB1299@gmail.com>
References: <1396164244.28950.15.camel@marge.simpson.net>
	 <CA+55aFzGVLTiD5QVqZ6YK41b9n0SUxDGD3+yE9CuGJek2U-+MQ@mail.gmail.com>
	 <1396239636.5361.57.camel@marge.simpson.net>
	 <CA+55aFywHpvUfghS4GFc3UC1WGZx3Of+zeKHxmRNcMQMoKoiJQ@mail.gmail.com>
	 <1396290426.5261.80.camel@marge.simpson.net>
	 <CA+55aFwdosGtoh8=krpx9C-fT-H7OHsC0UVyXc8aNE7h=W1RxQ@mail.gmail.com>
	 <1396322880.5324.37.camel@marge.simpson.net>
	 <20140401095548.GB1299@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 11:55 +0200, Ingo Molnar wrote: 
> * Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> 
> > On Mon, 2014-03-31 at 11:37 -0700, Linus Torvalds wrote: 
> > > On Mon, Mar 31, 2014 at 11:27 AM, Mike Galbraith
> > > <umgwanakikbuti@gmail.com> wrote:
> > > >
> > > > Oh, I didn't cc you because I wanted it applied instantly as ultra
> > > > critical, only because the chain of events might be of interest.
> > > 
> > > Ok. That was my main worry, since I was in the process or releasing
> > > 3.14, and I just couldn't tell if the patch was something I should
> > > worry about or not.
> > > 
> > > And it seems that not applying it was the right thing, which is all
> > > that matters by now.
> > 
> > Yes.  Jocular red flag was to Peter and Ingo.  I don't try to bypass 
> > them, that would be plain rude.  I've been known to help maintainers 
> > a little, but I don't ever try to call the shots.  They do that 
> > well.
> 
> Btw., in general feel free to Cc: Linus if a fix looks truly urgent, 
> as neither Peter nor me might be around on a weekend, shortly before a 
> release.

Still not urgent, but now verified to have fixed the large IO beast boot
problem.  'course that implies that disk discovery may generate truly
magnificent wakeup latency.. for the throttle to helpfully double.

---cut here---

Prevent large wakeup latencies from being accounted to the wrong task.

Cc: <stable@vger.kernel.org>
Signed-off-by: 	Mike Galbraith <umgwanakikbuti@gmail.com>
---
 kernel/sched/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -118,7 +118,12 @@ void update_rq_clock(struct rq *rq)
 {
 	s64 delta;
 
-	if (rq->skip_clock_update > 0)
+	/*
+	 * Set during wakeup to indicate we are on the way to schedule().
+	 * Decrement to ensure that a very large latency is not accounted
+	 * to the wrong task.
+	 */
+	if (rq->skip_clock_update-- > 0)
 		return;
 
 	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;


