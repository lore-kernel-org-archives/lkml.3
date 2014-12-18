Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaLRG2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:28:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17327 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaLRG2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:28:37 -0500
From: Ethan Zhao <ethan.zhao@oracle.com>
To: dirk.j.brandewie@intel.com, kristen@linux.intel.com,
        viresh.kumar@linaro.org, rjw@rjwysocki.net
Cc: linda.knippers@hp.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ethan.kernel@gmail.com,
        Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH V3] cpufreq: fix a NULL pointer dereference triggered by _PPC changed notification
Date: Thu, 18 Dec 2014 15:28:19 +0900
Message-Id: <1418884099-27919-1-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If _PPC changed notification happens before governor was initiated while kernel
is booting, a NULL pointer dereference will be triggered:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
 IP: [<ffffffff81470453>] __cpufreq_governor+0x23/0x1e0
 PGD 0
 Oops: 0000 [#1] SMP
 ... ...
 RIP: 0010:[<ffffffff81470453>]  [<ffffffff81470453>]
 __cpufreq_governor+0x23/0x1e0
 RSP: 0018:ffff881fcfbcfbb8  EFLAGS: 00010286
 RAX: 0000000000000000 RBX: ffff881fd11b3980 RCX: ffff88407fc20000
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff881fd11b3980
 RBP: ffff881fcfbcfbd8 R08: 0000000000000000 R09: 000000000000000f
 R10: ffffffff818068d0 R11: 0000000000000043 R12: 0000000000000004
 R13: 0000000000000000 R14: ffffffff8196cae0 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff881fffc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000030 CR3: 00000000018ae000 CR4: 00000000000407f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process kworker/0:3 (pid: 750, threadinfo ffff881fcfbce000, task
 ffff881fcf556400)
 Stack:
  ffff881fffc17d00 ffff881fcfbcfc18 ffff881fd11b3980 0000000000000000
  ffff881fcfbcfc08 ffffffff81470d08 ffff881fd11b3980 0000000000000007
  ffff881fcfbcfc18 ffff881fffc17d00 ffff881fcfbcfd28 ffffffff81472e9a
 Call Trace:
  [<ffffffff81470d08>] __cpufreq_set_policy+0x1b8/0x2e0
  [<ffffffff81472e9a>] cpufreq_update_policy+0xca/0x150
  [<ffffffff81472f20>] ? cpufreq_update_policy+0x150/0x150
  [<ffffffff81324a96>] acpi_processor_ppc_has_changed+0x71/0x7b
  [<ffffffff81320bcd>] acpi_processor_notify+0x55/0x115
  [<ffffffff812f9c29>] acpi_device_notify+0x19/0x1b
  [<ffffffff813084ca>] acpi_ev_notify_dispatch+0x41/0x5f
  [<ffffffff812f64a4>] acpi_os_execute_deferred+0x27/0x34

The root cause is a race conditon -- cpufreq core and acpi-cpufreq driver
were initiated, but cpufreq_governor wasn't and _PPC changed notification
happened, __cpufreq_governor() was called within acpi_os_execute_deferred
kernel thread context.

To fix this panic issue, add pointer checking code in __cpufreq_governor()
before pointer policy->governor is to be dereferenced.

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 v2&v3: correct comment style.

 drivers/cpufreq/cpufreq.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 4473eba..b75735c 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2021,6 +2021,11 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 	/* Don't start any governor operations if we are entering suspend */
 	if (cpufreq_suspended)
 		return 0;
+	/*
+	 * Governor might not be initiated here if _PPC changed notification
+	 * happened, check it.
+	 */
+	if (!policy->governor)
+		return -EINVAL;
 
 	if (policy->governor->max_transition_latency &&
 	    policy->cpuinfo.transition_latency >
-- 
1.8.3.1

