Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965680AbaLLTMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:12:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:7407 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965607AbaLLTMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:12:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,565,1413270000"; 
   d="scan'208";a="653022188"
Subject: [RFC][PATCH 8/8] x86, mpx: support 32bit binaries on 64bit kernel
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Fri, 12 Dec 2014 11:12:23 -0800
References: <20141212191213.579887D2@viggo.jf.intel.com>
In-Reply-To: <20141212191213.579887D2@viggo.jf.intel.com>
Message-Id: <20141212191223.97807F49@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Right now, the kernel can only switch between 64-bit and 32-bit
binaries at compile time. This patch adds support for 32-bit
binaries on 64-bit kernels when we support ia32 emulation.

We essentially choose which set of table sizes to use when doing
arithmetic for the bounds table calculations.

This also uses a different approach for calculating the table
indexes than before.  I think the new one makes it much more
clear what is going on, and allows us to share more code between
the 32 and 64-bit cases.

Based-on-patch-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/include/asm/mpx.h |   68 +++++++++----------
 b/arch/x86/mm/mpx.c          |  150 ++++++++++++++++++++++++++++++++++++-------
 2 files changed, 163 insertions(+), 55 deletions(-)

diff -puN arch/x86/include/asm/mpx.h~0002-x86-mpx-support-32bit-binaries-on-64bit-kernel arch/x86/include/asm/mpx.h
--- a/arch/x86/include/asm/mpx.h~0002-x86-mpx-support-32bit-binaries-on-64bit-kernel	2014-12-12 11:11:41.763068246 -0800
+++ b/arch/x86/include/asm/mpx.h	2014-12-12 11:11:41.768068471 -0800
@@ -13,49 +13,49 @@
 #define MPX_BNDCFG_ENABLE_FLAG	0x1
 #define MPX_BD_ENTRY_VALID_FLAG	0x1
 
-#ifdef CONFIG_X86_64
-
-/* upper 28 bits [47:20] of the virtual address in 64-bit used to
- * index into bounds directory (BD).
+/*
+ * The upper 28 bits [47:20] of the virtual address in 64-bit
+ * are used to index into bounds directory (BD).
+ *
+ * The directory is 2G (2^31) in size, and with 8-byte entries
+ * it has 2^28 entries.
  */
-#define MPX_BD_ENTRY_OFFSET	28
-#define MPX_BD_ENTRY_SHIFT	3
-/* bits [19:3] of the virtual address in 64-bit used to index into
- * bounds table (BT).
+#define MPX_BD_SIZE_BYTES_64	(1UL<<31)
+/* An entry is a long, so 8 bytes and a shift of 3 */
+#define MPX_BD_ENTRY_BYTES_64	8
+#define MPX_BD_NR_ENTRIES_64	(MPX_BD_SIZE_BYTES_64/MPX_BD_ENTRY_BYTES_64)
+
+/*
+ * The 32-bit directory is 4MB (2^22) in size, and with 4-byte
+ * entries it has 2^20 entries.
  */
-#define MPX_BT_ENTRY_OFFSET	17
-#define MPX_BT_ENTRY_SHIFT	5
-#define MPX_IGN_BITS		3
-#define MPX_BD_ENTRY_TAIL	3
-
-#else
-
-#define MPX_BD_ENTRY_OFFSET	20
-#define MPX_BD_ENTRY_SHIFT	2
-#define MPX_BT_ENTRY_OFFSET	10
-#define MPX_BT_ENTRY_SHIFT	4
-#define MPX_IGN_BITS		2
-#define MPX_BD_ENTRY_TAIL	2
-
-#endif
-
-#define MPX_BD_SIZE_BYTES (1UL<<(MPX_BD_ENTRY_OFFSET+MPX_BD_ENTRY_SHIFT))
-#define MPX_BT_SIZE_BYTES (1UL<<(MPX_BT_ENTRY_OFFSET+MPX_BT_ENTRY_SHIFT))
+#define MPX_BD_SIZE_BYTES_32	(1UL<<22)
+/* An entry is a long, so 4 bytes and a shift of 2 */
+#define MPX_BD_ENTRY_BYTES_32	4
+#define MPX_BD_NR_ENTRIES_32	(MPX_BD_SIZE_BYTES_32/MPX_BD_ENTRY_BYTES_32)
+
+/*
+ * A 64-bit table is 4MB total in size, and an entry is
+ * 4 64-bit pointers in size.
+ */
+#define MPX_BT_SIZE_BYTES_64	(1UL<<22)
+#define MPX_BT_ENTRY_BYTES_64	32
+#define MPX_BT_NR_ENTRIES_64	(MPX_BD_SIZE_BYTES_64/MPX_BD_ENTRY_BYTES_64)
+
+/*
+ * A 32-bit table is 16kB total in size, and an entry is
+ * 4 32-bit pointers in size.
+ */
+#define MPX_BT_SIZE_BYTES_32	(1UL<<14)
+#define MPX_BT_ENTRY_BYTES_32	16
+#define MPX_BT_NR_ENTRIES_32	(MPX_BD_SIZE_BYTES_32/MPX_BD_ENTRY_BYTES_32)
 
 #define MPX_BNDSTA_TAIL		2
 #define MPX_BNDCFG_TAIL		12
 #define MPX_BNDSTA_ADDR_MASK	(~((1UL<<MPX_BNDSTA_TAIL)-1))
