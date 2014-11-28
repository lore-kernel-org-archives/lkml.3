Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaK1SYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:53 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48171 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaK1SYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:46 -0500
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
Subject: [RFC PATCH 19/30] tsacct: Convert obsolete cputime type to nsecs
Date: Fri, 28 Nov 2014 19:23:49 +0100
Message-Id: <1417199040-21044-20-git-send-email-fweisbec@gmail.com>
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
 include/linux/sched.h |  2 +-
 kernel/tsacct.c       | 24 ++++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6c8c077..9ce575e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1523,7 +1523,7 @@ struct task_struct {
 #if defined(CONFIG_TASK_XACCT)
 	u64 acct_rss_mem1;	/* accumulated rss usage */
 	u64 acct_vm_mem1;	/* accumulated virtual memory usage */
-	cputime_t acct_timexpd;	/* stime + utime since last update */
+	u64 acct_timexpd;	/* stime + utime since last update */
 #endif
 #ifdef CONFIG_CPUSETS
 	nodemask_t mems_allowed;	/* Protected by alloc_lock */
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 4133e94..a66881e 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -31,7 +31,7 @@ void bacct_add_tsk(struct user_namespace *user_ns,
 		   struct taskstats *stats, struct task_struct *tsk)
 {
 	const struct cred *tcred;
-	cputime_t utime, stime, utimescaled, stimescaled;
+	u64 utime, stime, utimescaled, stimescaled;
 	u64 delta;
 
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
@@ -66,13 +66,13 @@ void bacct_add_tsk(struct user_namespace *user_ns,
 		task_tgid_nr_ns(rcu_dereference(tsk->real_parent), pid_ns) : 0;
 	rcu_read_unlock();
 
-	task_cputime_t(tsk, &utime, &stime);
-	stats->ac_utime = cputime_to_usecs(utime);
-	stats->ac_stime = cputime_to_usecs(stime);
+	task_cputime(tsk, &utime, &stime);
+	stats->ac_utime = div_u64(utime, NSEC_PER_USEC);
+	stats->ac_stime = div_u64(stime, NSEC_PER_USEC);
 
-	task_cputime_t_scaled(tsk, &utimescaled, &stimescaled);
-	stats->ac_utimescaled = cputime_to_usecs(utimescaled);
-	stats->ac_stimescaled = cputime_to_usecs(stimescaled);
+	task_cputime_scaled(tsk, &utimescaled, &stimescaled);
+	stats->ac_utimescaled = div_u64(utimescaled, NSEC_PER_USEC);
+	stats->ac_stimescaled = div_u64(stimescaled, NSEC_PER_USEC);
 
 	stats->ac_minflt = tsk->min_flt;
 	stats->ac_majflt = tsk->maj_flt;
@@ -121,10 +121,10 @@ void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 #undef MB
 
 static void __acct_update_integrals(struct task_struct *tsk,
-				    cputime_t utime, cputime_t stime)
+				    u64 utime, u64 stime)
 {
 	if (likely(tsk->mm)) {
-		cputime_t time, dtime;
+		u64 time, dtime;
 		struct timeval value;
 		unsigned long flags;
 		u64 delta;
@@ -132,7 +132,7 @@ static void __acct_update_integrals(struct task_struct *tsk,
 		local_irq_save(flags);
 		time = stime + utime;
 		dtime = time - tsk->acct_timexpd;
-		jiffies_to_timeval(cputime_to_jiffies(dtime), &value);
+		value = ns_to_timeval(dtime);
 		delta = value.tv_sec;
 		delta = delta * USEC_PER_SEC + value.tv_usec;
 
@@ -152,9 +152,9 @@ static void __acct_update_integrals(struct task_struct *tsk,
  */
 void acct_update_integrals(struct task_struct *tsk)
 {
-	cputime_t utime, stime;
+	u64 utime, stime;
 
-	task_cputime_t(tsk, &utime, &stime);
+	task_cputime(tsk, &utime, &stime);
 	__acct_update_integrals(tsk, utime, stime);
 }
 
-- 
2.1.3

