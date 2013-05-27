Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab3E0Jqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:46:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35340 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab3E0Jqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:46:37 -0400
Date: Mon, 27 May 2013 02:46:22 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-f5a2e34375a5e2b711aea488ac3ae50eeba6d57c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130425143435.834965397@linutronix.de>
References: <20130425143435.834965397@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource:
  Allow clocksource select to skip current clocksource
Git-Commit-ID: f5a2e34375a5e2b711aea488ac3ae50eeba6d57c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5a2e34375a5e2b711aea488ac3ae50eeba6d57c
Gitweb:     http://git.kernel.org/tip/f5a2e34375a5e2b711aea488ac3ae50eeba6d57c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 25 Apr 2013 20:31:45 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 16 May 2013 11:09:15 +0200

clocksource: Allow clocksource select to skip current clocksource

Preparatory patch for clocksource unbind support.

Split out code from clocksource_select and modify it, so it skips the
current clocksource on request and tries to find a fallback
clocksource. Convert all existing users. No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143435.834965397@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clocksource.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 1923a34..9782997 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -553,7 +553,7 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
 
 #ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 
-static struct clocksource *clocksource_find_best(bool oneshot)
+static struct clocksource *clocksource_find_best(bool oneshot, bool skipcur)
 {
 	struct clocksource *cs;
 
@@ -566,6 +566,8 @@ static struct clocksource *clocksource_find_best(bool oneshot)
 	 * the best rating.
 	 */
 	list_for_each_entry(cs, &clocksource_list, list) {
+		if (skipcur && cs == curr_clocksource)
+			continue;
 		if (oneshot && !(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES))
 			continue;
 		return cs;
@@ -573,26 +575,20 @@ static struct clocksource *clocksource_find_best(bool oneshot)
 	return NULL;
 }
 
-/**
- * clocksource_select - Select the best clocksource available
- *
- * Private function. Must hold clocksource_mutex when called.
- *
- * Select the clocksource with the best rating, or the clocksource,
- * which is selected by userspace override.
- */
-static void clocksource_select(void)
+static void __clocksource_select(bool skipcur)
 {
 	bool oneshot = tick_oneshot_mode_active();
 	struct clocksource *best, *cs;
 
 	/* Find the best suitable clocksource */
-	best = clocksource_find_best(oneshot);
+	best = clocksource_find_best(oneshot, skipcur);
 	if (!best)
 		return;
 
 	/* Check for the override clocksource. */
 	list_for_each_entry(cs, &clocksource_list, list) {
+		if (skipcur && cs == curr_clocksource)
+			continue;
 		if (strcmp(cs->name, override_name) != 0)
 			continue;
 		/*
@@ -618,6 +614,19 @@ static void clocksource_select(void)
 	}
 }
 
+/**
+ * clocksource_select - Select the best clocksource available
+ *
+ * Private function. Must hold clocksource_mutex when called.
+ *
+ * Select the clocksource with the best rating, or the clocksource,
+ * which is selected by userspace override.
+ */
+static void clocksource_select(void)
+{
+	return __clocksource_select(false);
+}
+
 #else /* !CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 static inline void clocksource_select(void) { }
