Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbaFCPYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:24:09 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45514 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574AbaFCPYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:24:07 -0400
Date: Tue, 3 Jun 2014 16:24:02 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org
Cc: richard@nod.at, akpm@linux-foundation.org, tglx@linutronix.de, bp@suse.de
Subject: [PATCH v2 08/11] [arch/x86] replace strict_strto calls
Message-ID: <20140603152402.GJ28580@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <dwalter@google.com>
Subject: [PATCH v2 08/11] [arch/x86] replace strict_strto calls

Replace obsolete strict_strto calls with appropriate kstrto calls

Signed-off-by: Daniel Walter <dwalter@google.com>
Acked-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c | 4 ++--
 arch/x86/kernel/cpu/mcheck/mce.c      | 6 +++---
 arch/x86/kernel/cpu/mcheck/mce_amd.c  | 4 ++--
 arch/x86/kvm/mmu_audit.c              | 2 +-
 arch/x86/platform/uv/tlb_uv.c         | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index a952e9c..4ff210a 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -461,7 +461,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 
 	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
 
-	if (strict_strtoul(buf, 10, &val) < 0)
+	if (kstrtoul(buf, 10, &val) < 0)
 		return -EINVAL;
 
 	err = amd_set_l3_disable_slot(this_leaf->base.nb, cpu, slot, val);
@@ -511,7 +511,7 @@ store_subcaches(struct _cpuid4_info *this_leaf, const char *buf, size_t count,
 	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
 		return -EINVAL;
 
-	if (strict_strtoul(buf, 16, &val) < 0)
+	if (kstrtoul(buf, 16, &val) < 0)
 		return -EINVAL;
 
 	if (amd_set_subcaches(cpu, val))
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 68317c8..7f781bb 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2142,7 +2142,7 @@ static ssize_t set_bank(struct device *s, struct device_attribute *attr,
 {
 	u64 new;
 
-	if (strict_strtoull(buf, 0, &new) < 0)
+	if (kstrtou64(buf, 0, &new) < 0)
 		return -EINVAL;
 
 	attr_to_bank(attr)->ctl = new;
@@ -2180,7 +2180,7 @@ static ssize_t set_ignore_ce(struct device *s,
 {
 	u64 new;
 
-	if (strict_strtoull(buf, 0, &new) < 0)
+	if (kstrtou64(buf, 0, &new) < 0)
 		return -EINVAL;
 
 	if (mca_cfg.ignore_ce ^ !!new) {
@@ -2204,7 +2204,7 @@ static ssize_t set_cmci_disabled(struct device *s,
 {
 	u64 new;
 
-	if (strict_strtoull(buf, 0, &new) < 0)
+	if (kstrtou64(buf, 0, &new) < 0)
 		return -EINVAL;
 
 	if (mca_cfg.cmci_disabled ^ !!new) {
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 603df4f..1e49f8f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -353,7 +353,7 @@ store_interrupt_enable(struct threshold_block *b, const char *buf, size_t size)
 	if (!b->interrupt_capable)
 		return -EINVAL;
 
-	if (strict_strtoul(buf, 0, &new) < 0)
+	if (kstrtoul(buf, 0, &new) < 0)
 		return -EINVAL;
 
 	b->interrupt_enable = !!new;
@@ -372,7 +372,7 @@ store_threshold_limit(struct threshold_block *b, const char *buf, size_t size)
 	struct thresh_restart tr;
 	unsigned long new;
 
-	if (strict_strtoul(buf, 0, &new) < 0)
+	if (kstrtoul(buf, 0, &new) < 0)
 		return -EINVAL;
 
 	if (new > THRESHOLD_MAX)
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index 1185fe7..9ade5cf 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -273,7 +273,7 @@ static int mmu_audit_set(const char *val, const struct kernel_param *kp)
 	int ret;
 	unsigned long enable;
 
-	ret = strict_strtoul(val, 10, &enable);
+	ret = kstrtoul(val, 10, &enable);
 	if (ret < 0)
 		return -EINVAL;
 
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index dfe605a..ccc3210 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1476,7 +1476,7 @@ static ssize_t ptc_proc_write(struct file *file, const char __user *user,
 		return count;
 	}
 
-	if (strict_strtol(optstr, 10, &input_arg) < 0) {
+	if (kstrtol(optstr, 10, &input_arg) < 0) {
 		printk(KERN_DEBUG "%s is invalid\n", optstr);
 		return -EINVAL;
 	}
-- 
1.9.3

