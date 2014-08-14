Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaHNHWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:22:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:38173 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbaHNHWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:22:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,861,1400050800"; 
   d="scan'208";a="587933547"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: bp@alien8.de
Cc: tony.luck@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>, Borislav Petkov <bp@suse.de>
Subject: [PATCH v2 1/5] x86, MCE: Provide a lock-less memory pool to save error record
Date: Thu, 14 Aug 2014 02:49:42 -0400
Message-Id: <1407998986-1834-2-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
References: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk is not safe to use in MCE context. Add a lockless memory
allocator pool to save error records in MCE context. Issuing those
records will be delayed to a context safe to do printk. This idea is
inspired by APEI/GHES driver.

We're very conservative and allocate only two pages for it but since
we're going to use those pages throughout the system's lifetime, we
allocate them statically to avoid early boot time allocation woes.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Link: http://lkml.kernel.org/r/1407830375-11087-1-git-send-email-gong.chen@linux.intel.com
[Boris: rewrite. ]
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/Kconfig                          |   1 +
 arch/x86/include/uapi/asm/mce.h           |   3 +-
 arch/x86/kernel/cpu/mcheck/Makefile       |   2 +-
 arch/x86/kernel/cpu/mcheck/mce-genpool.c  | 102 ++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |  11 ++++
 arch/x86/kernel/cpu/mcheck/mce.c          |   6 ++
 6 files changed, 123 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce-genpool.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4aafd322e21e..706dc3c8f6d6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -866,6 +866,7 @@ config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 
 config X86_MCE
 	bool "Machine Check / overheating reporting"
+	select GENERIC_ALLOCATOR
 	default y
 	---help---
 	  Machine Check support allows the processor to notify the
