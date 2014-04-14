Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaDNQZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:25:34 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62976 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbaDNQZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:25:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 12/38] tick-common: call tick_check_percpu() from tick_check_preferred()
Date: Mon, 14 Apr 2014 21:53:34 +0530
Message-Id: <3dc98fbdafb209e105b42925770da2884da8237e.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_check_percpu() and tick_check_preferred() are called from two places and in
exactly same order. So, would make sense to call tick_check_percpu() from
tick_check_preferred() instead, so that their common caller can just call
tick_check_preferred().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 8650026..6868d6a 100644
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
 
@@ -273,10 +273,6 @@ void tick_check_new_device(struct clock_event_device *newdev)
 	struct tick_device *td = tick_get_device(cpu);
 	struct clock_event_device *curdev = td->evtdev;
 
-	/* cpu local device ? */
-	if (!tick_check_percpu(curdev, newdev, cpu))
-		goto out_bc;
-
 	/* Preference decision */
 	if (!tick_check_preferred(curdev, newdev))
 		goto out_bc;
-- 
1.7.12.rc2.18.g61b472e

