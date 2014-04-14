Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbaDNQ0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:26:13 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:46997 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbaDNQZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:25:56 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 17/38] tick-common: call tick_install_replacement() from tick_check_new_device()
Date: Mon, 14 Apr 2014 21:53:39 +0530
Message-Id: <1673b3362965e31fb45482f5df9e59bfcc2e3f53.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of tick_check_new_device() is exactly same as what's being done by
tick_install_replacement(). And so we can actually call
tick_install_replacement() directly from tick_check_new_device() instead of
replicating code.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index c2aa441..bb9a218 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -272,9 +272,7 @@ bool tick_check_preferred(struct clock_event_device *curdev,
  */
 void tick_check_new_device(struct clock_event_device *newdev)
 {
-	int cpu = smp_processor_id();
-	struct tick_device *td = tick_get_device(cpu);
-	struct clock_event_device *curdev = td->evtdev;
+	struct clock_event_device *curdev = tick_get_cpu_device()->evtdev;
 
 	/* Preference decision */
 	if (!tick_check_preferred(curdev, newdev))
@@ -292,10 +290,8 @@ void tick_check_new_device(struct clock_event_device *newdev)
 		clockevents_shutdown(curdev);
 		curdev = NULL;
 	}
-	clockevents_exchange_device(curdev, newdev);
-	tick_setup_device(td, newdev, cpu);
-	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
-		tick_oneshot_notify();
+
+	tick_install_replacement(newdev);
 	return;
 
 out_bc:
-- 
1.7.12.rc2.18.g61b472e

