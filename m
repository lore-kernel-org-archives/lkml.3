Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165Ab3GWPoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:44:18 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61343 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3GWPoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:44:16 -0400
Subject: [PATCH, RFC] sched: update_top_cache_domain only at the times of
 building sched domain.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: mingo@kernel.org, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Jul 2013 21:44:17 +0600
Message-ID: <1374594257.5382.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Currently, update_top_cache_domain() is called whenever schedule domain is built or destroyed. But, the following
callpath shows that they're at the same callpath and can be avoided update_top_cache_domain() while destroying schedule
domain and update only at the times of building schedule domains.

	partition_sched_domains()
		detach_destroy_domain()
			cpu_attach_domain()
				update_top_cache_domain()
		build_sched_domains()
			cpu_attach_domain()
				update_top_cache_domain()
		
			

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7c32cb..8c6fee4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5102,8 +5102,8 @@ static void update_top_cache_domain(int cpu)
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
  */
-static void
-cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
+static void cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd,
+				int cpu, bool update_cache_domain)
 {
 	struct rq *rq = cpu_rq(cpu);
 	struct sched_domain *tmp;
@@ -5138,7 +5138,8 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	rcu_assign_pointer(rq->sd, sd);
 	destroy_sched_domains(tmp, cpu);
 
-	update_top_cache_domain(cpu);
+	if (update_cache_domain)
+		update_top_cache_domain(cpu);
 }
 
 /* cpus with isolated domains */
@@ -6021,7 +6022,7 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 	rcu_read_lock();
 	for_each_cpu(i, cpu_map) {
 		sd = *per_cpu_ptr(d.sd, i);
-		cpu_attach_domain(sd, d.rd, i);
+		cpu_attach_domain(sd, d.rd, i, 1);
 	}
 	rcu_read_unlock();
 
@@ -6109,7 +6110,7 @@ static void detach_destroy_domains(const struct cpumask *cpu_map)
 
 	rcu_read_lock();
 	for_each_cpu(i, cpu_map)
-		cpu_attach_domain(NULL, &def_root_domain, i);
+		cpu_attach_domain(NULL, &def_root_domain, i, 0);
 	rcu_read_unlock();
 }
 


