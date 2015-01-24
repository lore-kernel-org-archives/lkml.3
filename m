Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbbAXOL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:11:27 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:58410 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbbAXOEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:00 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 08/32] tile: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:14 -0500
Message-Id: <1422108218-25398-9-git-send-email-tj@kernel.org>
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

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/hardwall.c         |  5 +----
 arch/tile/kernel/proc.c             |  5 ++---
 arch/tile/kernel/setup.c            | 13 +++++--------
 arch/tile/mm/homecache.c            | 12 +++++-------
 arch/tile/mm/init.c                 | 18 +++++++-----------
 drivers/net/ethernet/tile/tilegx.c  |  5 ++---
 drivers/net/ethernet/tile/tilepro.c |  5 ++---
 7 files changed, 24 insertions(+), 39 deletions(-)

diff --git a/arch/tile/kernel/hardwall.c b/arch/tile/kernel/hardwall.c
index c4646bb..2fd1694 100644
--- a/arch/tile/kernel/hardwall.c
+++ b/arch/tile/kernel/hardwall.c
@@ -909,11 +909,8 @@ static void hardwall_destroy(struct hardwall_info *info)
 static int hardwall_proc_show(struct seq_file *sf, void *v)
 {
 	struct hardwall_info *info = sf->private;
-	char buf[256];
 
-	int rc = cpulist_scnprintf(buf, sizeof(buf), &info->cpumask);
-	buf[rc++] = '\n';
-	seq_write(sf, buf, rc);
+	seq_printf(sf, "%*pbl\n", cpumask_pr_args(&info->cpumask));
 	return 0;
 }
 
