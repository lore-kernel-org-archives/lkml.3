Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbbA1ACc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:02:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:39645 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037AbbA1ABw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:01:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,477,1418112000"; 
   d="scan'208";a="677052507"
From: Vikas Shivappa <vikas.shivappa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vikas.shivappa@intel.com, vikas.shivappa@linux.intel.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        peterz@infradead.org, matt.fleming@intel.com, will.auld@intel.com
Subject: [PATCH 3/6] x86/intel_cat: Support cache bit mask for Intel CAT
Date: Tue, 27 Jan 2015 16:00:06 -0800
Message-Id: <1422403209-15533-4-git-send-email-vikas.shivappa@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>
References: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for cache bit mask manipulation. The change adds a file to
the CAT cgroup which represents the CBM for the cgroup.

The CAT cgroup follows cgroup hierarchy ,mkdir and adding tasks to the
cgroup never fails.  When a child cgroup is created it inherits the
CLOSid and the CBM from its parent.  When a user changes the default
CBM for a cgroup, a new CLOSid may be allocated if the CBM was not
used before. If the new CBM is the one that is already used, the
reference for that CLOSid<->CBM is incremented. The changing of 'cbm'
may fail with -ERRNOSPC once the kernel runs out of maximum CLOSids it
can support.
User can create as many cgroups as he wants but having different CBMs
at the same time is restricted by the maximum number of CLOSids
(multiple cgroups can have the same CBM).
Kernel maintains a CLOSid<->cbm mapping which keeps reference counter
for each cgroup using a CLOSid.

The tasks in the CAT cgroup would get to fill the LLC cache represented
by the cgroup's 'cbm' file.

Reuse of CLOSids for cgroups with same bitmask also has following
goodness:
- This helps to use the scant CLOSids optimally.
- This also implies that during context switch, write to PQR-MSR is done
only when a task with a different bitmask is scheduled in.

Signed-off-by: Vikas Shivappa <vikas.shivappa@linux.intel.com>
---
 arch/x86/include/asm/intel_cat.h |   3 +
 arch/x86/kernel/cpu/intel_cat.c  | 155 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 158 insertions(+)

diff --git a/arch/x86/include/asm/intel_cat.h b/arch/x86/include/asm/intel_cat.h
index da277a2..b19df52 100644
--- a/arch/x86/include/asm/intel_cat.h
+++ b/arch/x86/include/asm/intel_cat.h
@@ -4,6 +4,9 @@
 #ifdef CONFIG_CGROUP_CAT
 
 #include <linux/cgroup.h>
+#define MAX_CBM_LENGTH			32
+#define IA32_L3_CBM_BASE		0xc90
+#define CBM_FROM_INDEX(x)		(IA32_L3_CBM_BASE + x)
 
 struct cat_subsys_info {
 	/* Clos Bitmap to keep track of available CLOSids.*/
diff --git a/arch/x86/kernel/cpu/intel_cat.c b/arch/x86/kernel/cpu/intel_cat.c
index 37864f8..049e840 100644
--- a/arch/x86/kernel/cpu/intel_cat.c
+++ b/arch/x86/kernel/cpu/intel_cat.c
@@ -33,6 +33,9 @@ static struct cat_subsys_info catss_info;
 static DEFINE_MUTEX(cat_group_mutex);
 struct cache_alloc cat_root_group;
 
+#define cat_for_each_child(pos_css, parent_cq)		\
+	css_for_each_child((pos_css), &(parent_cq)->css)
+
 static inline bool cat_supported(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_CAT_L3))
@@ -160,8 +163,160 @@ static void cat_css_free(struct cgroup_subsys_state *css)
 	mutex_unlock(&cat_group_mutex);
 }
 
