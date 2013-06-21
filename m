Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423393Ab3FUQ0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:26:01 -0400
Received: from relay1.sgi.com ([192.48.179.29]:32901 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423180Ab3FUQZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:25:58 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: holt@sgi.com, travis@sgi.com, nzimmer@sgi.com, rob@landley.net,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 1/2] x86_64, mm: Delay initializing large portion of memory
Date: Fri, 21 Jun 2013 11:25:33 -0500
Message-Id: <1371831934-156971-2-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a 16TB system it can takes upwards of two hours to boot the system with
about 60% of the time being spent initializing memory.  This patch delays
initializing a large portion of memory until after the system is booted.
This can significantly reduce the time it takes the boot the system down
to the 15 to 30 minute range.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 Documentation/kernel-parameters.txt |  15 ++++
 arch/x86/Kconfig                    |  10 +++
 arch/x86/include/asm/e820.h         |  16 +++-
 arch/x86/kernel/e820.c              | 163 ++++++++++++++++++++++++++++++++++--
 4 files changed, 196 insertions(+), 8 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2fe6e76..77b8195 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -706,6 +706,21 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Defaults to the default architecture's huge page size
 			if not specified.
 
+	delay_mem_init=B:M:n:l:h
+			This delays the initialization of a large portion of
+			memory by inserting it into the "absent" memory list.
+			This allows the system to boot up much faster at the
+			expense of the time needed to add this absent memory
+			after the system has booted.  That however can be done
+			in parallel with other operations.
+			Format: B:M:n:l:h
+			    (1 << B) is the block size (bsize)
+			    	     ['0' indicates use the default 128M]
+			    (1 << M) is the address space per node
+			    (n * bsize) is minimum sized node memory to slice
+			    (l * bisze) is low memory to leave on node
+			    (h * bisze) is high memory to leave on node
+
 	dhash_entries=	[KNL]
 			Set number of hash buckets for dentry cache.
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 685692c..28b6b2c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1566,6 +1566,16 @@ config EFI_STUB
 
 	  See Documentation/x86/efi-stub.txt for more information.
 
+config DELAY_MEM_INIT
+	bool "Delay memory initialization"
+	depends on EFI && MEMORY_HOTPLUG_SPARSE
+	---help---
+	  This  option delays initializing a large portion of memory
+	  until after the system is booted.  This can significantly
+	  reduce the time it takes the boot the system when there
+	  is a significant amount of memory present.  Systems with
+	  8TB or more of memory benefit the most.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index cccd07f..05278d8 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -18,8 +18,6 @@ extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern int e820_all_mapped(u64 start, u64 end, unsigned type);
 extern void e820_add_region(u64 start, u64 size, int type);
 extern void e820_print_map(char *who);
-extern int
-sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, u32 *pnr_map);
 extern u64 e820_update_range(u64 start, u64 size, unsigned old_type,
 			       unsigned new_type);
 extern u64 e820_remove_range(u64 start, u64 size, unsigned old_type,
@@ -31,6 +29,20 @@ extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
 struct setup_data;
 extern void parse_e820_ext(struct setup_data *data);
 
+extern int
+__sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, u32 *pnr_map);
+
+#ifdef CONFIG_DELAY_MEM_INIT
+extern int
+sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, u32 *pnr_map);
+#else
+static inline int sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
+				    u32 *pnr_map)
+{
+	return __sanitize_e820_map(biosmap, max_nr_map, pnr_map);
+}
+#endif /* CONFIG_DELAY_MEM_INIT */
+
 #if defined(CONFIG_X86_64) || \
 	(defined(CONFIG_X86_32) && defined(CONFIG_HIBERNATION))
 extern void e820_mark_nosave_regions(unsigned long limit_pfn);
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index d32abea..3752dc5 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -21,6 +21,10 @@
 #include <linux/memblock.h>
 #include <linux/sort.h>
 
+#ifdef CONFIG_DELAY_MEM_INIT
+#include <linux/memory.h>
+#endif
+
 #include <asm/e820.h>
 #include <asm/proto.h>
 #include <asm/setup.h>
@@ -41,6 +45,9 @@
  */
 struct e820map e820;
 struct e820map e820_saved;
+#ifdef CONFIG_DELAY_MEM_INIT
+struct e820map e820_absent;
+#endif
 
 /* For PCI or other memory-mapped resources */
 unsigned long pci_mem_start = 0xaeedbabe;
@@ -155,20 +162,25 @@ static void __init e820_print_type(u32 type)
 	}
 }
 
-void __init e820_print_map(char *who)
+static void __init __e820_print_map(char *who, struct e820map *e820x)
 {
 	int i;
 
-	for (i = 0; i < e820.nr_map; i++) {
+	for (i = 0; i < e820x->nr_map; i++) {
 		printk(KERN_INFO "%s: [mem %#018Lx-%#018Lx] ", who,
-		       (unsigned long long) e820.map[i].addr,
+		       (unsigned long long) e820x->map[i].addr,
 		       (unsigned long long)
-		       (e820.map[i].addr + e820.map[i].size - 1));
-		e820_print_type(e820.map[i].type);
+		       (e820x->map[i].addr + e820x->map[i].size - 1));
+		e820_print_type(e820x->map[i].type);
 		printk(KERN_CONT "\n");
 	}
 }
 
