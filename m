Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123Ab3JPMAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:00:38 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:52120 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760492Ab3JPMAg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Wed, 16 Oct 2013 08:00:36 -0400
Message-Id: <525E9BFF02000078000FB74E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 16 Oct 2013 13:00:31 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH, RFC] x86-64: properly handle FPU code/data selectors
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having had reports of certain Windows versions, when put in some
special driver verification mode, blue-screening due to the FPU state
having changed across interrupt handler runs (resulting from a host/
hypervisor side context switch somewhere in the middle of the guest
interrupt handler execution) on Xen, and assuming that KVM would suffer
from the same problem, as well as having also noticed (long ago) that
32-bit processes don't behave correctly in this regard when run on a
64-bit kernel, this is the resulting attempt to port (and suitably
extend) the Xen side fix to Linux.

The basic idea here is to either use a priori information on the
intended state layout (in the case of 32-bit processes) or "sense" the
proper layout (in the case of KVM guests) by inspecting the already
saved FPU rip/rdp, and reading their actual values in a second save
operation.

This second save operation could be another [F]XSAVE, but on all
systems I measured this on using FNSTENV turned out to be the faster
alternative.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/include/asm/cpufeature.h   |    1 
 arch/x86/include/asm/fpu-internal.h |   77 +++++++++----
 arch/x86/include/asm/processor.h    |    1 
 arch/x86/include/asm/xsave.h        |  207 +++++++++++++++++++++++++-----------
 arch/x86/kernel/i387.c              |   29 +++++
 arch/x86/kernel/xsave.c             |   35 +++---
 arch/x86/kvm/x86.c                  |    2 
 7 files changed, 255 insertions(+), 97 deletions(-)

--- 3.12-rc5/arch/x86/include/asm/cpufeature.h
+++ 3.12-rc5-x86-FPU-preserve-selectors/arch/x86/include/asm/cpufeature.h
@@ -216,6 +216,7 @@
 #define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
 #define X86_FEATURE_INVPCID	(9*32+10) /* Invalidate Processor Context ID */
 #define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
+#define X86_FEATURE_NO_FPU_SEL	(9*32+13) /* FPU CS/DS stored as zero */
 #define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
 #define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
