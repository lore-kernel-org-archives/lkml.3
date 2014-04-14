Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaDNQZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:25:21 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52488 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026AbaDNQZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:25:14 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 10/38] tick-common: remove extra checks from tick_check_new_device()
Date: Mon, 14 Apr 2014 21:53:32 +0530
Message-Id: <62394f8427b11f7e365870eda7801a277c697eb0.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_check_new_device() is calling tick_check_percpu() which has this as the
first test:

	if (!cpumask_test_cpu(cpu, newdev->cpumask))
		return false;

And so the same isn't required to be repeated by tick_check_new_device(). Remove
it.

This also initializes several variables during their definition only.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 949f3d3..395cbbd 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -269,16 +269,9 @@ bool tick_check_replacement(struct clock_event_device *curdev,
  */
 void tick_check_new_device(struct clock_event_device *newdev)
 {
-	struct clock_event_device *curdev;
-	struct tick_device *td;
-	int cpu;
-
-	cpu = smp_processor_id();
-	if (!cpumask_test_cpu(cpu, newdev->cpumask))
-		goto out_bc;
-
-	td = tick_get_device(cpu);
-	curdev = td->evtdev;
+	int cpu = smp_processor_id();
+	struct tick_device *td = tick_get_device(cpu);
+	struct clock_event_device *curdev = td->evtdev;
 
 	/* cpu local device ? */
 	if (!tick_check_percpu(curdev, newdev, cpu))
-- 
1.7.12.rc2.18.g61b472e

