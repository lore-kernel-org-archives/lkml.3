Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaE0N12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:27:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52053 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbaE0N1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:27:20 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-edac <linux-edac@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 3/3] MCE, CE: Add debugging glue
Date: Tue, 27 May 2014 15:27:15 +0200
Message-Id: <1401197235-13440-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1401197235-13440-1-git-send-email-bp@alien8.de>
References: <1401197235-13440-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

For testing purposes only.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/ce.c  | 24 ++++++++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce.c | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/ce.c b/arch/x86/kernel/cpu/mcheck/ce.c
index 3020415f27f4..aa2fee325588 100644
--- a/arch/x86/kernel/cpu/mcheck/ce.c
+++ b/arch/x86/kernel/cpu/mcheck/ce.c
@@ -94,6 +94,25 @@ static struct ce_array {
 
 static DEFINE_MUTEX(ce_lock);
 
+static void dump_array(struct ce_array *ca)
+{
+	u64 prev = 0;
+	int i;
+
+	pr_info("{ n: %d\n", ca->n);
+	for (i = 0; i < ca->n; i++) {
+		u64 this = PFN(ca->array[i]);
+
+		pr_info(" %03d: [%016llu|%03llx]\n", i, this, FULL_COUNT(ca->array[i]));
+
+		WARN_ON(prev > this);
+
+		prev = this;
+	}
+
+	pr_info("}\n");
+}
+
 /*
  * Decrement decay value. We're using DECAY_BITS bits to denote decay of an
  * element in the array. On insertion and any access, it gets maxed
@@ -202,6 +221,9 @@ u64 ce_del_lru_elem(void)
 
 	pfn = PFN(ca->array[min_idx]);
 
+	pr_err("%s: Deleting ca[%d]: %016llu|%03x\n",
+	       __func__, min_idx, pfn, min);
+
 	__del_elem(ca, min_idx);
 
 	mutex_unlock(&ce_lock);
@@ -263,7 +285,9 @@ int ce_add_elem(u64 pfn)
 		ret = 0;
 	}
 
+
 unlock:
+	dump_array(ca);
 	mutex_unlock(&ce_lock);
 
 	return ret;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 732fbe61416d..59b726d4e116 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2552,9 +2552,34 @@ static int fake_panic_set(void *data, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(fake_panic_fops, fake_panic_get,
 			fake_panic_set, "%llu\n");
 
+static u64 cec_pfn;
+
+static int cec_pfn_get(void *data, u64 *val)
+{
+	*val = cec_pfn;
+	return 0;
+}
+
+static int cec_pfn_set(void *data, u64 val)
+{
+	int ret;
+
+	cec_pfn = val;
+
+	ret = ce_add_elem(val);
+	if (ret < 0) {
+		ce_del_lru_elem();
+		ret = ce_add_elem(val);
+	}
+
+	return ret;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(cec_pfn_ops, cec_pfn_get, cec_pfn_set, "0x%llx\n");
+
 static int __init mcheck_debugfs_init(void)
 {
-	struct dentry *dmce, *ffake_panic;
+	struct dentry *dmce, *ffake_panic, *cec_pfn;
 
 	dmce = mce_get_debugfs_dir();
 	if (!dmce)
@@ -2564,6 +2589,10 @@ static int __init mcheck_debugfs_init(void)
 	if (!ffake_panic)
 		return -ENOMEM;
 
+	cec_pfn = debugfs_create_file("cec_pfn", 0400, dmce, NULL, &cec_pfn_ops);
+	if (!cec_pfn)
+		return -ENOMEM;
+
 	return 0;
 }
 #else
-- 
1.9.0

