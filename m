Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaATT6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:58:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50661 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaATT6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:58:42 -0500
Date: Mon, 20 Jan 2014 11:57:44 -0800
Message-Id: <201401201957.s0KJviJE010135@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/cpufeature and mpx for v3.14
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Liu Jinsong <jinsong.liu@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Xudong Hao <xudong.hao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This includes the basic infrastructure for MPX (Memory Protection
Extensions) support, but does not include MPX support itself.  It is,
however, a prerequisite for KVM support for MPX, which I believe will
be pushed later this merge window by the KVM team.

This includes moving the functionality in
futex_atomic_cmpxchg_inatomic() into a new function in uaccess.h so it
can be reused - this will be used by the final MPX patches.

The actual MPX functionality (map management and so on) will be pushed
in a future merge window, when ready.

The following changes since commit dc1ccc48159d63eca5089e507c82c7d22ef60839:

  Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/mpx

The head of this tree is 741e3902cd89a7fbc04ae53f29a7ca0da452aa8e.

  x86/intel/mpx: Remove unused LWP structure (2014-01-20 19:57:39 +0100)

----------------------------------------------------------------
Ingo Molnar (1):
      x86/intel/mpx: Remove unused LWP structure

Qiaowei Ren (5):
      x86, cpufeature: Define the Intel MPX feature flag
      x86, xsave: Support eager-only xsave features, add MPX support
      x86: add user_atomic_cmpxchg_inatomic at uaccess.h
      x86: replace futex_atomic_cmpxchg_inatomic() with user_atomic_cmpxchg_inatomic
      x86, mpx: Add MPX related opcodes to the x86 opcode map

 arch/x86/include/asm/cpufeature.h |  1 +
 arch/x86/include/asm/futex.h      | 21 +--------
 arch/x86/include/asm/processor.h  | 17 ++++++++
 arch/x86/include/asm/uaccess.h    | 92 +++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/xsave.h      | 14 ++++--
 arch/x86/kernel/xsave.c           | 10 +++++
 arch/x86/lib/x86-opcode-map.txt   |  4 +-
 7 files changed, 133 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 89270b4318db..e099f9502ace 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -216,6 +216,7 @@
 #define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
 #define X86_FEATURE_INVPCID	(9*32+10) /* Invalidate Processor Context ID */
 #define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
+#define X86_FEATURE_MPX		(9*32+14) /* Memory Protection Extension */
 #define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
 #define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
index be27ba1e947a..b4c1f5453436 100644
--- a/arch/x86/include/asm/futex.h
+++ b/arch/x86/include/asm/futex.h
@@ -110,26 +110,7 @@ static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 						u32 oldval, u32 newval)
 {
-	int ret = 0;
-
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
-		return -EFAULT;
-
-	asm volatile("\t" ASM_STAC "\n"
-		     "1:\t" LOCK_PREFIX "cmpxchgl %4, %2\n"
-		     "2:\t" ASM_CLAC "\n"
-		     "\t.section .fixup, \"ax\"\n"
-		     "3:\tmov     %3, %0\n"
-		     "\tjmp     2b\n"
-		     "\t.previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : "+r" (ret), "=a" (oldval), "+m" (*uaddr)
-		     : "i" (-EFAULT), "r" (newval), "1" (oldval)
-		     : "memory"
-	);
-
-	*uval = oldval;
-	return ret;
+	return user_atomic_cmpxchg_inatomic(uval, uaddr, oldval, newval);
 }
 
 #endif
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7b034a4057f9..865c39910cc8 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -370,6 +370,20 @@ struct ymmh_struct {
 	u32 ymmh_space[64];
 };
 
