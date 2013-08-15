Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab3HOUiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:38:13 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:46351 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab3HOUiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:38:12 -0400
Message-ID: <201308152038.r7FKcBdh004207@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 15 Aug 2013 16:29:02 -0400
Subject: [PATCH] tile: make __write_once a synonym for __read_mostly
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was really only useful for TILE64 when we mapped the
kernel data with small pages. Now we use a huge page and we
really don't want to map different parts of the kernel
data in different ways.

We retain the __write_once name in case we want to bring
it back to life at some point in the future.

Note that this change uncovered a latent bug where the
"smp_topology" variable happened to always be aligned mod 8
so we could store two "int" values at once, but when we
eliminated __write_once it ended up only aligned mod 4.
Fix with an explicit annotation.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/cache.h  | 13 ++++++++++---
 arch/tile/kernel/smp.c         |  6 +++++-
 arch/tile/kernel/vmlinux.lds.S | 12 ------------
 arch/tile/mm/init.c            | 13 ++-----------
 4 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/arch/tile/include/asm/cache.h b/arch/tile/include/asm/cache.h
index a9a5299..6160761 100644
--- a/arch/tile/include/asm/cache.h
+++ b/arch/tile/include/asm/cache.h
@@ -49,9 +49,16 @@
 #define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
 /*
- * Attribute for data that is kept read/write coherent until the end of
- * initialization, then bumped to read/only incoherent for performance.
+ * Originally we used small TLB pages for kernel data and grouped some
+ * things together as "write once", enforcing the property at the end
+ * of initialization by making those pages read-only and non-coherent.
+ * This allowed better cache utilization since cache inclusion did not
+ * need to be maintained.  However, to do this requires an extra TLB
+ * entry, which on balance is more of a performance hit than the
+ * non-coherence is a performance gain, so we now just make "read
+ * mostly" and "write once" be synonyms.  We keep the attribute
+ * separate in case we change our minds at a future date.
  */
-#define __write_once __attribute__((__section__(".w1data")))
+#define __write_once __read_mostly
 
 #endif /* _ASM_TILE_CACHE_H */
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index 62b3ba9..6da740e 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -22,7 +22,11 @@
 #include <asm/cacheflush.h>
 #include <asm/homecache.h>
 
-HV_Topology smp_topology __write_once;
+/*
+ * We write to width and height with a single store in head_NN.S,
+ * so make the variable aligned to "long".
+ */
+HV_Topology smp_topology __write_once __aligned(sizeof(long));
 EXPORT_SYMBOL(smp_topology);
 
 #if CHIP_HAS_IPI()
diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
index 8b20163..f1819423 100644
--- a/arch/tile/kernel/vmlinux.lds.S
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -74,20 +74,8 @@ SECTIONS
   __init_end = .;
 
   _sdata = .;                   /* Start of data section */
-
   RO_DATA_SECTION(PAGE_SIZE)
-
-  /* initially writeable, then read-only */
-  . = ALIGN(PAGE_SIZE);
-  __w1data_begin = .;
-  .w1data : AT(ADDR(.w1data) - LOAD_OFFSET) {
-    VMLINUX_SYMBOL(__w1data_begin) = .;
-    *(.w1data)
-    VMLINUX_SYMBOL(__w1data_end) = .;
-  }
-
   RW_DATA_SECTION(L2_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
-
   _edata = .;
 
   EXCEPTION_TABLE(L2_CACHE_BYTES)
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 22e41cf..4e316deb 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -271,21 +271,13 @@ static pgprot_t __init init_pgprot(ulong address)
 		return construct_pgprot(PAGE_KERNEL, PAGE_HOME_HASH);
 
 	/*
-	 * Make the w1data homed like heap to start with, to avoid
-	 * making it part of the page-striped data area when we're just
-	 * going to convert it to read-only soon anyway.
-	 */
-	if (address >= (ulong)__w1data_begin && address < (ulong)__w1data_end)
-		return construct_pgprot(PAGE_KERNEL, initial_heap_home());
-
-	/*
 	 * Otherwise we just hand out consecutive cpus.  To avoid
 	 * requiring this function to hold state, we just walk forward from
 	 * _sdata by PAGE_SIZE, skipping the readonly and init data, to reach
 	 * the requested address, while walking cpu home around kdata_mask.
 	 * This is typically no more than a dozen or so iterations.
 	 */
-	page = (((ulong)__w1data_end) + PAGE_SIZE - 1) & PAGE_MASK;
+	page = (((ulong)__end_rodata) + PAGE_SIZE - 1) & PAGE_MASK;
 	BUG_ON(address < page || address >= (ulong)_end);
 	cpu = cpumask_first(&kdata_mask);
 	for (; page < address; page += PAGE_SIZE) {
@@ -980,8 +972,7 @@ void free_initmem(void)
 	const unsigned long text_delta = MEM_SV_START - PAGE_OFFSET;
 
 	/*
-	 * Evict the dirty initdata on the boot cpu, evict the w1data
-	 * wherever it's homed, and evict all the init code everywhere.
+	 * Evict the cache on all cores to avoid incoherence.
 	 * We are guaranteed that no one will touch the init pages any more.
 	 */
 	homecache_evict(&cpu_cacheable_map);
-- 
1.8.3.1

