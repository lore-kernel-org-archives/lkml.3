Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500Ab3D3Hxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:53:47 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:37013 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759184Ab3D3Hxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:53:46 -0400
Date: Tue, 30 Apr 2013 09:53:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86/cleanups for v3.10
Message-ID: <20130430075341.GA20718@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

   HEAD: d50ba3687b99213501463a1947e3dd5b98bc2d99 x86/lib: Fix spelling, put space between a numeral and its units

Misc smaller cleanups.

 Thanks,

	Ingo

------------------>
Andy Shevchenko (2):
      x86/lib: Fix spelling in the comments
      x86/lib: Fix spelling, put space between a numeral and its units

Borislav Petkov (4):
      x86: Drop KERNEL_IMAGE_START
      x86-64, docs, mm: Add vsyscall range to virtual address space layout
      x86, msr: Unify variable names
      x86, quirks: Shut-up a long-standing gcc warning

Lans Zhang (1):
      x86_64: Use __BOOT_DS instead_of __KERNEL_DS for safety


 Documentation/x86/x86_64/mm.txt      |  4 +++-
 arch/x86/boot/compressed/head_64.S   |  2 +-
 arch/x86/include/asm/msr.h           | 14 +++++++-------
 arch/x86/include/asm/page_64_types.h |  1 -
 arch/x86/kernel/head64.c             |  6 +++---
 arch/x86/kernel/quirks.c             | 18 +++++++++++-------
 arch/x86/lib/checksum_32.S           |  2 +-
 arch/x86/lib/memcpy_32.c             |  6 +++---
 arch/x86/lib/memcpy_64.S             |  2 +-
 arch/x86/lib/memmove_64.S            |  6 +++---
 10 files changed, 33 insertions(+), 28 deletions(-)

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index d6498e3..881582f 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -13,7 +13,9 @@ ffffe90000000000 - ffffe9ffffffffff (=40 bits) hole
 ffffea0000000000 - ffffeaffffffffff (=40 bits) virtual memory map (1TB)
 ... unused hole ...
 ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from phys 0
-ffffffffa0000000 - fffffffffff00000 (=1536 MB) module mapping space
+ffffffffa0000000 - ffffffffff5fffff (=1525 MB) module mapping space
+ffffffffff600000 - ffffffffffdfffff (=8 MB) vsyscalls
+ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
 
 The direct mapping covers all memory in the system up to the highest
 memory address (this means in some cases it can also include PCI memory
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index c1d383d..16f24e6 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -52,7 +52,7 @@ ENTRY(startup_32)
 	jnz 1f
 
 	cli
-	movl	$(__KERNEL_DS), %eax
+	movl	$(__BOOT_DS), %eax
 	movl	%eax, %ds
 	movl	%eax, %es
 	movl	%eax, %ss
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 9264802..cb75028 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -137,11 +137,11 @@ static inline unsigned long long native_read_pmc(int counter)
  * pointer indirection), this allows gcc to optimize better
  */
 
-#define rdmsr(msr, val1, val2)					\
+#define rdmsr(msr, low, high)					\
 do {								\
 	u64 __val = native_read_msr((msr));			\
-	(void)((val1) = (u32)__val);				\
-	(void)((val2) = (u32)(__val >> 32));			\
+	(void)((low) = (u32)__val);				\
+	(void)((high) = (u32)(__val >> 32));			\
 } while (0)
 
 static inline void wrmsr(unsigned msr, unsigned low, unsigned high)
@@ -162,12 +162,12 @@ static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
 }
 
 /* rdmsr with exception handling */
-#define rdmsr_safe(msr, p1, p2)					\
+#define rdmsr_safe(msr, low, high)				\
 ({								\
 	int __err;						\
 	u64 __val = native_read_msr_safe((msr), &__err);	\
-	(*p1) = (u32)__val;					\
-	(*p2) = (u32)(__val >> 32);				\
+	(*low) = (u32)__val;					\
+	(*high) = (u32)(__val >> 32);				\
 	__err;							\
 })
 
@@ -208,7 +208,7 @@ do {                                                            \
 #define wrmsrl_safe(msr, val) wrmsr_safe((msr), (u32)(val),		\
 					     (u32)((val) >> 32))
 
-#define write_tsc(val1, val2) wrmsr(MSR_IA32_TSC, (val1), (val2))
+#define write_tsc(low, high) wrmsr(MSR_IA32_TSC, (low), (high))
 
 #define write_rdtscp_aux(val) wrmsr(MSR_TSC_AUX, (val), 0)
 
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 8b491e6..6c896fb 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -48,6 +48,5 @@
  * arch/x86/kernel/head_64.S), and it is mapped here:
  */
 #define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
-#define KERNEL_IMAGE_START	_AC(0xffffffff80000000, UL)
 
 #endif /* _ASM_X86_PAGE_64_DEFS_H */
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index c5e403f..101ac1a9 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -144,10 +144,10 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	 * Build-time sanity checks on the kernel image and module
 	 * area mappings. (these are purely build-time and produce no code)
 	 */
