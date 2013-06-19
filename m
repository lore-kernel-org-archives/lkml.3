Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab3FSSlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:41:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40176 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3FSSld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:41:33 -0400
Date: Wed, 19 Jun 2013 11:41:03 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-cd08e9234c987766ad077bba80eb5a07d0855525@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <7a61e955abdcbb1dfa9fe493f11a5ec53a11ddd3.1370948150.git.viresh.kumar@linaro.org>
References: <7a61e955abdcbb1dfa9fe493f11a5ec53a11ddd3.1370948150.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix memory leakage in build_sched_groups(
 )
Git-Commit-ID: cd08e9234c987766ad077bba80eb5a07d0855525
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:41:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd08e9234c987766ad077bba80eb5a07d0855525
Gitweb:     http://git.kernel.org/tip/cd08e9234c987766ad077bba80eb5a07d0855525
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 11 Jun 2013 16:32:44 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:58:46 +0200

sched: Fix memory leakage in build_sched_groups()

In build_sched_groups() we don't need to call get_group() for cpus
which are already covered in previous iterations. Calling get_group()
would mark the group used and eventually leak it since we wouldn't
connect it and not find it again to free it.

This will happen only in cases where sg->cpumask contained more than
one cpu (For any topology level). This patch would free sg's memory
for all cpus leaving the group leader as the group isn't marked used
now.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/7a61e955abdcbb1dfa9fe493f11a5ec53a11ddd3.1370948150.git.viresh.kumar@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3388387..014c97f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5357,12 +5357,12 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 
 	for_each_cpu(i, span) {
 		struct sched_group *sg;
-		int group = get_group(i, sdd, &sg);
-		int j;
+		int group, j;
 
 		if (cpumask_test_cpu(i, covered))
 			continue;
 
+		group = get_group(i, sdd, &sg);
 		cpumask_clear(sched_group_cpus(sg));
 		sg->sgp->power = 0;
 		cpumask_setall(sched_group_mask(sg));
