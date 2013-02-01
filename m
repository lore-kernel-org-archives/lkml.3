Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3BASrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:47:09 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:34883 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030183Ab3BASqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:46:03 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 4/6] cpufreq_stats: Do not track policies without associated governors.
Date: Fri,  1 Feb 2013 10:45:40 -0800
Message-Id: <1359744343-18690-7-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
References: <1359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Scaling drivers that implement internal governors do not have governor
sturctures associated with them.  Do not create/remove statisitcs
entries for polices that do not have governors associated with them.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/cpufreq_stats.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 9d7732b..8a1daf4 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -183,7 +183,7 @@ static void cpufreq_stats_free_table(unsigned int cpu)
 static void cpufreq_stats_free_sysfs(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
-	if (policy && policy->cpu == cpu)
+	if (policy && policy->cpu == cpu && policy->governor)
 		sysfs_remove_group(&policy->kobj, &stats_attr_group);
 	if (policy)
 		cpufreq_cpu_put(policy);
@@ -271,6 +271,8 @@ static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
 	unsigned int cpu = policy->cpu;
 	if (val != CPUFREQ_NOTIFY)
 		return 0;
+	if (!policy->governor)
+		return 0;
 	table = cpufreq_frequency_get_table(cpu);
 	if (!table)
 		return 0;
-- 
1.7.7.6

