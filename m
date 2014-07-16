Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaGPXfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:35:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49867 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGPXfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:35:43 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@deeprootsystems.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] PM / OPP: cpufreq: Avoid sleeping while atomic
Date: Wed, 16 Jul 2014 16:35:40 -0700
Message-Id: <1405553740-5067-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocate the cpufreq table after calling rcu_read_lock(),
which disables preemption. This causes scheduling while atomic
warnings. Use GFP_ATOMIC instead of GFP_KERNEL and update for
kcalloc while we're here.

BUG: sleeping function called from invalid context at mm/slub.c:1246
in_atomic(): 0, irqs_disabled(): 0, pid: 80, name: modprobe
5 locks held by modprobe/80:
 #0:  (&dev->mutex){......}, at: [<c050d484>] __driver_attach+0x48/0x98
 #1:  (&dev->mutex){......}, at: [<c050d494>] __driver_attach+0x58/0x98
 #2:  (subsys mutex#5){+.+.+.}, at: [<c050c114>] subsys_interface_register+0x38/0xc8
 #3:  (cpufreq_rwsem){.+.+.+}, at: [<c05a9c8c>] __cpufreq_add_dev.isra.22+0x84/0x92c
 #4:  (rcu_read_lock){......}, at: [<c05ab24c>] dev_pm_opp_init_cpufreq_table+0x18/0x10c
Preemption disabled at:[<  (null)>]   (null)

CPU: 2 PID: 80 Comm: modprobe Not tainted 3.16.0-rc3-next-20140701-00035-g286857f216aa-dirty #217
[<c0214da8>] (unwind_backtrace) from [<c02123f8>] (show_stack+0x10/0x14)
[<c02123f8>] (show_stack) from [<c070141c>] (dump_stack+0x70/0xbc)
[<c070141c>] (dump_stack) from [<c02f4cb0>] (__kmalloc+0x124/0x250)
[<c02f4cb0>] (__kmalloc) from [<c05ab270>] (dev_pm_opp_init_cpufreq_table+0x3c/0x10c)
[<c05ab270>] (dev_pm_opp_init_cpufreq_table) from [<bf000508>] (cpufreq_init+0x48/0x378 [cpufreq_generic])
[<bf000508>] (cpufreq_init [cpufreq_generic]) from [<c05a9e08>] (__cpufreq_add_dev.isra.22+0x200/0x92c)
[<c05a9e08>] (__cpufreq_add_dev.isra.22) from [<c050c160>] (subsys_interface_register+0x84/0xc8)
[<c050c160>] (subsys_interface_register) from [<c05a9494>] (cpufreq_register_driver+0x108/0x2d8)
[<c05a9494>] (cpufreq_register_driver) from [<bf000888>] (generic_cpufreq_probe+0x50/0x74 [cpufreq_generic])
[<bf000888>] (generic_cpufreq_probe [cpufreq_generic]) from [<c050e994>] (platform_drv_probe+0x18/0x48)
[<c050e994>] (platform_drv_probe) from [<c050d1f4>] (driver_probe_device+0x128/0x370)
[<c050d1f4>] (driver_probe_device) from [<c050d4d0>] (__driver_attach+0x94/0x98)
[<c050d4d0>] (__driver_attach) from [<c050b778>] (bus_for_each_dev+0x54/0x88)
[<c050b778>] (bus_for_each_dev) from [<c050c894>] (bus_add_driver+0xe8/0x204)
[<c050c894>] (bus_add_driver) from [<c050dd48>] (driver_register+0x78/0xf4)
[<c050dd48>] (driver_register) from [<c0208870>] (do_one_initcall+0xac/0x1d8)
[<c0208870>] (do_one_initcall) from [<c028b6b4>] (load_module+0x190c/0x21e8)
[<c028b6b4>] (load_module) from [<c028c034>] (SyS_init_module+0xa4/0x110)
[<c028c034>] (SyS_init_module) from [<c020f0c0>] (ret_fast_syscall+0x0/0x48)

Fixes: a0dd7b79657b "PM / OPP: Move cpufreq specific OPP functions out of generic OPP library"
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Nishanth Menon <nm@ti.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

It would be nice to not do atomic allocations, but I guess the table could
change size?

 drivers/cpufreq/cpufreq_opp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_opp.c b/drivers/cpufreq/cpufreq_opp.c
index c0c6f4a4eccf..f7a32d2326c6 100644
--- a/drivers/cpufreq/cpufreq_opp.c
+++ b/drivers/cpufreq/cpufreq_opp.c
@@ -60,7 +60,7 @@ int dev_pm_opp_init_cpufreq_table(struct device *dev,
 		goto out;
 	}
 
-	freq_table = kzalloc(sizeof(*freq_table) * (max_opps + 1), GFP_KERNEL);
+	freq_table = kcalloc(sizeof(*freq_table), (max_opps + 1), GFP_ATOMIC);
 	if (!freq_table) {
 		ret = -ENOMEM;
 		goto out;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

