Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190Ab3ICO17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:27:59 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:47275 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3ICO15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:27:57 -0400
Date: Tue, 3 Sep 2013 16:27:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm changes for v3.12
Message-ID: <20130903142753.GA28133@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asm-for-linus

   HEAD: f69fa9a91f60fff6f2d8b658b7d84d235d9d89b7 x86, doc: Update uaccess.h comment to reflect clang changes

Main changes:

 - Apply low level mutex optimization on x86-64, by Wedson Almeida Filho.

 - Change bitops to be naturally 'long', by H. Peter Anvin.

 - Add TSX-NI opcodes support to the x86 (instrumentation) decoder,
   by Masami Hiramatsu.

 - Add clang compatibility adjustments/workarounds, by Jan-Simon Möller.

 Thanks,

	Ingo

------------------>
H. Peter Anvin (2):
      x86, bitops: Change bitops to be native operand size
      x86, doc: Update uaccess.h comment to reflect clang changes

Jan-Simon Möller (2):
      x86, asm: Extend definitions of _ASM_* with a raw format
      x86, asm: Fix a compilation issue with clang

Masami Hiramatsu (1):
      x86, insn: Add new opcodes as of June, 2013

Ramkumar Ramachandra (1):
      x86/ia32/asm: Remove unused argument in macro

Wedson Almeida Filho (1):
      x86: Use asm-goto to implement mutex fast path on x86-64


 arch/x86/ia32/ia32entry.S            |  2 +-
 arch/x86/include/asm/asm.h           |  6 ++++-
 arch/x86/include/asm/bitops.h        | 46 +++++++++++++++++++++---------------
 arch/x86/include/asm/mutex_64.h      | 30 +++++++++++++++++++++++
 arch/x86/include/asm/sync_bitops.h   | 24 +++++++++----------
 arch/x86/include/asm/uaccess.h       |  7 ++++--
 arch/x86/lib/x86-opcode-map.txt      | 42 ++++++++++++++++++--------------
 arch/x86/tools/gen-insn-attr-x86.awk |  4 +++-
 8 files changed, 107 insertions(+), 54 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 474dc1b..4299eb0 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -452,7 +452,7 @@ ia32_badsys:
 
 	CFI_ENDPROC
 	
-	.macro PTREGSCALL label, func, arg
+	.macro PTREGSCALL label, func
 	ALIGN
 GLOBAL(\label)
 	leaq \func(%rip),%rax
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 1c2d247..4582e8e 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -3,21 +3,25 @@
 
 #ifdef __ASSEMBLY__
 # define __ASM_FORM(x)	x
+# define __ASM_FORM_RAW(x)     x
 # define __ASM_FORM_COMMA(x) x,
 #else
 # define __ASM_FORM(x)	" " #x " "
+# define __ASM_FORM_RAW(x)     #x
 # define __ASM_FORM_COMMA(x) " " #x ","
 #endif
 
 #ifdef CONFIG_X86_32
 # define __ASM_SEL(a,b) __ASM_FORM(a)
+# define __ASM_SEL_RAW(a,b) __ASM_FORM_RAW(a)
 #else
 # define __ASM_SEL(a,b) __ASM_FORM(b)
+# define __ASM_SEL_RAW(a,b) __ASM_FORM_RAW(b)
 #endif
 
 #define __ASM_SIZE(inst, ...)	__ASM_SEL(inst##l##__VA_ARGS__, \
 					  inst##q##__VA_ARGS__)
-#define __ASM_REG(reg)		__ASM_SEL(e##reg, r##reg)
+#define __ASM_REG(reg)         __ASM_SEL_RAW(e##reg, r##reg)
 
 #define _ASM_PTR	__ASM_SEL(.long, .quad)
 #define _ASM_ALIGN	__ASM_SEL(.balign 4, .balign 8)
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 6dfd019..41639ce 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -15,6 +15,14 @@
 #include <linux/compiler.h>
 #include <asm/alternative.h>
 
+#if BITS_PER_LONG == 32
+# define _BITOPS_LONG_SHIFT 5
+#elif BITS_PER_LONG == 64
+# define _BITOPS_LONG_SHIFT 6
+#else
+# error "Unexpected BITS_PER_LONG"
+#endif
+
 #define BIT_64(n)			(U64_C(1) << (n))
 
 /*
@@ -59,7 +67,7 @@
  * restricted to acting on a single-word quantity.
  */
 static __always_inline void
