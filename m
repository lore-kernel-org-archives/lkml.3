Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749Ab3GWRmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:42:12 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61822 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361Ab3GWRmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:42:11 -0400
Subject: [PATCH v2] sched: update_top_cache_domain only at the times of
 building sched domain.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Jul 2013 23:42:12 +0600
Message-ID: <1374601332.9192.0.camel@localhost.localdomain>
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

Changes since v1: use sd to determine when to skip, courtesy PeterZ

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7c32cb..387fb66 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5138,7 +5138,8 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	rcu_assign_pointer(rq->sd, sd);
 	destroy_sched_domains(tmp, cpu);
 
-	update_top_cache_domain(cpu);
+	if (sd)
+		update_top_cache_domain(cpu);
 }
 
 /* cpus with isolated domains */



