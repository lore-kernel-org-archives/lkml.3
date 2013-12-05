Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3LEUma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:42:30 -0500
Received: from mail-pd0-f201.google.com ([209.85.192.201]:45312 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3LEUm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:42:28 -0500
From: Ben Zhang <benzh@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Don Zickus <dzickus@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ben Zhang <benzh@chromium.org>
Subject: [PATCH] watchdog: touch_nmi_watchdog should only touch local cpu not every one
Date: Thu,  5 Dec 2013 12:42:24 -0800
Message-Id: <1386276144-9241-1-git-send-email-benzh@chromium.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <20131205031218.GO35219@redhat.com>
References: <20131205031218.GO35219@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran into a scenario where while one cpu was stuck and should have panic'd
because of the NMI watchdog, it didn't.  The reason was another cpu was spewing
stack dumps on to the console.  Upon investigation, I noticed that when writing
to the console and also when dumping the stack, the watchdog is touched.

This causes all the cpus to reset their NMI watchdog flags and the 'stuck' cpu
just spins forever.

This change causes the semantics of touch_nmi_watchdog to be changed slightly.
Previously, I accidentally changed the semantics and we noticed there was a
codepath in which touch_nmi_watchdog could be touched from a preemtible area.
That caused a BUG() to happen when CONFIG_DEBUG_PREEMPT was enabled.  I believe
it was the acpi code.

My attempt here re-introduces the change to have the touch_nmi_watchdog() code
only touch the local cpu instead of all of the cpus.  But instead of using
__get_cpu_var(), I use the __raw_get_cpu_var() version.

This avoids the preemption problem.  However my reasoning wasn't because I was
trying to be lazy.  Instead I rationalized it as, well if preemption is enabled
then interrupts should be enabled to and the NMI watchdog will have no reason
to trigger.  So it won't matter if the wrong cpu is touched because the percpu
interrupt counters the NMI watchdog uses should still be incrementing.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Ben Zhang <benzh@chromium.org>
---
 kernel/watchdog.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 4431610..613f611 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -158,14 +158,14 @@ void touch_all_softlockup_watchdogs(void)
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
-	if (watchdog_user_enabled) {
-		unsigned cpu;
-
-		for_each_present_cpu(cpu) {
-			if (per_cpu(watchdog_nmi_touch, cpu) != true)
-				per_cpu(watchdog_nmi_touch, cpu) = true;
-		}
-	}
+	/*
+	 * Using __raw here because some code paths have
+	 * preemption enabled.  If preemption is enabled
+	 * then interrupts should be enabled too, in which
+	 * case we shouldn't have to worry about the watchdog
+	 * going off.
+	 */
+	__raw_get_cpu_var(watchdog_nmi_touch) = true;
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
-- 
1.8.5.1

