Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaCaEUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 00:20:40 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57750 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaCaEUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 00:20:39 -0400
Message-ID: <1396239636.5361.57.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: update_rq_clock() must skip ONE update
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 31 Mar 2014 06:20:36 +0200
In-Reply-To: <CA+55aFzGVLTiD5QVqZ6YK41b9n0SUxDGD3+yE9CuGJek2U-+MQ@mail.gmail.com>
References: <1396164244.28950.15.camel@marge.simpson.net>
	 <CA+55aFzGVLTiD5QVqZ6YK41b9n0SUxDGD3+yE9CuGJek2U-+MQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-30 at 17:12 -0700, Linus Torvalds wrote: 
> The patch looks fine, but the changelog is so chock-full of odd
> language that I don't know what to do with the patch.
> 
> Is this actually a problem in real life, or just in the drug-induced
> wonderland that Mike was in when writing the changelog?

Point of being verbose was to make sure it was clear exactly how this
harmless little bug selectively kills large IO boxen.. and yeah, I'm
pretty sure this was in the real world, but hey, ya never know, looney
bins are full of people who think they're operating in the real world.

Whatever, I suppose the data suffices.  Magnitudes, their sources and
consequences are irrelevant to the bean counting buglet itself. 

        modprobe-134   [000]     5.027903: update_rq_clock <-scheduler_tick
        modprobe-134   [000]     5.037857: update_rq_clock <-scheduler_tick
        modprobe-134   [000]     5.037864: update_rq_clock <-enqueue_task
        modprobe-134   [000]     5.037866: enqueue_task_watchdog: WATCHDOG/0 enqueue 4915630446
        modprobe-134   [000]     5.044965: update_rq_clock <-scheduler_tick
        modprobe-134   [000]     5.046275: update_rq_clock <-scheduler_tick
        modprobe-134   [000]     5.050274: update_rq_clock <-scheduler_tick
        modprobe-134   [000]     5.052862: update_rq_clock <-dequeue_task
        modprobe-134   [000]     5.052866: pick_next_task_watchdog: WATCHDOG/0 select 4915630446
      watchdog/0-7     [000]     5.052868: finish_task_switch: WATCHDOG/0 runs 5052867644
      watchdog/0-7     [000]     5.052869: watchdog: WATCHDOG/0 DELAYED 137238048 max: 137238048
      watchdog/0-7     [000]     5.052872: update_rq_clock <-dequeue_task
      watchdog/0-7     [000]     5.052873: dequeue_task_watchdog: WATCHDOG/0 dequeue 5052872018
      watchdog/0-7     [000]     5.052874: put_prev_task_watchdog: WATCHDOG/0 STOP trace : delta_exec 137241572 sum_exec 137254287

Cc: <stable@vger.kernel.org>
Signed-off-by: 	Mike Galbraith <umgwanakikbuti@gmail.com>
---
 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -118,7 +118,7 @@ void update_rq_clock(struct rq *rq)
 {
 	s64 delta;
 
-	if (rq->skip_clock_update > 0)
+	if (rq->skip_clock_update-- > 0)
 		return;
 
 	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;



