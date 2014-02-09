Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaBIOQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 09:16:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50382 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaBIOQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 09:16:30 -0500
Date: Sun, 9 Feb 2014 06:16:09 -0800
From: tip-bot for Preeti U Murthy <tipbot@zytor.com>
Message-ID: <tip-849401b66d305f3feb75b6db7459b95ad190552a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        preeti@linux.vnet.ibm.com, tglx@linutronix.de, fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, tglx@linutronix.de, fengguang.wu@intel.com
In-Reply-To: <52F719EE.9010304@linux.vnet.ibm.com>
References: <52F719EE.9010304@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick:
  Fixup more fallout from hrtimer broadcast mode
Git-Commit-ID: 849401b66d305f3feb75b6db7459b95ad190552a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 09 Feb 2014 06:16:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  849401b66d305f3feb75b6db7459b95ad190552a
Gitweb:     http://git.kernel.org/tip/849401b66d305f3feb75b6db7459b95ad190552a
Author:     Preeti U Murthy <preeti@linux.vnet.ibm.com>
AuthorDate: Sun, 9 Feb 2014 11:32:22 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 9 Feb 2014 15:11:47 +0100

tick: Fixup more fallout from hrtimer broadcast mode

The hrtimer mode of broadcast is supported only when
GENERIC_CLOCKEVENTS_BROADCAST and TICK_ONESHOT config options
are enabled. Hence compile in the functions for hrtimer mode
of broadcast only when these options are selected.
Also fix max_delta_ticks value for the pseudo clock device.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/52F719EE.9010304@linux.vnet.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clockchips.h           | 1 +
 kernel/time/Makefile                 | 5 ++++-
 kernel/time/tick-broadcast-hrtimer.c | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 20a7183..2e4cb67 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -207,6 +207,7 @@ static inline void clockevents_resume(void) {}
 
 static inline int clockevents_notify(unsigned long reason, void *arg) { return 0; }
 static inline int tick_check_broadcast_expired(void) { return 0; }
+static inline void tick_setup_hrtimer_broadcast(void) {};
 
 #endif
 
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index 06151ef..57a413f 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -3,7 +3,10 @@ obj-y += timeconv.o posix-clock.o alarmtimer.o
 
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
-obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= tick-broadcast.o tick-broadcast-hrtimer.o
+ifeq ($(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST),y)
+ obj-y						+= tick-broadcast.o
+ obj-$(CONFIG_TICK_ONESHOT)			+= tick-broadcast-hrtimer.o
+endif
 obj-$(CONFIG_GENERIC_SCHED_CLOCK)		+= sched_clock.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
diff --git a/kernel/time/tick-broadcast-hrtimer.c b/kernel/time/tick-broadcast-hrtimer.c
index 9242527..eb682d5 100644
--- a/kernel/time/tick-broadcast-hrtimer.c
+++ b/kernel/time/tick-broadcast-hrtimer.c
@@ -82,7 +82,7 @@ static struct clock_event_device ce_broadcast_hrtimer = {
 	.min_delta_ns		= 1,
 	.max_delta_ns		= KTIME_MAX,
 	.min_delta_ticks	= 1,
-	.max_delta_ticks	= KTIME_MAX,
+	.max_delta_ticks	= ULONG_MAX,
 	.mult			= 1,
 	.shift			= 0,
 	.cpumask		= cpu_all_mask,
