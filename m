Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816Ab3E3Bvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 21:51:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:9907 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759777Ab3E3Bv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 21:51:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,767,1363158000"; 
   d="scan'208";a="345417516"
Message-ID: <51A6B07C.4060108@intel.com>
Date: Thu, 30 May 2013 09:50:52 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lukasz Majewski <l.majewski@samsung.com>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] sched:fix: Signed overflow prevention for vacancy
 calculation
References: <1369298064-14998-1-git-send-email-l.majewski@samsung.com> <1369298064-14998-2-git-send-email-l.majewski@samsung.com>
In-Reply-To: <1369298064-14998-2-git-send-email-l.majewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 04:34 PM, Lukasz Majewski wrote:
> Nasty bug with vacancy calculation has been fixed.
> In the if statement the FULL_UTIL is a large constant, max_cfs_util()
> returns unsigned and putil is also defined as unsigned. The outcome
> is that this condition is always true.
> 
> As observed, this was the reason for frequent jumps of processes between
> CPUs.
> 
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Thanks for the catching!
I do a little change, would you like to keep the authorship?

---

>From 4f7f2d091b7210e0be689d3e063d3cc82da1b1af Mon Sep 17 00:00:00 2001
From: Lukasz Majewski <l.majewski@samsung.com>
Date: Thu, 30 May 2013 09:21:46 +0800
Subject: [PATCH 2/2] sched:fix: Signed overflow prevention for vacancy
 calculation

Nasty bug with vacancy calculation has been fixed.
In the if statement the FULL_UTIL is a large constant, max_cfs_util()
returns unsigned and putil is also defined as unsigned. The outcome
is that this condition is always true.

As observed, this was the reason for frequent jumps of processes between
CPUs.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3a4917c..56a9d16 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3468,10 +3468,10 @@ find_leader_cpu(struct sched_group *group, struct task_struct *p, int this_cpu,
 	unsigned putil;
 	putil = div_u64(((u64)p->se.avg.runnable_avg_sum << SCHED_POWER_SHIFT),
 				p->se.avg.runnable_avg_period + 1);
+	vacancy = FULL_UTIL - max_cfs_util(this_cpu, wakeup) - (putil << 2);
 
 	/* bias toward local cpu */
-	if (cpumask_test_cpu(this_cpu, tsk_cpus_allowed(p)) &&
-		FULL_UTIL - max_cfs_util(this_cpu, wakeup) - (putil << 2) > 0)
+	if (cpumask_test_cpu(this_cpu, tsk_cpus_allowed(p)) && vacancy > 0)
 		return this_cpu;
 
 	/* Traverse only the allowed CPUs */
-- 
1.7.12


-- 
Thanks
    Alex
