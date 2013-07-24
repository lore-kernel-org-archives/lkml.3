Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab3GXD5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:57:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38434 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3GXD5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:57:37 -0400
Date: Tue, 23 Jul 2013 20:56:56 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-7d9ffa8961482232d964173cccba6e14d2d543b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davidlohr.bueso@hp.com, efault@gmx.de, peterz@infradead.org,
        wangyun@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davidlohr.bueso@hp.com, peterz@infradead.org, efault@gmx.de,
        wangyun@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <51D5008E.6030102@linux.vnet.ibm.com>
References: <51D5008E.6030102@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] sched: Micro-optimize the smart wake-affine logic
Git-Commit-ID: 7d9ffa8961482232d964173cccba6e14d2d543b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 20:57:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d9ffa8961482232d964173cccba6e14d2d543b2
Gitweb:     http://git.kernel.org/tip/7d9ffa8961482232d964173cccba6e14d2d543b2
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 4 Jul 2013 12:56:46 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Jul 2013 12:22:06 +0200

sched: Micro-optimize the smart wake-affine logic

Smart wake-affine is using node-size as the factor currently, but the overhead
of the mask operation is high.

Thus, this patch introduce the 'sd_llc_size' percpu variable, which will record
the highest cache-share domain size, and make it to be the new factor, in order
to reduce the overhead and make it more reasonable.

Tested-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Link: http://lkml.kernel.org/r/51D5008E.6030102@linux.vnet.ibm.com
[ Tidied up the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  | 7 ++++++-
 kernel/sched/fair.c  | 2 +-
 kernel/sched/sched.h | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7c32cb..6df0fbe 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5083,18 +5083,23 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
  * two cpus are in the same cache domain, see cpus_share_cache().
  */
 DEFINE_PER_CPU(struct sched_domain *, sd_llc);
+DEFINE_PER_CPU(int, sd_llc_size);
 DEFINE_PER_CPU(int, sd_llc_id);
 
 static void update_top_cache_domain(int cpu)
 {
 	struct sched_domain *sd;
 	int id = cpu;
+	int size = 1;
 
 	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
-	if (sd)
+	if (sd) {
 		id = cpumask_first(sched_domain_span(sd));
+		size = cpumask_weight(sched_domain_span(sd));
+	}
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
+	per_cpu(sd_llc_size, cpu) = size;
 	per_cpu(sd_llc_id, cpu) = id;
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 860063a..f237437 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3175,7 +3175,7 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
 
 static int wake_wide(struct task_struct *p)
 {
-	int factor = nr_cpus_node(cpu_to_node(smp_processor_id()));
+	int factor = this_cpu_read(sd_llc_size);
 
 	/*
 	 * Yeah, it's the switching-frequency, could means many wakee or
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 5e129ef..4c1cb80 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -594,6 +594,7 @@ static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
 }
 
 DECLARE_PER_CPU(struct sched_domain *, sd_llc);
+DECLARE_PER_CPU(int, sd_llc_size);
 DECLARE_PER_CPU(int, sd_llc_id);
 
 struct sched_group_power {
