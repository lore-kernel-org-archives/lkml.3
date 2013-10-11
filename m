Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3JKRMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 13:12:15 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:49631 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3JKRMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 13:12:13 -0400
From: Patrick Palka <patrick@parcs.ath.cx>
To: tglx@linutronix.de
Cc: john.stultz@linaro.org, linux-kernel@vger.kernel.org,
        Patrick Palka <patrick@parcs.ath.cx>
Subject: [PATCH] time: Fix signedness bug in sysfs_get_uname() and its callers
Date: Fri, 11 Oct 2013 13:11:55 -0400
Message-Id: <1381511515-2577-1-git-send-email-patrick@parcs.ath.cx>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_get_uname() is erroneously declared as returning size_t even
though it may return a negative value, specifically -EINVAL.  Its
callers then check whether its return value is less than zero and indeed
that is never the case for size_t.

This patch changes sysfs_get_uname() to return ssize_t and makes sure
its callers use ssize_t accordingly.

Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
---
 kernel/time/clockevents.c   | 2 +-
 kernel/time/clocksource.c   | 6 +++---
 kernel/time/tick-internal.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 38959c8..30554b9 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -584,7 +584,7 @@ static ssize_t sysfs_unbind_tick_dev(struct device *dev,
 				     const char *buf, size_t count)
 {
 	char name[CS_NAME_LEN];
-	size_t ret = sysfs_get_uname(buf, name, count);
+	ssize_t ret = sysfs_get_uname(buf, name, count);
 	struct clock_event_device *ce;
 
 	if (ret < 0)
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 50a8736..b286f42 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -893,7 +893,7 @@ sysfs_show_current_clocksources(struct device *dev,
 	return count;
 }
 
-size_t sysfs_get_uname(const char *buf, char *dst, size_t cnt)
+ssize_t sysfs_get_uname(const char *buf, char *dst, size_t cnt)
 {
 	size_t ret = cnt;
 
@@ -924,7 +924,7 @@ static ssize_t sysfs_override_clocksource(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t count)
 {
-	size_t ret;
+	ssize_t ret;
 
 	mutex_lock(&clocksource_mutex);
 
@@ -952,7 +952,7 @@ static ssize_t sysfs_unbind_clocksource(struct device *dev,
 {
 	struct clocksource *cs;
 	char name[CS_NAME_LEN];
-	size_t ret;
+	ssize_t ret;
 
 	ret = sysfs_get_uname(buf, name, count);
 	if (ret < 0)
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index bc906ca..18e71f7 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -31,7 +31,7 @@ extern void tick_install_replacement(struct clock_event_device *dev);
 
 extern void clockevents_shutdown(struct clock_event_device *dev);
 
-extern size_t sysfs_get_uname(const char *buf, char *dst, size_t cnt);
+extern ssize_t sysfs_get_uname(const char *buf, char *dst, size_t cnt);
 
 /*
  * NO_HZ / high resolution timer shared code
-- 
1.8.4.rc3

