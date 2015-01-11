Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbbAKIwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 03:52:09 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:55215 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbbAKIwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:52:04 -0500
Date: Sun, 11 Jan 2015 09:51:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20150111085157.GA2277@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   # HEAD: 2aba73a6146bb85d4a42386ca41dec0f4aa4b3ad Merge tag 'pr-20141223-x86-vdso' of git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux into x86/urgent

Misc fixes: two vdso fixes, two kbuild fixes and a boot failure 
fix with certain odd memory mappings.

 Thanks,

	Ingo

------------------>
Andy Lutomirski (2):
      x86_64, vdso: Fix the vdso address randomization algorithm
      x86, vdso: Use asm volatile in __getcpu

Bjørn Mork (1):
      x86/build: Clean auto-generated processor feature files

Jan Beulich (1):
      x86: Fix step size adjustment during initial memory mapping

Sylvain BERTRAND (1):
      x86: Fix mkcapflags.sh bash-ism


 arch/x86/boot/Makefile            |  1 +
 arch/x86/include/asm/vgtod.h      |  6 ++++--
 arch/x86/kernel/cpu/Makefile      |  1 +
 arch/x86/kernel/cpu/mkcapflags.sh |  2 +-
 arch/x86/mm/init.c                | 37 +++++++++++++++-----------------
 arch/x86/vdso/vma.c               | 45 +++++++++++++++++++++++++--------------
 6 files changed, 53 insertions(+), 39 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 5b016e2498f3..3db07f30636f 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -51,6 +51,7 @@ targets += cpustr.h
 $(obj)/cpustr.h: $(obj)/mkcpustr FORCE
 	$(call if_changed,cpustr)
 endif
+clean-files += cpustr.h
 
 # ---------------------------------------------------------------------------
 
diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index e7e9682a33e9..f556c4843aa1 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -80,9 +80,11 @@ static inline unsigned int __getcpu(void)
 
 	/*
 	 * Load per CPU data from GDT.  LSL is faster than RDTSCP and
-	 * works on all CPUs.
+	 * works on all CPUs.  This is volatile so that it orders
+	 * correctly wrt barrier() and to keep gcc from cleverly
+	 * hoisting it out of the calling function.
 	 */
-	asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
+	asm volatile ("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
 
 	return p;
 }
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index e27b49d7c922..80091ae54c2b 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -66,3 +66,4 @@ targets += capflags.c
 $(obj)/capflags.c: $(cpufeature) $(src)/mkcapflags.sh FORCE
 	$(call if_changed,mkcapflags)
 endif
+clean-files += capflags.c
diff --git a/arch/x86/kernel/cpu/mkcapflags.sh b/arch/x86/kernel/cpu/mkcapflags.sh
index e2b22df964cd..36d99a337b49 100644
--- a/arch/x86/kernel/cpu/mkcapflags.sh
+++ b/arch/x86/kernel/cpu/mkcapflags.sh
@@ -28,7 +28,7 @@ function dump_array()
 		# If the /* comment */ starts with a quote string, grab that.
 		VALUE="$(echo "$i" | sed -n 's@.*/\* *\("[^"]*"\).*\*/@\1@p')"
 		[ -z "$VALUE" ] && VALUE="\"$NAME\""
