Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3BES0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:26:21 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38228 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3BESYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:24:23 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/7] cpufreq: Don't remove sysfs link for policy->cpu
Date: Tue,  5 Feb 2013 10:24:00 -0800
Message-Id: <1360088646-19104-2-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

"cpufreq" directory in policy->cpu is never created using sysfs_create_link(),
but using kobject_init_and_add(). And so we shouldn't call sysfs_remove_link()
for policy->cpu(). sysfs stuff for policy->cpu is automatically removed when we
call kobject_put() for dying policy.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/cpufreq/cpufreq.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 9656420..2817c3c 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1058,7 +1058,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	cpus = cpumask_weight(data->cpus);
 	cpumask_clear_cpu(cpu, data->cpus);
 
-	if (unlikely((cpu == data->cpu) && (cpus > 1))) {
+	if (cpu != data->cpu) {
+		sysfs_remove_link(&dev->kobj, "cpufreq");
+	} else if (cpus > 1) {
 		/* first sibling now owns the new sysfs dir */
 		cpu_dev = get_cpu_device(cpumask_first(data->cpus));
 		sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
@@ -1083,7 +1085,6 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
 	cpufreq_cpu_put(data);
 	unlock_policy_rwsem_write(cpu);
-	sysfs_remove_link(&dev->kobj, "cpufreq");
 
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
-- 
1.7.7.6