-set_bit(unsigned int nr, volatile unsigned long *addr)
+set_bit(long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "orb %1,%0"
@@ -81,7 +89,7 @@ set_bit(unsigned int nr, volatile unsigned long *addr)
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __set_bit(int nr, volatile unsigned long *addr)
+static inline void __set_bit(long nr, volatile unsigned long *addr)
 {
 	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
@@ -97,7 +105,7 @@ static inline void __set_bit(int nr, volatile unsigned long *addr)
  * in order to ensure changes are visible on other processors.
  */
 static __always_inline void
-clear_bit(int nr, volatile unsigned long *addr)
+clear_bit(long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "andb %1,%0"
@@ -118,13 +126,13 @@ clear_bit(int nr, volatile unsigned long *addr)
  * clear_bit() is atomic and implies release semantics before the memory
  * operation. It can be used for an unlock.
  */
-static inline void clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
+static inline void clear_bit_unlock(long nr, volatile unsigned long *addr)
 {
 	barrier();
 	clear_bit(nr, addr);
 }
 
-static inline void __clear_bit(int nr, volatile unsigned long *addr)
+static inline void __clear_bit(long nr, volatile unsigned long *addr)
 {
 	asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
 }
@@ -141,7 +149,7 @@ static inline void __clear_bit(int nr, volatile unsigned long *addr)
  * No memory barrier is required here, because x86 cannot reorder stores past
  * older loads. Same principle as spin_unlock.
  */
-static inline void __clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
+static inline void __clear_bit_unlock(long nr, volatile unsigned long *addr)
 {
 	barrier();
 	__clear_bit(nr, addr);
@@ -159,7 +167,7 @@ static inline void __clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __change_bit(int nr, volatile unsigned long *addr)
+static inline void __change_bit(long nr, volatile unsigned long *addr)
 {
 	asm volatile("btc %1,%0" : ADDR : "Ir" (nr));
 }
@@ -173,7 +181,7 @@ static inline void __change_bit(int nr, volatile unsigned long *addr)
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void change_bit(int nr, volatile unsigned long *addr)
+static inline void change_bit(long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "xorb %1,%0"
@@ -194,7 +202,7 @@ static inline void change_bit(int nr, volatile unsigned long *addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_set_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -212,7 +220,7 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
  * This is the same as test_and_set_bit on x86.
  */
 static __always_inline int
-test_and_set_bit_lock(int nr, volatile unsigned long *addr)
+test_and_set_bit_lock(long nr, volatile unsigned long *addr)
 {
 	return test_and_set_bit(nr, addr);
 }
@@ -226,7 +234,7 @@ test_and_set_bit_lock(int nr, volatile unsigned long *addr)
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_set_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -245,7 +253,7 @@ static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -272,7 +280,7 @@ static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
  * accessed from a hypervisor on the same CPU if running in a VM: don't change
  * this without also updating arch/x86/kernel/kvm.c
  */
-static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -284,7 +292,7 @@ static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 }
 
 /* WARNING: non atomic and it can be reordered! */
-static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_change_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -304,7 +312,7 @@ static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_change_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -315,13 +323,13 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 	return oldbit;
 }
 
-static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
+static __always_inline int constant_test_bit(long nr, const volatile unsigned long *addr)
 {
-	return ((1UL << (nr % BITS_PER_LONG)) &
-		(addr[nr / BITS_PER_LONG])) != 0;
+	return ((1UL << (nr & (BITS_PER_LONG-1))) &
+		(addr[nr >> _BITOPS_LONG_SHIFT])) != 0;
 }
 
-static inline int variable_test_bit(int nr, volatile const unsigned long *addr)
+static inline int variable_test_bit(long nr, volatile const unsigned long *addr)
 {
 	int oldbit;
 
diff --git a/arch/x86/include/asm/mutex_64.h b/arch/x86/include/asm/mutex_64.h
index 68a87b0..c030bee 100644
--- a/arch/x86/include/asm/mutex_64.h
+++ b/arch/x86/include/asm/mutex_64.h
@@ -16,6 +16,20 @@
  *
  * Atomically decrements @v and calls <fail_fn> if the result is negative.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline void __mutex_fastpath_lock(atomic_t *v,
+					 void (*fail_fn)(atomic_t *))
+{
+	asm volatile goto(LOCK_PREFIX "   decl %0\n"
+			  "   jns %l[exit]\n"
+			  : : "m" (v->counter)
+			  : "memory", "cc"
+			  : exit);
+	fail_fn(v);
+exit:
+	return;
+}
+#else
 #define __mutex_fastpath_lock(v, fail_fn)			\
 do {								\
 	unsigned long dummy;					\
@@ -32,6 +46,7 @@ do {								\
 		     : "rax", "rsi", "rdx", "rcx",		\
 		       "r8", "r9", "r10", "r11", "memory");	\
 } while (0)
+#endif
 
 /**
  *  __mutex_fastpath_lock_retval - try to take the lock by moving the count
@@ -59,6 +74,20 @@ static inline int __mutex_fastpath_lock_retval(atomic_t *count,
  *
  * Atomically increments @v and calls <fail_fn> if the result is nonpositive.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline void __mutex_fastpath_unlock(atomic_t *v,
+					   void (*fail_fn)(atomic_t *))
+{
+	asm volatile goto(LOCK_PREFIX "   incl %0\n"
+			  "   jg %l[exit]\n"
+			  : : "m" (v->counter)
+			  : "memory", "cc"
+			  : exit);
+	fail_fn(v);
+exit:
+	return;
+}
+#else
 #define __mutex_fastpath_unlock(v, fail_fn)			\
 do {								\
 	unsigned long dummy;					\
@@ -75,6 +104,7 @@ do {								\
 		     : "rax", "rsi", "rdx", "rcx",		\
 		       "r8", "r9", "r10", "r11", "memory");	\
 } while (0)
+#endif
 
 #define __mutex_slowpath_needs_to_unlock()	1
 
diff --git a/arch/x86/include/asm/sync_bitops.h b/arch/x86/include/asm/sync_bitops.h
index 9d09b40..05af3b3 100644
--- a/arch/x86/include/asm/sync_bitops.h
+++ b/arch/x86/include/asm/sync_bitops.h
@@ -26,9 +26,9 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void sync_set_bit(int nr, volatile unsigned long *addr)
+static inline void sync_set_bit(long nr, volatile unsigned long *addr)
 {
-	asm volatile("lock; btsl %1,%0"
+	asm volatile("lock; bts %1,%0"
 		     : "+m" (ADDR)
 		     : "Ir" (nr)
 		     : "memory");
@@ -44,9 +44,9 @@ static inline void sync_set_bit(int nr, volatile unsigned long *addr)
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void sync_clear_bit(int nr, volatile unsigned long *addr)
+static inline void sync_clear_bit(long nr, volatile unsigned long *addr)
 {
-	asm volatile("lock; btrl %1,%0"
+	asm volatile("lock; btr %1,%0"
 		     : "+m" (ADDR)
 		     : "Ir" (nr)
 		     : "memory");
@@ -61,9 +61,9 @@ static inline void sync_clear_bit(int nr, volatile unsigned long *addr)
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void sync_change_bit(int nr, volatile unsigned long *addr)
+static inline void sync_change_bit(long nr, volatile unsigned long *addr)
 {
-	asm volatile("lock; btcl %1,%0"
+	asm volatile("lock; btc %1,%0"
 		     : "+m" (ADDR)
 		     : "Ir" (nr)
 		     : "memory");
@@ -77,11 +77,11 @@ static inline void sync_change_bit(int nr, volatile unsigned long *addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int sync_test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int sync_test_and_set_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	asm volatile("lock; btsl %2,%1\n\tsbbl %0,%0"
+	asm volatile("lock; bts %2,%1\n\tsbbl %0,%0"
 		     : "=r" (oldbit), "+m" (ADDR)
 		     : "Ir" (nr) : "memory");
 	return oldbit;
@@ -95,11 +95,11 @@ static inline int sync_test_and_set_bit(int nr, volatile unsigned long *addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int sync_test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int sync_test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	asm volatile("lock; btrl %2,%1\n\tsbbl %0,%0"
+	asm volatile("lock; btr %2,%1\n\tsbbl %0,%0"
 		     : "=r" (oldbit), "+m" (ADDR)
 		     : "Ir" (nr) : "memory");
 	return oldbit;
@@ -113,11 +113,11 @@ static inline int sync_test_and_clear_bit(int nr, volatile unsigned long *addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int sync_test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int sync_test_and_change_bit(long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	asm volatile("lock; btcl %2,%1\n\tsbbl %0,%0"
+	asm volatile("lock; btc %2,%1\n\tsbbl %0,%0"
 		     : "=r" (oldbit), "+m" (ADDR)
 		     : "Ir" (nr) : "memory");
 	return oldbit;
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 5ee2687..5838fa9 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -153,16 +153,19 @@ __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
  * Careful: we have to cast the result to the type of the pointer
  * for sign reasons.
  *
- * The use of %edx as the register specifier is a bit of a
+ * The use of _ASM_DX as the register specifier is a bit of a
  * simplification, as gcc only cares about it as the starting point
  * and not size: for a 64-bit value it will use %ecx:%edx on 32 bits
  * (%ecx being the next register in gcc's x86 register sequence), and
  * %rdx on 64 bits.
+ *
+ * Clang/LLVM cares about the size of the register, but still wants
+ * the base register for something that ends up being a pair.
  */
 #define get_user(x, ptr)						\
 ({									\
 	int __ret_gu;							\
-	register __inttype(*(ptr)) __val_gu asm("%edx");		\
+	register __inttype(*(ptr)) __val_gu asm("%"_ASM_DX);		\
 	__chk_user_ptr(ptr);						\
 	might_fault();							\
 	asm volatile("call __get_user_%P3"				\
diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 5d7e51f..533a85e 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -1,10 +1,8 @@
 # x86 Opcode Maps
 #
 # This is (mostly) based on following documentations.
-# - Intel(R) 64 and IA-32 Architectures Software Developer's Manual Vol.2
-#   (#325383-040US, October 2011)
-# - Intel(R) Advanced Vector Extensions Programming Reference
-#   (#319433-011,JUNE 2011).
+# - Intel(R) 64 and IA-32 Architectures Software Developer's Manual Vol.2C
+#   (#326018-047US, June 2013)
 #
 #<Opcode maps>
 # Table: table-name
@@ -29,6 +27,7 @@
 #  - (F3): the last prefix is 0xF3
 #  - (F2): the last prefix is 0xF2
 #  - (!F3) : the last prefix is not 0xF3 (including non-last prefix case)
+#  - (66&F2): Both 0x66 and 0xF2 prefixes are specified.
 
 Table: one byte opcode
 Referrer:
@@ -246,8 +245,8 @@ c2: RETN Iw (f64)
 c3: RETN
 c4: LES Gz,Mp (i64) | VEX+2byte (Prefix)
 c5: LDS Gz,Mp (i64) | VEX+1byte (Prefix)
-c6: Grp11 Eb,Ib (1A)
-c7: Grp11 Ev,Iz (1A)
+c6: Grp11A Eb,Ib (1A)
+c7: Grp11B Ev,Iz (1A)
 c8: ENTER Iw,Ib
 c9: LEAVE (d64)
 ca: RETF Iw
@@ -293,8 +292,8 @@ ef: OUT DX,eAX
 # 0xf0 - 0xff
 f0: LOCK (Prefix)
 f1:
-f2: REPNE (Prefix)
-f3: REP/REPE (Prefix)
+f2: REPNE (Prefix) | XACQUIRE (Prefix)
+f3: REP/REPE (Prefix) | XRELEASE (Prefix)
 f4: HLT
 f5: CMC
 f6: Grp3_1 Eb (1A)
@@ -326,7 +325,8 @@ AVXcode: 1
 0a:
 0b: UD2 (1B)
 0c:
-0d: NOP Ev | GrpP
+# AMD's prefetch group. Intel supports prefetchw(/1) only.
+0d: GrpP
 0e: FEMMS
 # 3DNow! uses the last imm byte as opcode extension.
 0f: 3DNow! Pq,Qq,Ib
@@ -729,12 +729,12 @@ dc: VAESENC Vdq,Hdq,Wdq (66),(v1)
 dd: VAESENCLAST Vdq,Hdq,Wdq (66),(v1)
 de: VAESDEC Vdq,Hdq,Wdq (66),(v1)
 df: VAESDECLAST Vdq,Hdq,Wdq (66),(v1)
-f0: MOVBE Gy,My | MOVBE Gw,Mw (66) | CRC32 Gd,Eb (F2)
-f1: MOVBE My,Gy | MOVBE Mw,Gw (66) | CRC32 Gd,Ey (F2)
+f0: MOVBE Gy,My | MOVBE Gw,Mw (66) | CRC32 Gd,Eb (F2) | CRC32 Gd,Eb (66&F2)
+f1: MOVBE My,Gy | MOVBE Mw,Gw (66) | CRC32 Gd,Ey (F2) | CRC32 Gd,Ew (66&F2)
 f2: ANDN Gy,By,Ey (v)
 f3: Grp17 (1A)
 f5: BZHI Gy,Ey,By (v) | PEXT Gy,By,Ey (F3),(v) | PDEP Gy,By,Ey (F2),(v)
-f6: MULX By,Gy,rDX,Ey (F2),(v)
+f6: ADCX Gy,Ey (66) | ADOX Gy,Ey (F3) | MULX By,Gy,rDX,Ey (F2),(v)
 f7: BEXTR Gy,Ey,By (v) | SHLX Gy,Ey,By (66),(v) | SARX Gy,Ey,By (F3),(v) | SHRX Gy,Ey,By (F2),(v)
 EndTable
 
@@ -861,8 +861,8 @@ EndTable
 
 GrpTable: Grp7
 0: SGDT Ms | VMCALL (001),(11B) | VMLAUNCH (010),(11B) | VMRESUME (011),(11B) | VMXOFF (100),(11B)
-1: SIDT Ms | MONITOR (000),(11B) | MWAIT (001)
-2: LGDT Ms | XGETBV (000),(11B) | XSETBV (001),(11B) | VMFUNC (100),(11B)
+1: SIDT Ms | MONITOR (000),(11B) | MWAIT (001),(11B) | CLAC (010),(11B) | STAC (011),(11B)
+2: LGDT Ms | XGETBV (000),(11B) | XSETBV (001),(11B) | VMFUNC (100),(11B) | XEND (101)(11B) | XTEST (110)(11B)
 3: LIDT Ms
 4: SMSW Mw/Rv
 5:
@@ -880,15 +880,21 @@ EndTable
 GrpTable: Grp9
 1: CMPXCHG8B/16B Mq/Mdq
 6: VMPTRLD Mq | VMCLEAR Mq (66) | VMXON Mq (F3) | RDRAND Rv (11B)
-7: VMPTRST Mq | VMPTRST Mq (F3)
+7: VMPTRST Mq | VMPTRST Mq (F3) | RDSEED Rv (11B)
 EndTable
 
 GrpTable: Grp10
 EndTable
 
-GrpTable: Grp11
-# Note: the operands are given by group opcode
-0: MOV
+# Grp11A and Grp11B are expressed as Grp11 in Intel SDM
+GrpTable: Grp11A
+0: MOV Eb,Ib
+7: XABORT Ib (000),(11B)
+EndTable
+
+GrpTable: Grp11B
+0: MOV Eb,Iz
+7: XBEGIN Jz (000),(11B)
 EndTable
 
 GrpTable: Grp12
diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index e6773dc..093a892 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -68,7 +68,7 @@ BEGIN {
 
 	lprefix1_expr = "\\((66|!F3)\\)"
 	lprefix2_expr = "\\(F3\\)"
-	lprefix3_expr = "\\((F2|!F3)\\)"
+	lprefix3_expr = "\\((F2|!F3|66\\&F2)\\)"
 	lprefix_expr = "\\((66|F2|F3)\\)"
 	max_lprefix = 4
 
@@ -83,6 +83,8 @@ BEGIN {
 	prefix_num["Operand-Size"] = "INAT_PFX_OPNDSZ"
 	prefix_num["REPNE"] = "INAT_PFX_REPNE"
 	prefix_num["REP/REPE"] = "INAT_PFX_REPE"
+	prefix_num["XACQUIRE"] = "INAT_PFX_REPNE"
+	prefix_num["XRELEASE"] = "INAT_PFX_REPE"
 	prefix_num["LOCK"] = "INAT_PFX_LOCK"
 	prefix_num["SEG=CS"] = "INAT_PFX_CS"
 	prefix_num["SEG=DS"] = "INAT_PFX_DS"
