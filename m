Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbbAXOLL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:11:11 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:51869 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbbAXOEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:02 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, x86@kernel.org,
        Mike Travis <travis@sgi.com>
Subject: [PATCH 09/32] x86: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:15 -0500
Message-Id: <1422108218-25398-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* Unnecessary buffer size calculation and condition on the lenght
  removed from intel_cacheinfo.c::show_shared_cpu_map_func().

* uv_nmi_nr_cpus_pr() got overly smart and implemented "..."
  abbreviation if the output stretched over the predefined 1024 byte
  buffer.  Replaced with plain printk.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org
Cc: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c | 26 ++++++++++++--------------
 arch/x86/mm/numa.c                    |  6 ++----
 arch/x86/platform/uv/uv_nmi.c         | 25 +++++++------------------
 3 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index c703507..6596433 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -952,20 +952,18 @@ static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf,
 static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
 					int type, char *buf)
 {
-	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
-	int n = 0;
-
-	if (len > 1) {
-		const struct cpumask *mask;
-
-		mask = to_cpumask(this_leaf->shared_cpu_map);
-		n = type ?
-			cpulist_scnprintf(buf, len-2, mask) :
-			cpumask_scnprintf(buf, len-2, mask);
-		buf[n++] = '\n';
-		buf[n] = '\0';
-	}
-	return n;
+	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
+	int ret;
+
+	if (type)
+		ret = scnprintf(buf, PAGE_SIZE - 1, "%*pbl",
+				cpumask_pr_args(mask));
+	else
+		ret = scnprintf(buf, PAGE_SIZE - 1, "%*pb",
+				cpumask_pr_args(mask));
+	buf[ret++] = '\n';
+	buf[ret] = '\0';
+	return ret;
 }
 
 static inline ssize_t show_shared_cpu_map(struct _cpuid4_info *leaf, char *buf,
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 1a88370..cd4785b 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -794,7 +794,6 @@ int early_cpu_to_node(int cpu)
 void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 {
 	struct cpumask *mask;
-	char buf[64];
 
 	if (node == NUMA_NO_NODE) {
 		/* early_cpu_to_node() already emits a warning and trace */
@@ -812,10 +811,9 @@ void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 	else
 		cpumask_clear_cpu(cpu, mask);
 
-	cpulist_scnprintf(buf, sizeof(buf), mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
+	printk(KERN_DEBUG "%s cpu %d node %d: mask now %*pbl\n",
 		enable ? "numa_add_cpu" : "numa_remove_cpu",
-		cpu, node, buf);
+		cpu, node, cpumask_pr_args(mask));
 	return;
 }
 
diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index c6b146e..7488caf 100644
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
@@ -371,16 +357,19 @@ static void uv_nmi_wait(int master)
 			break;
 
 		/* if not all made it in, send IPI NMI to them */
-		uv_nmi_nr_cpus_pr(KERN_ALERT
-			"UV: Sending NMI IPI to %d non-responding CPUs: %s\n");
+		pr_alert("UV: Sending NMI IPI to %d non-responding CPUs: %*pbl\n",
+			 cpumask_weight(uv_nmi_cpu_mask),
+			 cpumask_pr_args(uv_nmi_cpu_mask));
+
 		uv_nmi_nr_cpus_ping();
 
 		/* if all cpus are in, then done */
 		if (!uv_nmi_wait_cpus(0))
 			break;
 
-		uv_nmi_nr_cpus_pr(KERN_ALERT
-			"UV: %d CPUs not in NMI loop: %s\n");
+		pr_alert("UV: %d CPUs not in NMI loop: %*pbl\n",
+			 cpumask_weight(uv_nmi_cpu_mask),
+			 cpumask_pr_args(uv_nmi_cpu_mask));
 	} while (0);
 
 	pr_alert("UV: %d of %d CPUs in NMI\n",
-- 
2.1.0

