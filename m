Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaJTQ0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:26:37 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:62983 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaJTQZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:25:56 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rjw@rjwysocki.net
Cc: peterz@infradead.org, nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 3/5] cpuidle: idle: menu: Don't reflect when a state selection failed
Date: Mon, 20 Oct 2014 18:25:41 +0200
Message-Id: <1413822343-1972-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org>
References: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current code, the check to reflect or not the outcoming state is done
against the idle state which has been choose and its value.

Instead of doing a check in each of the reflect functions, just don't call reflect
if something went wrong in the idle path.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/governors/ladder.c | 3 +--
 drivers/cpuidle/governors/menu.c   | 4 +---
 kernel/sched/idle.c                | 3 ++-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index fb396d6..c0b36a8 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -165,8 +165,7 @@ static int ladder_enable_device(struct cpuidle_driver *drv,
 static void ladder_reflect(struct cpuidle_device *dev, int index)
 {
 	struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
-	if (index > 0)
-		ldev->last_state_idx = index;
+	ldev->last_state_idx = index;
 }
 
 static struct cpuidle_governor ladder_governor = {
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index a17515f..3907301 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -365,9 +365,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 static void menu_reflect(struct cpuidle_device *dev, int index)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
-	data->last_state_idx = index;
-	if (index >= 0)
-		data->needs_update = 1;
+	data->needs_update = 1;
 }
 
 /**
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index f439161..9ac7322 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -162,7 +162,8 @@ use_default:
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

