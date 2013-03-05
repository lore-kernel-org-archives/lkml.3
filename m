Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3CEWPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:15:45 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:40138 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab3CEWPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:15:42 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: konrad.wilk@oracle.com, jwboyer@redhat.com,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 2/2] cpufreq/intel_pstate: Fix intel_pstate_init() error path
Date: Tue,  5 Mar 2013 14:15:27 -0800
Message-Id: <1362521727-20666-3-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1362521727-20666-1-git-send-email-dirk.brandewie@gmail.com>
References: <1362521727-20666-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

If cpufreq_register_driver() fails just free memory that has been
allocated and return. intel_pstate_exit() function is removed sine we
are built-in only now there is no reason for a module exit proceedure.

Reported-by:Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c |   39 +++++++++++----------------------------
 1 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 2bfd083..f6dd1e7 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -750,37 +750,11 @@ static struct cpufreq_driver intel_pstate_driver = {
 	.owner		= THIS_MODULE,
 };
 
-static void intel_pstate_exit(void)
-{
-	int cpu;
-
-	sysfs_remove_group(intel_pstate_kobject,
-				&intel_pstate_attr_group);
-	debugfs_remove_recursive(debugfs_parent);
-
-	cpufreq_unregister_driver(&intel_pstate_driver);
-
-	if (!all_cpu_data)
-		return;
-
-	get_online_cpus();
-	for_each_online_cpu(cpu) {
-		if (all_cpu_data[cpu]) {
-			del_timer_sync(&all_cpu_data[cpu]->timer);
-			kfree(all_cpu_data[cpu]);
-		}
-	}
-
-	put_online_cpus();
-	vfree(all_cpu_data);
-}
-module_exit(intel_pstate_exit);
-
 static int __initdata no_load;
 
 static int __init intel_pstate_init(void)
 {
-	int rc = 0;
+	int cpu, rc = 0;
 	const struct x86_cpu_id *id;
 
 	if (no_load)
@@ -805,7 +779,16 @@ static int __init intel_pstate_init(void)
 	intel_pstate_sysfs_expose_params();
 	return rc;
 out:
-	intel_pstate_exit();
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		if (all_cpu_data[cpu]) {
+			del_timer_sync(&all_cpu_data[cpu]->timer);
+			kfree(all_cpu_data[cpu]);
+		}
+	}
+
+	put_online_cpus();
+	vfree(all_cpu_data);
 	return -ENODEV;
 }
 device_initcall(intel_pstate_init);
-- 
1.7.7.6

