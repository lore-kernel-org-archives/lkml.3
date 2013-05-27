Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab3E0Ju2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:50:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35383 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab3E0Ju0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:50:26 -0400
Date: Mon, 27 May 2013 02:50:10 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-a89c7edbe7d7aa80f507915f3dd801211b116b79@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130425143436.029915527@linutronix.de>
References: <20130425143436.029915527@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: Let clocksource_unregister()
  return success/error
Git-Commit-ID: a89c7edbe7d7aa80f507915f3dd801211b116b79
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

Commit-ID:  a89c7edbe7d7aa80f507915f3dd801211b116b79
Gitweb:     http://git.kernel.org/tip/a89c7edbe7d7aa80f507915f3dd801211b116b79
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 25 Apr 2013 20:31:46 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 16 May 2013 11:09:16 +0200

clocksource: Let clocksource_unregister() return success/error

The unregister call can fail, if the clocksource is the current one
and there is no replacement clocksource available. It can also fail,
if the clocksource is the watchdog clocksource and I'm not going to
provide support for this.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143436.029915527@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clocksource.h |  2 +-
 kernel/time/clocksource.c   | 33 ++++++++++++---------------------
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 32a895b..2f39a49 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -282,7 +282,7 @@ static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 
 
 extern int clocksource_register(struct clocksource*);
-extern void clocksource_unregister(struct clocksource*);
+extern int clocksource_unregister(struct clocksource*);
 extern void clocksource_touch_watchdog(void);
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 791d1ae..31b9033 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -389,28 +389,17 @@ static void clocksource_enqueue_watchdog(struct clocksource *cs)
 
 static void clocksource_dequeue_watchdog(struct clocksource *cs)
 {
-	struct clocksource *tmp;
 	unsigned long flags;
 
 	spin_lock_irqsave(&watchdog_lock, flags);
-	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
-		/* cs is a watched clocksource. */
-		list_del_init(&cs->wd_list);
-	} else if (cs == watchdog) {
-		/* Reset watchdog cycles */
-		clocksource_reset_watchdog();
-		/* Current watchdog is removed. Find an alternative. */
-		watchdog = NULL;
-		list_for_each_entry(tmp, &clocksource_list, list) {
-			if (tmp == cs || tmp->flags & CLOCK_SOURCE_MUST_VERIFY)
-				continue;
-			if (!watchdog || tmp->rating > watchdog->rating)
-				watchdog = tmp;
+	if (cs != watchdog) {
+		if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
+			/* cs is a watched clocksource. */
+			list_del_init(&cs->wd_list);
+			/* Check if the watchdog timer needs to be stopped. */
+			clocksource_stop_watchdog();
 		}
 	}
-	cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
-	/* Check if the watchdog timer needs to be stopped. */
-	clocksource_stop_watchdog();
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
@@ -841,13 +830,15 @@ static int clocksource_unbind(struct clocksource *cs)
  * clocksource_unregister - remove a registered clocksource
  * @cs:	clocksource to be unregistered
  */
-void clocksource_unregister(struct clocksource *cs)
+int clocksource_unregister(struct clocksource *cs)
 {
+	int ret = 0;
+
 	mutex_lock(&clocksource_mutex);
-	clocksource_dequeue_watchdog(cs);
-	list_del(&cs->list);
-	clocksource_select();
+	if (!list_empty(&cs->list))
+		ret = clocksource_unbind(cs);
 	mutex_unlock(&clocksource_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(clocksource_unregister);
 
