Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab3FLT4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 15:56:00 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58280 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab3FLTz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 15:55:58 -0400
From: Julius Werner <jwerner@chromium.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Todd Poynor <toddpoynor@google.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sameer Nanda <snanda@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH v2] PM / Sleep: Print last wakeup source on failed wakeup_count write
Date: Wed, 12 Jun 2013 12:55:22 -0700
Message-Id: <1371066922-23577-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a938da06 introduced a useful little log message to tell
users/debuggers which wakeup source aborted a suspend. However, this
message is only printed if the abort happens during the in-kernel
suspend path (after writing /sys/power/state).

The full specification of the /sys/power/wakeup_count facility allows
user-space power managers to double-check if wakeups have already
happened before it actually tries to suspend (e.g. while it was running
user-space pre-suspend hooks), by writing the last known wakeup_count
value to /sys/power/wakeup_count. This patch changes the sysfs handler
for that node to also print said log message if that write fails, so
that we can figure out the offending wakeup source for both kinds of
suspend aborts.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/base/power/wakeup.c | 5 +++--
 include/linux/suspend.h     | 1 +
 kernel/power/main.c         | 2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index 79715e7..90f83ca5 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -659,7 +659,7 @@ void pm_wakeup_event(struct device *dev, unsigned int msec)
 }
 EXPORT_SYMBOL_GPL(pm_wakeup_event);
 
-static void print_active_wakeup_sources(void)
+void pm_print_active_wakeup_sources(void)
 {
 	struct wakeup_source *ws;
 	int active = 0;
@@ -683,6 +683,7 @@ static void print_active_wakeup_sources(void)
 			last_activity_ws->name);
 	rcu_read_unlock();
 }
+EXPORT_SYMBOL_GPL(pm_print_active_wakeup_sources);
 
 /**
  * pm_wakeup_pending - Check if power transition in progress should be aborted.
@@ -708,7 +709,7 @@ bool pm_wakeup_pending(void)
 	spin_unlock_irqrestore(&events_lock, flags);
 
 	if (ret)
-		print_active_wakeup_sources();
+		pm_print_active_wakeup_sources();
 
 	return ret;
 }
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index d4e3f16..f73cabf 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -363,6 +363,7 @@ extern bool pm_wakeup_pending(void);
 extern bool pm_get_wakeup_count(unsigned int *count, bool block);
 extern bool pm_save_wakeup_count(unsigned int count);
 extern void pm_wakep_autosleep_enabled(bool set);
+extern void pm_print_active_wakeup_sources(void);
 
 static inline void lock_system_sleep(void)
 {
diff --git a/kernel/power/main.c b/kernel/power/main.c
index d77663b..0828070 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -424,6 +424,8 @@ static ssize_t wakeup_count_store(struct kobject *kobj,
 	if (sscanf(buf, "%u", &val) == 1) {
 		if (pm_save_wakeup_count(val))
 			error = n;
+		else
+			pm_print_active_wakeup_sources();
 	}
 
  out:
-- 
1.7.12.4

