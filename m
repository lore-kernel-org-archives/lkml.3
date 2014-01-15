Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaAOOYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:24:15 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34625 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaAOOYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:24:13 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org
Cc: wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Alex Shi <alex.shi@linaro.org>
Subject: [RFC PATCH] sched: select_idle_sibling macro optimize
Date: Wed, 15 Jan 2014 22:23:28 +0800
Message-Id: <1389795808-32013-1-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the sd domain just has one group, then we must be caught the
	i == target later, and then goes to deeper level domain.
So just skip this domain checking to save some instructions.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c7395d9..3265fbc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4196,6 +4196,11 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	sd = rcu_dereference(per_cpu(sd_llc, target));
 	for_each_lower_domain(sd) {
 		sg = sd->groups;
+
+		/* skip single group domain */
+		if (sg == sg->next)
+			continue;
+
 		do {
 			if (!cpumask_intersects(sched_group_cpus(sg),
 						tsk_cpus_allowed(p)))
-- 
1.8.1.2

