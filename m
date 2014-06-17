Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966411AbaFQVtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:49:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54183 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966381AbaFQVt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:49:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bibek Basu <bbasu@nvidia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 171/212] cpufreq: remove race while accessing cur_policy
Date: Tue, 17 Jun 2014 14:44:25 -0700
Message-Id: <1403041506-13646-172-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibek Basu <bbasu@nvidia.com>

commit c5450db85b828d0c46ac8fc570fb8a51bf07ac40 upstream.

While accessing cur_policy during executing events
CPUFREQ_GOV_START, CPUFREQ_GOV_STOP, CPUFREQ_GOV_LIMITS,
same mutex lock is not taken, dbs_data->mutex, which leads
to race and data corruption while running continious suspend
resume test. This is seen with ondemand governor with suspend
resume test using rtcwake.

 Unable to handle kernel NULL pointer dereference at virtual address 00000028
 pgd = ed610000
 [00000028] *pgd=adf11831, *pte=00000000, *ppte=00000000
 Internal error: Oops: 17 [#1] PREEMPT SMP ARM
 Modules linked in: nvhost_vi
 CPU: 1 PID: 3243 Comm: rtcwake Not tainted 3.10.24-gf5cf9e5 #1
 task: ee708040 ti: ed61c000 task.ti: ed61c000
 PC is at cpufreq_governor_dbs+0x400/0x634
 LR is at cpufreq_governor_dbs+0x3f8/0x634
 pc : [<c05652b8>] lr : [<c05652b0>] psr: 600f0013
 sp : ed61dcb0 ip : 000493e0 fp : c1cc14f0
 r10: 00000000 r9 : 00000000 r8 : 00000000
 r7 : eb725280 r6 : c1cc1560 r5 : eb575200 r4 : ebad7740
 r3 : ee708040 r2 : ed61dca8 r1 : 001ebd24 r0 : 00000000
 Flags: nZCv IRQs on FIQs on Mode SVC_32 ISA ARM Segment user
 Control: 10c5387d Table: ad61006a DAC: 00000015
 [<c05652b8>] (cpufreq_governor_dbs+0x400/0x634) from [<c055f700>] (__cpufreq_governor+0x98/0x1b4)
 [<c055f700>] (__cpufreq_governor+0x98/0x1b4) from [<c0560770>] (__cpufreq_set_policy+0x250/0x320)
 [<c0560770>] (__cpufreq_set_policy+0x250/0x320) from [<c0561dcc>] (cpufreq_update_policy+0xcc/0x168)
 [<c0561dcc>] (cpufreq_update_policy+0xcc/0x168) from [<c0561ed0>] (cpu_freq_notify+0x68/0xdc)
 [<c0561ed0>] (cpu_freq_notify+0x68/0xdc) from [<c008eff8>] (notifier_call_chain+0x4c/0x8c)
 [<c008eff8>] (notifier_call_chain+0x4c/0x8c) from [<c008f3d4>] (__blocking_notifier_call_chain+0x50/0x68)
 [<c008f3d4>] (__blocking_notifier_call_chain+0x50/0x68) from [<c008f40c>] (blocking_notifier_call_chain+0x20/0x28)
 [<c008f40c>] (blocking_notifier_call_chain+0x20/0x28) from [<c00aac6c>] (pm_qos_update_bounded_target+0xd8/0x310)
 [<c00aac6c>] (pm_qos_update_bounded_target+0xd8/0x310) from [<c00ab3b0>] (__pm_qos_update_request+0x64/0x70)
 [<c00ab3b0>] (__pm_qos_update_request+0x64/0x70) from [<c004b4b8>] (tegra_pm_notify+0x114/0x134)
 [<c004b4b8>] (tegra_pm_notify+0x114/0x134) from [<c008eff8>] (notifier_call_chain+0x4c/0x8c)
 [<c008eff8>] (notifier_call_chain+0x4c/0x8c) from [<c008f3d4>] (__blocking_notifier_call_chain+0x50/0x68)
 [<c008f3d4>] (__blocking_notifier_call_chain+0x50/0x68) from [<c008f40c>] (blocking_notifier_call_chain+0x20/0x28)
 [<c008f40c>] (blocking_notifier_call_chain+0x20/0x28) from [<c00ac228>] (pm_notifier_call_chain+0x1c/0x34)
 [<c00ac228>] (pm_notifier_call_chain+0x1c/0x34) from [<c00ad38c>] (enter_state+0xec/0x128)
 [<c00ad38c>] (enter_state+0xec/0x128) from [<c00ad400>] (pm_suspend+0x38/0xa4)
 [<c00ad400>] (pm_suspend+0x38/0xa4) from [<c00ac114>] (state_store+0x70/0xc0)
 [<c00ac114>] (state_store+0x70/0xc0) from [<c027b1e8>] (kobj_attr_store+0x14/0x20)
 [<c027b1e8>] (kobj_attr_store+0x14/0x20) from [<c019cd9c>] (sysfs_write_file+0x104/0x184)
 [<c019cd9c>] (sysfs_write_file+0x104/0x184) from [<c0143038>] (vfs_write+0xd0/0x19c)
 [<c0143038>] (vfs_write+0xd0/0x19c) from [<c0143414>] (SyS_write+0x4c/0x78)
 [<c0143414>] (SyS_write+0x4c/0x78) from [<c000f080>] (ret_fast_syscall+0x0/0x30)
 Code: e1a00006 eb084346 e59b0020 e5951024 (e5903028)
 ---[ end trace 0488523c8f6b0f9d ]---

Signed-off-by: Bibek Basu <bbasu@nvidia.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpufreq/cpufreq_governor.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index e6be635..922ab10 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -362,6 +362,11 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		break;
 
 	case CPUFREQ_GOV_LIMITS:
+		mutex_lock(&dbs_data->mutex);
+		if (!cpu_cdbs->cur_policy) {
+			mutex_unlock(&dbs_data->mutex);
+			break;
+		}
 		mutex_lock(&cpu_cdbs->timer_mutex);
 		if (policy->max < cpu_cdbs->cur_policy->cur)
 			__cpufreq_driver_target(cpu_cdbs->cur_policy,
@@ -371,6 +376,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 					policy->min, CPUFREQ_RELATION_L);
 		dbs_check_cpu(dbs_data, cpu);
 		mutex_unlock(&cpu_cdbs->timer_mutex);
+		mutex_unlock(&dbs_data->mutex);
 		break;
 	}
 	return 0;
-- 
1.9.1

