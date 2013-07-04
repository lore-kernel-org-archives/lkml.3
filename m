Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3GDQqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 12:46:38 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:55602 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab3GDQqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:46:35 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/7] posix_cpu_timers: consolidate timer list cleanups
Date: Thu,  4 Jul 2013 18:46:20 +0200
Message-Id: <1372956385-25396-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1372956385-25396-1-git-send-email-fweisbec@gmail.com>
References: <1372956385-25396-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning up the posix cpu timers on task exit shares some common code
among timer list types, most notably the list traversal and expiry time
update.

Unify this in a common helper.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Olivier Langlois <olivier@trillion01.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c |   48 +++++++++++++++++---------------------------
 1 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c3c4ea1..b1450ce 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -399,6 +399,21 @@ static int posix_cpu_timer_del(struct k_itimer *timer)
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
@@ -409,37 +424,12 @@ static void cleanup_timers(struct list_head *head,
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

