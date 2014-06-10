Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaFJJqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:46:53 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:60424 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbaFJJqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:46:50 -0400
X-Yandex-Uniq: db93db32-e48e-4545-bc17-eb7bc0de3d83
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 10 Jun 2014 13:46:45 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: viresh.kumar@linaro.org, paul.gortmaker@windriver.com,
        peterz@infradead.org, stuart.w.hayes@gmail.com,
        david.vrabel@citrix.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3] hrtimers: add fast path to hrtimer_get_next_event
Message-ID: <20140610094645.GN26511@stfomichev-desktop.yandex.net>
References: <1402305825-3015-1-git-send-email-stfomichev@yandex-team.ru>
 <alpine.DEB.2.10.1406091304140.3830@nanos>
 <20140609111115.GK26511@stfomichev-desktop.yandex.net>
 <20140609125931.GL26511@stfomichev-desktop.yandex.net>
 <alpine.DEB.2.10.1406091635080.3830@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406091635080.3830@nanos>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sigh. Is anybody actually reading and trying to understand what I
> write in reviews?
> 
> > Also the lockless check wants a comment why it is correct.
> 
> Is it that hard? A comment is NOT a uberlenghty explanation in the
> changelog. A comment starts with /* and ends with */ and is in the
> code.
> 
> 	/*
> 	 * Called with interrupts disabled and therefor
> 	 * protected against a switch to high resolution mode.
> 	 */
>  
> That's a comment, right?
Duh, I honestly thought you were talking about more details in the
changelog. How come you didn't like it? Piece of art :-)

Anyway, here is another respin of the patch.
Btw, maybe it also makes sense to convert _irqsave spinlocks to non-irq
ones? If we now have a comment telling we are called with interrupts
disabled, there is no way we need irq safe locks, right?

--

In hrtimer_get_next_event we unconditionally lock/unlock spinlock, even if it's
not required (hrtimer_hres_active() != 0). This patch adds fast path
when highres is active so we don't execute unnecessary operations.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 kernel/hrtimer.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ba340739c701..245c90e5626b 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1167,23 +1167,28 @@ ktime_t hrtimer_get_next_event(void)
 	unsigned long flags;
 	int i;
 
+	/*
+	 * Called with interrupts disabled and therefore
+	 * protected against a switch to high resolution mode.
+	 */
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

