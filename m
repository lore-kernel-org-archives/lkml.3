Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbaDWBXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:23:33 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:32838 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbaDWBTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:19:04 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>
Subject: [PATCH v2 11/21] of/fdt: update of_get_flat_dt_prop in prep for libfdt
Date: Tue, 22 Apr 2014 20:18:11 -0500
Message-Id: <1398215901-25609-12-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Make of_get_flat_dt_prop arguments compatible with libfdt fdt_getprop
call in preparation to convert FDT code to use libfdt. Make the return
value const and the property length ptr type an int.

Signed-off-by: Rob Herring <robh@kernel.org>
---
v2: fix warning on microblaze

 arch/arc/kernel/devtree.c              |  2 +-
 arch/arm/kernel/devtree.c              |  2 +-
 arch/arm/mach-exynos/exynos.c          |  2 +-
 arch/arm/mach-vexpress/platsmp.c       |  2 +-
 arch/arm/plat-samsung/s5p-dev-mfc.c    |  4 ++--
 arch/microblaze/kernel/prom.c          |  8 +++----
 arch/powerpc/kernel/epapr_paravirt.c   |  2 +-
 arch/powerpc/kernel/fadump.c           |  4 ++--
 arch/powerpc/kernel/prom.c             | 24 +++++++++++----------
 arch/powerpc/kernel/rtas.c             |  2 +-
 arch/powerpc/mm/hash_utils_64.c        | 22 +++++++++----------
 arch/powerpc/platforms/52xx/efika.c    |  4 ++--
 arch/powerpc/platforms/chrp/setup.c    |  4 ++--
 arch/powerpc/platforms/powernv/opal.c  | 12 +++++------
 arch/powerpc/platforms/pseries/setup.c |  4 ++--
 arch/xtensa/kernel/setup.c             |  2 +-
 drivers/of/fdt.c                       | 39 +++++++++++++++++-----------------
 drivers/of/of_reserved_mem.c           |  4 ++--
 include/linux/of_fdt.h                 |  8 +++----
 19 files changed, 77 insertions(+), 74 deletions(-)

diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
index b6dc4e2..0b3ef40 100644
--- a/arch/arc/kernel/devtree.c
+++ b/arch/arc/kernel/devtree.c
@@ -42,7 +42,7 @@ const struct machine_desc * __init setup_machine_fdt(void *dt)
 	const struct machine_desc *mdesc;
 	unsigned long dt_root;
 	void *clk;
