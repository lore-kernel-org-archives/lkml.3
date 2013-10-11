Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3JKRU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 13:20:58 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48640 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3JKRTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 13:19:31 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: pjt@google.com, arjan@linux.intel.com, rjw@sisk.pl,
        dirk.j.brandewie@intel.com, vincent.guittot@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        corbet@lwn.net, tglx@linutronix.de, catalin.marinas@arm.com,
        morten.rasmussen@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [RFC][PATCH 4/7] sched: power: Remove power capacity hints for kworker threads
Date: Fri, 11 Oct 2013 18:19:14 +0100
Message-Id: <1381511957-29776-5-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 11 Oct 2013 17:19:28.0489 (UTC) FILETIME=[0A976D90:01CEC6A6]
X-MC-Unique: 113101118192916001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r9BHL4Xh031587

Removing power hints for kworker threads enables easier use of
workqueues in the power driver late callback. That would otherwise
lead to an endless loop unless it is prevented in the power driver.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 50ae0ce..ea8d973 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2856,23 +2856,29 @@ static inline void hrtick_update(struct rq *rq)
 static unsigned long weighted_cpuload(const int cpu);
 static unsigned long power_of(int cpu);
 
-static inline void inc_cpu_capacity(int cpu)
+static inline void inc_cpu_capacity(int cpu, struct task_struct *p)
 {
+	if (p && p->flags & PF_WQ_WORKER)
+		return;
+
 	if (weighted_cpuload(cpu) > power_of(cpu))
 		go_faster(cpu, 0);
 }
 
-static inline void dec_cpu_capacity(int cpu)
+static inline void dec_cpu_capacity(int cpu, struct task_struct *p)
 {
+	if (p && p->flags & PF_WQ_WORKER)
+		return;
+
 	if (weighted_cpuload(cpu) < power_of(cpu))
 		go_slower(cpu, 0);
 }
 #else
-static inline void inc_cpu_capacity(int cpu)
+static inline void inc_cpu_capacity(int cpu, struct task_struct *p)
 {
 }
 
-static inline void dec_cpu_capacity(int cpu)
+static inline void dec_cpu_capacity(int cpu, struct task_struct *p)
 {
 }
 #endif
@@ -2923,7 +2929,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		inc_nr_running(rq);
 	}
 
-	inc_cpu_capacity(task_cpu(p));
+	inc_cpu_capacity(task_cpu(p), p);
 	hrtick_update(rq);
 }
 
@@ -2986,7 +2992,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_rq_runnable_avg(rq, 1);
 	}
 
-	dec_cpu_capacity(task_cpu(p));
+	dec_cpu_capacity(task_cpu(p), p);
 	hrtick_update(rq);
 }
 
@@ -5772,7 +5778,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 	 */
 	nohz_idle_balance(this_cpu, idle);
 
-	inc_cpu_capacity(this_cpu);
+	inc_cpu_capacity(this_cpu, NULL);
 	power_late_callback(this_cpu);
 }
 
-- 
1.7.9.5


