Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbaJVGJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:09:25 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:60303 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaJVGIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:08:02 -0400
From: Mike Turquette <mturquette@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com, riel@redhat.com,
        efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, patches@linaro.org,
        tuukka.tikkanen@linaro.org, amit.kucheria@linaro.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH RFC 5/7] sched: cfs: cpu frequency scaling arch functions
Date: Tue, 21 Oct 2014 23:07:29 -0700
Message-Id: <1413958051-7103-6-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_eval_cpu_freq and arch_scale_cpu_freq are added to allow the
scheduler to evaluate if cpu frequency should change and to invoke that
change from a safe context.

They are weakly defined arch functions that do nothing by default. A
CPUfreq governor could use these functions to implement a frequency
scaling policy based on updates to per-task statistics or updates to
per-cpu utilization.

As discussed at Linux Plumbers Conference 2014, the goal will be to
focus on a single cpu frequency scaling policy that works for everyone.
That may mean that the weak arch functions definitions can be removed
entirely and a single policy implements that logic for all
architectures.

Not-signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 kernel/sched/fair.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0930ad8..1af6f6d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2265,6 +2265,8 @@ static u32 __compute_runnable_contrib(u64 n)
 }
 
 unsigned long arch_scale_load_capacity(int cpu);
+void arch_eval_cpu_freq(struct cpumask *cpus);
+void arch_scale_cpu_freq(void);
 
 /*
  * We can represent the historical contribution to runnable average as the
@@ -5805,6 +5807,16 @@ unsigned long __weak arch_scale_load_capacity(int cpu)
 	return default_scale_load_capacity(cpu);
 }
 
+void __weak arch_eval_cpu_freq(struct cpumask *cpus)
+{
+	return;
+}
+
+void __weak arch_scale_cpu_freq(void)
+{
+	return;
+}
+
 static unsigned long scale_rt_capacity(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-- 
1.8.3.2

