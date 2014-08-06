Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbaHFRBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:01:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47964 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbaHFRBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:01:54 -0400
Date: Wed, 6 Aug 2014 19:01:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: WARN_ON_ONCE(in_nmi()) hit in irq_work_queue_on
Message-ID: <20140806170151.GC12054@laptop.lan>
References: <20140806162113.GC14261@redhat.com>
 <20140806164633.GY3935@laptop>
 <20140806165610.GB12054@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806165610.GB12054@laptop.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sigh, that's d84153d6c96f61a so that's been there a while, and been
> broken equally long.
> 
> So this is where we run a low period (!freq) hardware event on a
> nohz_full cpu or so? And because it throttles, we need to kick the tick
> into action to unthrottle it.
> 
> I suppose there's a good reason I never build with that nohz_full
> nonsense enabled :/
> 
> Not sure how we should go fix that, you can't just issue random IPIs
> from NMI context.

OK, thinking one more second would've done it, how about so?

---
 include/linux/perf_event.h | 7 ++++---
 kernel/events/core.c       | 8 +++++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 707617a8c0f6..177411e3ffc4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -421,9 +421,10 @@ struct perf_event {
 	struct fasync_struct		*fasync;
 
 	/* delayed work for NMIs and such */
-	int				pending_wakeup;
-	int				pending_kill;
-	int				pending_disable;
+	int				pending_kill      : 16;
+	int				pending_wakeup    : 1;
+	int				pending_disable   : 1;
+	int				pending_nohz_kick : 1;
 	struct irq_work			pending;
 
 	atomic_t			event_limit;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1cf24b3e42ec..e95fca20e26f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4258,6 +4258,11 @@ static void perf_pending_event(struct irq_work *entry)
 		event->pending_wakeup = 0;
 		perf_event_wakeup(event);
 	}
+
+	if (event->pending_nohz_kick) {
+		event->pending_nohz_kick = 0;
+		tick_nohz_full_kick();
+	}
 }
 
 /*
@@ -5431,7 +5436,8 @@ static int __perf_event_overflow(struct perf_event *event,
 			__this_cpu_inc(perf_throttled_count);
 			hwc->interrupts = MAX_INTERRUPTS;
 			perf_log_throttle(event, 0);
-			tick_nohz_full_kick();
+			event->pending_nohz_kick = 1;
+			irq_work_queue(&event->pending);
 			ret = 1;
 		}
 	}
