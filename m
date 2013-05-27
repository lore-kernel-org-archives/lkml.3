Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab3E0JoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:44:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35305 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab3E0JoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:44:06 -0400
Date: Mon, 27 May 2013 02:43:49 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-ba919d1caa2e624eb8c6cae1f2ce0a253e697d45@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130425143435.696321912@linutronix.de>
References: <20130425143435.696321912@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource:
  Let timekeeping_notify return success/error
Git-Commit-ID: ba919d1caa2e624eb8c6cae1f2ce0a253e697d45
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

Commit-ID:  ba919d1caa2e624eb8c6cae1f2ce0a253e697d45
Gitweb:     http://git.kernel.org/tip/ba919d1caa2e624eb8c6cae1f2ce0a253e697d45
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 25 Apr 2013 20:31:44 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 16 May 2013 11:09:14 +0200

clocksource: Let timekeeping_notify return success/error

timekeeping_notify() can fail due cs->enable() failure. Though the
caller does not notice and happily keeps the wrong clocksource as the
current one.

Let the caller know about failure, so the current clocksource will be
shown correctly in sysfs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143435.696321912@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clocksource.h | 2 +-
 kernel/time/clocksource.c   | 6 +++---
 kernel/time/timekeeping.c   | 5 +++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 7279b94..aa6ba44 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -321,7 +321,7 @@ static inline void __clocksource_updatefreq_khz(struct clocksource *cs, u32 khz)
 }
 
 
-extern void timekeeping_notify(struct clocksource *clock);
+extern int timekeeping_notify(struct clocksource *clock);
 
 extern cycle_t clocksource_mmio_readl_up(struct clocksource *);
 extern cycle_t clocksource_mmio_readl_down(struct clocksource *);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index dda5c71..1923a34 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -611,10 +611,10 @@ static void clocksource_select(void)
 			best = cs;
 		break;
 	}
-	if (curr_clocksource != best) {
-		printk(KERN_INFO "Switching to clocksource %s\n", best->name);
+
+	if (curr_clocksource != best && !timekeeping_notify(best)) {
+		pr_info("Switched to clocksource %s\n", best->name);
 		curr_clocksource = best;
-		timekeeping_notify(curr_clocksource);
 	}
 }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 98cd470..da6e10c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -648,14 +648,15 @@ static int change_clocksource(void *data)
  * This function is called from clocksource.c after a new, better clock
  * source has been registered. The caller holds the clocksource_mutex.
  */
-void timekeeping_notify(struct clocksource *clock)
+int timekeeping_notify(struct clocksource *clock)
 {
 	struct timekeeper *tk = &timekeeper;
 
 	if (tk->clock == clock)
-		return;
+		return 0;
 	stop_machine(change_clocksource, clock, NULL);
 	tick_clock_notify();
+	return tk->clock == clock ? 0 : -1;
 }
 
 /**
