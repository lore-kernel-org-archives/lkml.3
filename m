Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbaDNQZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:25:56 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40846 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbaDNQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:25:50 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 16/38] tick-common: don't pass cpumask to tick_setup_device()
Date: Mon, 14 Apr 2014 21:53:38 +0530
Message-Id: <41103d439bc01caa70bab32b3d1e84f48ef000f7.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_setup_device() is always passed cpumask of 'cpu', which is also passed as
parameter to this routine. So, just calculate the cpumask(cpu) in
tick_setup_device() instead of passing from every caller.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index c1b3619..c2aa441 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -145,9 +145,9 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
  * Setup the tick device
  */
 static void tick_setup_device(struct tick_device *td,
-			      struct clock_event_device *newdev, int cpu,
-			      const struct cpumask *cpumask)
+			      struct clock_event_device *newdev, int cpu)
 {
+	const struct cpumask *cpumask = cpumask_of(cpu);
 	ktime_t next_event;
 	void (*handler)(struct clock_event_device *) = NULL;
 
@@ -209,7 +209,7 @@ void tick_install_replacement(struct clock_event_device *newdev)
 	int cpu = smp_processor_id();
 
 	clockevents_exchange_device(td->evtdev, newdev);
-	tick_setup_device(td, newdev, cpu, cpumask_of(cpu));
+	tick_setup_device(td, newdev, cpu);
 	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_oneshot_notify();
 }
@@ -293,7 +293,7 @@ void tick_check_new_device(struct clock_event_device *newdev)
 		curdev = NULL;
 	}
 	clockevents_exchange_device(curdev, newdev);
-	tick_setup_device(td, newdev, cpu, cpumask_of(cpu));
+	tick_setup_device(td, newdev, cpu);
 	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_oneshot_notify();
 	return;
-- 
1.7.12.rc2.18.g61b472e