diff --git a/arch/x86/include/uapi/asm/mce.h b/arch/x86/include/uapi/asm/mce.h
index a0eab85ce7b8..577acacaf515 100644
--- a/arch/x86/include/uapi/asm/mce.h
+++ b/arch/x86/include/uapi/asm/mce.h
@@ -15,7 +15,8 @@ struct mce {
 	__u64 time;	/* wall time_t when error was detected */
 	__u8  cpuvendor;	/* cpu vendor as encoded in system.h */
 	__u8  inject_flags;	/* software inject flags */
-	__u16  pad;
+	__u8  severity;
+	__u8  usable_addr;	/* addr is usable */
 	__u32 cpuid;	/* CPUID 1 EAX */
 	__u8  cs;		/* code segment */
 	__u8  bank;	/* machine check bank */
diff --git a/arch/x86/kernel/cpu/mcheck/Makefile b/arch/x86/kernel/cpu/mcheck/Makefile
index bb34b03af252..a3311c886194 100644
--- a/arch/x86/kernel/cpu/mcheck/Makefile
+++ b/arch/x86/kernel/cpu/mcheck/Makefile
@@ -1,4 +1,4 @@
-obj-y				=  mce.o mce-severity.o
+obj-y				=  mce.o mce-severity.o mce-genpool.o
 
 obj-$(CONFIG_X86_ANCIENT_MCE)	+= winchip.o p5.o
 obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel.o
diff --git a/arch/x86/kernel/cpu/mcheck/mce-genpool.c b/arch/x86/kernel/cpu/mcheck/mce-genpool.c
new file mode 100644
index 000000000000..a0a0ad4b8778
--- /dev/null
+++ b/arch/x86/kernel/cpu/mcheck/mce-genpool.c
@@ -0,0 +1,102 @@
+/*
+ * MCE event pool management in MCE context
+ *
+ * Copyright (C) 2014 Intel Corp.
+ * Author: Chen, Gong <gong.chen@linux.intel.com>
+ *
+ * This file is licensed under GPLv2.
+ */
+#include <linux/smp.h>
+#include <linux/mm.h>
+#include <linux/genalloc.h>
+#include <linux/llist.h>
+#include "mce-internal.h"
+
+/*
+ * printk is not safe in MCE context thus a lock-less memory allocator
+ * (genpool) is used to save error information organized in a lock-less
+ * list.
+ */
+
+#define GENPOOL_BUFSZ	(2 * PAGE_SIZE)
+
+static struct gen_pool *mce_evt_pool;
+static LLIST_HEAD(mce_event_llist);
+static char genpool_buf[GENPOOL_BUFSZ];
+
+/*
+ * This memory pool is only to be used to save MCE records in MCE context.
+ * Since MCE events are rare so a fixed size memory pool should be enough.
+ * Keep 2 pages to save MCE events for now (~80 MCE records at most).
+ */
+static int mce_genpool_create(void)
+{
+	struct gen_pool *tmpp;
+	int ret = -ENOMEM;
+
+	tmpp = gen_pool_create(ilog2(sizeof(struct mce_evt_llist)), -1);
+	if (!tmpp)
+		goto out;
+
+	ret = gen_pool_add(tmpp, (unsigned long)genpool_buf, GENPOOL_BUFSZ, -1);
+	if (ret) {
+		gen_pool_destroy(tmpp);
+		goto out;
+	}
+
+	mce_evt_pool = tmpp;
+
+out:
+	return ret;
+}
+
+void mce_genpool_process(void)
+{
+	struct llist_node *head;
+	struct mce_evt_llist *node;
+	struct mce *mce;
+
+	head = llist_del_all(&mce_event_llist);
+	if (!head)
+		return;
+
+	head = llist_reverse_order(head);
+	llist_for_each_entry(node, head, llnode) {
+		mce = &node->mce;
+		atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, mce);
+		gen_pool_free(mce_evt_pool, (unsigned long)node, sizeof(*node));
+	}
+}
+
+bool mce_genpool_empty(void)
+{
+	return llist_empty(&mce_event_llist);
+}
+
+bool mce_genpool_add(struct mce *mce)
+{
+	struct mce_evt_llist *node;
+
+	if (!mce_evt_pool)
+		return false;
+
+	node = (void *)gen_pool_alloc(mce_evt_pool, sizeof(*node));
+	if (!node) {
+		pr_warn_ratelimited("MCE records pool overflow!\n");
+		return false;
+	}
+
+	memcpy(&node->mce, mce, sizeof(*mce));
+	llist_add(&node->llnode, &mce_event_llist);
+
+	return true;
+}
+
+int mce_genpool_init(void)
+{
+	/* Just init mce_genpool once. */
+	if (mce_evt_pool)
+		return 0;
+
+	return mce_genpool_create();
+}
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 09edd0b65fef..6f0ea3db02c8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -11,6 +11,8 @@ enum severity_level {
 	MCE_PANIC_SEVERITY,
 };
 
+extern struct atomic_notifier_head x86_mce_decoder_chain;
+
 #define ATTR_LEN		16
 
 /* One object for each MCE bank, shared by all CPUs */
@@ -21,6 +23,15 @@ struct mce_bank {
 	char			attrname[ATTR_LEN];	/* attribute name */
 };
 
+struct mce_evt_llist {
+	struct llist_node llnode;
+	struct mce mce;
+};
+
+void mce_genpool_process(void);
+bool mce_genpool_empty(void);
+bool mce_genpool_add(struct mce *mce);
+int mce_genpool_init(void);
 int mce_severity(struct mce *a, int tolerant, char **msg);
 struct dentry *mce_get_debugfs_dir(void);
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bd9ccda8087f..b2c8bb83672a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1686,6 +1686,12 @@ void mcheck_cpu_init(struct cpuinfo_x86 *c)
 	if (mca_cfg.disabled)
 		return;
 
+	if (mce_genpool_init()) {
+		mca_cfg.disabled = true;
+		pr_emerg("Couldn't allocate MCE records pool!\n");
+		return;
+	}
+
 	if (__mcheck_cpu_ancient_init(c))
 		return;
 
-- 
2.0.0.rc2

