Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab3D3Ocz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:32:55 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:53655 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3D3Ocw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:32:52 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] cpufreq: Issue CPUFREQ_GOV_POLICY_EXIT notifier before dropping policy refcount
Date: Tue, 30 Apr 2013 20:02:18 +0530
Message-Id: <a075fe570ce746dd9425a8ffa4f06fdf3a0e3965.1367332148.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1367332148.git.viresh.kumar@linaro.org>
References: <cover.1367332148.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1367332148.git.viresh.kumar@linaro.org>
References: <cover.1367332148.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must call __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT) before calling
cpufreq_cpu_put(data), so that policy kobject have valid fields. Otherwise,
removing last online cpu of policy->cpus causes this crash for
ondemand/conservative governor.

[  146.386064] [<c00fb076>] (sysfs_find_dirent+0xe/0xa8) from [<c00fb1bd>] (sysfs_get_dirent+0x21/0x58)
[  146.413440] [<c00fb1bd>] (sysfs_get_dirent+0x21/0x58) from [<c00fc259>] (sysfs_remove_group+0x85/0xbc)
[  146.441338] [<c00fc259>] (sysfs_remove_group+0x85/0xbc) from [<c02faad9>] (cpufreq_governor_dbs+0x369/0x4a0)
[  146.470795] [<c02faad9>] (cpufreq_governor_dbs+0x369/0x4a0) from [<c02f66d7>] (__cpufreq_governor+0x2b/0x8c)
[  146.500254] [<c02f66d7>] (__cpufreq_governor+0x2b/0x8c) from [<c02f6893>] (__cpufreq_remove_dev.isra.12+0x15b/0x250)
[  146.531799] [<c02f6893>] (__cpufreq_remove_dev.isra.12+0x15b/0x250) from [<c03e91c7>] (cpufreq_cpu_callback+0x2f/0x3c)
[  146.563860] [<c03e91c7>] (cpufreq_cpu_callback+0x2f/0x3c) from [<c0036fe1>] (notifier_call_chain+0x45/0x54)
[  146.593059] [<c0036fe1>] (notifier_call_chain+0x45/0x54) from [<c001e611>] (__cpu_notify+0x1d/0x34)
[  146.620177] [<c001e611>] (__cpu_notify+0x1d/0x34) from [<c03e5833>] (_cpu_down+0x63/0x1ac)
[  146.644948] [<c03e5833>] (_cpu_down+0x63/0x1ac) from [<c03e5997>] (cpu_down+0x1b/0x30)
[  146.668675] [<c03e5997>] (cpu_down+0x1b/0x30) from [<c03e60eb>] (store_online+0x27/0x54)
[  146.692922] [<c03e60eb>] (store_online+0x27/0x54) from [<c0295629>] (dev_attr_store+0x11/0x18)
[  146.718733] [<c0295629>] (dev_attr_store+0x11/0x18) from [<c00f9edd>] (sysfs_write_file+0xed/0x114)
[  146.745847] [<c00f9edd>] (sysfs_write_file+0xed/0x114) from [<c00b42a9>] (vfs_write+0x65/0xd8)
[  146.771656] [<c00b42a9>] (vfs_write+0x65/0xd8) from [<c00b4523>] (sys_write+0x2f/0x50)
[  146.795384] [<c00b4523>] (sys_write+0x2f/0x50) from [<c000cdc1>] (ret_fast_syscall+0x1/0x52)

Of course this only impacted drivers which have have_governor_per_policy set to
true. i.e. big LITTLE cpufreq driver.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1b8a48e..b7acfd1 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1075,14 +1075,14 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 				__func__, cpu_dev->id, cpu);
 	}
 
+	if ((cpus == 1) && (cpufreq_driver->target))
+		__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
+
 	pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
 	cpufreq_cpu_put(data);
 
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
-		if (cpufreq_driver->target)
-			__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
-
 		lock_policy_rwsem_read(cpu);
 		kobj = &data->kobj;
 		cmp = &data->kobj_unregister;
-- 
1.7.12.rc2.18.g61b472e

