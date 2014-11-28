Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaK1SZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:25:09 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:55581 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaK1SZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:25:04 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 29/30] cputime: Push time to account_guest_time() in nanosecs
Date: Fri, 28 Nov 2014 19:23:59 +0100
Message-Id: <1417199040-21044-30-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/cputime.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 7d818bb..9d002f5 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -148,24 +148,24 @@ void account_user_time(struct task_struct *p, u64 cputime, u64 cputime_scaled)
  * @cputime: the cpu time spent in virtual machine since the last update
  * @cputime_scaled: cputime scaled by cpu frequency
  */
-static void account_guest_time(struct task_struct *p, cputime_t cputime,
-			       cputime_t cputime_scaled)
+static void account_guest_time(struct task_struct *p, u64 cputime,
+			       u64 cputime_scaled)
 {
 	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
 	/* Add guest time to process. */
-	p->utime += cputime_to_nsecs(cputime);
-	p->utimescaled += cputime_to_nsecs(cputime_scaled);
-	account_group_user_time(p, cputime_to_nsecs(cputime));
-	p->gtime += cputime_to_nsecs(cputime);
+	p->utime += cputime;
+	p->utimescaled += cputime_scaled;
+	account_group_user_time(p, cputime);
+	p->gtime += cputime;
 
 	/* Add guest time to cpustat. */
 	if (task_nice(p) > 0) {
-		cpustat[CPUTIME_NICE] += cputime_to_nsecs(cputime);
-		cpustat[CPUTIME_GUEST_NICE] += cputime_to_nsecs(cputime);
+		cpustat[CPUTIME_NICE] += cputime;
+		cpustat[CPUTIME_GUEST_NICE] += cputime;
 	} else {
-		cpustat[CPUTIME_USER] += cputime_to_nsecs(cputime);
-		cpustat[CPUTIME_GUEST] += cputime_to_nsecs(cputime);
+		cpustat[CPUTIME_USER] += cputime;
+		cpustat[CPUTIME_GUEST] += cputime;
 	}
 }
 
@@ -205,7 +205,7 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	int index;
 
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
-		account_guest_time(p, cputime, cputime_scaled);
+		account_guest_time(p, cputime_to_nsecs(cputime), cputime_to_nsecs(cputime_scaled));
 		return;
 	}
 
@@ -350,7 +350,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 	} else if (p == rq->idle) {
 		account_idle_time(nsec);
 	} else if (p->flags & PF_VCPU) { /* System time or guest time */
-		account_guest_time(p, cputime, scaled);
+		account_guest_time(p, nsec, nsec_scaled);
 	} else {
 		__account_system_time(p, cputime, scaled,	CPUTIME_SYSTEM);
 	}
-- 
2.1.3

