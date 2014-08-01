Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbaHAQb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:31:56 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50392 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbaHAQbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:31:53 -0400
From: Amit Pundir <amit.pundir@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Todd Poynor <toddpoynor@google.com>, Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Amit Pundir <amit.pundir@linaro.org>
Subject: [RFC][PATCH 2/2] PM: Suspend: Print wall time at suspend entry and exit
Date: Fri,  1 Aug 2014 22:00:49 +0530
Message-Id: <1406910649-4028-3-git-send-email-amit.pundir@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406910649-4028-1-git-send-email-amit.pundir@linaro.org>
References: <1406910649-4028-1-git-send-email-amit.pundir@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Poynor <toddpoynor@google.com>

Existing printk timestamps in a dmesg only log suspend activities
(e.g. filesystem syncs, freezing/unfreezing tasks etc) while the
system has already started to enter/exit the suspend state. Sometimes
it is handy to have suspend entry/exit overhead information while
debugging suspend issues. This patch print markers with wall
timestamps at suspend Entry and Exit in the kernel log. These
timestamps can be used to compute how long the system spent in
low-power suspend state plus the entry/exit overhead.

This patch comes from the Android patch set, where its been used to
help diagnose battery life problems in various Android-based devices.

Cc: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Todd Poynor <toddpoynor@google.com>
[Amit Pundir: Reworded the commit message]
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---

The original patch was submitted to linux-pm couple of years back but
I could not trace any feedback or activity thereafter. Hence I'm
resubmitting this change.

 kernel/power/suspend.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index ed35a47..28726b6 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -26,6 +26,7 @@
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
 #include <linux/ftrace.h>
+#include <linux/rtc.h>
 #include <trace/events/power.h>
 #include <linux/compiler.h>
 
@@ -417,6 +418,18 @@ static int enter_state(suspend_state_t state)
 	return error;
 }
 
+static void pm_suspend_marker(char *annotation)
+{
+	struct timespec ts;
+	struct rtc_time tm;
+
+	getnstimeofday(&ts);
+	rtc_time_to_tm(ts.tv_sec, &tm);
+	pr_info("PM: suspend %s %d-%02d-%02d %02d:%02d:%02d.%09lu UTC\n",
+		annotation, tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
+		tm.tm_hour, tm.tm_min, tm.tm_sec, ts.tv_nsec);
+}
+
 /**
  * pm_suspend - Externally visible function for suspending the system.
  * @state: System sleep state to enter.
@@ -431,6 +444,7 @@ int pm_suspend(suspend_state_t state)
 	if (state <= PM_SUSPEND_ON || state >= PM_SUSPEND_MAX)
 		return -EINVAL;
 
+	pm_suspend_marker("entry");
 	error = enter_state(state);
 	if (error) {
 		suspend_stats.fail++;
@@ -438,6 +452,7 @@ int pm_suspend(suspend_state_t state)
 	} else {
 		suspend_stats.success++;
 	}
+	pm_suspend_marker("exit");
 	return error;
 }
 EXPORT_SYMBOL(pm_suspend);
-- 
1.7.10.4

