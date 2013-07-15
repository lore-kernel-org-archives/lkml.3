Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3GONOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:14:18 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:38895 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab3GONLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:11:09 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v2 07/17] staging/lustre: fix build error when !CONFIG_SMP
Date: Mon, 15 Jul 2013 21:08:05 +0800
Message-Id: <1373893695-4094-8-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
References: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three functions cfs_cpu_ht_nsiblings, cfs_cpt_cpumask and
cfs_cpt_table_print are missing if !CONFIG_SMP.

cpumask_t/nodemask_t/__read_mostly/____cacheline_aligned
are redefined.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/include/linux/libcfs/libcfs_cpu.h       |   46 ++++++++++----------
 .../lustre/include/linux/libcfs/linux/linux-cpu.h  |    6 ---
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    2 +
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c |   46 ++------------------
 drivers/staging/lustre/lustre/ptlrpc/service.c     |   11 ++++-
 5 files changed, 37 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_cpu.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_cpu.h
index 6ae7415..c87efb4 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_cpu.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_cpu.h
@@ -75,11 +75,19 @@
 #ifndef __LIBCFS_CPU_H__
 #define __LIBCFS_CPU_H__
 
-#ifndef HAVE_LIBCFS_CPT
-
-typedef unsigned long		cpumask_t;
-typedef unsigned long		nodemask_t;
+/* any CPU partition */
+#define CFS_CPT_ANY		(-1)
 
