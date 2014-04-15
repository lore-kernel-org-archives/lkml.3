Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaDOFZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:25:14 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:61044 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaDOFZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:25:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V1 Resend 3/5] tick-common: do additional checks in tick_check_preferred()
Date: Tue, 15 Apr 2014 10:54:39 +0530
Message-Id: <6fee05309c65f68120bfaed6c68a952157b5da5e.1397537987.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397537986.git.viresh.kumar@linaro.org>
References: <cover.1397537986.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397537986.git.viresh.kumar@linaro.org>
References: <cover.1397537986.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We return false from tick_check_preferred() if newdev doesn't have ONESHOT
feature but curdev has, but we don't return true when newdev has ONESHOT and
curdev doesn't. Instead we go on, check ratings and other things in that case.

This patch tries to fix this by rewriting some portion of this code and adds
sufficient comments to make logic clear.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 69cab28..2f13889 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -252,18 +252,29 @@ static bool tick_check_percpu(struct clock_event_device *curdev,
 static bool tick_check_preferred(struct clock_event_device *curdev,
 				 struct clock_event_device *newdev)
 {
-	/* Prefer oneshot capable device */
-	if (!(newdev->features & CLOCK_EVT_FEAT_ONESHOT)) {
-		if (curdev && (curdev->features & CLOCK_EVT_FEAT_ONESHOT))
-			return false;
-	}
+	if (!curdev)
+		return true;
+
+	/*
+	 * Prefer oneshot capable device.
+	 * return values based on if ONESHOT is available or not:
+	 *
+	 * curdev	newdev		operation
+	 * 0		0		check priority
+	 * 0		1		return true
+	 * 1		0		return false
+	 * 1		1		check priority
+	 */
+
+	if ((newdev->features & CLOCK_EVT_FEAT_ONESHOT) ^
+		(curdev->features & CLOCK_EVT_FEAT_ONESHOT))
+		return newdev->features & CLOCK_EVT_FEAT_ONESHOT;
 
 	/*
 	 * Use the higher rated one, but prefer a CPU local device with a lower
 	 * rating than a non-CPU local device
 	 */
-	return !curdev ||
-		newdev->rating > curdev->rating ||
+	return newdev->rating > curdev->rating ||
 	       !cpumask_equal(curdev->cpumask, newdev->cpumask);
 }
 
-- 
1.7.12.rc2.18.g61b472e