-	unsigned long len;
+	int len;
 
 	if (!early_init_dt_scan(dt))
 		return NULL;
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index dff9cc0..38f4711 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -247,7 +247,7 @@ const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 
 	if (!mdesc) {
 		const char *prop;
-		long size;
+		int size;
 		unsigned long dt_root;
 
 		early_print("\nError: unrecognized/unsupported "
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index b32a907..77293d3 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -250,7 +250,7 @@ static int __init exynos_fdt_map_chipid(unsigned long node, const char *uname,
 {
 	struct map_desc iodesc;
 	__be32 *reg;
-	unsigned long len;
+	int len;
 
 	if (!of_flat_dt_is_compatible(node, "samsung,exynos4210-chipid") &&
 		!of_flat_dt_is_compatible(node, "samsung,exynos5440-clock"))
diff --git a/arch/arm/mach-vexpress/platsmp.c b/arch/arm/mach-vexpress/platsmp.c
index 993c9ae..b4a5f0d 100644
--- a/arch/arm/mach-vexpress/platsmp.c
+++ b/arch/arm/mach-vexpress/platsmp.c
@@ -53,7 +53,7 @@ static int __init vexpress_dt_find_scu(unsigned long node,
 {
 	if (of_flat_dt_match(node, vexpress_dt_cortex_a9_match)) {
 		phys_addr_t phys_addr;
-		__be32 *reg = of_get_flat_dt_prop(node, "reg", NULL);
+		const __be32 *reg = of_get_flat_dt_prop(node, "reg", NULL);
 
 		if (WARN_ON(!reg))
 			return -EINVAL;
diff --git a/arch/arm/plat-samsung/s5p-dev-mfc.c b/arch/arm/plat-samsung/s5p-dev-mfc.c
index 98087b6..469b862 100644
--- a/arch/arm/plat-samsung/s5p-dev-mfc.c
+++ b/arch/arm/plat-samsung/s5p-dev-mfc.c
@@ -125,8 +125,8 @@ device_initcall(s5p_mfc_memory_init);
 int __init s5p_fdt_alloc_mfc_mem(unsigned long node, const char *uname,
 				int depth, void *data)
 {
-	__be32 *prop;
-	unsigned long len;
+	const __be32 *prop;
+	int len;
 	struct s5p_mfc_dt_meminfo mfc_mem;
 
 	if (!data)
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index abdfb10..c766306 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -43,13 +43,13 @@
 #include <asm/pci-bridge.h>
 
 #ifdef CONFIG_EARLY_PRINTK
-static char *stdout;
+static const char *stdout;
 
 static int __init early_init_dt_scan_chosen_serial(unsigned long node,
 				const char *uname, int depth, void *data)
 {
-	unsigned long l;
-	char *p;
+	int l;
+	const char *p;
 
 	pr_debug("%s: depth: %d, uname: %s\n", __func__, depth, uname);
 
@@ -80,7 +80,7 @@ static int __init early_init_dt_scan_chosen_serial(unsigned long node,
 				(strncmp(p, "xlnx,opb-uartlite", 17) == 0) ||
 				(strncmp(p, "xlnx,axi-uartlite", 17) == 0) ||
 				(strncmp(p, "xlnx,mdm", 8) == 0)) {
-			unsigned int *addrp;
+			const unsigned int *addrp;
 
 			*(u32 *)data = UARTLITE;
 
diff --git a/arch/powerpc/kernel/epapr_paravirt.c b/arch/powerpc/kernel/epapr_paravirt.c
index 7898be9..d64e92b 100644
--- a/arch/powerpc/kernel/epapr_paravirt.c
+++ b/arch/powerpc/kernel/epapr_paravirt.c
@@ -36,7 +36,7 @@ static int __init early_init_dt_scan_epapr(unsigned long node,
 					   int depth, void *data)
 {
 	const u32 *insts;
-	unsigned long len;
+	int len;
 	int i;
 
 	insts = of_get_flat_dt_prop(node, "hcall-instructions", &len);
diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 2230fd0..7213d93 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -55,9 +55,9 @@ int crash_mem_ranges;
 int __init early_init_dt_scan_fw_dump(unsigned long node,
 			const char *uname, int depth, void *data)
 {
-	__be32 *sections;
+	const __be32 *sections;
 	int i, num_sections;
-	unsigned long size;
+	int size;
 	const int *token;
 
 	if (depth != 1 || strcmp(uname, "rtas") != 0)
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 668aa47..f971134 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -163,7 +163,7 @@ static struct ibm_pa_feature {
 	{CPU_FTR_REAL_LE, PPC_FEATURE_TRUE_LE, 5, 0, 0},
 };
 
-static void __init scan_features(unsigned long node, unsigned char *ftrs,
+static void __init scan_features(unsigned long node, const unsigned char *ftrs,
 				 unsigned long tablelen,
 				 struct ibm_pa_feature *fp,
 				 unsigned long ft_size)
@@ -202,8 +202,8 @@ static void __init scan_features(unsigned long node, unsigned char *ftrs,
 
 static void __init check_cpu_pa_features(unsigned long node)
 {
-	unsigned char *pa_ftrs;
-	unsigned long tablelen;
+	const unsigned char *pa_ftrs;
+	int tablelen;
 
 	pa_ftrs = of_get_flat_dt_prop(node, "ibm,pa-features", &tablelen);
 	if (pa_ftrs == NULL)
@@ -216,7 +216,7 @@ static void __init check_cpu_pa_features(unsigned long node)
 #ifdef CONFIG_PPC_STD_MMU_64
 static void __init check_cpu_slb_size(unsigned long node)
 {
-	__be32 *slb_size_ptr;
+	const __be32 *slb_size_ptr;
 
 	slb_size_ptr = of_get_flat_dt_prop(node, "slb-size", NULL);
 	if (slb_size_ptr != NULL) {
@@ -257,7 +257,7 @@ static struct feature_property {
 static inline void identical_pvr_fixup(unsigned long node)
 {
 	unsigned int pvr;
-	char *model = of_get_flat_dt_prop(node, "model", NULL);
+	const char *model = of_get_flat_dt_prop(node, "model", NULL);
 
 	/*
 	 * Since 440GR(x)/440EP(x) processors have the same pvr,
@@ -295,11 +295,11 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 					  const char *uname, int depth,
 					  void *data)
 {
-	char *type = of_get_flat_dt_prop(node, "device_type", NULL);
+	const char *type = of_get_flat_dt_prop(node, "device_type", NULL);
 	const __be32 *prop;
 	const __be32 *intserv;
 	int i, nthreads;
-	unsigned long len;
+	int len;
 	int found = -1;
 	int found_thread = 0;
 
@@ -392,7 +392,7 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 int __init early_init_dt_scan_chosen_ppc(unsigned long node, const char *uname,
 					 int depth, void *data)
 {
-	unsigned long *lprop; /* All these set by kernel, so no need to convert endian */
+	const unsigned long *lprop; /* All these set by kernel, so no need to convert endian */
 
 	/* Use common scan routine to determine if this is the chosen node */
 	if (early_init_dt_scan_chosen(node, uname, depth, data) == 0)
@@ -443,8 +443,9 @@ int __init early_init_dt_scan_chosen_ppc(unsigned long node, const char *uname,
  */
 static int __init early_init_dt_scan_drconf_memory(unsigned long node)
 {
-	__be32 *dm, *ls, *usm;
-	unsigned long l, n, flags;
+	const __be32 *dm, *ls, *usm;
+	int l;
+	unsigned long n, flags;
 	u64 base, size, memblock_size;
 	unsigned int is_kexec_kdump = 0, rngs;
 
@@ -564,7 +565,8 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 
 static void __init early_reserve_mem_dt(void)
 {
-	unsigned long i, len, dt_root;
+	unsigned long i, dt_root;
+	int len;
 	const __be32 *prop;
 
 	dt_root = of_get_flat_dt_root();
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 8cd5ed0..8b4c857 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -1142,7 +1142,7 @@ void __init rtas_initialize(void)
 int __init early_init_dt_scan_rtas(unsigned long node,
 		const char *uname, int depth, void *data)
 {
-	u32 *basep, *entryp, *sizep;
+	const u32 *basep, *entryp, *sizep;
 
 	if (depth != 1 || strcmp(uname, "rtas") != 0)
 		return 0;
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index d766d6e..59cc19a 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -265,9 +265,9 @@ static int __init htab_dt_scan_seg_sizes(unsigned long node,
 					 const char *uname, int depth,
 					 void *data)
 {
-	char *type = of_get_flat_dt_prop(node, "device_type", NULL);
-	__be32 *prop;
-	unsigned long size = 0;
+	const char *type = of_get_flat_dt_prop(node, "device_type", NULL);
+	const __be32 *prop;
+	int size = 0;
 
 	/* We are scanning "cpu" nodes only */
 	if (type == NULL || strcmp(type, "cpu") != 0)
@@ -320,9 +320,9 @@ static int __init htab_dt_scan_page_sizes(unsigned long node,
 					  const char *uname, int depth,
 					  void *data)
 {
-	char *type = of_get_flat_dt_prop(node, "device_type", NULL);
-	__be32 *prop;
-	unsigned long size = 0;
+	const char *type = of_get_flat_dt_prop(node, "device_type", NULL);
+	const __be32 *prop;
+	int size = 0;
 
 	/* We are scanning "cpu" nodes only */
 	if (type == NULL || strcmp(type, "cpu") != 0)
@@ -402,9 +402,9 @@ static int __init htab_dt_scan_page_sizes(unsigned long node,
 static int __init htab_dt_scan_hugepage_blocks(unsigned long node,
 					const char *uname, int depth,
 					void *data) {
-	char *type = of_get_flat_dt_prop(node, "device_type", NULL);
-	__be64 *addr_prop;
-	__be32 *page_count_prop;
+	const char *type = of_get_flat_dt_prop(node, "device_type", NULL);
+	const __be64 *addr_prop;
+	const __be32 *page_count_prop;
 	unsigned int expected_pages;
 	long unsigned int phys_addr;
 	long unsigned int block_size;
@@ -546,8 +546,8 @@ static int __init htab_dt_scan_pftsize(unsigned long node,
 				       const char *uname, int depth,
 				       void *data)
 {
-	char *type = of_get_flat_dt_prop(node, "device_type", NULL);
-	__be32 *prop;
+	const char *type = of_get_flat_dt_prop(node, "device_type", NULL);
+	const __be32 *prop;
 
 	/* We are scanning "cpu" nodes only */
 	if (type == NULL || strcmp(type, "cpu") != 0)
diff --git a/arch/powerpc/platforms/52xx/efika.c b/arch/powerpc/platforms/52xx/efika.c
index 18c1048..6e19b0a 100644
--- a/arch/powerpc/platforms/52xx/efika.c
+++ b/arch/powerpc/platforms/52xx/efika.c
@@ -199,8 +199,8 @@ static void __init efika_setup_arch(void)
 
 static int __init efika_probe(void)
 {
-	char *model = of_get_flat_dt_prop(of_get_flat_dt_root(),
-					  "model", NULL);
+	const char *model = of_get_flat_dt_prop(of_get_flat_dt_root(),
+						"model", NULL);
 
 	if (model == NULL)
 		return 0;
diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index c665d7d..7044fd3 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -574,8 +574,8 @@ chrp_init2(void)
 
 static int __init chrp_probe(void)
 {
- 	char *dtype = of_get_flat_dt_prop(of_get_flat_dt_root(),
- 					  "device_type", NULL);
+	const char *dtype = of_get_flat_dt_prop(of_get_flat_dt_root(),
+						"device_type", NULL);
  	if (dtype == NULL)
  		return 0;
  	if (strcmp(dtype, "chrp"))
diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index 49d2f00..c132984 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -61,7 +61,7 @@ int __init early_init_dt_scan_opal(unsigned long node,
 				   const char *uname, int depth, void *data)
 {
 	const void *basep, *entryp, *sizep;
-	unsigned long basesz, entrysz, runtimesz;
+	int basesz, entrysz, runtimesz;
 
 	if (depth != 1 || strcmp(uname, "ibm,opal") != 0)
 		return 0;
@@ -77,11 +77,11 @@ int __init early_init_dt_scan_opal(unsigned long node,
 	opal.entry = of_read_number(entryp, entrysz/4);
 	opal.size = of_read_number(sizep, runtimesz/4);
 
-	pr_debug("OPAL Base  = 0x%llx (basep=%p basesz=%ld)\n",
+	pr_debug("OPAL Base  = 0x%llx (basep=%p basesz=%d)\n",
 		 opal.base, basep, basesz);
-	pr_debug("OPAL Entry = 0x%llx (entryp=%p basesz=%ld)\n",
+	pr_debug("OPAL Entry = 0x%llx (entryp=%p basesz=%d)\n",
 		 opal.entry, entryp, entrysz);
-	pr_debug("OPAL Entry = 0x%llx (sizep=%p runtimesz=%ld)\n",
+	pr_debug("OPAL Entry = 0x%llx (sizep=%p runtimesz=%d)\n",
 		 opal.size, sizep, runtimesz);
 
 	powerpc_firmware_features |= FW_FEATURE_OPAL;
@@ -102,7 +102,7 @@ int __init early_init_dt_scan_opal(unsigned long node,
 int __init early_init_dt_scan_recoverable_ranges(unsigned long node,
 				   const char *uname, int depth, void *data)
 {
-	unsigned long i, psize, size;
+	int i, psize, size;
 	const __be32 *prop;
 
 	if (depth != 1 || strcmp(uname, "ibm,opal") != 0)
@@ -359,7 +359,7 @@ int opal_get_chars(uint32_t vtermno, char *buf, int count)
 	if ((be64_to_cpu(evt) & OPAL_EVENT_CONSOLE_INPUT) == 0)
 		return 0;
 	len = cpu_to_be64(count);
-	rc = opal_console_read(vtermno, &len, buf);	
+	rc = opal_console_read(vtermno, &len, buf);
 	if (rc == OPAL_SUCCESS)
 		return be64_to_cpu(len);
 	return 0;
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 2db8cc6..099d2df 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -665,7 +665,7 @@ static int __init pseries_probe_fw_features(unsigned long node,
 					    void *data)
 {
 	const char *prop;
-	unsigned long len;
+	int len;
 	static int hypertas_found;
 	static int vec5_found;
 
@@ -698,7 +698,7 @@ static int __init pseries_probe_fw_features(unsigned long node,
 static int __init pSeries_probe(void)
 {
 	unsigned long root = of_get_flat_dt_root();
- 	char *dtype = of_get_flat_dt_prop(root, "device_type", NULL);
+	const char *dtype = of_get_flat_dt_prop(root, "device_type", NULL);
 
  	if (dtype == NULL)
  		return 0;
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 89986e5..1991a3d 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -220,7 +220,7 @@ static int __init xtensa_dt_io_area(unsigned long node, const char *uname,
 		int depth, void *data)
 {
 	const __be32 *ranges;
-	unsigned long len;
+	int len;
 
 	if (depth > 1)
 		return 0;
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 9c85352..1d1582b 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -35,7 +35,7 @@ char *of_fdt_get_string(struct boot_param_header *blob, u32 offset)
  */
 void *of_fdt_get_property(struct boot_param_header *blob,
 		       unsigned long node, const char *name,
-		       unsigned long *size)
+		       int *size)
 {
 	unsigned long p = node;
 
@@ -85,7 +85,8 @@ int of_fdt_is_compatible(struct boot_param_header *blob,
 		      unsigned long node, const char *compat)
 {
 	const char *cp;
-	unsigned long cplen, l, score = 0;
+	int cplen;
+	unsigned long l, score = 0;
 
 	cp = of_fdt_get_property(blob, node, "compatible", &cplen);
 	if (cp == NULL)
@@ -444,8 +445,8 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 {
 	int t_len = (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32);
 	phys_addr_t base, size;
-	unsigned long len;
-	__be32 *prop;
+	int len;
+	const __be32 *prop;
 	int nomap, first = 1;
 
 	prop = of_get_flat_dt_prop(node, "reg", &len);
@@ -488,7 +489,7 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
  */
 static int __init __reserved_mem_check_root(unsigned long node)
 {
-	__be32 *prop;
+	const __be32 *prop;
 
 	prop = of_get_flat_dt_prop(node, "#size-cells", NULL);
 	if (!prop || be32_to_cpup(prop) != dt_root_size_cells)
@@ -638,8 +639,8 @@ unsigned long __init of_get_flat_dt_root(void)
  * This function can be used within scan_flattened_dt callback to get
  * access to properties
  */
-void *__init of_get_flat_dt_prop(unsigned long node, const char *name,
-				 unsigned long *size)
+const void *__init of_get_flat_dt_prop(unsigned long node, const char *name,
+				       int *size)
 {
 	return of_fdt_get_property(initial_boot_params, node, name, size);
 }
@@ -710,7 +711,7 @@ const void * __init of_flat_dt_match_machine(const void *default_match,
 	}
 	if (!best_data) {
 		const char *prop;
-		long size;
+		int size;
 
 		pr_err("\n unrecognized device tree list:\n[ ");
 
@@ -739,8 +740,8 @@ const void * __init of_flat_dt_match_machine(const void *default_match,
 static void __init early_init_dt_check_for_initrd(unsigned long node)
 {
 	u64 start, end;
-	unsigned long len;
-	__be32 *prop;
+	int len;
+	const __be32 *prop;
 
 	pr_debug("Looking for initrd properties... ");
 
@@ -773,7 +774,7 @@ static inline void early_init_dt_check_for_initrd(unsigned long node)
 int __init early_init_dt_scan_root(unsigned long node, const char *uname,
 				   int depth, void *data)
 {
-	__be32 *prop;
+	const __be32 *prop;
 
 	if (depth != 0)
 		return 0;
@@ -795,9 +796,9 @@ int __init early_init_dt_scan_root(unsigned long node, const char *uname,
 	return 1;
 }
 
-u64 __init dt_mem_next_cell(int s, __be32 **cellp)
+u64 __init dt_mem_next_cell(int s, const __be32 **cellp)
 {
-	__be32 *p = *cellp;
+	const __be32 *p = *cellp;
 
 	*cellp = p + s;
 	return of_read_number(p, s);
@@ -809,9 +810,9 @@ u64 __init dt_mem_next_cell(int s, __be32 **cellp)
 int __init early_init_dt_scan_memory(unsigned long node, const char *uname,
 				     int depth, void *data)
 {
-	char *type = of_get_flat_dt_prop(node, "device_type", NULL);
-	__be32 *reg, *endp;
-	unsigned long l;
+	const char *type = of_get_flat_dt_prop(node, "device_type", NULL);
+	const __be32 *reg, *endp;
+	int l;
 
 	/* We are scanning "memory" nodes only */
 	if (type == NULL) {
@@ -832,7 +833,7 @@ int __init early_init_dt_scan_memory(unsigned long node, const char *uname,
 
 	endp = reg + (l / sizeof(__be32));
 
-	pr_debug("memory scan node %s, reg size %ld, data: %x %x %x %x,\n",
+	pr_debug("memory scan node %s, reg size %d, data: %x %x %x %x,\n",
 	    uname, l, reg[0], reg[1], reg[2], reg[3]);
 
 	while ((endp - reg) >= (dt_root_addr_cells + dt_root_size_cells)) {
@@ -855,8 +856,8 @@ int __init early_init_dt_scan_memory(unsigned long node, const char *uname,
 int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 				     int depth, void *data)
 {
-	unsigned long l;
-	char *p;
+	int l;
+	const char *p;
 
 	pr_debug("search \"chosen\", depth: %d, uname: %s\n", depth, uname);
 
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index daaaf93..e420eb5 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -95,8 +95,8 @@ static int __init __reserved_mem_alloc_size(unsigned long node,
 	int t_len = (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32);
 	phys_addr_t start = 0, end = 0;
 	phys_addr_t base = 0, align = 0, size;
-	unsigned long len;
-	__be32 *prop;
+	int len;
+	const __be32 *prop;
 	int nomap;
 	int ret;
 
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index 991ec74..b36a50d 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -66,7 +66,7 @@ extern char *of_fdt_get_string(struct boot_param_header *blob, u32 offset);
 extern void *of_fdt_get_property(struct boot_param_header *blob,
 				 unsigned long node,
 				 const char *name,
-				 unsigned long *size);
+				 int *size);
 extern int of_fdt_is_compatible(struct boot_param_header *blob,
 				unsigned long node,
 				const char *compat);
@@ -88,8 +88,8 @@ extern char *find_flat_dt_string(u32 offset);
 extern int of_scan_flat_dt(int (*it)(unsigned long node, const char *uname,
 				     int depth, void *data),
 			   void *data);
-extern void *of_get_flat_dt_prop(unsigned long node, const char *name,
-				 unsigned long *size);
+extern const void *of_get_flat_dt_prop(unsigned long node, const char *name,
+				       int *size);
 extern int of_flat_dt_is_compatible(unsigned long node, const char *name);
 extern int of_flat_dt_match(unsigned long node, const char *const *matches);
 extern unsigned long of_get_flat_dt_root(void);
@@ -103,7 +103,7 @@ extern void early_init_dt_add_memory_arch(u64 base, u64 size);
 extern int early_init_dt_reserve_memory_arch(phys_addr_t base, phys_addr_t size,
 					     bool no_map);
 extern void * early_init_dt_alloc_memory_arch(u64 size, u64 align);
-extern u64 dt_mem_next_cell(int s, __be32 **cellp);
+extern u64 dt_mem_next_cell(int s, const __be32 **cellp);
 
 /* Early flat tree scan hooks */
 extern int early_init_dt_scan_root(unsigned long node, const char *uname,
-- 
1.9.1