+#ifdef CONFIG_SMP
+/**
+ * return cpumask of CPU partition \a cpt
+ */
+cpumask_t *cfs_cpt_cpumask(struct cfs_cpt_table *cptab, int cpt);
+/**
+ * print string information of cpt-table
+ */
+int cfs_cpt_table_print(struct cfs_cpt_table *cptab, char *buf, int len);
+#else /* !CONFIG_SMP */
 struct cfs_cpt_table {
 	/* # of CPU partitions */
 	int			ctb_nparts;
@@ -91,10 +99,18 @@ struct cfs_cpt_table {
 	__u64			ctb_version;
 };
 
-#endif /* !HAVE_LIBCFS_CPT */
+static inline cpumask_t *
+cfs_cpt_cpumask(struct cfs_cpt_table *cptab, int cpt)
+{
+       return NULL;
+}
 
-/* any CPU partition */
-#define CFS_CPT_ANY		(-1)
+static inline int
+cfs_cpt_table_print(struct cfs_cpt_table *cptab, char *buf, int len)
+{
+       return 0;
+}
+#endif /* CONFIG_SMP */
 
 extern struct cfs_cpt_table	*cfs_cpt_table;
 
@@ -107,10 +123,6 @@ void cfs_cpt_table_free(struct cfs_cpt_table *cptab);
  */
 struct cfs_cpt_table *cfs_cpt_table_alloc(unsigned int ncpt);
 /**
- * print string information of cpt-table
- */
-int cfs_cpt_table_print(struct cfs_cpt_table *cptab, char *buf, int len);
-/**
  * return total number of CPU partitions in \a cptab
  */
 int
@@ -124,10 +136,6 @@ int cfs_cpt_weight(struct cfs_cpt_table *cptab, int cpt);
  */
 int cfs_cpt_online(struct cfs_cpt_table *cptab, int cpt);
 /**
- * return cpumask of CPU partition \a cpt
- */
-cpumask_t *cfs_cpt_cpumask(struct cfs_cpt_table *cptab, int cpt);
-/**
  * return nodemask of CPU partition \a cpt
  */
 nodemask_t *cfs_cpt_nodemask(struct cfs_cpt_table *cptab, int cpt);
@@ -200,14 +208,6 @@ int cfs_cpt_spread_node(struct cfs_cpt_table *cptab, int cpt);
 #define cfs_cpt_for_each(i, cptab)	\
 	for (i = 0; i < cfs_cpt_number(cptab); i++)
 
-#ifndef __read_mostly
-# define __read_mostly
-#endif
-
-#ifndef ____cacheline_aligned
-#define ____cacheline_aligned
-#endif
-
 int  cfs_cpu_init(void);
 void cfs_cpu_fini(void);
 
diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-cpu.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-cpu.h
index 224371c..5f793f2 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-cpu.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-cpu.h
@@ -81,12 +81,6 @@ struct cfs_cpt_table {
 	nodemask_t			*ctb_nodemask;
 };
 
-void cfs_cpu_core_siblings(int cpu, cpumask_t *mask);
-void cfs_cpu_ht_siblings(int cpu, cpumask_t *mask);
-void cfs_node_to_cpumask(int node, cpumask_t *mask);
-int cfs_cpu_core_nsiblings(int cpu);
-int cfs_cpu_ht_nsiblings(int cpu);
-
 /**
  * comment out definitions for compatible layer
  * #define CFS_CPU_NR			  NR_CPUS
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index 3ce4fb0..511fb16 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -702,6 +702,8 @@ kiblnd_get_completion_vector(kib_conn_t *conn, int cpt)
 		return 0;
 
 	mask = cfs_cpt_cpumask(lnet_cpt_table(), cpt);
+	if (mask == NULL)
+		return 0;
 
 	/* hash NID to CPU id in this partition... */
 	off = do_div(nid, cpus_weight(*mask));
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
index 95142d1..00ab8fd 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
@@ -76,62 +76,22 @@ struct cfs_cpt_data {
 
 static struct cfs_cpt_data	cpt_data;
 
-void
-cfs_cpu_core_siblings(int cpu, cpumask_t *mask)
+static void cfs_cpu_core_siblings(int cpu, cpumask_t *mask)
 {
 	/* return cpumask of cores in the same socket */
 	cpumask_copy(mask, topology_core_cpumask(cpu));
 }
-EXPORT_SYMBOL(cfs_cpu_core_siblings);
-
-/* return number of cores in the same socket of \a cpu */
-int
-cfs_cpu_core_nsiblings(int cpu)
-{
-	int	num;
-
-	down(&cpt_data.cpt_mutex);
-
-	cfs_cpu_core_siblings(cpu, cpt_data.cpt_cpumask);
-	num = cpus_weight(*cpt_data.cpt_cpumask);
-
-	up(&cpt_data.cpt_mutex);
-
-	return num;
-}
-EXPORT_SYMBOL(cfs_cpu_core_nsiblings);
 
 /* return cpumask of HTs in the same core */
-void
-cfs_cpu_ht_siblings(int cpu, cpumask_t *mask)
+static void cfs_cpu_ht_siblings(int cpu, cpumask_t *mask)
 {
 	cpumask_copy(mask, topology_thread_cpumask(cpu));
 }
-EXPORT_SYMBOL(cfs_cpu_ht_siblings);
 
-/* return number of HTs in the same core of \a cpu */
-int
-cfs_cpu_ht_nsiblings(int cpu)
-{
-	int	num;
-
-	down(&cpt_data.cpt_mutex);
-
-	cfs_cpu_ht_siblings(cpu, cpt_data.cpt_cpumask);
-	num = cpus_weight(*cpt_data.cpt_cpumask);
-
-	up(&cpt_data.cpt_mutex);
-
-	return num;
-}
-EXPORT_SYMBOL(cfs_cpu_ht_nsiblings);
-
-void
-cfs_node_to_cpumask(int node, cpumask_t *mask)
+static void cfs_node_to_cpumask(int node, cpumask_t *mask)
 {
 	cpumask_copy(mask, cpumask_of_node(node));
 }
-EXPORT_SYMBOL(cfs_node_to_cpumask);
 
 void
 cfs_cpt_table_free(struct cfs_cpt_table *cptab)
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index 1667b8e..cd1bab5 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -551,6 +551,7 @@ ptlrpc_server_nthreads_check(struct ptlrpc_service *svc,
 	if (tc->tc_thr_factor != 0) {
 		int	  factor = tc->tc_thr_factor;
 		const int fade = 4;
+		cpumask_t mask;
 
 		/*
 		 * User wants to increase number of threads with for
@@ -564,7 +565,8 @@ ptlrpc_server_nthreads_check(struct ptlrpc_service *svc,
 		 * have too many threads no matter how many cores/HTs
 		 * there are.
 		 */
-		if (cfs_cpu_ht_nsiblings(0) > 1) { /* weight is # of HTs */
+		cpumask_copy(&mask, topology_thread_cpumask(0));
+		if (cpus_weight(mask) > 1) { /* weight is # of HTs */
 			/* depress thread factor for hyper-thread */
 			factor = factor - (factor >> 1) + (factor >> 3);
 		}
@@ -2776,11 +2778,13 @@ int ptlrpc_start_thread(struct ptlrpc_service_part *svcpt, int wait)
 
 int ptlrpc_hr_init(void)
 {
+	cpumask_t			mask;
 	struct ptlrpc_hr_partition	*hrp;
 	struct ptlrpc_hr_thread		*hrt;
 	int				rc;
 	int				i;
 	int				j;
+	int				weight;
 	ENTRY;
 
 	memset(&ptlrpc_hr, 0, sizeof(ptlrpc_hr));
@@ -2793,6 +2797,9 @@ int ptlrpc_hr_init(void)
 
 	init_waitqueue_head(&ptlrpc_hr.hr_waitq);
 
+	cpumask_copy(&mask, topology_thread_cpumask(0));
+	weight = cpus_weight(mask);
+
 	cfs_percpt_for_each(hrp, i, ptlrpc_hr.hr_partitions) {
 		hrp->hrp_cpt = i;
 
@@ -2800,7 +2807,7 @@ int ptlrpc_hr_init(void)
 		atomic_set(&hrp->hrp_nstopped, 0);
 
 		hrp->hrp_nthrs = cfs_cpt_weight(ptlrpc_hr.hr_cpt_table, i);
-		hrp->hrp_nthrs /= cfs_cpu_ht_nsiblings(0);
+		hrp->hrp_nthrs /= weight;
 
 		LASSERT(hrp->hrp_nthrs > 0);
 		OBD_CPT_ALLOC(hrp->hrp_thrs, ptlrpc_hr.hr_cpt_table, i,
-- 
1.7.9.5