diff --git a/arch/tile/kernel/proc.c b/arch/tile/kernel/proc.c
index 6829a95..7983e98 100644
--- a/arch/tile/kernel/proc.c
+++ b/arch/tile/kernel/proc.c
@@ -45,10 +45,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	int n = ptr_to_cpu(v);
 
 	if (n == 0) {
-		char buf[NR_CPUS*5];
-		cpulist_scnprintf(buf, sizeof(buf), cpu_online_mask);
 		seq_printf(m, "cpu count\t: %d\n", num_online_cpus());
-		seq_printf(m, "cpu list\t: %s\n", buf);
+		seq_printf(m, "cpu list\t: %*pbl\n",
+			   cpumask_pr_args(cpu_online_mask));
 		seq_printf(m, "model name\t: %s\n", chip_model);
 		seq_printf(m, "flags\t\t:\n");  /* nothing for now */
 		seq_printf(m, "cpu MHz\t\t: %llu.%06llu\n",
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 864eea6..f1f5799 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -215,12 +215,11 @@ early_param("mem", setup_mem);  /* compatibility with x86 */
 
 static int __init setup_isolnodes(char *str)
 {
-	char buf[MAX_NUMNODES * 5];
 	if (str == NULL || nodelist_parse(str, isolnodes) != 0)
 		return -EINVAL;
 
-	nodelist_scnprintf(buf, sizeof(buf), isolnodes);
-	pr_info("Set isolnodes value to '%s'\n", buf);
+	pr_info("Set isolnodes value to '%*pbl'\n",
+		nodemask_pr_args(&isolnodes));
 	return 0;
 }
 early_param("isolnodes", setup_isolnodes);
@@ -1315,11 +1314,9 @@ early_param("disabled_cpus", disabled_cpus);
 
 void __init print_disabled_cpus(void)
 {
-	if (!cpumask_empty(&disabled_map)) {
-		char buf[100];
-		cpulist_scnprintf(buf, sizeof(buf), &disabled_map);
-		pr_info("CPUs not available for Linux: %s\n", buf);
-	}
+	if (!cpumask_empty(&disabled_map))
+		pr_info("CPUs not available for Linux: %*pbl\n",
+			cpumask_pr_args(&disabled_map));
 }
 
 static void __init setup_cpu_maps(void)
diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index cd33873..b9e127b 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -115,7 +115,6 @@ void flush_remote(unsigned long cache_pfn, unsigned long cache_control,
 	struct cpumask cache_cpumask_copy, tlb_cpumask_copy;
 	struct cpumask *cache_cpumask, *tlb_cpumask;
 	HV_PhysAddr cache_pa;
-	char cache_buf[NR_CPUS*5], tlb_buf[NR_CPUS*5];
 
 	mb();   /* provided just to simplify "magic hypervisor" mode */
 
@@ -149,13 +148,12 @@ void flush_remote(unsigned long cache_pfn, unsigned long cache_control,
 			     asids, asidcount);
 	if (rc == 0)
 		return;
-	cpumask_scnprintf(cache_buf, sizeof(cache_buf), &cache_cpumask_copy);
-	cpumask_scnprintf(tlb_buf, sizeof(tlb_buf), &tlb_cpumask_copy);
 
-	pr_err("hv_flush_remote(%#llx, %#lx, %p [%s], %#lx, %#lx, %#lx, %p [%s], %p, %d) = %d\n",
-	       cache_pa, cache_control, cache_cpumask, cache_buf,
-	       (unsigned long)tlb_va, tlb_length, tlb_pgsize,
-	       tlb_cpumask, tlb_buf, asids, asidcount, rc);
+	pr_err("hv_flush_remote(%#llx, %#lx, %p [%*pb], %#lx, %#lx, %#lx, %p [%*pb], %p, %d) = %d\n",
+	       cache_pa, cache_control, cache_cpumask,
+	       cpumask_pr_args(&cache_cpumask_copy),
+	       (unsigned long)tlb_va, tlb_length, tlb_pgsize, tlb_cpumask,
+	       cpumask_pr_args(&tlb_cpumask_copy), asids, asidcount, rc);
 	panic("Unsafe to continue.");
 }
 
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index be240cc..ace32d7 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -353,15 +353,13 @@ static int __init setup_ktext(char *str)
 
 	/* Neighborhood ktext pages on specified mask */
 	else if (cpulist_parse(str, &ktext_mask) == 0) {
-		char buf[NR_CPUS * 5];
-		cpulist_scnprintf(buf, sizeof(buf), &ktext_mask);
 		if (cpumask_weight(&ktext_mask) > 1) {
 			ktext_small = 1;
-			pr_info("ktext: using caching neighborhood %s with small pages\n",
-				buf);
+			pr_info("ktext: using caching neighborhood %*pbl with small pages\n",
+				cpumask_pr_args(&ktext_mask));
 		} else {
-			pr_info("ktext: caching on cpu %s with one huge page\n",
-				buf);
+			pr_info("ktext: caching on cpu %*pbl with one huge page\n",
+				cpumask_pr_args(&ktext_mask));
 		}
 	}
 
@@ -492,11 +490,9 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 		struct cpumask bad;
 		cpumask_andnot(&bad, &ktext_mask, cpu_possible_mask);
 		cpumask_and(&ktext_mask, &ktext_mask, cpu_possible_mask);
-		if (!cpumask_empty(&bad)) {
-			char buf[NR_CPUS * 5];
-			cpulist_scnprintf(buf, sizeof(buf), &bad);
-			pr_info("ktext: not using unavailable cpus %s\n", buf);
-		}
+		if (!cpumask_empty(&bad))
+			pr_info("ktext: not using unavailable cpus %*pbl\n",
+				cpumask_pr_args(&bad));
 		if (cpumask_empty(&ktext_mask)) {
 			pr_warn("ktext: no valid cpus; caching on %d\n",
 				smp_processor_id());
diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
index 049747f..bea8cd2 100644
--- a/drivers/net/ethernet/tile/tilegx.c
+++ b/drivers/net/ethernet/tile/tilegx.c
@@ -292,7 +292,6 @@ static inline int mpipe_instance(struct net_device *dev)
  */
 static bool network_cpus_init(void)
 {
-	char buf[1024];
 	int rc;
 
 	if (network_cpus_string == NULL)
@@ -314,8 +313,8 @@ static bool network_cpus_init(void)
 		return false;
 	}
 
-	cpulist_scnprintf(buf, sizeof(buf), &network_cpus_map);
-	pr_info("Linux network CPUs: %s\n", buf);
+	pr_info("Linux network CPUs: %*pbl\n",
+		cpumask_pr_args(&network_cpus_map));
 	return true;
 }
 
diff --git a/drivers/net/ethernet/tile/tilepro.c b/drivers/net/ethernet/tile/tilepro.c
index fb12d31..3d8f60d 100644
--- a/drivers/net/ethernet/tile/tilepro.c
+++ b/drivers/net/ethernet/tile/tilepro.c
@@ -2410,9 +2410,8 @@ static int __init network_cpus_setup(char *str)
 		if (cpumask_empty(&network_cpus_map)) {
 			pr_warn("Ignoring network_cpus='%s'\n", str);
 		} else {
-			char buf[1024];
-			cpulist_scnprintf(buf, sizeof(buf), &network_cpus_map);
-			pr_info("Linux network CPUs: %s\n", buf);
+			pr_info("Linux network CPUs: %*pbl\n",
+				cpumask_pr_args(&network_cpus_map));
 			network_cpus_used = true;
 		}
 	}
-- 
2.1.0

