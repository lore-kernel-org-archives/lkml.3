Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbbA1ABy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:01:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:39631 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbbA1ABw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:01:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,477,1418112000"; 
   d="scan'208";a="677052503"
From: Vikas Shivappa <vikas.shivappa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vikas.shivappa@intel.com, vikas.shivappa@linux.intel.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        peterz@infradead.org, matt.fleming@intel.com, will.auld@intel.com
Subject: [PATCH 2/6] x86/intel_cat: Adds support for Class of service management
Date: Tue, 27 Jan 2015 16:00:05 -0800
Message-Id: <1422403209-15533-3-git-send-email-vikas.shivappa@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>
References: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a cgroup subsystem to support cache allocation. When a
CAT cgroup is created it has a CLOSid and CBM associated with it which
are inherited from its parent. A Class of service(CLOS) in Cache
Allocation is represented by a CLOSid. CLOSid is internal to the kernel
and not exposed to user. Cache bitmask(CBM) represents one cache
'subset'. Root cgroup would have all available bits set for its CBM and
would be assigned the CLOSid 0.

CLOSid allocation is tracked using a separate bitmap. The maximum number
of CLOSids is specified by the h/w during CPUID enumeration and the
kernel simply throws an -ENOSPC when it runs out of CLOSids.

Each CBM has an associated CLOSid. If multiple cgroups have the same CBM
they would also have the same CLOSid. The reference count parameter in
CLOSid-CBM map keeps track of how many cgroups are using each
CLOSid<->CBM mapping.

Signed-off-by: Vikas Shivappa <vikas.shivappa@linux.intel.com>
---
 arch/x86/include/asm/intel_cat.h |  40 +++++++++++++
 arch/x86/kernel/cpu/intel_cat.c  | 126 +++++++++++++++++++++++++++++++++++++--
 include/linux/cgroup_subsys.h    |   4 ++
 3 files changed, 165 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/include/asm/intel_cat.h

diff --git a/arch/x86/include/asm/intel_cat.h b/arch/x86/include/asm/intel_cat.h
new file mode 100644
index 0000000..da277a2
--- /dev/null
+++ b/arch/x86/include/asm/intel_cat.h
@@ -0,0 +1,40 @@
+#ifndef _CAT_H_
+#define _CAT_H_
+
+#ifdef CONFIG_CGROUP_CAT
+
+#include <linux/cgroup.h>
+
+struct cat_subsys_info {
+	/* Clos Bitmap to keep track of available CLOSids.*/
+	unsigned long *closmap;
+};
+
+struct cache_alloc {
+	struct cgroup_subsys_state css;
+	/* Class of service for the cgroup.*/
+	unsigned int clos;
+	/* Corresponding cache bit mask.*/
+	unsigned long *cbm;
+};
+
+struct clos_cbm_map {
+	unsigned long cbm;
+	unsigned int cgrp_count;
+};
+
+/*
+ * Return cat group corresponding to this container.
+ */
+static inline struct cache_alloc *css_cat(struct cgroup_subsys_state *css)
+{
+	return css ? container_of(css, struct cache_alloc, css) : NULL;
+}
+
+static inline struct cache_alloc *parent_cat(struct cache_alloc *cq)
+{
+	return css_cat(cq->css.parent);
+}
+
+#endif
+#endif
diff --git a/arch/x86/kernel/cpu/intel_cat.c b/arch/x86/kernel/cpu/intel_cat.c
index 2f4b19b..37864f8 100644
--- a/arch/x86/kernel/cpu/intel_cat.c
+++ b/arch/x86/kernel/cpu/intel_cat.c
@@ -23,6 +23,15 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/spinlock.h>
+#include <asm/intel_cat.h>
+
+/*
+ * ccmap maintains 1:1 mapping between CLOSid and cbm.
+ */
+static struct clos_cbm_map *ccmap;
+static struct cat_subsys_info catss_info;
+static DEFINE_MUTEX(cat_group_mutex);
+struct cache_alloc cat_root_group;
 
 static inline bool cat_supported(struct cpuinfo_x86 *c)
 {
@@ -35,17 +44,124 @@ static inline bool cat_supported(struct cpuinfo_x86 *c)
 static int __init cat_late_init(void)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
-	int maxid, cbmlen;
+	static struct clos_cbm_map *ccm;
+	size_t sizeb;
+	int maxid, cbm_len;
 
-	if (!cat_supported(c))
+	if (!cat_supported(c)) {
+		cat_root_group.css.ss->disabled = 1;
 		return -ENODEV;
 
-	maxid = c->x86_cat_closs;
-	cbmlen = c->x86_cat_cbmlength;
+	} else {
+		maxid = c->x86_cat_closs;
+		cbm_len = c->x86_cat_cbmlength;
+		sizeb = BITS_TO_LONGS(maxid) * sizeof(long);
+
+		catss_info.closmap = kzalloc(sizeb, GFP_KERNEL);
+		if (!catss_info.closmap)
+			return -ENOMEM;
+
+		sizeb = maxid * sizeof(struct clos_cbm_map);
+		ccmap = kzalloc(sizeb, GFP_KERNEL);
+		if (!ccmap) {
+			kfree(catss_info.closmap);
+			return -ENOMEM;
+		}
 
-	pr_info("cbmlength:%u,Closs: %u\n", cbmlen, maxid);
+		set_bit(0, catss_info.closmap);
+		cat_root_group.clos = 0;
+
+		ccm = &ccmap[0];
+		ccm->cbm = (u32)((u64)(1 << cbm_len) - 1);
+		cat_root_group.cbm = &(ccm->cbm);
+		ccm->cgrp_count++;
+	}
+
+	pr_info("cbmlength:%u,Closs: %u\n", cbm_len, maxid);
 
 	return 0;
 }
 
 late_initcall(cat_late_init);
