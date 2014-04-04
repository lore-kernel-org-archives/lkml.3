Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaDDGti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:49:38 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49289 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaDDGlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:41:16 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 15/36] hrtimer: don't emulate notifier call to initialize timer base
Date: Fri,  4 Apr 2014 12:05:58 +0530
Message-Id: <2af2580fcd9edf7faacfd33bdfdda79feb64384e.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hrtimers_init() we need to call init_hrtimers_cpu() for boot cpu. For this,
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
index 833db9f..5b0cbe7 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1753,8 +1753,7 @@ static struct notifier_block hrtimers_nb = {
 
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

