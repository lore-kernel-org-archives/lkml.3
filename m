Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbaLJPxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:53:15 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:39511 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121AbaLJPxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:53:12 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 03/12] mips: use {cpu|node}mask pr_cont and seq output functions
Date: Wed, 10 Dec 2014 10:52:45 -0500
Message-Id: <1418226774-30215-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418226774-30215-1-git-send-email-tj@kernel.org>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the existing user of cpu{mask|list}_scnprintf() and
node{mask|list}_scnprintf() which use them just to printk or
seq_printf() the resulting buffer to use the following functions
instead respectively.

* For printk: cpu{mask|list}_pr_cont() and node{mask|list}_pr_cont().

* For seq_file: seq_cpumask[_list]() and seq_nodemask[_list]().

Because these conversions usually break up a single output function
call into multiple, the reduction is LOC isn't too big but it removes
unnecessary complexity and/or arbitrary limit on the length printed.

This patch is dependent on the previous patch ("bitmap, cpumask,
nodemask: implement pr_cont variants of formatting functions") which
is planned to go through -mm.  It'd be the easiest to route this
together.  If this should go through the subsystem tree, please wait
till the forementioned patch is merged to mainline.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/netlogic/common/smp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/mips/netlogic/common/smp.c b/arch/mips/netlogic/common/smp.c
index 4fde7ac..e91592a 100644
--- a/arch/mips/netlogic/common/smp.c
+++ b/arch/mips/netlogic/common/smp.c
@@ -162,7 +162,6 @@ void __init nlm_smp_setup(void)
 	unsigned int boot_cpu;
 	int num_cpus, i, ncore, node;
 	volatile u32 *cpu_ready = nlm_get_boot_data(BOOT_CPU_READY);
-	char buf[64];
 
 	boot_cpu = hard_smp_processor_id();
 	cpumask_clear(&phys_cpu_present_mask);
@@ -189,10 +188,12 @@ void __init nlm_smp_setup(void)
 		}
 	}
 
-	cpumask_scnprintf(buf, ARRAY_SIZE(buf), &phys_cpu_present_mask);
-	pr_info("Physical CPU mask: %s\n", buf);
-	cpumask_scnprintf(buf, ARRAY_SIZE(buf), cpu_possible_mask);
-	pr_info("Possible CPU mask: %s\n", buf);
+	pr_info("Physical CPU mask: ");
+	cpumask_pr_cont(&phys_cpu_present_mask);
+	pr_cont("\n");
+	pr_info("Possible CPU mask: ");
+	cpumask_pr_cont(cpu_possible_mask);
+	pr_cont("\n");
 
 	/* check with the cores we have woken up */
 	for (ncore = 0, i = 0; i < NLM_NR_NODES; i++)
-- 
2.1.0

