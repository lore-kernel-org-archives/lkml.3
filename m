Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbaLJP4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:56:48 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:45021 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbaLJPxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:53:16 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 05/12] tile: use {cpu|node}mask pr_cont and seq output functions
Date: Wed, 10 Dec 2014 10:52:47 -0500
Message-Id: <1418226774-30215-6-git-send-email-tj@kernel.org>
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
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/hardwall.c         |  6 ++----
 arch/tile/kernel/proc.c             |  6 +++---
 arch/tile/kernel/setup.c            | 12 ++++++------
 arch/tile/mm/homecache.c            | 14 +++++++-------
 arch/tile/mm/init.c                 | 12 ++++++------
 drivers/net/ethernet/tile/tilegx.c  |  6 +++---
 drivers/net/ethernet/tile/tilepro.c |  6 +++---
 7 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/arch/tile/kernel/hardwall.c b/arch/tile/kernel/hardwall.c
index c4646bb..f8b8453 100644
--- a/arch/tile/kernel/hardwall.c
+++ b/arch/tile/kernel/hardwall.c
@@ -909,11 +909,9 @@ static void hardwall_destroy(struct hardwall_info *info)
 static int hardwall_proc_show(struct seq_file *sf, void *v)
 {
 	struct hardwall_info *info = sf->private;
-	char buf[256];
 
-	int rc = cpulist_scnprintf(buf, sizeof(buf), &info->cpumask);
-	buf[rc++] = '\n';
-	seq_write(sf, buf, rc);
+	seq_cpumask_list(sf, &info->cpumask);
+	seq_putc(sf, '\n');
 	return 0;
 }
 
