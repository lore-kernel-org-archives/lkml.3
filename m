Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbaLJPxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:53:23 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:61902 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427AbaLJPxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:53:18 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, x86@kernel.org,
        Mike Travis <travis@sgi.com>
Subject: [PATCH 06/12] x86: use {cpu|node}mask pr_cont and seq output functions
Date: Wed, 10 Dec 2014 10:52:48 -0500
Message-Id: <1418226774-30215-7-git-send-email-tj@kernel.org>
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

* uv_nmi_nr_cpus_pr() got overly smart and implemented "..."
  abbreviation if the output stretched over the predefined 1024 byte
  buffer.  Replaced with plain pr_cont.

This patch is dependent on the previous patch ("bitmap, cpumask,
nodemask: implement pr_cont variants of formatting functions") which
is planned to go through -mm.  It'd be the easiest to route this
together.  If this should go through the subsystem tree, please wait
till the forementioned patch is merged to mainline.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org
Cc: Mike Travis <travis@sgi.com>
---
 arch/x86/mm/numa.c            |  9 ++++-----
 arch/x86/platform/uv/uv_nmi.c | 27 +++++++++------------------
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 1a88370..614a302 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -794,7 +794,6 @@ int early_cpu_to_node(int cpu)
 void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 {
 	struct cpumask *mask;
-	char buf[64];
 
 	if (node == NUMA_NO_NODE) {
 		/* early_cpu_to_node() already emits a warning and trace */
@@ -812,10 +811,10 @@ void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 	else
 		cpumask_clear_cpu(cpu, mask);
 
-	cpulist_scnprintf(buf, sizeof(buf), mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
-		enable ? "numa_add_cpu" : "numa_remove_cpu",
-		cpu, node, buf);
+	printk(KERN_DEBUG "%s cpu %d node %d: mask now ",
+	       enable ? "numa_add_cpu" : "numa_remove_cpu", cpu, node);
+	cpulist_pr_cont(mask);
+	pr_cont("\n");
 	return;
 }
 
diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index c6b146e..61ee9cf 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -273,20 +273,6 @@ static inline void uv_clear_nmi(int cpu)
 	}
 }
 
-/* Print non-responding cpus */
-static void uv_nmi_nr_cpus_pr(char *fmt)
-{
-	static char cpu_list[1024];
-	int len = sizeof(cpu_list);
-	int c = cpumask_weight(uv_nmi_cpu_mask);
-	int n = cpulist_scnprintf(cpu_list, len, uv_nmi_cpu_mask);
-
-	if (n >= len-1)
-		strcpy(&cpu_list[len - 6], "...\n");
-
-	printk(fmt, c, cpu_list);
-}
-
 /* Ping non-responding cpus attemping to force them into the NMI handler */
 static void uv_nmi_nr_cpus_ping(void)
 {
@@ -371,16 +357,21 @@ static void uv_nmi_wait(int master)
 			break;
 
 		/* if not all made it in, send IPI NMI to them */
-		uv_nmi_nr_cpus_pr(KERN_ALERT
-			"UV: Sending NMI IPI to %d non-responding CPUs: %s\n");
+		pr_alert("UV: Sending NMI IPI to %d non-responding CPUs: ",
+			 cpumask_weight(uv_nmi_cpu_mask));
+		cpulist_pr_cont(uv_nmi_cpu_mask);
+		pr_cont("\n");
+
 		uv_nmi_nr_cpus_ping();
 
 		/* if all cpus are in, then done */
 		if (!uv_nmi_wait_cpus(0))
 			break;
 
-		uv_nmi_nr_cpus_pr(KERN_ALERT
-			"UV: %d CPUs not in NMI loop: %s\n");
+		pr_alert("UV: %d CPUs not in NMI loop: ",
+			 cpumask_weight(uv_nmi_cpu_mask));
+		cpulist_pr_cont(uv_nmi_cpu_mask);
+		pr_cont("\n");
 	} while (0);
 
 	pr_alert("UV: %d of %d CPUs in NMI\n",
-- 
2.1.0