+/* We don't support LWP yet: */
+struct lwp_struct {
+	u8 reserved[128];
+};
+
+struct bndregs_struct {
+	u64 bndregs[8];
+} __packed;
+
+struct bndcsr_struct {
+	u64 cfg_reg_u;
+	u64 status_reg;
+} __packed;
+
 struct xsave_hdr_struct {
 	u64 xstate_bv;
 	u64 reserved1[2];
@@ -380,6 +394,9 @@ struct xsave_struct {
 	struct i387_fxsave_struct i387;
 	struct xsave_hdr_struct xsave_hdr;
 	struct ymmh_struct ymmh;
+	struct lwp_struct lwp;
+	struct bndregs_struct bndregs;
+	struct bndcsr_struct bndcsr;
 	/* new processor state extensions will go here */
 } __attribute__ ((packed, aligned (64)));
 
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 8ec57c07b125..48ff83855268 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -525,6 +525,98 @@ extern __must_check long strnlen_user(const char __user *str, long n);
 unsigned long __must_check clear_user(void __user *mem, unsigned long len);
 unsigned long __must_check __clear_user(void __user *mem, unsigned long len);
 
+extern void __cmpxchg_wrong_size(void)
+	__compiletime_error("Bad argument size for cmpxchg");
+
+#define __user_atomic_cmpxchg_inatomic(uval, ptr, old, new, size)	\
+({									\
+	int __ret = 0;							\
+	__typeof__(ptr) __uval = (uval);				\
+	__typeof__(*(ptr)) __old = (old);				\
+	__typeof__(*(ptr)) __new = (new);				\
+	switch (size) {							\
+	case 1:								\
+	{								\
+		asm volatile("\t" ASM_STAC "\n"				\
+			"1:\t" LOCK_PREFIX "cmpxchgb %4, %2\n"		\
+			"2:\t" ASM_CLAC "\n"				\
+			"\t.section .fixup, \"ax\"\n"			\
+			"3:\tmov     %3, %0\n"				\
+			"\tjmp     2b\n"				\
+			"\t.previous\n"					\
+			_ASM_EXTABLE(1b, 3b)				\
+			: "+r" (__ret), "=a" (__old), "+m" (*(ptr))	\
+			: "i" (-EFAULT), "q" (__new), "1" (__old)	\
+			: "memory"					\
+		);							\
+		break;							\
+	}								\
+	case 2:								\
+	{								\
+		asm volatile("\t" ASM_STAC "\n"				\
+			"1:\t" LOCK_PREFIX "cmpxchgw %4, %2\n"		\
+			"2:\t" ASM_CLAC "\n"				\
+			"\t.section .fixup, \"ax\"\n"			\
+			"3:\tmov     %3, %0\n"				\
+			"\tjmp     2b\n"				\
+			"\t.previous\n"					\
+			_ASM_EXTABLE(1b, 3b)				\
+			: "+r" (__ret), "=a" (__old), "+m" (*(ptr))	\
+			: "i" (-EFAULT), "r" (__new), "1" (__old)	\
+			: "memory"					\
+		);							\
+		break;							\
+	}								\
+	case 4:								\
+	{								\
+		asm volatile("\t" ASM_STAC "\n"				\
+			"1:\t" LOCK_PREFIX "cmpxchgl %4, %2\n"		\
+			"2:\t" ASM_CLAC "\n"				\
+			"\t.section .fixup, \"ax\"\n"			\
+			"3:\tmov     %3, %0\n"				\
+			"\tjmp     2b\n"				\
+			"\t.previous\n"					\
+			_ASM_EXTABLE(1b, 3b)				\
+			: "+r" (__ret), "=a" (__old), "+m" (*(ptr))	\
+			: "i" (-EFAULT), "r" (__new), "1" (__old)	\
+			: "memory"					\
+		);							\
+		break;							\
+	}								\
+	case 8:								\
+	{								\
+		if (!IS_ENABLED(CONFIG_X86_64))				\
+			__cmpxchg_wrong_size();				\
+									\
+		asm volatile("\t" ASM_STAC "\n"				\
+			"1:\t" LOCK_PREFIX "cmpxchgq %4, %2\n"		\
+			"2:\t" ASM_CLAC "\n"				\
+			"\t.section .fixup, \"ax\"\n"			\
+			"3:\tmov     %3, %0\n"				\
+			"\tjmp     2b\n"				\
+			"\t.previous\n"					\
+			_ASM_EXTABLE(1b, 3b)				\
+			: "+r" (__ret), "=a" (__old), "+m" (*(ptr))	\
+			: "i" (-EFAULT), "r" (__new), "1" (__old)	\
+			: "memory"					\
+		);							\
+		break;							\
+	}								\
+	default:							\
+		__cmpxchg_wrong_size();					\
+	}								\
+	*__uval = __old;						\
+	__ret;								\
+})
+
+#define user_atomic_cmpxchg_inatomic(uval, ptr, old, new)		\
+({									\
+	access_ok(VERIFY_WRITE, (ptr), sizeof(*(ptr))) ?		\
+		__user_atomic_cmpxchg_inatomic((uval), (ptr),		\
+				(old), (new), sizeof(*(ptr))) :		\
+		-EFAULT;						\
+})
+
 /*
  * movsl can be slow when source and dest are not both 8-byte aligned
  */
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 0415cdabb5a6..554738963b28 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -9,6 +9,8 @@
 #define XSTATE_FP	0x1
 #define XSTATE_SSE	0x2
 #define XSTATE_YMM	0x4
+#define XSTATE_BNDREGS	0x8
+#define XSTATE_BNDCSR	0x10
 
 #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
 
@@ -20,10 +22,14 @@
 #define XSAVE_YMM_SIZE	    256
 #define XSAVE_YMM_OFFSET    (XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET)
 
-/*
- * These are the features that the OS can handle currently.
- */
-#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+/* Supported features which support lazy state saving */
+#define XSTATE_LAZY	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+
+/* Supported features which require eager state saving */
+#define XSTATE_EAGER	(XSTATE_BNDREGS | XSTATE_BNDCSR)
+
+/* All currently supported features */
+#define XCNTXT_MASK	(XSTATE_LAZY | XSTATE_EAGER)
 
 #ifdef CONFIG_X86_64
 #define REX_PREFIX	"0x48, "
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 422fd8223470..a4b451c6addf 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -562,6 +562,16 @@ static void __init xstate_enable_boot_cpu(void)
 	if (cpu_has_xsaveopt && eagerfpu != DISABLE)
 		eagerfpu = ENABLE;
 
+	if (pcntxt_mask & XSTATE_EAGER) {
+		if (eagerfpu == DISABLE) {
+			pr_err("eagerfpu not present, disabling some xstate features: 0x%llx\n",
+					pcntxt_mask & XSTATE_EAGER);
+			pcntxt_mask &= ~XSTATE_EAGER;
+		} else {
+			eagerfpu = ENABLE;
+		}
+	}
+
 	pr_info("enabled xstate_bv 0x%llx, cntxt size 0x%x\n",
 		pcntxt_mask, xstate_size);
 }
diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 533a85e3a07e..1a2be7c6895d 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -346,8 +346,8 @@ AVXcode: 1
 17: vmovhps Mq,Vq (v1) | vmovhpd Mq,Vq (66),(v1)
 18: Grp16 (1A)
 19:
-1a:
-1b:
+1a: BNDCL Ev,Gv | BNDCU Ev,Gv | BNDMOV Gv,Ev | BNDLDX Gv,Ev,Gv
+1b: BNDCN Ev,Gv | BNDMOV Ev,Gv | BNDMK Gv,Ev | BNDSTX Ev,GV,Gv
 1c:
 1d:
 1e:
