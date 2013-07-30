Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3HASWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 14:22:22 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:25227 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab3HASWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 14:22:18 -0400
Message-ID: <201308011822.r71IMHBM020349@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 30 Jul 2013 17:32:04 -0400
Subject: [PATCH] tile: convert uses of "inv" to "finv"
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "inv" (invalidate) instruction is generally less safe than "finv"
(flush and invalidate), as it will drop dirty data from the cache.
It turns out we have almost no need for "inv" (other than for the
older 32-bit architecture in some limited cases), so convert to
"finv" where possible and delete the extra "inv" infrastructure.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/cacheflush.h    | 44 ++++++++++++++++-------------------
 arch/tile/include/asm/uaccess.h       | 31 ------------------------
 arch/tile/include/uapi/asm/cachectl.h |  4 ++--
 arch/tile/kernel/head_32.S            |  2 +-
 arch/tile/kernel/head_64.S            |  2 +-
 arch/tile/lib/cacheflush.c            | 13 +++++++----
 arch/tile/lib/exports.c               |  1 -
 arch/tile/lib/usercopy_32.S           | 19 ---------------
 arch/tile/lib/usercopy_64.S           | 19 ---------------
 9 files changed, 32 insertions(+), 103 deletions(-)

diff --git a/arch/tile/include/asm/cacheflush.h b/arch/tile/include/asm/cacheflush.h
index 0fc63c4..92ee4c8 100644
--- a/arch/tile/include/asm/cacheflush.h
+++ b/arch/tile/include/asm/cacheflush.h
@@ -75,23 +75,6 @@ static inline void copy_to_user_page(struct vm_area_struct *vma,
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy((dst), (src), (len))
 
-/*
- * Invalidate a VA range; pads to L2 cacheline boundaries.
- *
- * Note that on TILE64, __inv_buffer() actually flushes modified
- * cache lines in addition to invalidating them, i.e., it's the
- * same as __finv_buffer().
- */
-static inline void __inv_buffer(void *buffer, size_t size)
-{
-	char *next = (char *)((long)buffer & -L2_CACHE_BYTES);
-	char *finish = (char *)L2_CACHE_ALIGN((long)buffer + size);
-	while (next < finish) {
-		__insn_inv(next);
-		next += CHIP_INV_STRIDE();
-	}
-}
-
 /* Flush a VA range; pads to L2 cacheline boundaries. */
 static inline void __flush_buffer(void *buffer, size_t size)
 {
@@ -115,13 +98,6 @@ static inline void __finv_buffer(void *buffer, size_t size)
 }
 
 
-/* Invalidate a VA range and wait for it to be complete. */
-static inline void inv_buffer(void *buffer, size_t size)
-{
-	__inv_buffer(buffer, size);
-	mb();
-}
-
 /*
  * Flush a locally-homecached VA range and wait for the evicted
  * cachelines to hit memory.
@@ -142,6 +118,26 @@ static inline void finv_buffer_local(void *buffer, size_t size)
 	mb_incoherent();
 }
 
+#ifdef __tilepro__
+/* Invalidate a VA range; pads to L2 cacheline boundaries. */
+static inline void __inv_buffer(void *buffer, size_t size)
+{
+	char *next = (char *)((long)buffer & -L2_CACHE_BYTES);
+	char *finish = (char *)L2_CACHE_ALIGN((long)buffer + size);
+	while (next < finish) {
+		__insn_inv(next);
+		next += CHIP_INV_STRIDE();
+	}
+}
+
+/* Invalidate a VA range and wait for it to be complete. */
+static inline void inv_buffer(void *buffer, size_t size)
+{
+	__inv_buffer(buffer, size);
+	mb();
+}
+#endif
+
 /*
  * Flush and invalidate a VA range that is homed remotely, waiting
  * until the memory controller holds the flushed values.  If "hfh" is
diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index e4d44bd..f68503f 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -567,37 +567,6 @@ static inline unsigned long __must_check flush_user(
 }
 
 /**
- * inv_user: - Invalidate a block of memory in user space from cache.
- * @mem:   Destination address, in user space.
- * @len:   Number of bytes to invalidate.
- *
- * Returns number of bytes that could not be invalidated.
- * On success, this will be zero.
- *
- * Note that on Tile64, the "inv" operation is in fact a
- * "flush and invalidate", so cache write-backs will occur prior
- * to the cache being marked invalid.
- */
-extern unsigned long inv_user_asm(void __user *mem, unsigned long len);
-static inline unsigned long __must_check __inv_user(
-	void __user *mem, unsigned long len)
-{
-	int retval;
-
-	might_fault();
-	retval = inv_user_asm(mem, len);
-	mb_incoherent();
-	return retval;
-}
-static inline unsigned long __must_check inv_user(
-	void __user *mem, unsigned long len)
-{
-	if (access_ok(VERIFY_WRITE, mem, len))
-		return __inv_user(mem, len);
-	return len;
-}
-
-/**
  * finv_user: - Flush-inval a block of memory in user space from cache.
  * @mem:   Destination address, in user space.
  * @len:   Number of bytes to invalidate.
diff --git a/arch/tile/include/uapi/asm/cachectl.h b/arch/tile/include/uapi/asm/cachectl.h
index af4c9f9..572ddca 100644
--- a/arch/tile/include/uapi/asm/cachectl.h
+++ b/arch/tile/include/uapi/asm/cachectl.h
@@ -29,8 +29,8 @@
  * to honor the arguments at some point.)
  *
  * Flush and invalidation of memory can normally be performed with the
- * __insn_flush(), __insn_inv(), and __insn_finv() instructions from
- * userspace.  The DCACHE option to the system call allows userspace
+ * __insn_flush() and __insn_finv() instructions from userspace.
+ * The DCACHE option to the system call allows userspace
  * to flush the entire L1+L2 data cache from the core.  In this case,
  * the address and length arguments are not used.  The DCACHE flush is
  * restricted to the current core, not all cores in the address space.
diff --git a/arch/tile/kernel/head_32.S b/arch/tile/kernel/head_32.S
index ac11530..80cd407 100644
--- a/arch/tile/kernel/head_32.S
+++ b/arch/tile/kernel/head_32.S
@@ -64,7 +64,7 @@ ENTRY(_start)
 	  auli r0, r0, ha16(swapper_pg_dir - PAGE_OFFSET)
 	}
 	{
-	  inv r6
+	  finv r6
 	  move r1, zero   /* high 32 bits of CPA is zero */
 	}
 	{
diff --git a/arch/tile/kernel/head_64.S b/arch/tile/kernel/head_64.S
index 6093964..e23e5f7 100644
--- a/arch/tile/kernel/head_64.S
+++ b/arch/tile/kernel/head_64.S
@@ -77,7 +77,7 @@ ENTRY(_start)
 	{
 	  /* After initializing swapper_pgprot, HV_PTE_GLOBAL is set. */
 	  bfextu r7, r1, HV_PTE_INDEX_GLOBAL, HV_PTE_INDEX_GLOBAL
-	  inv r4
+	  finv r4
 	}
 	bnez r7, .Lno_write
 	{
diff --git a/arch/tile/lib/cacheflush.c b/arch/tile/lib/cacheflush.c
index 8f8ad81..2238b40 100644
--- a/arch/tile/lib/cacheflush.c
+++ b/arch/tile/lib/cacheflush.c
@@ -147,18 +147,21 @@ void finv_buffer_remote(void *buffer, size_t size, int hfh)
 		force_load(p);
 
 	/*
-	 * Repeat, but with inv's instead of loads, to get rid of the
+	 * Repeat, but with finv's instead of loads, to get rid of the
 	 * data we just loaded into our own cache and the old home L3.
-	 * No need to unroll since inv's don't target a register.
+	 * No need to unroll since finv's don't target a register.
+	 * The finv's are guaranteed not to actually flush the data in
+	 * the buffer back to their home, since we just read it, so the
+	 * lines are clean in cache; we will only invalidate those lines.
 	 */
 	p = (char *)buffer + size - 1;
-	__insn_inv(p);
+	__insn_finv(p);
 	p -= step_size;
 	p = (char *)((unsigned long)p | (step_size - 1));
 	for (; p >= base; p -= step_size)
-		__insn_inv(p);
+		__insn_finv(p);
 
-	/* Wait for the load+inv's (and thus finvs) to have completed. */
+	/* Wait for these finv's (and thus the first finvs) to be done. */
 	__insn_mf();
 
 #ifdef __tilegx__
diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index a93b02a..359b1bc 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -22,7 +22,6 @@ EXPORT_SYMBOL(strnlen_user_asm);
 EXPORT_SYMBOL(strncpy_from_user_asm);
 EXPORT_SYMBOL(clear_user_asm);
 EXPORT_SYMBOL(flush_user_asm);
-EXPORT_SYMBOL(inv_user_asm);
 EXPORT_SYMBOL(finv_user_asm);
 
 /* arch/tile/kernel/entry.S */
diff --git a/arch/tile/lib/usercopy_32.S b/arch/tile/lib/usercopy_32.S
index b62d002..21ffa88 100644
--- a/arch/tile/lib/usercopy_32.S
+++ b/arch/tile/lib/usercopy_32.S
@@ -109,25 +109,6 @@ STD_ENTRY(flush_user_asm)
 	.popsection
 
 /*
- * inv_user_asm takes the user target address in r0 and the
- * number of bytes to invalidate in r1.
- * It returns the number of not inv'able bytes (hopefully zero) in r0.
- */
-STD_ENTRY(inv_user_asm)
-	bz r1, 2f
-	{ movei r2, L2_CACHE_BYTES; add r1, r0, r1 }
-	{ sub r2, zero, r2; addi r1, r1, L2_CACHE_BYTES-1 }
-	{ and r0, r0, r2; and r1, r1, r2 }
-	{ sub r1, r1, r0 }
-1:      { inv r0; addi r1, r1, -CHIP_INV_STRIDE() }
-	{ addi r0, r0, CHIP_INV_STRIDE(); bnzt r1, 1b }
-2:      { move r0, r1; jrp lr }
-	STD_ENDPROC(inv_user_asm)
-	.pushsection __ex_table,"a"
-	.word 1b, 2b
-	.popsection
-
-/*
  * finv_user_asm takes the user target address in r0 and the
  * number of bytes to flush-invalidate in r1.
  * It returns the number of not finv'able bytes (hopefully zero) in r0.
diff --git a/arch/tile/lib/usercopy_64.S b/arch/tile/lib/usercopy_64.S
index adb2dbb..f248d31 100644
--- a/arch/tile/lib/usercopy_64.S
+++ b/arch/tile/lib/usercopy_64.S
@@ -109,25 +109,6 @@ STD_ENTRY(flush_user_asm)
 	.popsection
 
 /*
- * inv_user_asm takes the user target address in r0 and the
- * number of bytes to invalidate in r1.
- * It returns the number of not inv'able bytes (hopefully zero) in r0.
- */
-STD_ENTRY(inv_user_asm)
-	beqz r1, 2f
-	{ movei r2, L2_CACHE_BYTES; add r1, r0, r1 }
-	{ sub r2, zero, r2; addi r1, r1, L2_CACHE_BYTES-1 }
-	{ and r0, r0, r2; and r1, r1, r2 }
-	{ sub r1, r1, r0 }
-1:      { inv r0; addi r1, r1, -CHIP_INV_STRIDE() }
-	{ addi r0, r0, CHIP_INV_STRIDE(); bnezt r1, 1b }
-2:      { move r0, r1; jrp lr }
-	STD_ENDPROC(inv_user_asm)
-	.pushsection __ex_table,"a"
-	.quad 1b, 2b
-	.popsection
-
-/*
  * finv_user_asm takes the user target address in r0 and the
  * number of bytes to flush-invalidate in r1.
  * It returns the number of not finv'able bytes (hopefully zero) in r0.
-- 
1.8.3.1

