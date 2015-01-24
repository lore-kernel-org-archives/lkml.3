Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbbAXOMP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:12:15 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:53105 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbbAXOD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:03:57 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 06/32] powerpc: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:12 -0500
Message-Id: <1422108218-25398-7-git-send-email-tj@kernel.org>
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

* Spurious if (len > 1) test dropped from shared_cpu_map_show().

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/kernel/cacheinfo.c     | 15 ++++++---------
 arch/powerpc/sysdev/xics/ics-opal.c |  6 ++----
 arch/powerpc/sysdev/xics/ics-rtas.c |  7 ++-----
 3 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/kernel/cacheinfo.c b/arch/powerpc/kernel/cacheinfo.c
index 40198d5..ae77b7e 100644
--- a/arch/powerpc/kernel/cacheinfo.c
+++ b/arch/powerpc/kernel/cacheinfo.c
@@ -607,19 +607,16 @@ static ssize_t shared_cpu_map_show(struct kobject *k, struct kobj_attribute *att
 {
 	struct cache_index_dir *index;
 	struct cache *cache;
-	int len;
-	int n = 0;
+	int ret;
 
 	index = kobj_to_cache_index_dir(k);
 	cache = index->cache;
-	len = PAGE_SIZE - 2;
 
-	if (len > 1) {
-		n = cpumask_scnprintf(buf, len, &cache->shared_cpu_map);
-		buf[n++] = '\n';
-		buf[n] = '\0';
-	}
-	return n;
+	ret = scnprintf(buf, PAGE_SIZE - 1, "%*pb\n",
+			cpumask_pr_args(&cache->shared_cpu_map));
+	buf[ret++] = '\n';
+	buf[ret] = '\0';
+	return ret;
 }
 
 static struct kobj_attribute cache_shared_cpu_map_attr =
diff --git a/arch/powerpc/sysdev/xics/ics-opal.c b/arch/powerpc/sysdev/xics/ics-opal.c
index 4ba554e..68c7e5c 100644
--- a/arch/powerpc/sysdev/xics/ics-opal.c
+++ b/arch/powerpc/sysdev/xics/ics-opal.c
@@ -131,10 +131,8 @@ static int ics_opal_set_affinity(struct irq_data *d,
 
 	wanted_server = xics_get_irq_server(d->irq, cpumask, 1);
 	if (wanted_server < 0) {
-		char cpulist[128];
-		cpumask_scnprintf(cpulist, sizeof(cpulist), cpumask);
-		pr_warning("%s: No online cpus in the mask %s for irq %d\n",
-			   __func__, cpulist, d->irq);
+		pr_warning("%s: No online cpus in the mask %*pb for irq %d\n",
+			   __func__, cpumask_pr_args(cpumask), d->irq);
 		return -1;
 	}
 	server = ics_opal_mangle_server(wanted_server);
diff --git a/arch/powerpc/sysdev/xics/ics-rtas.c b/arch/powerpc/sysdev/xics/ics-rtas.c
index bc81335b..0af97de 100644
--- a/arch/powerpc/sysdev/xics/ics-rtas.c
+++ b/arch/powerpc/sysdev/xics/ics-rtas.c
@@ -140,11 +140,8 @@ static int ics_rtas_set_affinity(struct irq_data *d,
 
 	irq_server = xics_get_irq_server(d->irq, cpumask, 1);
 	if (irq_server == -1) {
-		char cpulist[128];
-		cpumask_scnprintf(cpulist, sizeof(cpulist), cpumask);
-		printk(KERN_WARNING
-			"%s: No online cpus in the mask %s for irq %d\n",
-			__func__, cpulist, d->irq);
+		pr_warning("%s: No online cpus in the mask %*pb for irq %d\n",
+			   __func__, cpumask_pr_args(cpumask), d->irq);
 		return -1;
 	}
 
-- 
2.1.0

