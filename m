Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab3FDLUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:20:49 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46621 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab3FDLUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:20:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] sched: Optimize build_sched_domains() for saving first SD node for a cpu
Date: Tue,  4 Jun 2013 16:50:18 +0530
Message-Id: <d226c91fed3dfa2dca644d14c88b1d1ff9d2e722.1370344689.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are saving first scheduling domain for a cpu in build_sched_domains() by
iterating over the nested sd->child list. We don't actually need to do it this
way.

*per_cpu_ptr(d.sd, i) is guaranteed to be NULL in the beginning as we have
called __visit_domain_allocation_hell() which does a memset to zero for struct
s_data.

So, save pointer to first SD while running the iteration loop over tl's.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/sched/core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58453b8..638f6cb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6533,16 +6533,13 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 		sd = NULL;
 		for (tl = sched_domain_topology; tl->init; tl++) {
 			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
+			if (!*per_cpu_ptr(d.sd, i))
+				*per_cpu_ptr(d.sd, i) = sd;
 			if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
 				sd->flags |= SD_OVERLAP;
 			if (cpumask_equal(cpu_map, sched_domain_span(sd)))
 				break;
 		}
-
-		while (sd->child)
-			sd = sd->child;
-
-		*per_cpu_ptr(d.sd, i) = sd;
 	}
 
 	/* Build the groups for the domains */
-- 
1.7.12.rc2.18.g61b472e