-	BUILD_BUG_ON(MODULES_VADDR < KERNEL_IMAGE_START);
-	BUILD_BUG_ON(MODULES_VADDR-KERNEL_IMAGE_START < KERNEL_IMAGE_SIZE);
+	BUILD_BUG_ON(MODULES_VADDR < __START_KERNEL_map);
+	BUILD_BUG_ON(MODULES_VADDR - __START_KERNEL_map < KERNEL_IMAGE_SIZE);
 	BUILD_BUG_ON(MODULES_LEN + KERNEL_IMAGE_SIZE > 2*PUD_SIZE);
-	BUILD_BUG_ON((KERNEL_IMAGE_START & ~PMD_MASK) != 0);
+	BUILD_BUG_ON((__START_KERNEL_map & ~PMD_MASK) != 0);
 	BUILD_BUG_ON((MODULES_VADDR & ~PMD_MASK) != 0);
 	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
 	BUILD_BUG_ON(!(((MODULES_END - 1) & PGDIR_MASK) ==
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 26ee48a..04ee1e2 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -354,18 +354,22 @@ static void ati_force_hpet_resume(void)
 
 static u32 ati_ixp4x0_rev(struct pci_dev *dev)
 {
-	u32 d;
-	u8  b;
+	int err = 0;
+	u32 d = 0;
+	u8  b = 0;
 
-	pci_read_config_byte(dev, 0xac, &b);
+	err = pci_read_config_byte(dev, 0xac, &b);
 	b &= ~(1<<5);
-	pci_write_config_byte(dev, 0xac, b);
-	pci_read_config_dword(dev, 0x70, &d);
+	err |= pci_write_config_byte(dev, 0xac, b);
+	err |= pci_read_config_dword(dev, 0x70, &d);
 	d |= 1<<8;
-	pci_write_config_dword(dev, 0x70, d);
-	pci_read_config_dword(dev, 0x8, &d);
+	err |= pci_write_config_dword(dev, 0x70, d);
+	err |= pci_read_config_dword(dev, 0x8, &d);
 	d &= 0xff;
 	dev_printk(KERN_DEBUG, &dev->dev, "SB4X0 revision 0x%x\n", d);
+
+	WARN_ON_ONCE(err);
+
 	return d;
 }
 
diff --git a/arch/x86/lib/checksum_32.S b/arch/x86/lib/checksum_32.S
index 2af5df3..e78b8ee 100644
--- a/arch/x86/lib/checksum_32.S
+++ b/arch/x86/lib/checksum_32.S
@@ -61,7 +61,7 @@ ENTRY(csum_partial)
 	testl $3, %esi		# Check alignment.
 	jz 2f			# Jump if alignment is ok.
 	testl $1, %esi		# Check alignment.
-	jz 10f			# Jump if alignment is boundary of 2bytes.
+	jz 10f			# Jump if alignment is boundary of 2 bytes.
 
 	# buf is odd
 	dec %ecx
diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index b908a59..e78761d 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -26,7 +26,7 @@ void *memmove(void *dest, const void *src, size_t n)
 	char *ret = dest;
 
 	__asm__ __volatile__(
-		/* Handle more 16bytes in loop */
+		/* Handle more 16 bytes in loop */
 		"cmp $0x10, %0\n\t"
 		"jb	1f\n\t"
 
@@ -51,7 +51,7 @@ void *memmove(void *dest, const void *src, size_t n)
 		"sub $0x10, %0\n\t"
 
 		/*
-		 * We gobble 16byts forward in each loop.
+		 * We gobble 16 bytes forward in each loop.
 		 */
 		"3:\n\t"
 		"sub $0x10, %0\n\t"
@@ -117,7 +117,7 @@ void *memmove(void *dest, const void *src, size_t n)
 		"sub $0x10, %0\n\t"
 
 		/*
-		 * We gobble 16byts backward in each loop.
+		 * We gobble 16 bytes backward in each loop.
 		 */
 		"7:\n\t"
 		"sub $0x10, %0\n\t"
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 1c273be..56313a3 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -98,7 +98,7 @@ ENTRY(memcpy)
 	subq $0x20,	%rdx
 	/*
 	 * At most 3 ALU operations in one cycle,
-	 * so append NOPS in the same 16bytes trunk.
+	 * so append NOPS in the same 16 bytes trunk.
 	 */
 	.p2align 4
 .Lcopy_backward_loop:
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index ee16461..65268a6 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -27,7 +27,7 @@
 ENTRY(memmove)
 	CFI_STARTPROC
 
-	/* Handle more 32bytes in loop */
+	/* Handle more 32 bytes in loop */
 	mov %rdi, %rax
 	cmp $0x20, %rdx
 	jb	1f
@@ -56,7 +56,7 @@ ENTRY(memmove)
 3:
 	sub $0x20, %rdx
 	/*
-	 * We gobble 32byts forward in each loop.
+	 * We gobble 32 bytes forward in each loop.
 	 */
 5:
 	sub $0x20, %rdx
@@ -122,7 +122,7 @@ ENTRY(memmove)
 	addq %rdx, %rdi
 	subq $0x20, %rdx
 	/*
-	 * We gobble 32byts backward in each loop.
+	 * We gobble 32 bytes backward in each loop.
 	 */
 8:
 	subq $0x20, %rdx
