Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaJQRBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 13:01:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbaJQRAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 13:00:13 -0400
From: Ulrich Obergfell <uobergfe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dzickus@redhat.com, uobergfe@redhat.com
Subject: [PATCH v2 8/9] watchdog: clean up some function names and arguments
Date: Fri, 17 Oct 2014 19:06:27 +0200
Message-Id: <1413565588-4144-9-git-send-email-uobergfe@redhat.com>
In-Reply-To: <1413565588-4144-1-git-send-email-uobergfe@redhat.com>
References: <1413565588-4144-1-git-send-email-uobergfe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the update_timers*() functions to update_watchdog*().

Remove the boolean argument from watchdog_enable_all_cpus()
because update_watchdog_all_cpus() is now a generic function
to change the run state of the lockup detectors and to have
the lockup detectors use a new sample period.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
---
 kernel/watchdog.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index cfdb2cb..f435e37 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -641,7 +641,7 @@ static void restart_watchdog_hrtimer(void *info)
 				HRTIMER_MODE_REL_PINNED);
 }
 
-static void update_timers(int cpu)
+static void update_watchdog(int cpu)
 {
 	/*
 	 * Make sure that perf event counter will adopt to a new
@@ -656,17 +656,17 @@ static void update_timers(int cpu)
 	watchdog_nmi_enable(cpu);
 }
 
-static void update_timers_all_cpus(void)
+static void update_watchdog_all_cpus(void)
 {
 	int cpu;
 
 	get_online_cpus();
 	for_each_online_cpu(cpu)
-		update_timers(cpu);
+		update_watchdog(cpu);
 	put_online_cpus();
 }
 
-static int watchdog_enable_all_cpus(bool sample_period_changed)
+static int watchdog_enable_all_cpus(void)
 {
 	int err = 0;
 
@@ -676,8 +676,12 @@ static int watchdog_enable_all_cpus(bool sample_period_changed)
 			pr_err("Failed to create watchdog threads, disabled\n");
 		else
 			watchdog_running = 1;
-	} else if (sample_period_changed) {
-		update_timers_all_cpus();
+	} else {
+		/*
+		 * Enable/disable the lockup detectors or
+		 * change the sample period 'on the fly'.
+		 */
+		update_watchdog_all_cpus();
 	}
 
 	return err;
@@ -709,7 +713,7 @@ static int proc_watchdog_update(void)
 	 * or disabled 'on the fly'.
 	 */
 	if (watchdog_enabled && watchdog_thresh)
-		err = watchdog_enable_all_cpus(true);
+		err = watchdog_enable_all_cpus();
 	else
 		watchdog_disable_all_cpus();
 
@@ -849,5 +853,5 @@ void __init lockup_detector_init(void)
 	set_sample_period();
 
 	if (watchdog_enabled)
-		watchdog_enable_all_cpus(false);
+		watchdog_enable_all_cpus();
 }
-- 
1.7.11.7

