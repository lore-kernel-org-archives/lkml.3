Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaC1Ll5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:41:57 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:33217 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaC1Lly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:41:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 01/16] hrtimer: move unlock_hrtimer_base() upwards
Date: Fri, 28 Mar 2014 17:11:20 +0530
Message-Id: <a576aa9824d480c67a5f382b96875b062ed8dac1.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unlock_hrtimer_base() was handled specially at a separate place earlier as
lock_hrtimer_base() had separate definitions for SMP and non-SMP cases, but
unlock_hrtimer_base() had only a single definition. And so probably it was kept
at the end of this #ifdef/endif CONFIG_SMP. But this #ifdef ends right after
lock_hrtimer_base()'s definition and so we can move unlock_hrtimer_base()
upwards, i.e. closer to its counterparts. This improves readability of the code.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e486a14..a710638 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -253,6 +253,12 @@ lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 
 #endif	/* !CONFIG_SMP */
 
+static inline
+void unlock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
+{
+	raw_spin_unlock_irqrestore(&timer->base->cpu_base->lock, *flags);
+}
+
 /*
  * Functions for the union type storage format of ktime_t which are
  * too large for inlining:
@@ -801,15 +807,6 @@ static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
 #endif
 }
 
-/*
- * Counterpart to lock_hrtimer_base above:
- */
-static inline
-void unlock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
-{
-	raw_spin_unlock_irqrestore(&timer->base->cpu_base->lock, *flags);
-}
-
 /**
  * hrtimer_forward - forward the timer expiry
  * @timer:	hrtimer to forward
-- 
1.7.12.rc2.18.g61b472e

