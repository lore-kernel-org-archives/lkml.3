Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206Ab3ICSbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:31:04 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:51809 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab3ICSbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:31:00 -0400
Date: Tue, 3 Sep 2013 20:30:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm changes for v3.12
Message-ID: <20130903183056.GA31203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mm-for-linus

   HEAD: 30e46b574a1db7d14404e52dca8e1aa5f5155fd2 x86: avoid remapping data in parse_setup_data()

Misc smaller fixes:

 - a parse_setup_data() boot crash fix

 - a memblock and an __early_ioremap cleanup

 - turn the always-on CONFIG_ARCH_MEMORY_PROBE=y into a configurable 
   option and turn it off - it's an unrobust debug facility, it shouldn't 
   be enabled by default.

 Thanks,

	Ingo

------------------>
Jianguo Wu (1):
      mm: Remove unused variable idx0 in __early_ioremap()

Linn Crosetto (1):
      x86: avoid remapping data in parse_setup_data()

Tang Chen (1):
      x86: Use memblock_set_current_limit() to set limit for memblock.

Toshi Kani (1):
      mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default


 Documentation/memory-hotplug.txt | 16 +++++++++-------
 arch/x86/Kconfig                 |  6 +++++-
 arch/x86/include/asm/e820.h      |  2 +-
 arch/x86/kernel/e820.c           |  5 ++++-
 arch/x86/kernel/setup.c          | 23 ++++++++++-------------
 arch/x86/mm/ioremap.c            |  5 ++---
 6 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/Documentation/memory-hotplug.txt b/Documentation/memory-hotplug.txt
index 8e5eacb..8fd254c 100644
--- a/Documentation/memory-hotplug.txt
+++ b/Documentation/memory-hotplug.txt
@@ -210,13 +210,15 @@ If memory device is found, memory hotplug code will be called.
 
 4.2 Notify memory hot-add event by hand
 ------------
-In some environments, especially virtualized environment, firmware will not
-notify memory hotplug event to the kernel. For such environment, "probe"
-interface is supported. This interface depends on CONFIG_ARCH_MEMORY_PROBE.
-
-Now, CONFIG_ARCH_MEMORY_PROBE is supported only by powerpc but it does not
-contain highly architecture codes. Please add config if you need "probe"
-interface.
+On powerpc, the firmware does not notify a memory hotplug event to the kernel.
+Therefore, "probe" interface is supported to notify the event to the kernel.
+This interface depends on CONFIG_ARCH_MEMORY_PROBE.
+
+CONFIG_ARCH_MEMORY_PROBE is supported on powerpc only. On x86, this config
+option is disabled by default since ACPI notifies a memory hotplug event to
+the kernel, which performs its hotplug operation as the result. Please
+enable this option if you need the "probe" interface for testing purposes
+on x86.
 
 Probe interface is located at
 /sys/devices/system/memory/probe
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..2f9d957 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1344,8 +1344,12 @@ config ARCH_SELECT_MEMORY_MODEL
 	depends on ARCH_SPARSEMEM_ENABLE
 
 config ARCH_MEMORY_PROBE
-	def_bool y
+	bool "Enable sysfs memory/probe interface"
 	depends on X86_64 && MEMORY_HOTPLUG
+	help
+	  This option enables a sysfs memory/probe interface for testing.
+	  See Documentation/memory-hotplug.txt for more information.
+	  If you are unsure how to answer this question, answer N.
 
 config ARCH_PROC_KCORE_TEXT
 	def_bool y
diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index cccd07f..779c2ef 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -29,7 +29,7 @@ extern void e820_setup_gap(void);
 extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
 			unsigned long start_addr, unsigned long long end_addr);
 struct setup_data;
-extern void parse_e820_ext(struct setup_data *data);
+extern void parse_e820_ext(u64 phys_addr, u32 data_len);
 
 #if defined(CONFIG_X86_64) || \
 	(defined(CONFIG_X86_32) && defined(CONFIG_HIBERNATION))
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index d32abea..174da5f 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -658,15 +658,18 @@ __init void e820_setup_gap(void)
  * boot_params.e820_map, others are passed via SETUP_E820_EXT node of
  * linked list of struct setup_data, which is parsed here.
  */
-void __init parse_e820_ext(struct setup_data *sdata)
+void __init parse_e820_ext(u64 phys_addr, u32 data_len)
 {
 	int entries;
 	struct e820entry *extmap;
+	struct setup_data *sdata;
 
+	sdata = early_memremap(phys_addr, data_len);
 	entries = sdata->len / sizeof(struct e820entry);
 	extmap = (struct e820entry *)(sdata->data);
 	__append_e820_map(extmap, entries);
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	early_iounmap(sdata, data_len);
 	printk(KERN_INFO "e820: extended physical RAM map:\n");
 	e820_print_map("extended");
 }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f8ec578..b6b45e4 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -426,25 +426,23 @@ static void __init reserve_initrd(void)
 static void __init parse_setup_data(void)
 {
 	struct setup_data *data;
-	u64 pa_data;
+	u64 pa_data, pa_next;
 
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		u32 data_len, map_len;
+		u32 data_len, map_len, data_type;
 
 		map_len = max(PAGE_SIZE - (pa_data & ~PAGE_MASK),
 			      (u64)sizeof(struct setup_data));
 		data = early_memremap(pa_data, map_len);
 		data_len = data->len + sizeof(struct setup_data);
-		if (data_len > map_len) {
-			early_iounmap(data, map_len);
-			data = early_memremap(pa_data, data_len);
-			map_len = data_len;
-		}
+		data_type = data->type;
+		pa_next = data->next;
+		early_iounmap(data, map_len);
 
-		switch (data->type) {
+		switch (data_type) {
 		case SETUP_E820_EXT:
-			parse_e820_ext(data);
+			parse_e820_ext(pa_data, data_len);
 			break;
 		case SETUP_DTB:
 			add_dtb(pa_data);
@@ -452,8 +450,7 @@ static void __init parse_setup_data(void)
 		default:
 			break;
 		}
-		pa_data = data->next;
-		early_iounmap(data, map_len);
+		pa_data = pa_next;
 	}
 }
 
@@ -1070,7 +1067,7 @@ void __init setup_arch(char **cmdline_p)
 
 	cleanup_highmap();
 
-	memblock.current_limit = ISA_END_ADDRESS;
+	memblock_set_current_limit(ISA_END_ADDRESS);
 	memblock_x86_fill();
 
 	/*
@@ -1103,7 +1100,7 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_real_mode();
 
-	memblock.current_limit = get_max_mapped();
+	memblock_set_current_limit(get_max_mapped());
 	dma_contiguous_reserve(0);
 
 	/*
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 0215e2c..799580c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -487,7 +487,7 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 	unsigned long offset;
 	resource_size_t last_addr;
 	unsigned int nrpages;
-	enum fixed_addresses idx0, idx;
+	enum fixed_addresses idx;
 	int i, slot;
 
 	WARN_ON(system_state != SYSTEM_BOOTING);
@@ -540,8 +540,7 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 	/*
 	 * Ok, go for it..
 	 */
-	idx0 = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
-	idx = idx0;
+	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
 	while (nrpages > 0) {
 		early_set_fixmap(idx, phys_addr, prot);
 		phys_addr += PAGE_SIZE;
