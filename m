Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbaFLQZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:25:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39809 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043AbaFLQZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:25:55 -0400
From: Borislav Petkov <bp@alien8.de>
To: linux-edac <linux-edac@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH -v2 3/3] MCE, CE: Add debugging glue
Date: Thu, 12 Jun 2014 18:22:30 +0200
Message-Id: <1402590150-9798-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402590150-9798-1-git-send-email-bp@alien8.de>
References: <1402590150-9798-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

For testing purposes only.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 23 ++++++++++++++++++++++-
 drivers/ras/ce.c                 | 28 +++++++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index f908b4cd7448..fa92c46c0220 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2579,9 +2579,26 @@ static int fake_panic_set(void *data, u64 val)
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
+	cec_pfn = val;
+
+	return ce_add_elem(val);
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
@@ -2591,6 +2608,10 @@ static int __init mcheck_debugfs_init(void)
 	if (!ffake_panic)
 		return -ENOMEM;
 
+	cec_pfn = debugfs_create_file("cec_pfn", 0400, dmce, NULL, &cec_pfn_ops);
+	if (!cec_pfn)
+		return -ENOMEM;
+
 	return 0;
 }
 #else
diff --git a/drivers/ras/ce.c b/drivers/ras/ce.c
index 6b66a587c3ae..4603c0003391 100644
--- a/drivers/ras/ce.c
+++ b/drivers/ras/ce.c
@@ -94,6 +94,25 @@ static struct ce_array {
 
 static DEFINE_MUTEX(ce_mutex);
 
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
@@ -180,6 +199,7 @@ static u64 del_lru_elem_unlocked(struct ce_array *ca)
 {
 	unsigned int min = FULL_COUNT_MASK;
 	int i, min_idx = 0;
+	u64 pfn;
 
 	for (i = 0; i < ca->n; i++) {
 		unsigned int this = FULL_COUNT(ca->array[i]);
@@ -189,9 +209,14 @@ static u64 del_lru_elem_unlocked(struct ce_array *ca)
 		}
 	}
 
+	pfn = PFN(ca->array[min_idx]);
+
+	pr_err("%s: Deleting ca[%d]: %016llu|%03x\n",
+		__func__, min_idx, pfn, min);
+
 	__del_elem(ca, min_idx);
 
-	return PFN(ca->array[min_idx]);
+	return pfn;
 }
 
 /*
@@ -266,6 +291,7 @@ int ce_add_elem(u64 pfn)
 	}
 
 unlock:
+	dump_array(ca);
 	mutex_unlock(&ce_mutex);
 
 	return ret;
-- 
2.0.0

