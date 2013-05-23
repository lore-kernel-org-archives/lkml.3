Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab3EWIgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:36:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37109 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab3EWIfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:35:44 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-49-519dd4dec47b
From: Lukasz Majewski <l.majewski@samsung.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/2] sched:fix: Signed overflow prevention for vacancy
 calculation
Date: Thu, 23 May 2013 10:34:24 +0200
Message-id: <1369298064-14998-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1369298064-14998-1-git-send-email-l.majewski@samsung.com>
References: <1369298064-14998-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t9jAd17V+YGGjT/NbDo3/aTxaLz7BNm
	i7NNb9gt3jzczGhxedccNovPvUcYLW43rmCz6DjyjdmBw2PxnpdMHneu7WHz6NuyitHj8ya5
	AJYoLpuU1JzMstQifbsErowbP46zFLzjqpj+rqqBsYWzi5GTQ0LARGL7x12sELaYxIV769lA
	bCGBRYwSFx6aQdhdTBKPHhqA2GwCehKf7z5lArFFBBQl3kx/wdLFyMXBLLCTSWL+0U5GkISw
	QIjEzd5vQEM5OFgEVCV2LS8DCfMKuElc+fiPCWKXvMTT+31guzgF3CXuvdjIDrHLTWLyg/1M
	Exh5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIDqhn0jsYVzVYHGIU4GBU4uGVuD0n
	UIg1say4MvcQowQHs5II7+aeuYFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRm
	p6YWpBbBZJk4OKUaGIs+XZt/zcV8Xnua7afpk1dJP0m/IlXkYaMxP3nGsd1zxAKS9pv/uN6/
	52nfYaVvy16I8nsoKqWtV7r8VfrU+rSjKzQ3TeFqfDyL70kfg7q8XJ/kJvH4fd3OD7ZOVJ11
	nytkwuHPokV7PZZYxhjq7OHrk//Hcs4gzP7S0uupZ/bO4Sv4ML85kkeJpTgj0VCLuag4EQCd
	BE4mJAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nasty bug with vacancy calculation has been fixed.
In the if statement the FULL_UTIL is a large constant, max_cfs_util()
returns unsigned and putil is also defined as unsigned. The outcome
is that this condition is always true.

As observed, this was the reason for frequent jumps of processes between
CPUs.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
This patch was developed on top of the following Alex's repository:
https://github.com/alexshi/power-scheduling/commits/power-scheduling
---
 kernel/sched/fair.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 14d29b3..8b07f6c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3476,9 +3476,10 @@ find_leader_cpu(struct sched_group *group, struct task_struct *p, int this_cpu,
 	do_div(tmp, (p->se.avg.runnable_avg_period + 1));
 	putil = (unsigned) tmp;
 
+	vacancy = (int) (FULL_UTIL - max_cfs_util(this_cpu, wakeup) -
+			 (putil << 2));
 	/* bias toward local cpu */
-	if (cpumask_test_cpu(this_cpu, tsk_cpus_allowed(p)) &&
-		FULL_UTIL - max_cfs_util(this_cpu, wakeup) - (putil << 2) > 0)
+	if (cpumask_test_cpu(this_cpu, tsk_cpus_allowed(p)) && vacancy > 0)
 		return this_cpu;
 
 	/* Traverse only the allowed CPUs */
-- 
1.7.10.4

