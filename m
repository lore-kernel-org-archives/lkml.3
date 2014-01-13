Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaAMPze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:55:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60799 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaAMPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:55:27 -0500
Date: Mon, 13 Jan 2014 07:54:59 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-fyqtb1lapxca3lhsxv9cumdc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Fix up the smp-affinity mask tests
Git-Commit-ID: e4099a5e929435cd6349343f002583f29868c900
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:55:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4099a5e929435cd6349343f002583f29868c900
Gitweb:     http://git.kernel.org/tip/e4099a5e929435cd6349343f002583f29868c900
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 17 Dec 2013 10:03:34 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:47:22 +0100

sched/deadline: Fix up the smp-affinity mask tests

For now deadline tasks are not allowed to set smp affinity; however
the current tests are wrong, cure this.

The test in __sched_setscheduler() also uses an on-stack cpumask_t
which is a no-no.

Change both tests to use cpumask_subset() such that we test the root
domain span to be a subset of the cpus_allowed mask. This way we're
sure the tasks can always run on all CPUs they can be balanced over,
and have no effective affinity constraints.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-fyqtb1lapxca3lhsxv9cumdc@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e30356d6..27c6375 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3384,23 +3384,14 @@ change:
 #ifdef CONFIG_SMP
 		if (dl_bandwidth_enabled() && dl_policy(policy)) {
 			cpumask_t *span = rq->rd->span;
-			cpumask_t act_affinity;
-
-			/*
-			 * cpus_allowed mask is statically initialized with
-			 * CPU_MASK_ALL, span is instead dynamic. Here we
-			 * compute the "dynamic" affinity of a task.
-			 */
-			cpumask_and(&act_affinity, &p->cpus_allowed,
-				    cpu_active_mask);
 
 			/*
 			 * Don't allow tasks with an affinity mask smaller than
 			 * the entire root_domain to become SCHED_DEADLINE. We
 			 * will also fail if there's no bandwidth available.
 			 */
-			if (!cpumask_equal(&act_affinity, span) ||
-					   rq->rd->dl_bw.bw == 0) {
+			if (!cpumask_subset(span, &p->cpus_allowed) ||
+			    rq->rd->dl_bw.bw == 0) {
 				task_rq_unlock(rq, p, &flags);
 				return -EPERM;
 			}
@@ -3420,8 +3411,7 @@ change:
 	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
 	 * is available.
 	 */
-	if ((dl_policy(policy) || dl_task(p)) &&
-	    dl_overflow(p, policy, attr)) {
+	if ((dl_policy(policy) || dl_task(p)) && dl_overflow(p, policy, attr)) {
 		task_rq_unlock(rq, p, &flags);
 		return -EBUSY;
 	}
@@ -3860,6 +3850,10 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	if (retval)
 		goto out_unlock;
 
+
+	cpuset_cpus_allowed(p, cpus_allowed);
+	cpumask_and(new_mask, in_mask, cpus_allowed);
+
 	/*
 	 * Since bandwidth control happens on root_domain basis,
 	 * if admission test is enabled, we only admit -deadline
@@ -3870,16 +3864,12 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	if (task_has_dl_policy(p)) {
 		const struct cpumask *span = task_rq(p)->rd->span;
 
-		if (dl_bandwidth_enabled() &&
-		    !cpumask_equal(in_mask, span)) {
+		if (dl_bandwidth_enabled() && !cpumask_subset(span, new_mask)) {
 			retval = -EBUSY;
 			goto out_unlock;
 		}
 	}
 #endif
-
-	cpuset_cpus_allowed(p, cpus_allowed);
-	cpumask_and(new_mask, in_mask, cpus_allowed);
 again:
 	retval = set_cpus_allowed_ptr(p, new_mask);
 
@@ -4535,7 +4525,7 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
  * When dealing with a -deadline task, we have to check if moving it to
  * a new CPU is possible or not. In fact, this is only true iff there
  * is enough bandwidth available on such CPU, otherwise we want the
- * whole migration progedure to fail over.
+ * whole migration procedure to fail over.
  */
 static inline
 bool set_task_cpu_dl(struct task_struct *p, unsigned int cpu)
