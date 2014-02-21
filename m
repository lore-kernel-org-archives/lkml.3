Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbaBUUd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:33:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58585 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbaBUUdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:33:23 -0500
Date: Fri, 21 Feb 2014 12:32:48 -0800
From: tip-bot for Boris Ostrovsky <tipbot@zytor.com>
Message-ID: <tip-82b95800b256205cff2eeab5bbd03430d2d0f20d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de,
        juri.lelli@gmail.com
In-Reply-To: <1392646353-1874-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1392646353-1874-1-git-send-email-boris.ostrovsky@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/deadline: Test for CPU'
 s presence explicitly
Git-Commit-ID: 82b95800b256205cff2eeab5bbd03430d2d0f20d
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

Commit-ID:  82b95800b256205cff2eeab5bbd03430d2d0f20d
Gitweb:     http://git.kernel.org/tip/82b95800b256205cff2eeab5bbd03430d2d0f20d
Author:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
AuthorDate: Mon, 17 Feb 2014 09:12:33 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:27:10 +0100

sched/deadline: Test for CPU's presence explicitly

A hot-removed CPU may have ID that is numerically larger than the number of
existing CPUs in the system (e.g. we can unplug CPU 4 from a system that
has CPUs 0, 1 and 4).

Thus the WARN_ONs should check whether the CPU in question is currently
present, not whether its ID value is less than num_present_cpus().

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392646353-1874-1-git-send-email-boris.ostrovsky@oracle.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/cpudeadline.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 045fc74..5b8838b 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -70,7 +70,7 @@ static void cpudl_heapify(struct cpudl *cp, int idx)
 
 static void cpudl_change_key(struct cpudl *cp, int idx, u64 new_dl)
 {
-	WARN_ON(idx > num_present_cpus() || idx == IDX_INVALID);
+	WARN_ON(!cpu_present(idx) || idx == IDX_INVALID);
 
 	if (dl_time_before(new_dl, cp->elements[idx].dl)) {
 		cp->elements[idx].dl = new_dl;
@@ -117,7 +117,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	}
 
 out:
-	WARN_ON(best_cpu > num_present_cpus() && best_cpu != -1);
+	WARN_ON(!cpu_present(best_cpu) && best_cpu != -1);
 
 	return best_cpu;
 }
@@ -137,7 +137,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
 	int old_idx, new_cpu;
 	unsigned long flags;
 
-	WARN_ON(cpu > num_present_cpus());
+	WARN_ON(!cpu_present(cpu));
 
 	raw_spin_lock_irqsave(&cp->lock, flags);
 	old_idx = cp->cpu_to_idx[cpu];
