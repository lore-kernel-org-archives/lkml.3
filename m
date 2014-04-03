Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaDCWXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:23:14 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:46137 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbaDCWRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:35 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 07/20] mips: convert fdt pointers to opaque pointers
Date: Thu,  3 Apr 2014 17:16:50 -0500
Message-Id: <1396563423-30893-8-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

The architecture code does not need to access the internals of the FDT
blob, so make the pointer to it void *.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/include/asm/mips-boards/generic.h | 4 +---
 arch/mips/include/asm/prom.h                | 6 +++---
 arch/mips/kernel/prom.c                     | 2 +-
 arch/mips/lantiq/prom.c                     | 2 +-
 arch/mips/lantiq/prom.h                     | 2 +-
 arch/mips/mti-sead3/sead3-setup.c           | 8 ++++----
 arch/mips/ralink/of.c                       | 4 ++--
 7 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/mips/include/asm/mips-boards/generic.h b/arch/mips/include/asm/mips-boards/generic.h
index 4861681..b969491 100644
--- a/arch/mips/include/asm/mips-boards/generic.h
+++ b/arch/mips/include/asm/mips-boards/generic.h
@@ -67,9 +67,7 @@
 
 extern int mips_revision_sconid;
 
-#ifdef CONFIG_OF
-extern struct boot_param_header __dtb_start;
-#endif
+extern char __dtb_start[];
 
 #ifdef CONFIG_PCI
 extern void mips_pcibios_init(void);
diff --git a/arch/mips/include/asm/prom.h b/arch/mips/include/asm/prom.h
index ccd2b75..a9494c0 100644
--- a/arch/mips/include/asm/prom.h
+++ b/arch/mips/include/asm/prom.h
@@ -21,13 +21,13 @@ extern void device_tree_init(void);
 
 struct boot_param_header;
 
-extern void __dt_setup_arch(struct boot_param_header *bph);
+extern void __dt_setup_arch(void *bph);
 
 #define dt_setup_arch(sym)						\
 ({									\
-	extern struct boot_param_header __dtb_##sym##_begin;		\
+	extern char __dtb_##sym##_begin[];				\
 									\
-	__dt_setup_arch(&__dtb_##sym##_begin);				\
+	__dt_setup_arch(__dtb_##sym##_begin);				\
 })
 
 #else /* CONFIG_OF */
diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index 3c3b0df..5d39bb8 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -47,7 +47,7 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 	return __alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS));
 }
 
-void __init __dt_setup_arch(struct boot_param_header *bph)
+void __init __dt_setup_arch(void *bph)
 {
 	if (!early_init_dt_scan(bph))
 		return;
diff --git a/arch/mips/lantiq/prom.c b/arch/mips/lantiq/prom.c
index cdea687..7447d32 100644
--- a/arch/mips/lantiq/prom.c
+++ b/arch/mips/lantiq/prom.c
@@ -71,7 +71,7 @@ void __init plat_mem_setup(void)
 	 * Load the builtin devicetree. This causes the chosen node to be
 	 * parsed resulting in our memory appearing
 	 */
-	__dt_setup_arch(&__dtb_start);
+	__dt_setup_arch(__dtb_start);
 }
 
 void __init device_tree_init(void)
diff --git a/arch/mips/lantiq/prom.h b/arch/mips/lantiq/prom.h
index 8e07b5f..69a4c58 100644
--- a/arch/mips/lantiq/prom.h
+++ b/arch/mips/lantiq/prom.h
@@ -26,6 +26,6 @@ struct ltq_soc_info {
 extern void ltq_soc_detect(struct ltq_soc_info *i);
 extern void ltq_soc_init(void);
 
-extern struct boot_param_header __dtb_start;
+extern char __dtb_start[];
 
 #endif
diff --git a/arch/mips/mti-sead3/sead3-setup.c b/arch/mips/mti-sead3/sead3-setup.c
index bf7fe48..e43f480 100644
--- a/arch/mips/mti-sead3/sead3-setup.c
+++ b/arch/mips/mti-sead3/sead3-setup.c
@@ -69,17 +69,17 @@ static void __init parse_memsize_param(void)
 	if (!memsize)
 		return;
 
-	offset = fdt_path_offset(&__dtb_start, "/memory");
+	offset = fdt_path_offset(__dtb_start, "/memory");
 	if (offset > 0) {
 		uint64_t new_value;
 		/*
 		 * reg contains 2 32-bits BE values, offset and size. We just
 		 * want to replace the size value without affecting the offset
 		 */
-		prop_value = fdt_getprop(&__dtb_start, offset, "reg", &prop_len);
+		prop_value = fdt_getprop(__dtb_start, offset, "reg", &prop_len);
 		new_value = be64_to_cpu(*prop_value);
 		new_value =  (new_value & ~0xffffffffllu) | memsize;
-		fdt_setprop_inplace_u64(&__dtb_start, offset, "reg", new_value);
+		fdt_setprop_inplace_u64(__dtb_start, offset, "reg", new_value);
 	}
 }
 
@@ -92,7 +92,7 @@ void __init plat_mem_setup(void)
 	 * Load the builtin devicetree. This causes the chosen node to be
 	 * parsed resulting in our memory appearing
 	 */
-	__dt_setup_arch(&__dtb_start);
+	__dt_setup_arch(__dtb_start);
 }
 
 void __init device_tree_init(void)
diff --git a/arch/mips/ralink/of.c b/arch/mips/ralink/of.c
index 0170d82..91d7060 100644
--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -28,7 +28,7 @@
 __iomem void *rt_sysc_membase;
 __iomem void *rt_memc_membase;
 
-extern struct boot_param_header __dtb_start;
+extern char __dtb_start[];
 
 __iomem void *plat_of_remap_node(const char *node)
 {
@@ -63,7 +63,7 @@ void __init plat_mem_setup(void)
 	 * Load the builtin devicetree. This causes the chosen node to be
 	 * parsed resulting in our memory appearing
 	 */
-	__dt_setup_arch(&__dtb_start);
+	__dt_setup_arch(__dtb_start);
 
 	if (soc_info.mem_size)
 		add_memory_region(soc_info.mem_base, soc_info.mem_size * SZ_1M,
-- 
1.8.3.2

