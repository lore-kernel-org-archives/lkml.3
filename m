Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3ARTy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:54:28 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47563 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673Ab3ARTxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:53:06 -0500
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: Rafael <rjw@sisk.pl>, Kevin <khilman@deeprootsystems.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        lkml <linux-kernel@vger.kernel.org>, lo <linux-omap@vger.kernel.org>,
        Jack <jack@embed.me.uk>, Alexander <holler@ahsoftware.de>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/4] cpufreq: cpufreq-cpu0: use RCU locks around usage of OPP
Date: Fri, 18 Jan 2013 13:52:33 -0600
Message-ID: <1358538755-29109-3-git-send-email-nm@ti.com>
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

Reported-by: Jack Mitchell <jack@embed.me.uk>
Tested-by: Alexander Holler <holler@ahsoftware.de>
Tested-by: Jack Mitchell <jack@embed.me.uk>
Acked-by: Alexander Holler <holler@ahsoftware.de>

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/cpufreq/cpufreq-cpu0.c |    5 +++++
 1 file changed, 5 insertions(+)

Fixes warning as shown in: http://pastebin.com/6Y0bpCFi
Something similar to this was attempted to be addressed by: https://patchwork.kernel.org/patch/879022/
[    2.321123] ===============================
[    2.325591] [ INFO: suspicious RCU usage. ]
[    2.330063] 3.8.0-rc4-00291-gbb85e3f-dirty #2 Not tainted
[    2.335805] -------------------------------
[    2.340270] drivers/base/power/opp.c:157 suspicious rcu_dereference_check() usage!
[    2.348285] other info that might help us debug this:
[    2.356769] rcu_scheduler_active = 1, debug_locks = 1
[    2.363727] no locks held by swapper/0/1.
[    2.368006] stack backtrace:
[    2.372707] [<c0013678>] (unwind_backtrace+0x0/0xe0) from [<c03475bc>] (opp_get_voltage+0x78/0xc8)
[    2.382219] [<c03475bc>] (opp_get_voltage+0x78/0xc8) from [<c04046e4>] (cpu0_cpufreq_driver_init+0x154/0x208)
[    2.392727] [<c04046e4>] (cpu0_cpufreq_driver_init+0x154/0x208) from [<c0008878>] (do_one_initcall+0x90/0x164)
[    2.403323] [<c0008878>] (do_one_initcall+0x90/0x164) from [<c0547698>] (kernel_init+0xf8/0x290)
[    2.412646] [<c0547698>] (kernel_init+0xf8/0x290) from [<c000d9b0>] (ret_from_fork+0x14/0x24)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 52bf36d..debc5a7 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -71,12 +71,15 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 	}
 
 	if (cpu_reg) {
+		rcu_read_lock();
 		opp = opp_find_freq_ceil(cpu_dev, &freq_Hz);
 		if (IS_ERR(opp)) {
+			rcu_read_unlock();
 			pr_err("failed to find OPP for %ld\n", freq_Hz);
 			return PTR_ERR(opp);
 		}
 		volt = opp_get_voltage(opp);
+		rcu_read_unlock();
 		tol = volt * voltage_tolerance / 100;
 		volt_old = regulator_get_voltage(cpu_reg);
 	}
@@ -236,12 +239,14 @@ static int cpu0_cpufreq_driver_init(void)
 		 */
 		for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++)
 			;
+		rcu_read_lock();
 		opp = opp_find_freq_exact(cpu_dev,
 				freq_table[0].frequency * 1000, true);
 		min_uV = opp_get_voltage(opp);
 		opp = opp_find_freq_exact(cpu_dev,
 				freq_table[i-1].frequency * 1000, true);
 		max_uV = opp_get_voltage(opp);
+		rcu_read_unlock();
 		ret = regulator_set_voltage_time(cpu_reg, min_uV, max_uV);
 		if (ret > 0)
 			transition_latency += ret * 1000;
-- 
1.7.9.5

