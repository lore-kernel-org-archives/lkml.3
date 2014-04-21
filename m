Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaDUJ4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:56:43 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51677 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaDUJ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:56:34 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 12/19] tick-common: don't pass 'cpu' & 'cpumask' to tick_setup_device()
Date: Mon, 21 Apr 2014 15:25:08 +0530
Message-Id: <acd540da2c350029b45b9467815dce910b18c866.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_setup_device() is always passed cpumask of 'cpu' and 'cpu' is always
obtained from smp_processor_id(). Remove these two parameters and obtain them in
tick_setup_device() instead.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 896c992..85ee9fd 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -145,9 +145,10 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
  * Setup the tick device
  */
 static void tick_setup_device(struct tick_device *td,
-			      struct clock_event_device *newdev, int cpu,
-			      const struct cpumask *cpumask)
+			      struct clock_event_device *newdev)
 {
+	int cpu = smp_processor_id();
+	const struct cpumask *cpumask = cpumask_of(cpu);
 	ktime_t next_event;
 	void (*handler)(struct clock_event_device *) = NULL;
 
@@ -206,10 +207,9 @@ static void tick_setup_device(struct tick_device *td,
 void tick_install_replacement(struct clock_event_device *newdev)
 {
 	struct tick_device *td = tick_get_cpu_device();
-	int cpu = smp_processor_id();
 
 	clockevents_exchange_device(td->evtdev, newdev);
-	tick_setup_device(td, newdev, cpu, cpumask_of(cpu));
+	tick_setup_device(td, newdev);
 	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_oneshot_notify();
 }
@@ -287,7 +287,7 @@ void tick_check_new_device(struct clock_event_device *newdev)
 		curdev = NULL;
 	}
 	clockevents_exchange_device(curdev, newdev);
-	tick_setup_device(td, newdev, cpu, cpumask_of(cpu));
+	tick_setup_device(td, newdev);
 	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_oneshot_notify();
 	return;
-- 
1.7.12.rc2.18.g61b472e

