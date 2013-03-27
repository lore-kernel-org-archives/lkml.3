Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab3C0PcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:32:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60388 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3C0PcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:32:19 -0400
From: Paolo Pisati <paolo.pisati@canonical.com>
To: cpufreq@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: check OF /cpus presence before dereferencing it
Date: Wed, 27 Mar 2013 16:32:14 +0100
Message-Id: <1364398334-19662-1-git-send-email-paolo.pisati@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check for '/cpus' presence before blindly dereferencing it:

[    4.181793] Unable to handle kernel NULL pointer dereference at virtual address 0000001c
[    4.181793] pgd = c0004000
[    4.181823] [0000001c] *pgd=00000000
[    4.181823] Internal error: Oops: 5 [#1] SMP ARM
[    4.181823] Modules linked in:
[    4.181823] CPU: 1    Tainted: G        W     (3.8.0-15-generic #25~hbankD)
[    4.181854] PC is at of_get_next_child+0x64/0x70
[    4.181854] LR is at of_get_next_child+0x24/0x70
[    4.181854] pc : [<c04fda18>]    lr : [<c04fd9d8>]    psr: 60000113
[    4.181854] sp : ed891ec0  ip : ed891ec0  fp : ed891ed4
[    4.181884] r10: c04dafd0  r9 : c098690c  r8 : c0936208
[    4.181884] r7 : ed890000  r6 : c0a63d00  r5 : 00000000  r4 : 00000000
[    4.181884] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : c0b2acc8
[    4.181884] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[    4.181884] Control: 10c5387d  Table: adcb804a  DAC: 00000015
[    4.181915] Process swapper/0 (pid: 1, stack limit = 0xed890238)
[    4.181915] Stack: (0xed891ec0 to 0xed892000)
[    4.181915] 1ec0: c09b7b70 00000007 ed891efc ed891ed8 c04daff4 c04fd9c0 00000000 c09b7b70
[    4.181915] 1ee0: 00000007 c0a63d00 ed890000 c0936208 ed891f54 ed891f00 c00088e0 c04dafdc
[    4.181945] 1f00: ed891f54 ed891f10 c006e940 00000000 00000000 00000007 00000007 c08a4914
[    4.181945] 1f20: 00000000 c07dbd30 c0a63d00 c09b7b70 00000007 c0a63d00 000000bc c0936208
[    4.181945] 1f40: c098690c c0986914 ed891f94 ed891f58 c0936a40 c00087bc 00000007 00000007
[    4.181976] 1f60: c0936208 be8bda20 b6eea010 c0a63d00 c064547c 00000000 00000000 00000000
[    4.181976] 1f80: 00000000 00000000 ed891fac ed891f98 c0645498 c09368c8 00000000 00000000
[    4.181976] 1fa0: 00000000 ed891fb0 c0014658 c0645488 00000000 00000000 00000000 00000000
[    4.182006] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    4.182006] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[    4.182037] [<c04fda18>] (of_get_next_child+0x64/0x70) from [<c04daff4>] (cpu0_cpufreq_driver_init+0x24/0x284)
[    4.182067] [<c04daff4>] (cpu0_cpufreq_driver_init+0x24/0x284) from [<c00088e0>] (do_one_initcall+0x130/0x1b0)
[    4.182067] [<c00088e0>] (do_one_initcall+0x130/0x1b0) from [<c0936a40>] (kernel_init_freeable+0x184/0x24c)
[    4.182098] [<c0936a40>] (kernel_init_freeable+0x184/0x24c) from [<c0645498>] (kernel_init+0x1c/0xf4)
[    4.182128] [<c0645498>] (kernel_init+0x1c/0xf4) from [<c0014658>] (ret_from_fork+0x14/0x20)
[    4.182128] Code: f57ff04f e320f004 e89da830 e89da830 (e595001c)
[    4.182128] ---[ end trace 634903a22e8609cb ]---
[    4.182189] Kernel panic - not syncing: Attempted to kill init!  exitcode=0x0000000b
[    4.182189]
[    4.642395] CPU0: stopping

Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
---
 drivers/cpufreq/cpufreq-cpu0.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 4e5b7fb..f3e8f51 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -178,10 +178,16 @@ static struct cpufreq_driver cpu0_cpufreq_driver = {
 
 static int cpu0_cpufreq_probe(struct platform_device *pdev)
 {
-	struct device_node *np;
+	struct device_node *np, *tmp;
 	int ret;
 
-	for_each_child_of_node(of_find_node_by_path("/cpus"), np) {
+	tmp = of_find_node_by_path("/cpus");
+	if (!tmp) {
+		pr_err("failed to find OF /cpus\n");
+		return -ENOENT;
+	}
+
+	for_each_child_of_node(tmp, np) {
 		if (of_get_property(np, "operating-points", NULL))
 			break;
 	}
-- 
1.7.10.4

