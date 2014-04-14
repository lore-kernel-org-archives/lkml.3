Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbaDNQZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:25:49 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33204 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbaDNQZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:25:39 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 14/38] tick-common: do additional checks in tick_check_preferred()
Date: Mon, 14 Apr 2014 21:53:36 +0530
Message-Id: <212d5ff77b5ffef9d80b1f3d7d0bb5f42cb2ffc6.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
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
index 3dc31f5..3bd9f9c 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -236,18 +236,29 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
 	if (!tick_check_percpu(curdev, newdev, smp_processor_id()))
 		return false;
 
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

