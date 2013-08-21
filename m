Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab3HUKA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:00:26 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:38298 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3HUKAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:00:21 -0400
Message-ID: <52148FA9.806@huawei.com>
Date: Wed, 21 Aug 2013 18:00:09 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 07/11] cpuset: use effective cpumask to build sched domains
References: <52148F52.0@huawei.com>
In-Reply-To: <52148F52.0@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're going to have separate user-configured masks and effective ones,
and configured masks won't be restricted by the parent, so we should
use effective masks to build sched domains.

This won't introduce behavior change.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 0de15eb..e7ad4a7 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -500,11 +500,11 @@ out:
 #ifdef CONFIG_SMP
 /*
  * Helper routine for generate_sched_domains().
- * Do cpusets a, b have overlapping cpus_allowed masks?
+ * Do cpusets a, b have overlapping effective cpus_allowed masks?
  */
 static int cpusets_overlap(struct cpuset *a, struct cpuset *b)
 {
-	return cpumask_intersects(a->cpus_allowed, b->cpus_allowed);
+	return cpumask_intersects(a->real_cpus_allowed, b->real_cpus_allowed);
 }
 
 static void
@@ -621,7 +621,7 @@ static int generate_sched_domains(cpumask_var_t **domains,
 			*dattr = SD_ATTR_INIT;
 			update_domain_attr_tree(dattr, &top_cpuset);
 		}
-		cpumask_copy(doms[0], top_cpuset.cpus_allowed);
+		cpumask_copy(doms[0], top_cpuset.real_cpus_allowed);
 
 		goto done;
 	}
@@ -728,7 +728,7 @@ restart:
 			struct cpuset *b = csa[j];
 
 			if (apn == b->pn) {
-				cpumask_or(dp, dp, b->cpus_allowed);
+				cpumask_or(dp, dp, b->real_cpus_allowed);
 				if (dattr)
 					update_domain_attr_tree(dattr + nslot, b);
 
@@ -854,6 +854,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpuset *trialcs,
 {
 	struct cgroup_subsys_state *pos_css;
 	struct cpuset *cp;
+	bool need_rebuild_sched_domains = false;
 
 	rcu_read_lock();
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
@@ -887,10 +888,17 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpuset *trialcs,
 
 		update_tasks_cpumask(cp, heap);
 
+		if (!cpumask_empty(cp->cpus_allowed) &&
+		    is_sched_load_balance(cp))
+			need_rebuild_sched_domains = true;
+
 		rcu_read_lock();
 		css_put(&cp->css);
 	}
 	rcu_read_unlock();
+
+	if (need_rebuild_sched_domains)
+		rebuild_sched_domains_locked();
 }
 
 /**
@@ -944,9 +952,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	update_cpumasks_hier(cs, trialcs, &heap);
 
 	heap_free(&heap);
-
-	if (is_sched_load_balance(cs))
-		rebuild_sched_domains_locked();
 	return 0;
 }
 
-- 
1.8.0.2

