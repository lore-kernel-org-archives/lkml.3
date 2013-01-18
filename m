Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab3ARTxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:53:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51846 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab3ARTxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:53:07 -0500
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: Rafael <rjw@sisk.pl>, Kevin <khilman@deeprootsystems.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        lkml <linux-kernel@vger.kernel.org>, lo <linux-omap@vger.kernel.org>,
        Jack <jack@embed.me.uk>, Alexander <holler@ahsoftware.de>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/4] cpufreq: OMAP: use RCU locks around usage of OPP
Date: Fri, 18 Jan 2013 13:52:32 -0600
Message-ID: <1358538755-29109-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358538755-29109-1-git-send-email-nm@ti.com>
References: <1358538755-29109-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OPP pointer is RCU protected, hence after finding it, de-reference
also should be protected with the same RCU context else the OPP
pointer may become invalid.

Reported-by: Alexander Holler <holler@ahsoftware.de>
Tested-by: Alexander Holler <holler@ahsoftware.de>
Acked-by: Alexander Holler <holler@ahsoftware.de>

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/cpufreq/omap-cpufreq.c |    3 +++
 1 file changed, 3 insertions(+)

Fixes warning as follows: http://dpaste.de/5j4qX/
[ 5.175323] ===============================
[ 5.179901] [ INFO: suspicious RCU usage. ]
[ 5.184295] 3.7.1-beagleboard-00018-g65ab3da-dirty #180 Not tainted
[ 5.190979] -------------------------------
[ 5.195465] drivers/base/power/opp.c:155 suspicious rcu_dereference_check() usage!
[ 5.203460]
[ 5.203460] other info that might help us debug this:
[ 5.203460]
[ 5.211914]
[ 5.211914] rcu_scheduler_active = 1, debug_locks = 0
[ 5.219055] 3 locks held by swapper/1:
[ 5.222991] #0: (subsys mutex#5){+.+.+.}, at: [<c026217c>] subsys_interface_register+0x34/0xbc
[ 5.232360] #1: (&per_cpu(cpu_policy_rwsem, cpu)){+.+.+.}, at: [<c02d9374>] lock_policy_rwsem_write+0x24/0x48
[ 5.243072] #2: (&this_dbs_info->timer_mutex){+.+...}, at: [<c02db234>] cpufreq_governor_dbs+0x2e8/0x380
[ 5.253295]
[ 5.253295] stack backtrace:
[ 5.257965] [<c0013198>] (unwind_backtrace+0x0/0xe0) from [<c026bd08>] (opp_get_voltage+0x5c/0xc0)
[ 5.267395] [<c026bd08>] (opp_get_voltage+0x5c/0xc0) from [<c02db928>] (omap_target+0x180/0x364)
[ 5.276672] [<c02db928>] (omap_target+0x180/0x364) from [<c02d8bbc>] (__cpufreq_driver_target+0x38/0x54)
[ 5.303039] [<c02d8bbc>] (__cpufreq_driver_target+0x38/0x54) from [<c02db260>] (cpufreq_governor_dbs+0x314/0x380)
[ 5.313903] [<c02db260>] (cpufreq_governor_dbs+0x314/0x380) from [<c02d948c>] (__cpufreq_governor+0x70/0xb4)
[ 5.324310] [<c02d948c>] (__cpufreq_governor+0x70/0xb4) from [<c02d96fc>] (__cpufreq_set_policy+0x150/0x168)
[ 5.334686] [<c02d96fc>] (__cpufreq_set_policy+0x150/0x168) from [<c02d9ae0>] (cpufreq_add_dev_interface+0x17c/0x1f0)
[ 5.345886] [<c02d9ae0>] (cpufreq_add_dev_interface+0x17c/0x1f0) from [<c02d9c80>] (cpufreq_add_dev+0x12c/0x1d8)
[ 5.356628] [<c02d9c80>] (cpufreq_add_dev+0x12c/0x1d8) from [<c02621c4>] (subsys_interface_register+0x7c/0xbc)
[ 5.367187] [<c02621c4>] (subsys_interface_register+0x7c/0xbc) from [<c02d91bc>] (cpufreq_register_driver+0x9c/0x128)
[ 5.378387] [<c02d91bc>] (cpufreq_register_driver+0x9c/0x128) from [<c00086a0>] (do_one_initcall+0x90/0x164)
[ 5.395812] [<c00086a0>] (do_one_initcall+0x90/0x164) from [<c03d5740>] (kernel_init+0xe4/0x298)
[ 5.408569] [<c03d5740>] (kernel_init+0xe4/0x298) from [<c000de30>] (ret_from_fork+0x14/0x24)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 1f3417a..97102b0 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -110,13 +110,16 @@ static int omap_target(struct cpufreq_policy *policy,
 	freq = ret;
 
 	if (mpu_reg) {
+		rcu_read_lock();
 		opp = opp_find_freq_ceil(mpu_dev, &freq);
 		if (IS_ERR(opp)) {
+			rcu_read_unlock();
 			dev_err(mpu_dev, "%s: unable to find MPU OPP for %d\n",
 				__func__, freqs.new);
 			return -EINVAL;
 		}
 		volt = opp_get_voltage(opp);
+		rcu_read_unlock();
 		tol = volt * OPP_TOLERANCE / 100;
 		volt_old = regulator_get_voltage(mpu_reg);
 	}
-- 
1.7.9.5