diff --git a/arch/tile/kernel/proc.c b/arch/tile/kernel/proc.c
index 6829a95..3dbd98a 100644
--- a/arch/tile/kernel/proc.c
+++ b/arch/tile/kernel/proc.c
@@ -45,10 +45,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	int n = ptr_to_cpu(v);
 
 	if (n == 0) {
-		char buf[NR_CPUS*5];
-		cpulist_scnprintf(buf, sizeof(buf), cpu_online_mask);
 		seq_printf(m, "cpu count\t: %d\n", num_online_cpus());
-		seq_printf(m, "cpu list\t: %s\n", buf);
+		seq_printf(m, "cpu list\t: ");
+		seq_cpumask_list(m, cpu_online_mask);
+		seq_printf(m, "\n");
 		seq_printf(m, "model name\t: %s\n", chip_model);
 		seq_printf(m, "flags\t\t:\n");  /* nothing for now */
 		seq_printf(m, "cpu MHz\t\t: %llu.%06llu\n",
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 864eea6..6532399 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -215,12 +215,12 @@ early_param("mem", setup_mem);  /* compatibility with x86 */
 
 static int __init setup_isolnodes(char *str)
 {
-	char buf[MAX_NUMNODES * 5];
 	if (str == NULL || nodelist_parse(str, isolnodes) != 0)
 		return -EINVAL;
 
-	nodelist_scnprintf(buf, sizeof(buf), isolnodes);
-	pr_info("Set isolnodes value to '%s'\n", buf);
+	pr_info("Set isolnodes value to '");
+	nodelist_pr_cont(isolnodes);
+	pr_cont("'\n");
 	return 0;
 }
 early_param("isolnodes", setup_isolnodes);
@@ -1316,9 +1316,9 @@ early_param("disabled_cpus", disabled_cpus);
 void __init print_disabled_cpus(void)
 {
 	if (!cpumask_empty(&disabled_map)) {
-		char buf[100];
-		cpulist_scnprintf(buf, sizeof(buf), &disabled_map);
-		pr_info("CPUs not available for Linux: %s\n", buf);
+		pr_info("CPUs not available for Linux: ");
+		cpulist_pr_cont(&disabled_map);
+		pr_cont("\n");
 	}
 }
 
diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index cd33873..a7278fe 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -115,7 +115,6 @@ void flush_remote(unsigned long cache_pfn, unsigned long cache_control,
 	struct cpumask cache_cpumask_copy, tlb_cpumask_copy;
 	struct cpumask *cache_cpumask, *tlb_cpumask;
 	HV_PhysAddr cache_pa;
-	char cache_buf[NR_CPUS*5], tlb_buf[NR_CPUS*5];
 
 	mb();   /* provided just to simplify "magic hypervisor" mode */
 
@@ -149,13 +148,14 @@ void flush_remote(unsigned long cache_pfn, unsigned long cache_control,
 			     asids, asidcount);
 	if (rc == 0)
 		return;
-	cpumask_scnprintf(cache_buf, sizeof(cache_buf), &cache_cpumask_copy);
-	cpumask_scnprintf(tlb_buf, sizeof(tlb_buf), &tlb_cpumask_copy);
 
-	pr_err("hv_flush_remote(%#llx, %#lx, %p [%s], %#lx, %#lx, %#lx, %p [%s], %p, %d) = %d\n",
-	       cache_pa, cache_control, cache_cpumask, cache_buf,
-	       (unsigned long)tlb_va, tlb_length, tlb_pgsize,
-	       tlb_cpumask, tlb_buf, asids, asidcount, rc);
+	pr_err("hv_flush_remote(%#llx, %#lx, %p [",
+	       cache_pa, cache_control, cache_cpumask);
+	cpumask_pr_cont(&cache_cpumask_copy);
+	pr_cont("], %#lx, %#lx, %#lx, %p [",
+		(unsigned long)tlb_va, tlb_length, tlb_pgsize, tlb_cpumask);
+	cpumask_pr_cont(&tlb_cpumask_copy);
+	pr_cont("], %p, %d) = %d\n", asids, asidcount, rc);
 	panic("Unsafe to continue.");
 }
 
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index be240cc..8e6dea3 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -353,15 +353,15 @@ static int __init setup_ktext(char *str)
 
 	/* Neighborhood ktext pages on specified mask */
 	else if (cpulist_parse(str, &ktext_mask) == 0) {
-		char buf[NR_CPUS * 5];
-		cpulist_scnprintf(buf, sizeof(buf), &ktext_mask);
 		if (cpumask_weight(&ktext_mask) > 1) {
 			ktext_small = 1;
-			pr_info("ktext: using caching neighborhood %s with small pages\n",
-				buf);
+			pr_info("ktext: using caching neighborhood ");
+			cpulist_pr_cont(&ktext_mask);
+			pr_cont(" with small pages\n");
 		} else {
-			pr_info("ktext: caching on cpu %s with one huge page\n",
-				buf);
+			pr_info("ktext: caching on cpu ");
+			cpulist_pr_cont(&ktext_mask);
+			pr_cont(" with one huge page\n");
 		}
 	}
 
diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
index 049747f..3ecb8b2 100644
--- a/drivers/net/ethernet/tile/tilegx.c
+++ b/drivers/net/ethernet/tile/tilegx.c
@@ -292,7 +292,6 @@ static inline int mpipe_instance(struct net_device *dev)
  */
 static bool network_cpus_init(void)
 {
-	char buf[1024];
 	int rc;
 
 	if (network_cpus_string == NULL)
@@ -314,8 +313,9 @@ static bool network_cpus_init(void)
 		return false;
 	}
 
-	cpulist_scnprintf(buf, sizeof(buf), &network_cpus_map);
-	pr_info("Linux network CPUs: %s\n", buf);
+	pr_info("Linux network CPUs: ");
+	cpulist_pr_cont(&network_cpus_map);
+	pr_cont("\n");
 	return true;
 }
 
diff --git a/drivers/net/ethernet/tile/tilepro.c b/drivers/net/ethernet/tile/tilepro.c
index fb12d31..ab9bfbf 100644
--- a/drivers/net/ethernet/tile/tilepro.c
+++ b/drivers/net/ethernet/tile/tilepro.c
@@ -2410,9 +2410,9 @@ static int __init network_cpus_setup(char *str)
 		if (cpumask_empty(&network_cpus_map)) {
 			pr_warn("Ignoring network_cpus='%s'\n", str);
 		} else {
-			char buf[1024];
-			cpulist_scnprintf(buf, sizeof(buf), &network_cpus_map);
-			pr_info("Linux network CPUs: %s\n", buf);
+			pr_info("Linux network CPUs: ");
+			cpulist_pr_cont(&network_cpus_map);
+			pr_cont("\n");
 			network_cpus_used = true;
 		}
 	}
-- 
2.1.0

