Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3EPFKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 01:10:51 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33272 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab3EPFKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 01:10:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/3] cpufreq: Drop rwsem lock around CPUFREQ_GOV_POLICY_EXIT
Date: Thu, 16 May 2013 10:39:58 +0530
Message-Id: <84fda3b9bd78dbdb8bd062b130365342b4cf202b.1368679353.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1368679353.git.viresh.kumar@linaro.org>
References: <cover.1368679353.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1368679353.git.viresh.kumar@linaro.org>
References: <cover.1368679353.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this lock around __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT), we
get circular dependency when we call sysfs_remove_group().

[  195.319079] ======================================================
[  195.337653] [ INFO: possible circular locking dependency detected ]
[  195.356497] 3.9.0-rc7+ #15 Not tainted
[  195.367758] -------------------------------------------------------
[  195.386613] cat/2387 is trying to acquire lock:
[  195.400176]  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<c02f6179>] lock_policy_rwsem_read+0x25/0x34
[  195.428920]
[  195.428920] but task is already holding lock:
[  195.446393]  (s_active#41){++++.+}, at: [<c00f9bf7>] sysfs_read_file+0x4f/0xcc
[  195.468305]
[  195.468305] which lock already depends on the new lock.
[  195.468305]
[  195.492830]
[  195.492830] the existing dependency chain (in reverse order) is:
[  195.515250]
-> #1 (s_active#41){++++.+}:
[  195.527647]        [<c0055a79>] lock_acquire+0x61/0xbc
[  195.543129]        [<c00fabf1>] sysfs_addrm_finish+0xc1/0x128
[  195.560362]        [<c00f9819>] sysfs_hash_and_remove+0x35/0x64
[  195.578119]        [<c00fbe6f>] remove_files.isra.0+0x1b/0x24
[  195.595497]        [<c00fbea5>] sysfs_remove_group+0x2d/0xa8
[  195.612469]        [<c02f9a0b>] cpufreq_governor_interactive+0x13b/0x35c
[  195.632668]        [<c02f61df>] __cpufreq_governor+0x2b/0x8c
[  195.649644]        [<c02f6579>] __cpufreq_set_policy+0xa9/0xf8
[  195.667132]        [<c02f6b75>] store_scaling_governor+0x61/0x100
[  195.685404]        [<c02f6f4d>] store+0x39/0x60
[  195.698989]        [<c00f9b81>] sysfs_write_file+0xed/0x114
[  195.715694]        [<c00b3fd1>] vfs_write+0x65/0xd8
[  195.730320]        [<c00b424b>] sys_write+0x2f/0x50
[  195.744943]        [<c000cdc1>] ret_fast_syscall+0x1/0x52
[  195.761135]
-> #0 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
[  195.778665]        [<c0055253>] __lock_acquire+0xef3/0x13dc
[  195.795371]        [<c0055a79>] lock_acquire+0x61/0xbc
[  195.810776]        [<c03ee1f5>] down_read+0x25/0x30
[  195.825398]        [<c02f6179>] lock_policy_rwsem_read+0x25/0x34
[  195.843410]        [<c02f6edd>] show+0x21/0x58
[  195.856731]        [<c00f9c0f>] sysfs_read_file+0x67/0xcc
[  195.872919]        [<c00b40a7>] vfs_read+0x63/0xd8
[  195.887282]        [<c00b41fb>] sys_read+0x2f/0x50
[  195.901645]        [<c000cdc1>] ret_fast_syscall+0x1/0x52
[  195.917863]
[  195.917863] other info that might help us debug this:
[  195.917863]
[  195.941853]  Possible unsafe locking scenario:
[  195.941853]
[  195.959586]        CPU0                    CPU1
[  195.973149]        ----                    ----
[  195.986712]   lock(s_active#41);
[  195.996407]                                lock(&per_cpu(cpu_policy_rwsem, cpu));
[  196.018912]                                lock(s_active#41);
[  196.036161]   lock(&per_cpu(cpu_policy_rwsem, cpu));
[  196.051051]
[  196.051051]  *** DEADLOCK ***
[  196.051051]
[  196.068792] 2 locks held by cat/2387:
[  196.079750]  #0:  (&buffer->mutex){+.+.+.}, at: [<c00f9bcd>] sysfs_read_file+0x25/0xcc
[  196.103546]  #1:  (s_active#41){++++.+}, at: [<c00f9bf7>] sysfs_read_file+0x4f/0xcc
[  196.126577]
[  196.126577] stack backtrace:
[  196.139644] [<c0011d55>] (unwind_backtrace+0x1/0x9c) from [<c03e9a09>] (print_circular_bug+0x19d/0x1e8)
[  196.167857] [<c03e9a09>] (print_circular_bug+0x19d/0x1e8) from [<c0055253>] (__lock_acquire+0xef3/0x13dc)
[  196.196542] [<c0055253>] (__lock_acquire+0xef3/0x13dc) from [<c0055a79>] (lock_acquire+0x61/0xbc)
[  196.223139] [<c0055a79>] (lock_acquire+0x61/0xbc) from [<c03ee1f5>] (down_read+0x25/0x30)
[  196.247722] [<c03ee1f5>] (down_read+0x25/0x30) from [<c02f6179>] (lock_policy_rwsem_read+0x25/0x34)
[  196.274905] [<c02f6179>] (lock_policy_rwsem_read+0x25/0x34) from [<c02f6edd>] (show+0x21/0x58)
[  196.300724] [<c02f6edd>] (show+0x21/0x58) from [<c00f9c0f>] (sysfs_read_file+0x67/0xcc)
[  196.324719] [<c00f9c0f>] (sysfs_read_file+0x67/0xcc) from [<c00b40a7>] (vfs_read+0x63/0xd8)
[  196.349756] [<c00b40a7>] (vfs_read+0x63/0xd8) from [<c00b41fb>] (sys_read+0x2f/0x50)
[  196.372970] [<c00b41fb>] (sys_read+0x2f/0x50) from [<c000cdc1>] (ret_fast_syscall+0x1/0x52)

This lock isn't required while calling __cpufreq_governor(policy,
CPUFREQ_GOV_POLICY_EXIT). Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index cb0f723..2d5a829 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1739,18 +1739,23 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 			/* end old governor */
 			if (data->governor) {
 				__cpufreq_governor(data, CPUFREQ_GOV_STOP);
+				unlock_policy_rwsem_write(policy->cpu);
 				__cpufreq_governor(data,
 						CPUFREQ_GOV_POLICY_EXIT);
+				lock_policy_rwsem_write(policy->cpu);
 			}
 
 			/* start new governor */
 			data->governor = policy->governor;
 			if (!__cpufreq_governor(data, CPUFREQ_GOV_POLICY_INIT)) {
-				if (!__cpufreq_governor(data, CPUFREQ_GOV_START))
+				if (!__cpufreq_governor(data, CPUFREQ_GOV_START)) {
 					failed = 0;
-				else
+				} else {
+					unlock_policy_rwsem_write(policy->cpu);
 					__cpufreq_governor(data,
 							CPUFREQ_GOV_POLICY_EXIT);
+					lock_policy_rwsem_write(policy->cpu);
+				}
 			}
 
 			if (failed) {
-- 
1.7.12.rc2.18.g61b472e

