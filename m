Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936240AbaFIJXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:23:52 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:47615 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933562AbaFIJXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:23:50 -0400
X-Yandex-Uniq: 42b13bb2-f315-4a28-a8ef-0028c1417b25
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: tglx@linutronix.de, stfomichev@yandex-team.ru, viresh.kumar@linaro.org,
        paul.gortmaker@windriver.com, peterz@infradead.org,
        stuart.w.hayes@gmail.com, david.vrabel@citrix.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hrtimers: conditionally lock/unlock spinlock in hrtimer_get_next_event
Date: Mon,  9 Jun 2014 13:23:45 +0400
Message-Id: <1402305825-3015-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hrtimer_get_next_event we unconditionally lock/unlock spinlock, even if it's
not required (hrtimer_hres_active() != 0). This patch moves
locking/unlocking and mindelta range check inside the if clause,
so we don't execute unnecessary operations.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 kernel/hrtimer.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 39f339dcbe93..ce21e5f6bcf0 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1166,9 +1166,9 @@ ktime_t hrtimer_get_next_event(void)
 	unsigned long flags;
 	int i;
 
-	raw_spin_lock_irqsave(&cpu_base->lock, flags);
-
 	if (!hrtimer_hres_active()) {
+		raw_spin_lock_irqsave(&cpu_base->lock, flags);
+
 		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
 			struct hrtimer *timer;
 			struct timerqueue_node *next;
@@ -1183,12 +1183,13 @@ ktime_t hrtimer_get_next_event(void)
 			if (delta.tv64 < mindelta.tv64)
 				mindelta.tv64 = delta.tv64;
 		}
-	}
 
-	raw_spin_unlock_irqrestore(&cpu_base->lock, flags);
+		raw_spin_unlock_irqrestore(&cpu_base->lock, flags);
+
+		if (mindelta.tv64 < 0)
+			mindelta.tv64 = 0;
+	}
 
-	if (mindelta.tv64 < 0)
-		mindelta.tv64 = 0;
 	return mindelta;
 }
 #endif
-- 
1.8.3.2

