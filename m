Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaCZLXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:23:04 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:55315 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaCZLW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:22:59 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 12/14] hrtimer: don't emulate notifier call to initialize timer base
Date: Wed, 26 Mar 2014 16:51:18 +0530
Message-Id: <7eb4d1a03031b4d873ce08e8912900d7936a3ca8.1395832156.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hrtimers_init() we need to call init_hrtimers_cpu() for boot CPU. For this,
currently we are emulating a call to hotplug notifier. Probably this was done
initially to get rid of code redundancy. But this sequence always called a
single routine, i.e. init_hrtimers_cpu(), and so calling that routine directly
would be better. This would get rid of emulating a notifier call, few typecasts
and the extra steps we are doing in notifier callback.

So, this patch calls init_hrtimers_cpu() directly from hrtimers_init().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index f14d861..39dbdbd 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1756,8 +1756,7 @@ static struct notifier_block hrtimers_nb = {
 
 void __init hrtimers_init(void)
 {
-	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
-			  (void *)(long)smp_processor_id());
+	init_hrtimers_cpu(smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
 #ifdef CONFIG_HIGH_RES_TIMERS
 	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
-- 
1.7.12.rc2.18.g61b472e