+/*
+ * Tests if atleast two contiguous bits are set.
+ */
+
+static inline bool cbm_is_contiguous(unsigned long var)
+{
+	unsigned long first_bit, zero_bit;
+	unsigned long maxcbm = MAX_CBM_LENGTH;
+
+	if (bitmap_weight(&var, maxcbm) < 2)
+		return false;
+
+	first_bit = find_next_bit(&var, maxcbm, 0);
+	zero_bit = find_next_zero_bit(&var, maxcbm, first_bit);
+
+	if (find_next_bit(&var, maxcbm, zero_bit) < maxcbm)
+		return false;
+
+	return true;
+}
+
+static int cat_cbm_read(struct seq_file *m, void *v)
+{
+	struct cache_alloc *cq = css_cat(seq_css(m));
+
+	seq_bitmap(m, cq->cbm, MAX_CBM_LENGTH);
+	seq_putc(m, '\n');
+	return 0;
+}
+
+static int validate_cbm(struct cache_alloc *cq, unsigned long cbmvalue)
+{
+	struct cache_alloc *par, *c;
+	struct cgroup_subsys_state *css;
+
+	if (!cbm_is_contiguous(cbmvalue)) {
+		pr_info("cbm should have >= 2 bits and be contiguous\n");
+		return -EINVAL;
+	}
+
+	par = parent_cat(cq);
+	if (!bitmap_subset(&cbmvalue, par->cbm, MAX_CBM_LENGTH))
+		return -EINVAL;
+
+	rcu_read_lock();
+	cat_for_each_child(css, cq) {
+		c = css_cat(css);
+		if (!bitmap_subset(c->cbm, &cbmvalue, MAX_CBM_LENGTH)) {
+			pr_info("Children's mask not a subset\n");
+			rcu_read_unlock();
+			return -EINVAL;
+		}
+	}
+
+	rcu_read_unlock();
+	return 0;
+}
+
+static bool cbm_search(unsigned long cbm, int *closid)
+{
+	int maxid = boot_cpu_data.x86_cat_closs;
+	unsigned int i;
+
+	for (i = 0; i < maxid; i++)
+		if (bitmap_equal(&cbm, &ccmap[i].cbm, MAX_CBM_LENGTH)) {
+			*closid = i;
+			return true;
+		}
+
+	return false;
+}
+
+static void cbmmap_dump(void)
+{
+	int i;
+
+	pr_debug("CBMMAP\n");
+	for (i = 0; i < boot_cpu_data.x86_cat_closs; i++)
+		pr_debug("cbm: 0x%x,cgrp_count: %u\n",
+		 (unsigned int)ccmap[i].cbm, ccmap[i].cgrp_count);
+}
+
+/*
+ * cat_cbm_write() - Validates and writes the cache bit mask(cbm)
+ * to the IA32_L3_MASK_n and also store the same in the ccmap.
+ *
+ * CLOSids are reused for cgroups which have same bitmask.
+ * - This helps to use the scant CLOSids optimally.
+ * - This also implies that at context switch write
+ * to PQR-MSR is done only when a task with a
+ * different bitmask is scheduled in.
+ */
+
+static int cat_cbm_write(struct cgroup_subsys_state *css,
+				 struct cftype *cft, u64 cbmvalue)
+{
+	struct cache_alloc *cq = css_cat(css);
+	ssize_t err = 0;
+	unsigned long cbm;
+	unsigned int closid;
+	u32 cbm_mask =
+		(u32)((u64)(1 << boot_cpu_data.x86_cat_cbmlength) - 1);
+
+	if (cq == &cat_root_group)
+		return -EPERM;
+
+	/*
+	* Need global mutex as cbm write may allocate a closid.
+	*/
+	mutex_lock(&cat_group_mutex);
+	cbm = cbmvalue & cbm_mask;
+
+	if (bitmap_equal(&cbm, cq->cbm, MAX_CBM_LENGTH))
+		goto out;
+
+	err = validate_cbm(cq, cbm);
+	if (err)
+		goto out;
+
+	cat_free_closid(cq);
+	if (cbm_search(cbm, &closid)) {
+		cq->clos = closid;
+		ccmap[cq->clos].cgrp_count++;
+	} else {
+		err = cat_alloc_closid(cq);
+		if (err)
+			goto out;
+
+		wrmsrl(CBM_FROM_INDEX(cq->clos), cbm);
+	}
+
+	ccmap[cq->clos].cbm = cbm;
+	cq->cbm = &ccmap[cq->clos].cbm;
+	cbmmap_dump();
+
+out:
+
+	mutex_unlock(&cat_group_mutex);
+	return err;
+}
+
+static struct cftype cat_files[] = {
+	{
+		.name = "cbm",
+		.seq_show = cat_cbm_read,
+		.write_u64 = cat_cbm_write,
+		.mode = 0666,
+	},
+	{ }	/* terminate */
+};
+
 struct cgroup_subsys cat_cgrp_subsys = {
 	.css_alloc			= cat_css_alloc,
 	.css_free			= cat_css_free,
+	.legacy_cftypes		= cat_files,
 	.early_init			= 0,
 };
-- 
1.9.1

