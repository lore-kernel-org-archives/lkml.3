Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbaFIM7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 08:59:50 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:60568 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933386AbaFIM7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:36 -0400
X-Yandex-Uniq: 4e512a67-4ff6-4f12-9a02-a4f49ee4160c
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Mon, 9 Jun 2014 16:59:31 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: viresh.kumar@linaro.org, paul.gortmaker@windriver.com,
        peterz@infradead.org, stuart.w.hayes@gmail.com,
        david.vrabel@citrix.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] hrtimers: add fast path to hrtimer_get_next_event
Message-ID: <20140609125931.GL26511@stfomichev-desktop.yandex.net>
References: <1402305825-3015-1-git-send-email-stfomichev@yandex-team.ru>
 <alpine.DEB.2.10.1406091304140.3830@nanos>
 <20140609111115.GK26511@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609111115.GK26511@stfomichev-desktop.yandex.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hrtimer_get_next_event we unconditionally lock/unlock spinlock, even if it's
not required (hrtimer_hres_active() != 0). This patch adds fast path
when highres is active so we don't execute unnecessary operations.

We can safely do lockless check because:
- hrtimer_get_next_event is always called with interrupts disabled;
- we may switch to hres only from softirq handler with disabled interrupts.

Because we only care about hres_active which may be changed only from
local CPU, we can use interrupt context for synchronization.

run_timer_softirq
  hrtimer_run_pending
    hrtimer_switch_to_hres
      local_irq_save <-
      base->hres_active = 0

tick_nohz_idle_enter
  local_irq_disable <-
  __tick_nohz_idle_enter
    tick_nohz_stop_sched_tick
      get_next_timer_interrupt
        cmp_next_hrtimer_event
          hrtimer_get_next_event
          check base->hres_active

irq_exit <- irq context
  tick_irq_exit
    tick_nohz_irq_exit
      tick_nohz_full_stop_tick
        tick_nohz_stop_sched_tick
            ... <see above>
      __tick_nohz_idle_enter
        ... <see above>

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 kernel/hrtimer.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ba340739c701..731be91e927f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1167,23 +1167,24 @@ ktime_t hrtimer_get_next_event(void)
 	unsigned long flags;
 	int i;
 
+	if (hrtimer_hres_active())
+		return mindelta;
+
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 
-	if (!hrtimer_hres_active()) {
-		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
-			struct hrtimer *timer;
-			struct timerqueue_node *next;
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
+		struct hrtimer *timer;
+		struct timerqueue_node *next;
 
-			next = timerqueue_getnext(&base->active);
-			if (!next)
-				continue;
+		next = timerqueue_getnext(&base->active);
+		if (!next)
+			continue;
 
-			timer = container_of(next, struct hrtimer, node);
-			delta.tv64 = hrtimer_get_expires_tv64(timer);
-			delta = ktime_sub(delta, base->get_time());
-			if (delta.tv64 < mindelta.tv64)
-				mindelta.tv64 = delta.tv64;
-		}
+		timer = container_of(next, struct hrtimer, node);
+		delta.tv64 = hrtimer_get_expires_tv64(timer);
+		delta = ktime_sub(delta, base->get_time());
+		if (delta.tv64 < mindelta.tv64)
+			mindelta.tv64 = delta.tv64;
 	}
 
 	raw_spin_unlock_irqrestore(&cpu_base->lock, flags);
-- 
1.8.3.2