-		[ "$VALUE" == '""' ] && continue
+		[ "$VALUE" = '""' ] && continue
 
 		# Name is uppercase, VALUE is all lowercase
 		VALUE="$(echo "$VALUE" | tr A-Z a-z)"
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index a97ee0801475..08a7d313538a 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -438,20 +438,20 @@ static unsigned long __init init_range_memory_mapping(
 static unsigned long __init get_new_step_size(unsigned long step_size)
 {
 	/*
-	 * Explain why we shift by 5 and why we don't have to worry about
-	 * 'step_size << 5' overflowing:
-	 *
-	 * initial mapped size is PMD_SIZE (2M).
+	 * Initial mapped size is PMD_SIZE (2M).
 	 * We can not set step_size to be PUD_SIZE (1G) yet.
 	 * In worse case, when we cross the 1G boundary, and
 	 * PG_LEVEL_2M is not set, we will need 1+1+512 pages (2M + 8k)
-	 * to map 1G range with PTE. Use 5 as shift for now.
+	 * to map 1G range with PTE. Hence we use one less than the
+	 * difference of page table level shifts.
 	 *
-	 * Don't need to worry about overflow, on 32bit, when step_size
-	 * is 0, round_down() returns 0 for start, and that turns it
-	 * into 0x100000000ULL.
+	 * Don't need to worry about overflow in the top-down case, on 32bit,
+	 * when step_size is 0, round_down() returns 0 for start, and that
+	 * turns it into 0x100000000ULL.
+	 * In the bottom-up case, round_up(x, 0) returns 0 though too, which
+	 * needs to be taken into consideration by the code below.
 	 */
-	return step_size << 5;
+	return step_size << (PMD_SHIFT - PAGE_SHIFT - 1);
 }
 
 /**
@@ -471,7 +471,6 @@ static void __init memory_map_top_down(unsigned long map_start,
 	unsigned long step_size;
 	unsigned long addr;
 	unsigned long mapped_ram_size = 0;
-	unsigned long new_mapped_ram_size;
 
 	/* xen has big range in reserved near end of ram, skip it at first.*/
 	addr = memblock_find_in_range(map_start, map_end, PMD_SIZE, PMD_SIZE);
@@ -496,14 +495,12 @@ static void __init memory_map_top_down(unsigned long map_start,
 				start = map_start;
 		} else
 			start = map_start;
-		new_mapped_ram_size = init_range_memory_mapping(start,
+		mapped_ram_size += init_range_memory_mapping(start,
 							last_start);
 		last_start = start;
 		min_pfn_mapped = last_start >> PAGE_SHIFT;
-		/* only increase step_size after big range get mapped */
-		if (new_mapped_ram_size > mapped_ram_size)
+		if (mapped_ram_size >= step_size)
 			step_size = get_new_step_size(step_size);
-		mapped_ram_size += new_mapped_ram_size;
 	}
 
 	if (real_end < map_end)
@@ -524,7 +521,7 @@ static void __init memory_map_top_down(unsigned long map_start,
 static void __init memory_map_bottom_up(unsigned long map_start,
 					unsigned long map_end)
 {
-	unsigned long next, new_mapped_ram_size, start;
+	unsigned long next, start;
 	unsigned long mapped_ram_size = 0;
 	/* step_size need to be small so pgt_buf from BRK could cover it */
 	unsigned long step_size = PMD_SIZE;
@@ -539,19 +536,19 @@ static void __init memory_map_bottom_up(unsigned long map_start,
 	 * for page table.
 	 */
 	while (start < map_end) {
-		if (map_end - start > step_size) {
+		if (step_size && map_end - start > step_size) {
 			next = round_up(start + 1, step_size);
 			if (next > map_end)
 				next = map_end;
-		} else
+		} else {
 			next = map_end;
+		}
 
-		new_mapped_ram_size = init_range_memory_mapping(start, next);
+		mapped_ram_size += init_range_memory_mapping(start, next);
 		start = next;
 
-		if (new_mapped_ram_size > mapped_ram_size)
+		if (mapped_ram_size >= step_size)
 			step_size = get_new_step_size(step_size);
-		mapped_ram_size += new_mapped_ram_size;
 	}
 }
 
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 009495b9ab4b..1c9f750c3859 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -41,12 +41,17 @@ void __init init_vdso_image(const struct vdso_image *image)
 
 struct linux_binprm;
 
-/* Put the vdso above the (randomized) stack with another randomized offset.
-   This way there is no hole in the middle of address space.
-   To save memory make sure it is still in the same PTE as the stack top.
-   This doesn't give that many random bits.
-
-   Only used for the 64-bit and x32 vdsos. */
+/*
+ * Put the vdso above the (randomized) stack with another randomized
+ * offset.  This way there is no hole in the middle of address space.
+ * To save memory make sure it is still in the same PTE as the stack
+ * top.  This doesn't give that many random bits.
+ *
+ * Note that this algorithm is imperfect: the distribution of the vdso
+ * start address within a PMD is biased toward the end.
+ *
+ * Only used for the 64-bit and x32 vdsos.
+ */
 static unsigned long vdso_addr(unsigned long start, unsigned len)
 {
 #ifdef CONFIG_X86_32
@@ -54,22 +59,30 @@ static unsigned long vdso_addr(unsigned long start, unsigned len)
 #else
 	unsigned long addr, end;
 	unsigned offset;
-	end = (start + PMD_SIZE - 1) & PMD_MASK;
+
+	/*
+	 * Round up the start address.  It can start out unaligned as a result
+	 * of stack start randomization.
+	 */
+	start = PAGE_ALIGN(start);
+
+	/* Round the lowest possible end address up to a PMD boundary. */
+	end = (start + len + PMD_SIZE - 1) & PMD_MASK;
 	if (end >= TASK_SIZE_MAX)
 		end = TASK_SIZE_MAX;
 	end -= len;
-	/* This loses some more bits than a modulo, but is cheaper */
-	offset = get_random_int() & (PTRS_PER_PTE - 1);
-	addr = start + (offset << PAGE_SHIFT);
-	if (addr >= end)
-		addr = end;
+
+	if (end > start) {
+		offset = get_random_int() % (((end - start) >> PAGE_SHIFT) + 1);
+		addr = start + (offset << PAGE_SHIFT);
+	} else {
+		addr = start;
+	}
 
 	/*
-	 * page-align it here so that get_unmapped_area doesn't
-	 * align it wrongfully again to the next page. addr can come in 4K
-	 * unaligned here as a result of stack start randomization.
+	 * Forcibly align the final address in case we have a hardware
+	 * issue that requires alignment for performance reasons.
 	 */
-	addr = PAGE_ALIGN(addr);
 	addr = align_vdso_addr(addr);
 
 	return addr;