+
+/*
+ * Allocates a new closid from unused closids.
+ * Called with the cat_group_mutex held.
+ */
+
+static int cat_alloc_closid(struct cache_alloc *cq)
+{
+	unsigned int id;
+	unsigned int maxid;
+
+	lockdep_assert_held(&cat_group_mutex);
+
+	maxid = boot_cpu_data.x86_cat_closs;
+	id = find_next_zero_bit(catss_info.closmap, maxid, 0);
+	if (id == maxid)
+		return -ENOSPC;
+
+	set_bit(id, catss_info.closmap);
+	ccmap[id].cgrp_count++;
+	cq->clos = id;
+
+	return 0;
+}
+
+/*
+* Called with the cat_group_mutex held.
+*/
+static int cat_free_closid(struct cache_alloc *cq)
+{
+
+	lockdep_assert_held(&cat_group_mutex);
+
+	WARN_ON(!ccmap[cq->clos].cgrp_count);
+	ccmap[cq->clos].cgrp_count--;
+	if (!ccmap[cq->clos].cgrp_count)
+		clear_bit(cq->clos, catss_info.closmap);
+
+	return 0;
+}
+
+static struct cgroup_subsys_state *
+cat_css_alloc(struct cgroup_subsys_state *parent_css)
+{
+	struct cache_alloc *parent = css_cat(parent_css);
+	struct cache_alloc *cq;
+
+	/*
+	 * Cannot return failure on systems with no Cache Allocation
+	 * as the cgroup_init does not handle failures gracefully.
+	 */
+	if (!parent)
+		return &cat_root_group.css;
+
+	cq = kzalloc(sizeof(struct cache_alloc), GFP_KERNEL);
+	if (!cq)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_lock(&cat_group_mutex);
+	cq->clos = parent->clos;
+	ccmap[parent->clos].cgrp_count++;
+	mutex_unlock(&cat_group_mutex);
+
+	cq->cbm = parent->cbm;
+	return &cq->css;
+}
+
+static void cat_css_free(struct cgroup_subsys_state *css)
+{
+	struct cache_alloc *cq = css_cat(css);
+
+	mutex_lock(&cat_group_mutex);
+	cat_free_closid(cq);
+	kfree(cq);
+	mutex_unlock(&cat_group_mutex);
+}
+
+struct cgroup_subsys cat_cgrp_subsys = {
+	.css_alloc			= cat_css_alloc,
+	.css_free			= cat_css_free,
+	.early_init			= 0,
+};
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index 98c4f9b..271c2c7 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -47,6 +47,10 @@ SUBSYS(net_prio)
 SUBSYS(hugetlb)
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_CAT)
+SUBSYS(cat)
+#endif
+
 /*
  * The following subsystems are not supported on the default hierarchy.
  */
-- 
1.9.1