+void __init e820_print_map(char *who)
+{
+	__e820_print_map(who, &e820);
+}
+
 /*
  * Sanitize the BIOS e820 map.
  *
@@ -252,7 +264,7 @@ static int __init cpcompare(const void *a, const void *b)
 	return (ap->addr != ap->pbios->addr) - (bp->addr != bp->pbios->addr);
 }
 
-int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
+int __init __sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 			     u32 *pnr_map)
 {
 	static struct change_member change_point_list[2*E820_X_MAX] __initdata;
@@ -378,6 +390,145 @@ int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 	return 0;
 }
 
+#ifdef CONFIG_DELAY_MEM_INIT
+static u64 block_size;		/* block size */
+static u64 mem_per_node;	/* mem_per_node address increment */
+static u64 min_region_size;	/* min size of region to slice from */
+static u64 pre_region_size;	/* multiply bsize for node low memory */
+static u64 post_region_size;	/* multiply bsize for node high memory */
+
+static int __init setup_delay_mem_init(char *str)
+{
+	int bbits, mpnbits, minmult, premult, postmult;
+
+	if (sscanf(str, "%d:%d:%d:%d:%d", &bbits, &mpnbits,
+		&minmult, &premult, &postmult) != 5)
+		goto error;
+
+	if (!bbits)	/* default block size */
+		bbits = MIN_MEMORY_BLOCK_SIZE;
+
+	if (!mpnbits || !minmult || !premult || !postmult)
+		goto error;
+
+	/* (The '+1' because memory can end on a non-block size boundary) */
+	if (bbits > mpnbits || (premult + postmult + 1) > minmult
+	    || bbits > MAX_PHYSMEM_BITS || mpnbits > MAX_PHYSMEM_BITS)
+		goto error;
+
+	block_size = 1ull << bbits;
+	mem_per_node = 1ull << mpnbits;
+	min_region_size = block_size * minmult;
+	pre_region_size = block_size * premult;
+	post_region_size = block_size * postmult;
+	pr_info("e820: delay_mem_init=%s (bsize:%llx mem_incr:%llx)\n",
+		str, block_size, mem_per_node);
+	return 0;
+
+error:
+	mem_per_node = 0;
+	pr_err("e820: Invalid parameter: delay_mem_init=%s\n", str);
+	return -EINVAL;
+}
+early_param("delay_mem_init", setup_delay_mem_init);
+
+/* Check if region already present */
+static int __init e820_region_found(struct e820map *e820x,
+					u64 start, u64 size, int type)
+{
+	u64 end = start + size;
+	int i;
+
+	for (i = 0; i < e820x->nr_map; i++) {
+		struct e820entry *ei = &e820x->map[i];
+		u64 ei_end;
+
+		if (type != ei->type)
+			continue;
+
+		ei_end = ei->addr + ei->size;
+		if (ei->addr <= start && end <= ei_end)
+			return 1;
+	}
+	return 0;
+}
+
+/* Move region of memory from e820 to e820_absent */
+static void __init add_e820_absent(u64 start, u64 size, int type)
+{
+	u64 bsize = block_size;
+	u64 size0, addr1, size1, addr2, size2;
+
+	/* start/size0 ... addr1/size1 [removed region] ... addr2/size2 */
+	addr1 = start + pre_region_size;
+	size0 = addr1 - start;
+
+	addr2 = ((start + size) & ~(bsize - 1)) - post_region_size;
+	size2 = (size + start) - addr2;
+	size1 = size - size0 - size2;
+
+	if (size1 && !(size1 & (bsize - 1))) {
+		if (e820_region_found(&e820, addr1, size1, type))
+			e820_remove_range(addr1, size1, type, 1);
+
+		if (!e820_region_found(&e820_absent, addr1, size1, type))
+			__e820_add_region(&e820_absent, addr1, size1, type);
+	}
+}
+
+/* Move memory from Node 1 thru last Node - 1 to the "absent" list */
+static void __init setup_e820_absent(void)
+{
+	u64 last_base = 0;
+	u64 last_size = 0;
+	u64 last_start = 0;
+	int i;
+
+	if (!mem_per_node)
+		return;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		u64 start = e820.map[i].addr;
+		u64 size = e820.map[i].size;
+		int type = e820.map[i].type;
+
+		if (type != E820_RAM)
+			continue;
+
+		if (start > last_start && (start & (mem_per_node - 1)) == 0) {
+			if (last_base) {
+				add_e820_absent(last_base, last_size, type);
+				last_base = 0;
+			}
+			if (size >= min_region_size) {
+				last_base = start;
+				last_size = size;
+			}
+			last_start = start;
+		}
+	}
+	if (last_start)
+		__e820_print_map("e820_absent", &e820_absent);
+	else
+		pr_info("e820: No memory found to move to absent list\n");
+}
+
+/* Check for possible "absent" (delayed) memory after each addition */
+int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
+			     u32 *pnr_map)
+{
+	int ret;
+
+	ret = __sanitize_e820_map(biosmap, max_nr_map, pnr_map);
+
+	if (ret == 0 && biosmap == e820.map) {
+		setup_e820_absent();
+		ret = __sanitize_e820_map(biosmap, max_nr_map, pnr_map);
+	}
+	return ret;
+}
+#endif /* CONFIG_DELAY_MEM_INIT */
+
 static int __init __append_e820_map(struct e820entry *biosmap, int nr_map)
 {
 	while (nr_map) {
-- 
1.8.2.1

