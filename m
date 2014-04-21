Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaDUJ77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:59:59 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:35803 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaDUJ4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:56:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 10/19] tick-common: call tick_check_percpu() from tick_check_preferred()
Date: Mon, 21 Apr 2014 15:25:06 +0530
Message-Id: <37a6c338869c26a16f5fd9d6b33c1aa68ffc2c59.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_check_percpu() and tick_check_preferred() are called from two places and in
exactly same order. So, would make sense to call tick_check_percpu() from
tick_check_preferred() instead, so that their caller can just call
tick_check_preferred().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 965e9c3..9d3106b 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -233,6 +233,9 @@ static bool tick_check_percpu(struct clock_event_device *curdev,
 static bool tick_check_preferred(struct clock_event_device *curdev,
 				 struct clock_event_device *newdev)
 {
+	if (!tick_check_percpu(curdev, newdev, smp_processor_id()))
+		return false;
+
 	/* Prefer oneshot capable device */
 	if (!(newdev->features & CLOCK_EVT_FEAT_ONESHOT)) {
 		if (curdev && (curdev->features & CLOCK_EVT_FEAT_ONESHOT))
@@ -257,9 +260,6 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
 bool tick_check_replacement(struct clock_event_device *curdev,
 			    struct clock_event_device *newdev)
 {
-	if (!tick_check_percpu(curdev, newdev, smp_processor_id()))
-		return false;
-
 	return tick_check_preferred(curdev, newdev);
 }
 
@@ -276,10 +276,6 @@ void tick_check_new_device(struct clock_event_device *newdev)
 	if (!cpumask_test_cpu(cpu, newdev->cpumask))
 		goto out_bc;
 
-	/* cpu local device ? */
-	if (!tick_check_percpu(curdev, newdev, cpu))
-		goto out_bc;
-
 	/* Preference decision */
 	if (!tick_check_preferred(curdev, newdev))
 		goto out_bc;
-- 
1.7.12.rc2.18.g61b472e