-
 #define MPX_BNDCFG_ADDR_MASK	(~((1UL<<MPX_BNDCFG_TAIL)-1))
 #define MPX_BNDSTA_ERROR_CODE	0x3
 
-#define MPX_BD_ENTRY_MASK	((1<<MPX_BD_ENTRY_OFFSET)-1)
-#define MPX_BT_ENTRY_MASK	((1<<MPX_BT_ENTRY_OFFSET)-1)
-#define MPX_GET_BD_ENTRY_OFFSET(addr)	((((addr)>>(MPX_BT_ENTRY_OFFSET+ \
-		MPX_IGN_BITS)) & MPX_BD_ENTRY_MASK) << MPX_BD_ENTRY_SHIFT)
-#define MPX_GET_BT_ENTRY_OFFSET(addr)	((((addr)>>MPX_IGN_BITS) & \
-		MPX_BT_ENTRY_MASK) << MPX_BT_ENTRY_SHIFT)
-
 #ifdef CONFIG_X86_INTEL_MPX
 siginfo_t *mpx_generate_siginfo(struct pt_regs *regs,
 				struct xsave_struct *xsave_buf);
diff -puN arch/x86/mm/mpx.c~0002-x86-mpx-support-32bit-binaries-on-64bit-kernel arch/x86/mm/mpx.c
--- a/arch/x86/mm/mpx.c~0002-x86-mpx-support-32bit-binaries-on-64bit-kernel	2014-12-12 11:11:41.764068291 -0800
+++ b/arch/x86/mm/mpx.c	2014-12-12 11:11:41.768068471 -0800
@@ -32,6 +32,22 @@ static int is_mpx_vma(struct vm_area_str
 	return (vma->vm_ops == &mpx_vma_ops);
 }
 
+static inline unsigned long mpx_bd_size_bytes(struct mm_struct *mm)
+{
+	if (is_64bit_mm(mm))
+		return MPX_BD_SIZE_BYTES_64;
+	else
+		return MPX_BD_SIZE_BYTES_32;
+}
+
+static inline unsigned long mpx_bt_size_bytes(struct mm_struct *mm)
+{
+	if (is_64bit_mm(mm))
+		return MPX_BT_SIZE_BYTES_64;
+	else
+		return MPX_BT_SIZE_BYTES_32;
+}
+
 /*
  * This is really a simplified "vm_mmap". it only handles MPX
  * bounds tables (the bounds directory is user-allocated).
@@ -48,7 +64,7 @@ static unsigned long mpx_mmap(unsigned l
 	struct vm_area_struct *vma;
 
 	/* Only bounds table can be allocated here */
-	if (len != MPX_BT_SIZE_BYTES)
+	if (len != mpx_bt_size_bytes(mm))
 		return -EINVAL;
 
 	down_write(&mm->mmap_sem);
@@ -441,13 +457,12 @@ static int mpx_cmpxchg_bd_entry(struct m
 }
 
 /*
- * With 32-bit mode, MPX_BT_SIZE_BYTES is 4MB, and the size of each
- * bounds table is 16KB. With 64-bit mode, MPX_BT_SIZE_BYTES is 2GB,
+ * With 32-bit mode, a bounds directory is 4MB, and the size of each
+ * bounds table is 16KB. With 64-bit mode, a bounds directory is 2GB,
  * and the size of each bounds table is 4MB.
  */
