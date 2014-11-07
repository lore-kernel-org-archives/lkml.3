Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaKGOcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:32:33 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63449 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaKGObo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:31:44 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rjw@rjwysocki.net
Cc: preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, lenb@kernel.org
Subject: [PATCH V3 4/6] cpuidle: idle: menu: Don't reflect when a state selection failed
Date: Fri,  7 Nov 2014 15:31:25 +0100
Message-Id: <1415370687-18688-5-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current code, the check to reflect or not the outcoming state is done
against the idle state which has been chosen and its value.

Instead of doing a check in each of the reflect functions, just don't call reflect
if something went wrong in the idle path.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
---
 drivers/cpuidle/governors/ladder.c | 3 +--
 drivers/cpuidle/governors/menu.c   | 3 +--
 kernel/sched/idle.c                | 3 ++-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index 51c9ccd..86e4d49 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -165,8 +165,7 @@ static int ladder_enable_device(struct cpuidle_driver *drv,
 static void ladder_reflect(struct cpuidle_device *dev, int index)
 {
 	struct ladder_device *ldev = this_cpu_ptr(&ladder_devices);
-	if (index > 0)
-		ldev->last_state_idx = index;
+	ldev->last_state_idx = index;
 }
 
 static struct cpuidle_governor ladder_governor = {
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 91b3000..2e4a315 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -366,8 +366,7 @@ static void menu_reflect(struct cpuidle_device *dev, int index)
 {
 	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	data->last_state_idx = index;
-	if (index >= 0)
-		data->needs_update = 1;
+	data->needs_update = 1;
 }
 
 /**
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 0a7a1d1..0ae1cc8 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -173,7 +173,8 @@ use_default:
 	/*
 	 * Give the governor an opportunity to reflect on the outcome
 	 */
-	cpuidle_reflect(dev, entered_state);
+	if (entered_state >= 0)
+		cpuidle_reflect(dev, entered_state);
 
 exit_idle:
 	__current_set_polling();
-- 
1.9.1

