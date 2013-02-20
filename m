Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935426Ab3BTOwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:52:16 -0500
Received: from multi.imgtec.com ([194.200.65.239]:49913 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933262Ab3BTOwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:52:15 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Vineet Gupta <vgupta@synopsys.com>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/2] metag: copy devicetree to non-init memory
Date: Wed, 20 Feb 2013 14:52:08 +0000
Message-ID: <1361371929-28148-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361371929-28148-1-git-send-email-james.hogan@imgtec.com>
References: <1361371929-28148-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_20_14_52_14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make a copy of the device tree blob in non-init memory. It is required
when using built-in device tree files that the platform code copies the
blob to non-init memory prior to calling unflatten_device_tree(),
otherwise the strings that the device tree refer to will get poisoned
and potentially reused, breaking later reading of the device tree
post-init (such as compatible matching in modules, debugfs, and the
procfs interface).

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/prom.h |  1 +
 arch/metag/kernel/devtree.c   | 17 +++++++++++++++++
 arch/metag/kernel/setup.c     |  2 ++
 3 files changed, 20 insertions(+)

diff --git a/arch/metag/include/asm/prom.h b/arch/metag/include/asm/prom.h
index d881396..ccac97e 100644
--- a/arch/metag/include/asm/prom.h
+++ b/arch/metag/include/asm/prom.h
@@ -18,6 +18,7 @@
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
 extern struct machine_desc *setup_machine_fdt(void *dt);
+extern void copy_fdt(void);
 extern void metag_dt_memblock_reserve(void);
 
 #endif /* __ASM_METAG_PROM_H */
diff --git a/arch/metag/kernel/devtree.c b/arch/metag/kernel/devtree.c
index 5b6b1d85..7cd0252 100644
--- a/arch/metag/kernel/devtree.c
+++ b/arch/metag/kernel/devtree.c
@@ -95,3 +95,20 @@ struct machine_desc * __init setup_machine_fdt(void *dt)
 
 	return mdesc_best;
 }
+
+/**
+ * copy_fdt - Copy device tree into non-init memory.
+ *
+ * We must copy the flattened device tree blob into non-init memory because the
+ * unflattened device tree will reference the strings in it directly.
+ */
+void __init copy_fdt(void)
+{
+	void *alloc = early_init_dt_alloc_memory_arch(
+			be32_to_cpu(initial_boot_params->totalsize), 0x40);
+	if (alloc) {
+		memcpy(alloc, initial_boot_params,
+		       be32_to_cpu(initial_boot_params->totalsize));
+		initial_boot_params = alloc;
+	}
+}
diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index dd6c5ad..8792461 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -406,6 +406,8 @@ void __init setup_arch(char **cmdline_p)
 	cpu_2_hwthread_id[smp_processor_id()] = hard_processor_id();
 	hwthread_id_2_cpu[hard_processor_id()] = smp_processor_id();
 
+	/* Copy device tree blob into non-init memory before unflattening */
+	copy_fdt();
 	unflatten_device_tree();
 
 #ifdef CONFIG_SMP
-- 
1.8.1.2


