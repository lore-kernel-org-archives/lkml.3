Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964870AbaE3Ol1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:41:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:55059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933513AbaE3OlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:41:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="548947036"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, bsegall@google.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        fengguang.wu@intel.com, yuyang.du@intel.com
Subject: [RFC PATCH 08/16 v3] Write CPU topology info for Workload Consolidation fields in sched_domain
Date: Fri, 30 May 2014 14:36:04 +0800
Message-Id: <1401431772-14320-9-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Write additional CPU topology info in sched_domain for our use in cpu_attach_domain()

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/core.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1cb7402..9df01d5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5496,6 +5496,31 @@ static void update_top_cache_domain(int cpu)
 	rcu_assign_pointer(per_cpu(sd_asym, cpu), sd);
 }
 
+static void update_cpu_position_info(struct sched_domain *sd)
+{
+	while (sd) {
+		int i = 0, j = 0, first, min = INT_MAX;
+		struct sched_group *group;
+
+		group = sd->groups;
+		first = group_first_cpu(group);
+		do {
+			int k = group_first_cpu(group);
+			i += 1;
+			if (k < first)
+				j += 1;
+			if (k < min) {
+				sd->first_group = group;
+				min = k;
+			}
+		} while (group = group->next, group != sd->groups);
+
+		sd->total_groups = i;
+		sd->group_number = j;
+		sd = sd->parent;
+	}
+}
+
 /*
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
@@ -5544,6 +5569,8 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	destroy_sched_domains(tmp, cpu);
 
 	update_top_cache_domain(cpu);
+
+	update_cpu_position_info(sd);
 }
 
 /* cpus with isolated domains */
-- 
1.7.9.5

