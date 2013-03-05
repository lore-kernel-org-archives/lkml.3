Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab3CEOB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:01:58 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:60701 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab3CEOBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:01:37 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 2/3] posix_cpu_timers: Consolidate timer list cleanups
Date: Tue,  5 Mar 2013 15:01:21 +0100
Message-Id: <1362492082-23019-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1362492082-23019-1-git-send-email-fweisbec@gmail.com>
References: <1362492082-23019-1-git-send-email-fweisbec@gmail.com>
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
index b633291..bb03633 100644
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