-static int allocate_bt(long __user *bd_entry)
+static int allocate_bt(struct mm_struct *mm, long __user *bd_entry)
 {
-	struct mm_struct *mm = current->mm;
 	unsigned long expected_old_val = 0;
 	unsigned long actual_old_val = 0;
 	unsigned long bt_addr;
@@ -458,7 +473,7 @@ static int allocate_bt(long __user *bd_e
 	 * Carve the virtual space out of userspace for the new
 	 * bounds table:
 	 */
-	bt_addr = mpx_mmap(MPX_BT_SIZE_BYTES);
+	bt_addr = mpx_mmap(mpx_bt_size_bytes(mm));
 	if (IS_ERR((void *)bt_addr))
 		return PTR_ERR((void *)bt_addr);
 	/*
@@ -508,7 +523,7 @@ static int allocate_bt(long __user *bd_e
 	}
 	return 0;
 out_unmap:
-	vm_munmap(bt_addr, MPX_BT_SIZE_BYTES);
+	vm_munmap(bt_addr, mpx_bt_size_bytes(mm));
 	return ret;
 }
 
@@ -527,6 +542,7 @@ static int do_mpx_bt_fault(struct xsave_
 {
 	unsigned long bd_entry, bd_base;
 	struct bndcsr *bndcsr;
+	struct mm_struct *mm = current->mm;
 
 	bndcsr = get_xsave_addr(xsave_buf, XSTATE_BNDCSR);
 	if (!bndcsr)
@@ -545,10 +561,10 @@ static int do_mpx_bt_fault(struct xsave_
 	 * the directory is.
 	 */
 	if ((bd_entry < bd_base) ||
-	    (bd_entry >= bd_base + MPX_BD_SIZE_BYTES))
+	    (bd_entry >= bd_base + mpx_bd_size_bytes(mm)))
 		return -EINVAL;
 
-	return allocate_bt((long __user *)bd_entry);
+	return allocate_bt(mm, (long __user *)bd_entry);
 }
 
 int mpx_handle_bd_fault(struct xsave_struct *xsave_buf)
