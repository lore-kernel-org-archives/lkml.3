Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab3JGQgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:36:51 -0400
Received: from mail-ye0-f171.google.com ([209.85.213.171]:39881 "EHLO
	mail-ye0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab3JGQgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:36:44 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 28/29] metag: use common of_flat_dt_match_machine
Date: Mon,  7 Oct 2013 11:29:36 -0500
Message-Id: <1381163377-21044-29-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert metag to use the common of_flat_dt_get_machine_name function.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
[james.hogan: fix missing arch_get_next_mach and const mismatch]
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/mach/arch.h |  2 +-
 arch/metag/include/asm/prom.h      |  2 +-
 arch/metag/kernel/devtree.c        | 60 ++++++++++++--------------------------
 arch/metag/kernel/setup.c          |  2 +-
 4 files changed, 22 insertions(+), 44 deletions(-)

diff --git a/arch/metag/include/asm/mach/arch.h b/arch/metag/include/asm/mach/arch.h
index 12c5664..433f946 100644
--- a/arch/metag/include/asm/mach/arch.h
+++ b/arch/metag/include/asm/mach/arch.h
@@ -53,7 +53,7 @@ struct machine_desc {
 /*
  * Current machine - only accessible during boot.
  */
-extern struct machine_desc *machine_desc;
+extern const struct machine_desc *machine_desc;
 
 /*
  * Machine type table - also only accessible during boot
diff --git a/arch/metag/include/asm/prom.h b/arch/metag/include/asm/prom.h
index d2aa35d..9f67cbf 100644
--- a/arch/metag/include/asm/prom.h
+++ b/arch/metag/include/asm/prom.h
@@ -17,7 +17,7 @@
 #include <asm/setup.h>
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
-extern struct machine_desc *setup_machine_fdt(void *dt);
+extern const struct machine_desc *setup_machine_fdt(void *dt);
 extern void copy_fdt(void);
 
 #endif /* __ASM_METAG_PROM_H */
diff --git a/arch/metag/kernel/devtree.c b/arch/metag/kernel/devtree.c
index 68c2fee..18dd7ae 100644
--- a/arch/metag/kernel/devtree.c
+++ b/arch/metag/kernel/devtree.c
@@ -34,6 +34,19 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 	return alloc_bootmem_align(size, align);
 }
 
+static const void * __init arch_get_next_mach(const char *const **match)
+{
+	static const struct machine_desc *mdesc = __arch_info_begin;
+	const struct machine_desc *m = mdesc;
+
+	if (m >= __arch_info_end)
+		return NULL;
+
+	mdesc++;
+	*match = m->dt_compat;
+	return m;
+}
+
 /**
  * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
  * @dt:		virtual address pointer to dt blob
@@ -41,53 +54,18 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
  * If a dtb was passed to the kernel, then use it to choose the correct
  * machine_desc and to setup the system.
  */
-struct machine_desc * __init setup_machine_fdt(void *dt)
+const struct machine_desc * __init setup_machine_fdt(void *dt)
 {
-	struct machine_desc *mdesc, *mdesc_best = NULL;
-	unsigned int score, mdesc_score = ~1;
-	unsigned long dt_root;
-	const char *model;
+	const struct machine_desc *mdesc;
 
 	/* check device tree validity */
 	if (!early_init_dt_scan(dt))
 		return NULL;
 
-	/* Search the mdescs for the 'best' compatible value match */
-	dt_root = of_get_flat_dt_root();
-
-	for_each_machine_desc(mdesc) {
-		score = of_flat_dt_match(dt_root, mdesc->dt_compat);
-		if (score > 0 && score < mdesc_score) {
-			mdesc_best = mdesc;
-			mdesc_score = score;
-		}
-	}
-	if (!mdesc_best) {
-		const char *prop;
-		long size;
-
-		pr_err("\nError: unrecognized/unsupported device tree compatible list:\n[ ");
-
-		prop = of_get_flat_dt_prop(dt_root, "compatible", &size);
-		if (prop) {
-			while (size > 0) {
-				printk("'%s' ", prop);
-				size -= strlen(prop) + 1;
-				prop += strlen(prop) + 1;
-			}
-		}
-		printk("]\n\n");
-
+	mdesc = of_flat_dt_match_machine(NULL, arch_get_next_mach);
+	if (!mdesc)
 		dump_machine_table(); /* does not return */
-	}
-
-	model = of_get_flat_dt_prop(dt_root, "model", NULL);
-	if (!model)
-		model = of_get_flat_dt_prop(dt_root, "compatible", NULL);
-	if (!model)
-		model = "<unknown>";
-	pr_info("Machine: %s, model: %s\n", mdesc_best->name, model);
-
-	return mdesc_best;
+	pr_info("Machine name: %s\n", mdesc->name);
 
+	return mdesc;
 }
diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index 2c697d3..92cc119 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -115,7 +115,7 @@ extern u32 __dtb_start[];
 extern struct console dash_console;
 #endif
 
-struct machine_desc *machine_desc __initdata;
+const struct machine_desc *machine_desc __initdata;
 
 /*
  * Map a Linux CPU number to a hardware thread ID
-- 
1.8.1.2

