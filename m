Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaBQJWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:22:25 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:44767 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaBQJWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:22:19 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, swarren@nvidia.com
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: remove sysfs link when a cpu != policy->cpu, is removed
Date: Mon, 17 Feb 2014 14:52:11 +0530
Message-Id: <324f43fc664f51eec355b08b6c2d4cedd2140b4c.1392628861.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier patch tried to do this but missed this piece of code to fix.

42f921a cpufreq: remove sysfs files for CPUs which failed to come back after
resume

Currently we are getting this on suspend/resume:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 877 at fs/sysfs/dir.c:52 sysfs_warn_dup+0x68/0x84()
sysfs: cannot create duplicate filename '/devices/system/cpu/cpu1/cpufreq'
Modules linked in: brcmfmac brcmutil
CPU: 0 PID: 877 Comm: test-rtc-resume Not tainted 3.14.0-rc2-00259-g9398a10cd964 #12
[<c0015bac>] (unwind_backtrace) from [<c0011850>] (show_stack+0x10/0x14)
[<c0011850>] (show_stack) from [<c056e018>] (dump_stack+0x80/0xcc)
[<c056e018>] (dump_stack) from [<c0025e44>] (warn_slowpath_common+0x64/0x88)
[<c0025e44>] (warn_slowpath_common) from [<c0025efc>] (warn_slowpath_fmt+0x30/0x40)
[<c0025efc>] (warn_slowpath_fmt) from [<c012776c>] (sysfs_warn_dup+0x68/0x84)
[<c012776c>] (sysfs_warn_dup) from [<c0127a54>] (sysfs_do_create_link_sd+0xb0/0xb8)
[<c0127a54>] (sysfs_do_create_link_sd) from [<c038ef64>] (__cpufreq_add_dev.isra.27+0x2a8/0x814)
[<c038ef64>] (__cpufreq_add_dev.isra.27) from [<c038f548>] (cpufreq_cpu_callback+0x70/0x8c)
[<c038f548>] (cpufreq_cpu_callback) from [<c0043864>] (notifier_call_chain+0x44/0x84)
[<c0043864>] (notifier_call_chain) from [<c0025f60>] (__cpu_notify+0x28/0x44)
[<c0025f60>] (__cpu_notify) from [<c00261e8>] (_cpu_up+0xf0/0x140)
[<c00261e8>] (_cpu_up) from [<c0569eb8>] (enable_nonboot_cpus+0x68/0xb0)
[<c0569eb8>] (enable_nonboot_cpus) from [<c006339c>] (suspend_devices_and_enter+0x198/0x2dc)
[<c006339c>] (suspend_devices_and_enter) from [<c0063654>] (pm_suspend+0x174/0x1e8)
[<c0063654>] (pm_suspend) from [<c00624e0>] (state_store+0x6c/0xbc)
[<c00624e0>] (state_store) from [<c01fc200>] (kobj_attr_store+0x14/0x20)
[<c01fc200>] (kobj_attr_store) from [<c0126e50>] (sysfs_kf_write+0x44/0x48)
[<c0126e50>] (sysfs_kf_write) from [<c012a274>] (kernfs_fop_write+0xb4/0x14c)
[<c012a274>] (kernfs_fop_write) from [<c00d4818>] (vfs_write+0xa8/0x180)
[<c00d4818>] (vfs_write) from [<c00d4bb8>] (SyS_write+0x3c/0x70)
[<c00d4bb8>] (SyS_write) from [<c000e620>] (ret_fast_syscall+0x0/0x30)
---[ end trace 76969904b614c18f ]---

Fix this by removing sysfs link for cpufreq directory when cpu removed isn't
policy->cpu.

Reported-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---

Fix for 3.14 only.

 drivers/cpufreq/cpufreq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 08ca8c9..cb003a6 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1323,8 +1323,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 	up_read(&policy->rwsem);
 
 	if (cpu != policy->cpu) {
-		if (!frozen)
-			sysfs_remove_link(&dev->kobj, "cpufreq");
+		sysfs_remove_link(&dev->kobj, "cpufreq");
 	} else if (cpus > 1) {
 		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu);
 		if (new_cpu >= 0) {
-- 
1.7.12.rc2.18.g61b472e

