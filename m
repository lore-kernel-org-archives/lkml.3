Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaDDGnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:43:31 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60673 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaDDGnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:43:18 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 36/36] timer: don't emulate notifier call to initialize timer base
Date: Fri,  4 Apr 2014 12:06:19 +0530
Message-Id: <2ad6493a8e3fb226b5b9dde6a95ed5de53f2a844.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In init_timers() we need to call init_timers_cpu() for boot cpu. For this,
currently we are emulating a call to hotplug notifier. Probably this was done
initially to get rid of code redundancy. But this sequence always called a
single routine, i.e. init_timers_cpu(), and so calling that routine directly
would be better. This would get rid of emulating a notifier call, few typecasts
and the extra steps we are doing in notifier callback.

So, this patch calls init_timers_cpu() directly from init_timers().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/timer.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 4360edc..d13eb56 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1666,15 +1666,9 @@ static struct notifier_block timers_nb = {
 
 void __init init_timers(void)
 {
-	int err;
-
 	/* ensure there are enough low bits for flags in timer->base pointer */
 	BUILD_BUG_ON(__alignof__(struct tvec_base) & TIMER_FLAG_MASK);
-
-	err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
-			       (void *)(long)smp_processor_id());
-	BUG_ON(err != NOTIFY_OK);
-
+	BUG_ON(init_timers_cpu(smp_processor_id()));
 	init_timer_stats();
 	register_cpu_notifier(&timers_nb);
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
-- 
1.7.12.rc2.18.g61b472e

