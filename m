Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbaGATYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:24:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44280 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbaGATXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:23:50 -0400
From: Borislav Petkov <bp@alien8.de>
To: linux-edac <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -v3 4/4] MCE, CE: Add debugging glue
Date: Tue,  1 Jul 2014 21:23:43 +0200
Message-Id: <1404242623-10094-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404242623-10094-1-git-send-email-bp@alien8.de>
References: <1404242623-10094-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

For testing purposes only.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 28 +++++++++++++++++++++++++++-
 drivers/ras/ce.c                 | 28 +++++++++++++++++++++++++++-
 include/linux/ras.h              |  1 +
 3 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a15a09b29ed0..4a17e1d86ae7 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1418,6 +1418,8 @@ int mce_notify_irq(void)
 	/* Not more than two messages every minute */
 	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
 
+	mce_schedule_work();
+
 	if (test_and_clear_bit(0, &mce_need_notify)) {
 		/* wake processes polling /dev/mcelog */
 		wake_up_interruptible(&mce_chrdev_wait);
@@ -2596,9 +2598,29 @@ static int fake_panic_set(void *data, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(fake_panic_fops, fake_panic_get,
 			fake_panic_set, "%llu\n");
 
+static u64 cec_pfn;
+
+static int cec_pfn_get(void *data, u64 *val)
+{
+	*val = cec_pfn;
+
+	ce_dump_array();
+
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
@@ -2608,6 +2630,10 @@ static int __init mcheck_debugfs_init(void)
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
index 4cab8e8a4ef0..c3c7936527f1 100644
--- a/drivers/ras/ce.c
+++ b/drivers/ras/ce.c
@@ -94,6 +94,26 @@ static struct ce_array {
 
 static DEFINE_MUTEX(ce_mutex);
 
+void ce_dump_array(void)
+{
+	struct ce_array *ca = &ce_arr;
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
@@ -180,6 +200,7 @@ static u64 del_lru_elem_unlocked(struct ce_array *ca)
 {
 	unsigned int min = FULL_COUNT_MASK;
 	int i, min_idx = 0;
+	u64 pfn;
 
 	for (i = 0; i < ca->n; i++) {
 		unsigned int this = FULL_COUNT(ca->array[i]);
@@ -189,9 +210,14 @@ static u64 del_lru_elem_unlocked(struct ce_array *ca)
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
diff --git a/include/linux/ras.h b/include/linux/ras.h
index 24e82fb0fe99..a9aed3900453 100644
--- a/include/linux/ras.h
+++ b/include/linux/ras.h
@@ -13,4 +13,5 @@ static inline int ras_add_daemon_trace(void) { return 0; }
 
 void __init ce_init(void);
 int ce_add_elem(u64 pfn);
+void ce_dump_array(void);
 #endif
-- 
2.0.0

