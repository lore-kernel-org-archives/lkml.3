Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab3CORB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:01:27 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:53903 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3CORBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:01:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 2/4] posix_cpu_timers: Consolidate timer list cleanups
Date: Fri, 15 Mar 2013 17:54:00 +0100
Message-Id: <1363366442-11494-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363366442-11494-1-git-send-email-fweisbec@gmail.com>
References: <1363366442-11494-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning up the posix cpu timers on task exit shares
some common code among timer list types, most notably the
list traversal and expiry time update.

Unify this in a common helper.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/posix-cpu-timers.c |   48 +++++++++++++++++---------------------------
 1 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index e5286b5..b30775f 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -382,6 +382,21 @@ static int posix_cpu_timer_del(struct k_itimer *timer)
 	return ret;
 }
 
+static void cleanup_timers_list(struct list_head *head,
+				unsigned long long curr)
+{
+	struct cpu_timer_list *timer, *next;
+
+	list_for_each_entry_safe(timer, next, head, entry) {
+		list_del_init(&timer->entry);
+		if (timer->expires < curr) {
+			timer->expires = 0;
+		} else {
+			timer->expires -= curr;
+		}
+	}
+}
+
 /*
  * Clean out CPU timers still ticking when a thread exited.  The task
  * pointer is cleared, and the expiry time is replaced with the residual
@@ -392,37 +407,12 @@ static void cleanup_timers(struct list_head *head,
 			   cputime_t utime, cputime_t stime,
 			   unsigned long long sum_exec_runtime)
 {
-	struct cpu_timer_list *timer, *next;
-	cputime_t ptime = utime + stime;
 
-	list_for_each_entry_safe(timer, next, head, entry) {
-		list_del_init(&timer->entry);
-		if (timer->expires < cputime_to_expires(ptime)) {
-			timer->expires = 0;
-		} else {
-			timer->expires -= cputime_to_expires(ptime);
-		}
-	}
-
-	++head;
-	list_for_each_entry_safe(timer, next, head, entry) {
-		list_del_init(&timer->entry);
-		if (timer->expires < cputime_to_expires(utime)) {
-			timer->expires = 0;
-		} else {
-			timer->expires -= cputime_to_expires(utime);
-		}
-	}
+	cputime_t ptime = utime + stime;
 
-	++head;
-	list_for_each_entry_safe(timer, next, head, entry) {
-		list_del_init(&timer->entry);
-		if (timer->expires < sum_exec_runtime) {
-			timer->expires = 0;
-		} else {
-			timer->expires -= sum_exec_runtime;
-		}
-	}
+	cleanup_timers_list(head, cputime_to_expires(ptime));
+	cleanup_timers_list(++head, cputime_to_expires(utime));
+	cleanup_timers_list(++head, sum_exec_runtime);
 }
 
 /*
-- 
1.7.5.4

