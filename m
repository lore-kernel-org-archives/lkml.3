Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaEWSRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:17:34 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36426 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaEWSQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:16:57 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: [RFC PATCH 14/16] sched: Use energy model in select_idle_sibling
Date: Fri, 23 May 2014 19:16:41 +0100
Message-Id: <1400869003-27769-15-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 23 May 2014 18:16:55.0838 (UTC) FILETIME=[2DE723E0:01CF76B3]
X-MC-Unique: 114052319165517301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4NIHcW0005157

Make select_idle_sibling() consider energy when picking an idle cpu.

Only idle cpus are still considered. A more aggressive energy conserving
approach could go further and consider partly utilized cpus.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5a52467..542c2b2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4644,7 +4644,9 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	struct sched_domain *sd;
 	struct sched_group *sg;
 	int i = task_cpu(p);
+	int target_energy;
 
+#ifndef CONFIG_SCHED_ENERGY
 	if (idle_cpu(target))
 		return target;
 
@@ -4653,6 +4655,8 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	 */
 	if (i != target && cpus_share_cache(i, target) && idle_cpu(i))
 		return i;
+#endif
+	target_energy = energy_diff_task(target, p);
 
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
@@ -4666,8 +4670,12 @@ static int select_idle_sibling(struct task_struct *p, int target)
 				goto next;
 
 			for_each_cpu(i, sched_group_cpus(sg)) {
+				int diff;
 				if (i == target || !idle_cpu(i))
 					goto next;
+				diff = energy_diff_task(i, p);
+				if (diff > target_energy)
+					goto next;
 			}
 
 			target = cpumask_first_and(sched_group_cpus(sg),
-- 
1.7.9.5