@@ -779,7 +795,95 @@ static int unmap_single_bt(struct mm_str
 	 * avoid recursion, do_munmap() will check whether it comes
 	 * from one bounds table through VM_MPX flag.
 	 */
-	return do_munmap(mm, bt_addr, MPX_BT_SIZE_BYTES);
+	return do_munmap(mm, bt_addr, mpx_bt_size_bytes(mm));
+}
+
+/*
+ * Take a virtual address and turns it in to the offset in bytes
+ * inside of the bounds table where the bounds table entry
+ * controlling 'addr' can be found.
+ */
+static unsigned long mpx_get_bt_entry_offset_bytes(struct mm_struct *mm,
+		unsigned long addr)
+{
+	unsigned long bt_entry_size_bytes;
+	unsigned long bt_table_nr_entries;
+	unsigned long offset = addr;
+
+	if (is_64bit_mm(mm)) {
+		/* Bottom 3 bits are ignored on 64-bit */
+		offset >>= 3;
+		bt_entry_size_bytes = MPX_BT_ENTRY_BYTES_64;
+		bt_table_nr_entries = MPX_BT_NR_ENTRIES_64;
+	} else {
+		/* Bottom 2 bits are ignored on 32-bit */
+		offset >>= 2;
+		bt_entry_size_bytes = MPX_BT_ENTRY_BYTES_32;
+		bt_table_nr_entries = MPX_BT_NR_ENTRIES_32;
+	}
+	/*
+	 * We know the size of the table in to which we are
+	 * indexing, and we have eliminated all the low bits
+	 * which are ignored for indexing.
+	 *
+	 * Mask out all the high bits which we do not need
+	 * to index in to the table.
+	 */
+	offset &= (bt_table_nr_entries-1);
+	/*
+	 * We now have an entry offset in terms of *entries* in
+	 * the table.  We need to scale it back up to bytes.
+	 */
+	offset *= bt_entry_size_bytes;
+	return offset;
+}
+
+static noinline unsigned long mpx_get_bd_entry_offset(struct mm_struct *mm,
+		unsigned long addr)
+{
+	/*
+	 * Total size of the process's virtual address space
+	 * Use a u64 because 4GB (for 32-bit) won't fit in a long.
+	 */
+	u64 vaddr_space_size;
+	/*
+	 * How much virtual address space does a single bounds
+	 * directory entry cover?
+	 */
+	unsigned long bd_entry_virt_space;
+
+	/*
+	 * There are several ways to derive the bd offsets.  We
+	 * use the following approach here:
+	 * 1. We know the size of the virtual address space
+	 * 2. We know the number of entries in a bounds table
+	 * 3. We know that each entry covers a fixed amount of
+	 *    virtual address space.
+	 * So, we can just divide the virtual address by the
+	 * number of entries to figure out which entry "controls"
+	 * the given virtual address.
+	 */
+	if (is_64bit_mm(mm)) {
+	      	vaddr_space_size = 1ULL << __VIRTUAL_MASK_SHIFT;
+		bd_entry_virt_space = vaddr_space_size / MPX_BD_NR_ENTRIES_64;
+		/*
+		 * __VIRTUAL_MASK takes the 64-bit addressing hole
+		 * in to accout.  This is a noop on 32-bit.
+		 */
+		addr &= __VIRTUAL_MASK;
+		return addr / bd_entry_virt_space;
+	} else {
+	      	vaddr_space_size = (1ULL << 32);
+		bd_entry_virt_space = vaddr_space_size / MPX_BD_NR_ENTRIES_32;
+		return addr / bd_entry_virt_space;
+	}
+	/*
+	 * The two return calls above are exact copies.  If we
+	 * pull out a single copy and put it in here, gcc won't
+	 * realize that we're doing a power-of-2 divide and use
+	 * shifts.  It uses a real divide.  If we put them up
+	 * there, it manages to figure it out (gcc 4.8.3).
+	 */
 }
 
 /*
@@ -793,6 +897,7 @@ static int unmap_shared_bt(struct mm_str
 		unsigned long end, bool prev_shared, bool next_shared)
 {
 	unsigned long bt_addr;
+	unsigned long start_off, end_off;
 	int ret;
 
 	ret = get_bt_addr(mm, bd_entry, &bt_addr);
@@ -804,17 +909,20 @@ static int unmap_shared_bt(struct mm_str
 	if (ret)
 		return ret;
 
+	start_off = mpx_get_bt_entry_offset_bytes(mm, start);
+	end_off   = mpx_get_bt_entry_offset_bytes(mm, end);
+
 	if (prev_shared && next_shared)
 		ret = zap_bt_entries(mm, bt_addr,
-				bt_addr+MPX_GET_BT_ENTRY_OFFSET(start),
-				bt_addr+MPX_GET_BT_ENTRY_OFFSET(end));
+				bt_addr+start_off,
+				bt_addr+end_off);
 	else if (prev_shared)
 		ret = zap_bt_entries(mm, bt_addr,
-				bt_addr+MPX_GET_BT_ENTRY_OFFSET(start),
-				bt_addr+MPX_BT_SIZE_BYTES);
+				bt_addr + start_off,
+				bt_addr + mpx_bt_size_bytes(mm));
 	else if (next_shared)
 		ret = zap_bt_entries(mm, bt_addr, bt_addr,
-				bt_addr+MPX_GET_BT_ENTRY_OFFSET(end));
+				bt_addr+end_off);
 	else
 		ret = unmap_single_bt(mm, bd_entry, bt_addr);
 
@@ -835,8 +943,8 @@ static int unmap_edge_bts(struct mm_stru
 	struct vm_area_struct *prev, *next;
 	bool prev_shared = false, next_shared = false;
 
-	bde_start = mm->bd_addr + MPX_GET_BD_ENTRY_OFFSET(start);
-	bde_end = mm->bd_addr + MPX_GET_BD_ENTRY_OFFSET(end-1);
+	bde_start = mm->bd_addr + mpx_get_bd_entry_offset(mm, start);
+	bde_end   = mm->bd_addr + mpx_get_bd_entry_offset(mm, end-1);
 
 	/*
 	 * Check whether bde_start and bde_end are shared with adjacent
@@ -848,10 +956,10 @@ static int unmap_edge_bts(struct mm_stru
 	 * in to 'next'.
 	 */
 	next = find_vma_prev(mm, start, &prev);
-	if (prev && (mm->bd_addr + MPX_GET_BD_ENTRY_OFFSET(prev->vm_end-1))
+	if (prev && (mm->bd_addr + mpx_get_bd_entry_offset(mm, prev->vm_end-1))
 			== bde_start)
 		prev_shared = true;
-	if (next && (mm->bd_addr + MPX_GET_BD_ENTRY_OFFSET(next->vm_start))
+	if (next && (mm->bd_addr + mpx_get_bd_entry_offset(mm, next->vm_start))
 			== bde_end)
 		next_shared = true;
 
@@ -916,8 +1024,8 @@ static int mpx_unmap_tables(struct mm_st
 	 *   1. fully covered
 	 *   2. not at the edges of the mapping, even if full aligned
 	 */
-	bde_start = mm->bd_addr + MPX_GET_BD_ENTRY_OFFSET(start);
-	bde_end = mm->bd_addr + MPX_GET_BD_ENTRY_OFFSET(end-1);
+	bde_start = mm->bd_addr + mpx_get_bd_entry_offset(mm, start);
+	bde_end   = mm->bd_addr + mpx_get_bd_entry_offset(mm, end-1);
 	for (bd_entry = bde_start + 1; bd_entry < bde_end; bd_entry++) {
 		ret = get_bt_addr(mm, bd_entry, &bt_addr);
 		switch (ret) {
_