--- 3.12-rc5/arch/x86/include/asm/fpu-internal.h
+++ 3.12-rc5-x86-FPU-preserve-selectors/arch/x86/include/asm/fpu-internal.h
@@ -67,6 +67,17 @@ extern void finit_soft_fpu(struct i387_s
 static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
 #endif
 
+struct ix87_env {
+	u16 fcw, _res0;
+	u16 fsw, _res1;
+	u16 ftw, _res2;
+	u32 fip;
+	u16 fcs;
+	u16 fop;
+	u32 foo;
+	u16 fos, _res3;
+};
+
 static inline int is_ia32_compat_frame(void)
 {
 	return config_enabled(CONFIG_IA32_EMULATION) &&
@@ -157,9 +168,10 @@ static inline int fsave_user(struct i387
 	return user_insn(fnsave %[fx]; fwait,  [fx] "=m" (*fx), "m" (*fx));
 }
 
-static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
+static inline int fxsave_user(struct i387_fxsave_struct __user *fx,
+			      unsigned int word_size)
 {
-	if (config_enabled(CONFIG_X86_32))
+	if (config_enabled(CONFIG_X86_32) || word_size == 4)
 		return user_insn(fxsave %[fx], [fx] "=m" (*fx), "m" (*fx));
 	else if (config_enabled(CONFIG_AS_FXSAVEQ))
 		return user_insn(fxsaveq %[fx], [fx] "=m" (*fx), "m" (*fx));
@@ -168,9 +180,10 @@ static inline int fxsave_user(struct i38
 	return user_insn(rex64/fxsave (%[fx]), "=m" (*fx), [fx] "R" (fx));
 }
 
-static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
+static inline int fxrstor_checking(struct i387_fxsave_struct *fx,
+				   unsigned int word_size)
 {
-	if (config_enabled(CONFIG_X86_32))
+	if (config_enabled(CONFIG_X86_32) || word_size == 4)
 		return check_insn(fxrstor %[fx], "=m" (*fx), [fx] "m" (*fx));
 	else if (config_enabled(CONFIG_AS_FXSAVEQ))
 		return check_insn(fxrstorq %[fx], "=m" (*fx), [fx] "m" (*fx));
@@ -180,9 +193,10 @@ static inline int fxrstor_checking(struc
 			  "m" (*fx));
 }
 
-static inline int fxrstor_user(struct i387_fxsave_struct __user *fx)
+static inline int fxrstor_user(struct i387_fxsave_struct __user *fx,
+			       unsigned int word_size)
 {
-	if (config_enabled(CONFIG_X86_32))
+	if (config_enabled(CONFIG_X86_32) || word_size == 4)
 		return user_insn(fxrstor %[fx], "=m" (*fx), [fx] "m" (*fx));
 	else if (config_enabled(CONFIG_AS_FXSAVEQ))
 		return user_insn(fxrstorq %[fx], "=m" (*fx), [fx] "m" (*fx));
@@ -202,11 +216,14 @@ static inline int frstor_user(struct i38
 	return user_insn(frstor %[fx], "=m" (*fx), [fx] "m" (*fx));
 }
 
-static inline void fpu_fxsave(struct fpu *fpu)
+static inline void fpu_fxsave(struct fpu *fpu, int word_size)
 {
-	if (config_enabled(CONFIG_X86_32))
+	if (config_enabled(CONFIG_X86_32) || word_size == 4) {
 		asm volatile( "fxsave %[fx]" : [fx] "=m" (fpu->state->fxsave));
-	else if (config_enabled(CONFIG_AS_FXSAVEQ))
+		fpu->word_size = word_size;
+		return;
+	}
+	if (config_enabled(CONFIG_AS_FXSAVEQ))
 		asm volatile("fxsaveq %0" : "=m" (fpu->state->fxsave));
 	else {
 		/* Using "rex64; fxsave %0" is broken because, if the memory
@@ -234,16 +251,20 @@ static inline void fpu_fxsave(struct fpu
 			     : "=m" (fpu->state->fxsave)
 			     : [fx] "R" (&fpu->state->fxsave));
 	}
+	if (word_size == 0)
+		word_size = fpu_word_size(&fpu->state->fxsave);
+	if (word_size >= 0)
+		fpu->word_size = word_size;
 }
 
 /*
  * These must be called with preempt disabled. Returns
  * 'true' if the FPU state is still intact.
  */
-static inline int fpu_save_init(struct fpu *fpu)
+static inline int fpu_save_init(struct fpu *fpu, unsigned int word_size)
 {
 	if (use_xsave()) {
-		fpu_xsave(fpu);
+		fpu_xsave(fpu, word_size);
 
 		/*
 		 * xsave header may indicate the init state of the FP.
@@ -251,7 +272,7 @@ static inline int fpu_save_init(struct f
 		if (!(fpu->state->xsave.xsave_hdr.xstate_bv & XSTATE_FP))
 			return 1;
 	} else if (use_fxsr()) {
-		fpu_fxsave(fpu);
+		fpu_fxsave(fpu, word_size);
 	} else {
 		asm volatile("fnsave %[fx]; fwait"
 			     : [fx] "=m" (fpu->state->fsave));
@@ -275,15 +296,20 @@ static inline int fpu_save_init(struct f
 
 static inline int __save_init_fpu(struct task_struct *tsk)
 {
-	return fpu_save_init(&tsk->thread.fpu);
+	unsigned int word_size = sizeof(long);
+
+	if (config_enabled(CONFIG_IA32_EMULATION) &&
+	    test_tsk_thread_flag(tsk, TIF_IA32))
+		word_size = 4;
+	return fpu_save_init(&tsk->thread.fpu, word_size);
 }
 
 static inline int fpu_restore_checking(struct fpu *fpu)
 {
 	if (use_xsave())
-		return fpu_xrstor_checking(&fpu->state->xsave);
+		return fpu_xrstor_checking(&fpu->state->xsave, fpu->word_size);
 	else if (use_fxsr())
-		return fxrstor_checking(&fpu->state->fxsave);
+		return fxrstor_checking(&fpu->state->fxsave, fpu->word_size);
 	else
 		return frstor_checking(&fpu->state->fsave);
 }
@@ -300,6 +326,9 @@ static inline int restore_fpu_checking(s
 		X86_FEATURE_FXSAVE_LEAK,
 		[addr] "m" (tsk->thread.fpu.has_fpu));
 
+	if (config_enabled(CONFIG_IA32_EMULATION) &&
+	    test_tsk_thread_flag(tsk, TIF_IA32))
+		tsk->thread.fpu.word_size = 4;
 	return fpu_restore_checking(&tsk->thread.fpu);
 }
 
@@ -377,9 +406,9 @@ static inline void drop_init_fpu(struct 
 		drop_fpu(tsk);
 	else {
 		if (use_xsave())
-			xrstor_state(init_xstate_buf, -1);
+			xrstor_state(init_xstate_buf, -1, 0);
 		else
-			fxrstor_checking(&init_xstate_buf->i387);
+			fxrstor_checking(&init_xstate_buf->i387, 0);
 	}
 }
 
@@ -507,10 +536,16 @@ static inline void user_fpu_begin(void)
 
 static inline void __save_fpu(struct task_struct *tsk)
 {
-	if (use_xsave())
-		xsave_state(&tsk->thread.fpu.state->xsave, -1);
-	else
-		fpu_fxsave(&tsk->thread.fpu);
+	unsigned int word_size = sizeof(long);
+
+	if (config_enabled(CONFIG_IA32_EMULATION) &&
+	    test_tsk_thread_flag(tsk, TIF_IA32))
+		word_size = 4;
+	if (use_xsave()) {
+		xsave_state(&tsk->thread.fpu.state->xsave, -1, word_size);
+		tsk->thread.fpu.word_size = word_size;
+	} else
+		fpu_fxsave(&tsk->thread.fpu, word_size);
 }
 
 /*
--- 3.12-rc5/arch/x86/include/asm/processor.h
+++ 3.12-rc5-x86-FPU-preserve-selectors/arch/x86/include/asm/processor.h
@@ -393,6 +393,7 @@ union thread_xstate {
 struct fpu {
 	unsigned int last_cpu;
 	unsigned int has_fpu;
+	unsigned int word_size;
 	union thread_xstate *state;
 };
 
--- 3.12-rc5/arch/x86/include/asm/xsave.h
+++ 3.12-rc5-x86-FPU-preserve-selectors/arch/x86/include/asm/xsave.h
@@ -25,12 +25,6 @@
  */
 #define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
 
-#ifdef CONFIG_X86_64
-#define REX_PREFIX	"0x48, "
-#else
-#define REX_PREFIX
-#endif
-
 extern unsigned int xstate_size;
 extern u64 pcntxt_mask;
 extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
@@ -39,26 +33,41 @@ extern struct xsave_struct *init_xstate_
 extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
 extern int init_fpu(struct task_struct *child);
+extern int fpu_word_size(struct i387_fxsave_struct *);
 
-static inline int fpu_xrstor_checking(struct xsave_struct *fx)
+static inline int fpu_xrstor_checking(struct xsave_struct *fx,
+				      unsigned int word_size)
 {
 	int err;
 
-	asm volatile("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : [err] "=r" (err)
-		     : "D" (fx), "m" (*fx), "a" (-1), "d" (-1), "0" (0)
-		     : "memory");
+	if (config_enabled(CONFIG_64BIT) && word_size != 4)
+		asm volatile("1: .byte 0x48,0x0f,0xae,0x2f\n\t"
+			     "2:\n"
+			     ".section .fixup,\"ax\"\n"
+			     "3:  movl $-1,%[err]\n"
+			     "    jmp  2b\n"
+			     ".previous\n"
+			     _ASM_EXTABLE(1b, 3b)
+			     : [err] "=r" (err)
+			     : "D" (fx), "m" (*fx), "a" (-1), "d" (-1), "0" (0)
+			     : "memory");
+	else
+		asm volatile("1: .byte 0x0f,0xae,0x2f\n\t"
+			     "2:\n"
+			     ".section .fixup,\"ax\"\n"
+			     "3:  movl $-1,%[err]\n"
+			     "    jmp  2b\n"
+			     ".previous\n"
+			     _ASM_EXTABLE(1b, 3b)
+			     : [err] "=r" (err)
+			     : "D" (fx), "m" (*fx), "a" (-1), "d" (-1), "0" (0)
+			     : "memory");
 
 	return err;
 }
 
-static inline int xsave_user(struct xsave_struct __user *buf)
+static inline int xsave_user(struct xsave_struct __user *buf,
+			     unsigned int word_size)
 {
 	int err;
 
@@ -70,70 +79,146 @@ static inline int xsave_user(struct xsav
 	if (unlikely(err))
 		return -EFAULT;
 
-	__asm__ __volatile__(ASM_STAC "\n"
-			     "1: .byte " REX_PREFIX "0x0f,0xae,0x27\n"
-			     "2: " ASM_CLAC "\n"
-			     ".section .fixup,\"ax\"\n"
-			     "3:  movl $-1,%[err]\n"
-			     "    jmp  2b\n"
-			     ".previous\n"
-			     _ASM_EXTABLE(1b,3b)
-			     : [err] "=r" (err)
-			     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
-			     : "memory");
+	if (config_enabled(CONFIG_64BIT) && word_size != 4)
+		__asm__ __volatile__(ASM_STAC "\n"
+				     "1: .byte 0x48,0x0f,0xae,0x27\n"
+				     "2: " ASM_CLAC "\n"
+				     ".section .fixup,\"ax\"\n"
+				     "3:  movl $-1,%[err]\n"
+				     "    jmp  2b\n"
+				     ".previous\n"
+				     _ASM_EXTABLE(1b,3b)
+				     : [err] "=r" (err)
+				     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
+				     : "memory");
+	else
+		__asm__ __volatile__(ASM_STAC "\n"
+				     "1: .byte 0x0f,0xae,0x27\n"
+				     "2: " ASM_CLAC "\n"
+				     ".section .fixup,\"ax\"\n"
+				     "3:  movl $-1,%[err]\n"
+				     "    jmp  2b\n"
+				     ".previous\n"
+				     _ASM_EXTABLE(1b,3b)
+				     : [err] "=r" (err)
+				     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
+				     : "memory");
+
 	return err;
 }
 
-static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
+static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask,
+				unsigned int word_size)
 {
 	int err;
 	struct xsave_struct *xstate = ((__force struct xsave_struct *)buf);
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
 
-	__asm__ __volatile__(ASM_STAC "\n"
-			     "1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n"
-			     "2: " ASM_CLAC "\n"
-			     ".section .fixup,\"ax\"\n"
-			     "3:  movl $-1,%[err]\n"
-			     "    jmp  2b\n"
-			     ".previous\n"
-			     _ASM_EXTABLE(1b,3b)
-			     : [err] "=r" (err)
-			     : "D" (xstate), "a" (lmask), "d" (hmask), "0" (0)
-			     : "memory");	/* memory required? */
+	if (config_enabled(CONFIG_64BIT) && word_size != 4)
+		__asm__ __volatile__(ASM_STAC "\n"
+				     "1: .byte 0x48,0x0f,0xae,0x2f\n"
+				     "2: " ASM_CLAC "\n"
+				     ".section .fixup,\"ax\"\n"
+				     "3:  movl $-1,%[err]\n"
+				     "    jmp  2b\n"
+				     ".previous\n"
+				     _ASM_EXTABLE(1b,3b)
+				     : [err] "=r" (err)
+				     : "D" (xstate), "a" (lmask), "d" (hmask),
+				       "0" (0)
+				     : "memory");	/* memory required? */
+	else
+		__asm__ __volatile__(ASM_STAC "\n"
+				     "1: .byte 0x0f,0xae,0x2f\n"
+				     "2: " ASM_CLAC "\n"
+				     ".section .fixup,\"ax\"\n"
+				     "3:  movl $-1,%[err]\n"
+				     "    jmp  2b\n"
+				     ".previous\n"
+				     _ASM_EXTABLE(1b,3b)
+				     : [err] "=r" (err)
+				     : "D" (xstate), "a" (lmask), "d" (hmask),
+				       "0" (0)
+				     : "memory");	/* memory required? */
+
 	return err;
 }
 
-static inline void xrstor_state(struct xsave_struct *fx, u64 mask)
+static inline void xrstor_state(struct xsave_struct *fx, u64 mask,
+				unsigned int word_size)
 {
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
 
-	asm volatile(".byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
-		     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
-		     :   "memory");
+	if (config_enabled(CONFIG_64BIT) && word_size != 4)
+		asm volatile(".byte 0x48,0x0f,0xae,0x2f\n\t"
+			     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+			     :   "memory");
+	else
+		asm volatile(".byte 0x0f,0xae,0x2f\n\t"
+			     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+			     :   "memory");
 }
 
-static inline void xsave_state(struct xsave_struct *fx, u64 mask)
+static inline void xsave_state(struct xsave_struct *fx, u64 mask,
+			       unsigned int word_size)
 {
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
 
-	asm volatile(".byte " REX_PREFIX "0x0f,0xae,0x27\n\t"
-		     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
-		     :   "memory");
-}
-
-static inline void fpu_xsave(struct fpu *fpu)
-{
-	/* This, however, we can work around by forcing the compiler to select
-	   an addressing mode that doesn't require extended registers. */
-	alternative_input(
-		".byte " REX_PREFIX "0x0f,0xae,0x27",
-		".byte " REX_PREFIX "0x0f,0xae,0x37",
-		X86_FEATURE_XSAVEOPT,
-		[fx] "D" (&fpu->state->xsave), "a" (-1), "d" (-1) :
-		"memory");
+	if (config_enabled(CONFIG_64BIT) && word_size != 4)
+		asm volatile(".byte 0x48,0x0f,0xae,0x27\n\t"
+			     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+			     :   "memory");
+	else
+		asm volatile(".byte 0x0f,0xae,0x27\n\t"
+			     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+			     :   "memory");
+}
+
+static inline void fpu_xsave(struct fpu *fpu, int word_size)
+{
+	if (config_enabled(CONFIG_64BIT) && word_size != 4) {
+		u32 fcs = fpu->state->xsave.i387.fcs;
+		u32 fos = fpu->state->xsave.i387.fos;
+
+		if (static_cpu_has(X86_FEATURE_XSAVEOPT) && word_size == 0) {
+			/*
+			 * xsaveopt may not write the FPU portion even when
+			 * the respective mask bit is set. For fpu_word_size()
+			 * to work we hence need to put the save image back
+			 * into the state that it was in right after the
+			 * previous xsaveopt.
+			 */
+			fpu->state->xsave.i387.fcs = 0;
+			fpu->state->xsave.i387.fos = 0;
+		}
+		alternative_input(
+			".byte 0x48,0x0f,0xae,0x27",
+			".byte 0x48,0x0f,0xae,0x37",
+			X86_FEATURE_XSAVEOPT,
+			[fx] "D" (&fpu->state->xsave), "a" (-1), "d" (-1) :
+			"memory");
+		if (word_size == 0) {
+			if (fpu->state->xsave.xsave_hdr.xstate_bv & XSTATE_FP)
+				word_size = fpu_word_size(&fpu->state->xsave.i387);
+			else
+				word_size = -1;
+			if (static_cpu_has(X86_FEATURE_XSAVEOPT) &&
+			    word_size < 0) {
+				fpu->state->xsave.i387.fcs = fcs;
+				fpu->state->xsave.i387.fos = fos;
+			}
+		}
+	} else
+		alternative_input(
+			".byte 0x0f,0xae,0x27",
+			".byte 0x0f,0xae,0x37",
+			X86_FEATURE_XSAVEOPT,
+			[fx] "D" (&fpu->state->xsave), "a" (-1), "d" (-1) :
+			"memory");
+	if (word_size >= 0)
+		fpu->word_size = word_size;
 }
 #endif
--- 3.12-rc5/arch/x86/kernel/i387.c
+++ 3.12-rc5-x86-FPU-preserve-selectors/arch/x86/kernel/i387.c
@@ -199,6 +199,7 @@ void fpu_finit(struct fpu *fpu)
 	}
 
 	if (cpu_has_fxsr) {
+		fpu->word_size = 0;
 		fx_finit(&fpu->state->fxsave);
 	} else {
 		struct i387_fsave_struct *fp = &fpu->state->fsave;
@@ -242,6 +243,34 @@ int init_fpu(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(init_fpu);
 
+#ifdef CONFIG_64BIT
+int fpu_word_size(struct i387_fxsave_struct *fxsave)
+{
+	struct ix87_env env;
+
+	if (static_cpu_has(X86_FEATURE_NO_FPU_SEL))
+		return -1;
+
+	/*
+	 * AMD CPUs don't save/restore FDP/FIP/FOP unless an exception
+	 * is pending.
+	 */
+	if (!(fxsave->swd & 0x0080) &&
+	    boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		return -1;
+
+	if ((fxsave->rip | fxsave->rdp) >> 32)
+		return sizeof(long);
+
+	asm volatile("fnstenv %0" : "=m" (env));
+	fxsave->fcs = env.fcs;
+	fxsave->fos = env.fos;
+
+	return 4;
+}
+EXPORT_SYMBOL_GPL(fpu_word_size);
+#endif
+
 /*
  * The xstateregs_active() routine is the same as the fpregs_active() routine,
  * as the "regset->n" for the xstate regset will be updated based on the feature
--- 3.12-rc5/arch/x86/kernel/xsave.c
+++ 3.12-rc5-x86-FPU-preserve-selectors/arch/x86/kernel/xsave.c
@@ -195,14 +195,16 @@ static inline int save_xstate_epilog(voi
 	return err;
 }
 
-static inline int save_user_xstate(struct xsave_struct __user *buf)
+static inline int save_user_xstate(struct xsave_struct __user *buf,
+				   unsigned int word_size)
 {
 	int err;
 
 	if (use_xsave())
-		err = xsave_user(buf);
+		err = xsave_user(buf, word_size);
 	else if (use_fxsr())
-		err = fxsave_user((struct i387_fxsave_struct __user *) buf);
+		err = fxsave_user((struct i387_fxsave_struct __user *) buf,
+				  word_size);
 	else
 		err = fsave_user((struct i387_fsave_struct __user *) buf);
 
@@ -249,12 +251,15 @@ int save_xstate_sig(void __user *buf, vo
 			(struct _fpstate_ia32 __user *) buf) ? -1 : 1;
 
 	if (user_has_fpu()) {
+		unsigned int word_size = is_ia32_compat_frame()
+					 ? 4 : sizeof(long);
+
 		/* Save the live register state to the user directly. */
-		if (save_user_xstate(buf_fx))
+		if (save_user_xstate(buf_fx, word_size))
 			return -1;
 		/* Update the thread's fxstate to save the fsave header. */
 		if (ia32_fxstate)
-			fpu_fxsave(&tsk->thread.fpu);
+			fpu_fxsave(&tsk->thread.fpu, word_size);
 	} else {
 		sanitize_i387_state(tsk);
 		if (__copy_to_user(buf_fx, xsave, xstate_size))
@@ -311,19 +316,21 @@ sanitize_restored_xstate(struct task_str
  */
 static inline int restore_user_xstate(void __user *buf, u64 xbv, int fx_only)
 {
+	unsigned int word_size = is_ia32_compat_frame() ? 4 : sizeof(long);
+
 	if (use_xsave()) {
 		if ((unsigned long)buf % 64 || fx_only) {
 			u64 init_bv = pcntxt_mask & ~XSTATE_FPSSE;
-			xrstor_state(init_xstate_buf, init_bv);
-			return fxrstor_user(buf);
+			xrstor_state(init_xstate_buf, init_bv, 0);
+			return fxrstor_user(buf, word_size);
 		} else {
 			u64 init_bv = pcntxt_mask & ~xbv;
 			if (unlikely(init_bv))
-				xrstor_state(init_xstate_buf, init_bv);
-			return xrestore_user(buf, xbv);
+				xrstor_state(init_xstate_buf, init_bv, 0);
+			return xrestore_user(buf, xbv, word_size);
 		}
 	} else if (use_fxsr()) {
-		return fxrstor_user(buf);
+		return fxrstor_user(buf, word_size);
 	} else
 		return frstor_user(buf);
 }
@@ -499,12 +506,12 @@ static void __init setup_init_fpu_buf(vo
 	/*
 	 * Init all the features state with header_bv being 0x0
 	 */
-	xrstor_state(init_xstate_buf, -1);
+	xrstor_state(init_xstate_buf, -1, 0);
 	/*
 	 * Dump the init state again. This is to identify the init state
 	 * of any feature which is not represented by all zero's.
 	 */
-	xsave_state(init_xstate_buf, -1);
+	xsave_state(init_xstate_buf, -1, 0);
 }
 
 static enum { AUTO, ENABLE, DISABLE } eagerfpu = AUTO;
@@ -621,7 +628,7 @@ void eager_fpu_init(void)
 	init_fpu(current);
 	__thread_fpu_begin(current);
 	if (cpu_has_xsave)
-		xrstor_state(init_xstate_buf, -1);
+		xrstor_state(init_xstate_buf, -1, 0);
 	else
-		fxrstor_checking(&init_xstate_buf->i387);
+		fxrstor_checking(&init_xstate_buf->i387, 0);
 }
--- 3.12-rc5/arch/x86/kvm/x86.c
+++ 3.12-rc5-x86-FPU-preserve-selectors/arch/x86/kvm/x86.c
@@ -6653,7 +6653,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *
 		return;
 
 	vcpu->guest_fpu_loaded = 0;
-	fpu_save_init(&vcpu->arch.guest_fpu);
+	fpu_save_init(&vcpu->arch.guest_fpu, 0);
 	__kernel_fpu_end();
 	++vcpu->stat.fpu_reload;
 	kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);


