Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab3HGO6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 10:58:50 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60307 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab3HGO6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:58:39 -0400
Message-ID: <201308071458.r77EwdJk013085@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 6 Aug 2013 14:29:59 -0400
Subject: [PATCH] tile: support "memmap" boot parameter
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds support for the "memmap" boot parameter similar
to what x86 provides.  The tile version supports "memmap=1G$5G",
for example, as a way to reserve a 1 GB range starting at PA 5GB.
The memory is reserved via bootmem during startup, and we create a
suitable "struct resource" marked as "Reserved" so you can see the
range reported by /proc/iomem.  Up to 64 such regions can currently
be reserved on the boot command line.

We do not support the x86 options "memmap=nn@ss" (force some memory
to be available at the given address) since it's pointless to try to
have Linux use memory the Tilera hypervisor hasn't given it.  We do
not support "memmap=nn#ss" to add an ACPI range for later processing,
since we don't support ACPI.  We do not support "memmap=exactmap"
since we don't support reading the e820 information from the BIOS
like x86 does.  I did add support for "memmap=nn" (and the synonym
"mem=nn") which cap the highest PA value at "nn"; these are both
just a synonym for the existing tile boot option "maxmem".

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/setup.c | 80 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 76 insertions(+), 4 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 676e155..b00e156 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -154,6 +154,65 @@ static int __init setup_maxnodemem(char *str)
 }
 early_param("maxnodemem", setup_maxnodemem);
 
+struct memmap_entry {
+	u64 addr;	/* start of memory segment */
+	u64 size;	/* size of memory segment */
+};
+static struct memmap_entry memmap_map[64];
+static int memmap_nr;
+
+static void add_memmap_region(u64 addr, u64 size)
+{
+	if (memmap_nr >= ARRAY_SIZE(memmap_map)) {
+		pr_err("Ooops! Too many entries in the memory map!\n");
+		return;
+	}
+	memmap_map[memmap_nr].addr = addr;
+	memmap_map[memmap_nr].size = size;
+	memmap_nr++;
+}
+
+static int __init setup_memmap(char *p)
+{
+	char *oldp;
+	u64 start_at, mem_size;
+
+	if (!p)
+		return -EINVAL;
+
+	if (!strncmp(p, "exactmap", 8)) {
+		pr_err("\"memmap=exactmap\" not valid on tile\n");
+		return 0;
+	}
+
+	oldp = p;
+	mem_size = memparse(p, &p);
+	if (p == oldp)
+		return -EINVAL;
+
+	if (*p == '@') {
+		pr_err("\"memmap=nn@ss\" (force RAM) invalid on tile\n");
+	} else if (*p == '#') {
+		pr_err("\"memmap=nn#ss\" (force ACPI data) invalid on tile\n");
+	} else if (*p == '$') {
+		start_at = memparse(p+1, &p);
+		add_memmap_region(start_at, mem_size);
+	} else {
+		if (mem_size == 0)
+			return -EINVAL;
+		maxmem_pfn = (mem_size >> HPAGE_SHIFT) <<
+			(HPAGE_SHIFT - PAGE_SHIFT);
+	}
+	return *p == '\0' ? 0 : -EINVAL;
+}
+early_param("memmap", setup_memmap);
+
+static int __init setup_mem(char *str)
+{
+	return setup_maxmem(str);
+}
+early_param("mem", setup_mem);  /* compatibility with x86 */
+
 static int __init setup_isolnodes(char *str)
 {
 	char buf[MAX_NUMNODES * 5];
@@ -629,6 +688,12 @@ static void __init setup_bootmem_allocator(void)
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		setup_bootmem_allocator_node(i);
 
+	/* Reserve any memory excluded by "memmap" arguments. */
+	for (i = 0; i < memmap_nr; ++i) {
+		struct memmap_entry *m = &memmap_map[i];
+		reserve_bootmem(m->addr, m->size, 0);
+	}
+
 #ifdef CONFIG_KEXEC
 	if (crashk_res.start != crashk_res.end)
 		reserve_bootmem(crashk_res.start, resource_size(&crashk_res), 0);
@@ -1562,11 +1627,11 @@ insert_non_bus_resource(void)
 #endif
 
 static struct resource* __init
-insert_ram_resource(u64 start_pfn, u64 end_pfn)
+insert_ram_resource(u64 start_pfn, u64 end_pfn, bool reserved)
 {
 	struct resource *res =
 		kzalloc(sizeof(struct resource), GFP_ATOMIC);
-	res->name = "System RAM";
+	res->name = reserved ? "Reserved" : "System RAM";
 	res->start = start_pfn << PAGE_SHIFT;
 	res->end = (end_pfn << PAGE_SHIFT) - 1;
 	res->flags = IORESOURCE_BUSY | IORESOURCE_MEM;
@@ -1601,11 +1666,11 @@ static int __init request_standard_resources(void)
 		    end_pfn > pci_reserve_start_pfn) {
 			if (end_pfn > pci_reserve_end_pfn)
 				insert_ram_resource(pci_reserve_end_pfn,
-						     end_pfn);
+						    end_pfn, 0);
 			end_pfn = pci_reserve_start_pfn;
 		}
 #endif
-		insert_ram_resource(start_pfn, end_pfn);
+		insert_ram_resource(start_pfn, end_pfn, 0);
 	}
 
 	code_resource.start = __pa(_text - CODE_DELTA);
@@ -1616,6 +1681,13 @@ static int __init request_standard_resources(void)
 	insert_resource(&iomem_resource, &code_resource);
 	insert_resource(&iomem_resource, &data_resource);
 
+	/* Mark any "memmap" regions busy for the resource manager. */
+	for (i = 0; i < memmap_nr; ++i) {
+		struct memmap_entry *m = &memmap_map[i];
+		insert_ram_resource(PFN_DOWN(m->addr),
+				    PFN_UP(m->addr + m->size - 1), 1);
+	}
+
 #ifdef CONFIG_KEXEC
 	insert_resource(&iomem_resource, &crashk_res);
 #endif
-- 
1.8.3.1

