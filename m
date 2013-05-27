Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3E0JpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:45:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35330 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab3E0JpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:45:16 -0400
Date: Mon, 27 May 2013 02:45:06 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-09ac369c825d9d593404306d59062d854b321e9b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130425143435.762417789@linutronix.de>
References: <20130425143435.762417789@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: Add module refcount
Git-Commit-ID: 09ac369c825d9d593404306d59062d854b321e9b
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

Commit-ID:  09ac369c825d9d593404306d59062d854b321e9b
Gitweb:     http://git.kernel.org/tip/09ac369c825d9d593404306d59062d854b321e9b
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 25 Apr 2013 20:31:44 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 16 May 2013 11:09:14 +0200

clocksource: Add module refcount

Add a module refcount, so the current clocksource cannot be removed
unconditionally.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143435.762417789@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clocksource.h |  3 +++
 kernel/time/timekeeping.c   | 19 ++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index aa6ba44..32a895b 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -21,6 +21,7 @@
 /* clocksource cycle base type */
 typedef u64 cycle_t;
 struct clocksource;
+struct module;
 
 #ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
 #include <asm/clocksource.h>
@@ -162,6 +163,7 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  * @suspend:		suspend function for the clocksource, if necessary
  * @resume:		resume function for the clocksource, if necessary
  * @cycle_last:		most recent cycle counter value seen by ::read()
+ * @owner:		module reference, must be set by clocksource in modules
  */
 struct clocksource {
 	/*
@@ -195,6 +197,7 @@ struct clocksource {
 	cycle_t cs_last;
 	cycle_t wd_last;
 #endif
+	struct module *owner;
 } ____cacheline_aligned;
 
 /*
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index da6e10c..933efa4 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -627,11 +627,20 @@ static int change_clocksource(void *data)
 	write_seqcount_begin(&timekeeper_seq);
 
 	timekeeping_forward_now(tk);
-	if (!new->enable || new->enable(new) == 0) {
-		old = tk->clock;
-		tk_setup_internals(tk, new);
-		if (old->disable)
-			old->disable(old);
+	/*
+	 * If the cs is in module, get a module reference. Succeeds
+	 * for built-in code (owner == NULL) as well.
+	 */
+	if (try_module_get(new->owner)) {
+		if (!new->enable || new->enable(new) == 0) {
+			old = tk->clock;
+			tk_setup_internals(tk, new);
+			if (old->disable)
+				old->disable(old);
+			module_put(old->owner);
+		} else {
+			module_put(new->owner);
+		}
 	}
 	timekeeping_update(tk, true, true);
 
