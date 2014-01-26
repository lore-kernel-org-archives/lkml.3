Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaAZB4r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 20:56:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:41673 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbaAZB4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 20:56:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,721,1384329600"; 
   d="scan'208";a="470834205"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v3 4/4] x86, mpx: extend siginfo structure to include bound violation information
Date: Sun, 26 Jan 2014 17:08:58 +0800
Message-Id: <1390727338-20487-5-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com>
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new fields about bound violation into siginfo
structure. si_lower and si_upper are respectively lower bound
and upper bound when bound violation is caused.

These fields will be set in #BR exception handler by decoding
the user instruction and constructing the faulting pointer.
A userspace application can get violation address, lower bound
and upper bound for bound violation from this new siginfo structure.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/include/asm/mpx.h         |   19 +++
 arch/x86/kernel/mpx.c              |  287 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c            |    6 +
 include/uapi/asm-generic/siginfo.h |    9 +-
 kernel/signal.c                    |    4 +
 5 files changed, 324 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/mpx.h b/arch/x86/include/asm/mpx.h
index 9652e9e..e099573 100644
--- a/arch/x86/include/asm/mpx.h
+++ b/arch/x86/include/asm/mpx.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <asm/ptrace.h>
+#include <asm/insn.h>
 
 #ifdef CONFIG_X86_64
 
@@ -30,6 +31,22 @@
 
 #endif
 
+struct mpx_insn {
+	struct insn_field rex_prefix;	/* REX prefix */
+	struct insn_field modrm;
+	struct insn_field sib;
+	struct insn_field displacement;
+
+	unsigned char addr_bytes;	/* effective address size */
+	unsigned char limit;
+	unsigned char x86_64;
+
+	const unsigned char *kaddr;	/* kernel address of insn to analyze */
+	const unsigned char *next_byte;
+};
+
+#define MAX_MPX_INSN_SIZE	15
+
 typedef union {
 	struct {
 		unsigned long ignored:MPX_IGN_BITS;
@@ -40,5 +57,7 @@ typedef union {
 } mpx_addr;
 
 void do_mpx_bt_fault(struct xsave_struct *xsave_buf);
+void do_mpx_bounds(struct pt_regs *regs, siginfo_t *info,
+		struct xsave_struct *xsave_buf);
 
 #endif /* _ASM_X86_MPX_H */
diff --git a/arch/x86/kernel/mpx.c b/arch/x86/kernel/mpx.c
index 9e91178..983abf7 100644
--- a/arch/x86/kernel/mpx.c
+++ b/arch/x86/kernel/mpx.c
@@ -91,6 +91,269 @@ int mpx_release(struct task_struct *tsk)
 	return 0;
 }
 
+typedef enum {REG_TYPE_RM, REG_TYPE_INDEX, REG_TYPE_BASE} reg_type_t;
+static unsigned long get_reg(struct mpx_insn *insn, struct pt_regs *regs,
+			     reg_type_t type)
+{
+	int regno = 0;
+	unsigned char modrm = (unsigned char)insn->modrm.value;
+	unsigned char sib = (unsigned char)insn->sib.value;
+
+	static const int regoff[] = {
+		offsetof(struct pt_regs, ax),
+		offsetof(struct pt_regs, cx),
+		offsetof(struct pt_regs, dx),
+		offsetof(struct pt_regs, bx),
+		offsetof(struct pt_regs, sp),
+		offsetof(struct pt_regs, bp),
+		offsetof(struct pt_regs, si),
+		offsetof(struct pt_regs, di),
+#ifdef CONFIG_X86_64
+		offsetof(struct pt_regs, r8),
+		offsetof(struct pt_regs, r9),
+		offsetof(struct pt_regs, r10),
+		offsetof(struct pt_regs, r11),
+		offsetof(struct pt_regs, r12),
+		offsetof(struct pt_regs, r13),
+		offsetof(struct pt_regs, r14),
+		offsetof(struct pt_regs, r15),
+#endif
+	};
+
+	switch (type) {
+	case REG_TYPE_RM:
+		regno = X86_MODRM_RM(modrm);
+		if (X86_REX_B(insn->rex_prefix.value) == 1)
+			regno += 8;
+		break;
+
+	case REG_TYPE_INDEX:
+		regno = X86_SIB_INDEX(sib);
+		if (X86_REX_X(insn->rex_prefix.value) == 1)
+			regno += 8;
+		break;
+
+	case REG_TYPE_BASE:
+		regno = X86_SIB_BASE(sib);
+		if (X86_REX_B(insn->rex_prefix.value) == 1)
+			regno += 8;
+		break;
+
+	default:
+		break;
+	}
+
+	return regs_get_register(regs, regoff[regno]);
+}
+
+/*
+ * return the address being referenced be instruction
+ * for rm=3 returning the content of the rm reg
+ * for rm!=3 calculates the address using SIB and Disp
+ */
+static unsigned long get_addr_ref(struct mpx_insn *insn, struct pt_regs *regs)
+{
+	unsigned long addr;
+	unsigned long base;
+	unsigned long indx;
+	unsigned char modrm = (unsigned char)insn->modrm.value;
+	unsigned char sib = (unsigned char)insn->sib.value;
+
+	if (X86_MODRM_MOD(modrm) == 3) {
+		addr = get_reg(insn, regs, REG_TYPE_RM);
+	} else {
+		if (insn->sib.nbytes) {
+			base = get_reg(insn, regs, REG_TYPE_BASE);
+			indx = get_reg(insn, regs, REG_TYPE_INDEX);
+			addr = base + indx * (1 << X86_SIB_SCALE(sib));
+		} else {
+			addr = get_reg(insn, regs, REG_TYPE_RM);
+		}
+		addr += insn->displacement.value;
+	}
+
+	return addr;
+}
+
+/* Verify next sizeof(t) bytes can be on the same instruction */
+#define validate_next(t, insn, n)	\
+	((insn)->next_byte + sizeof(t) + n - (insn)->kaddr <= (insn)->limit)
+
+#define __get_next(t, insn)		\
+({					\
+	t r = *(t *)insn->next_byte;	\
+	insn->next_byte += sizeof(t);	\
+	r;				\
+})
+
+#define __peek_next(t, insn)		\
+({					\
+	t r = *(t *)insn->next_byte;	\
+	r;				\
+})
+
+#define get_next(t, insn)		\
+({					\
+	if (unlikely(!validate_next(t, insn, 0)))	\
+		goto err_out;		\
+	__get_next(t, insn);		\
+})
+
+#define peek_next(t, insn)		\
+({					\
+	if (unlikely(!validate_next(t, insn, 0)))	\
+		goto err_out;		\
+	__peek_next(t, insn);		\
+})
+
+static void mpx_insn_get_prefixes(struct mpx_insn *insn)
+{
+	unsigned char b;
+
+	/* Decode legacy prefix and REX prefix */
+	b = peek_next(unsigned char, insn);
+	while (b != 0x0f) {
+		/*
+		 * look for a rex prefix
+		 * a REX prefix cannot be followed by a legacy prefix.
+		 */
+		if (insn->x86_64 && ((b&0xf0)==0x40)) {
+			insn->rex_prefix.value = b;
+			insn->rex_prefix.nbytes = 1;
+			insn->next_byte++;
+			break;
+		}
+
+		/* check the other legacy prefixes */
+		switch (b) {
+		case 0xf2:
+		case 0xf3:
+		case 0xf0:
+		case 0x64:
+		case 0x65:
+		case 0x2e:
+		case 0x3e:
+		case 0x26:
+		case 0x36:
+		case 0x66:
+		case 0x67:
+			insn->next_byte++;
+			break;
+		default: /* everything else is garbage */
+			goto err_out;
+		}
+		b = peek_next(unsigned char, insn);
+	}
+
+err_out:
+	return;
+}
+
+static void mpx_insn_get_modrm(struct mpx_insn *insn)
+{
+	insn->modrm.value = get_next(unsigned char, insn);
+	insn->modrm.nbytes = 1;
+
+err_out:
+	return;
+}
+
+static void mpx_insn_get_sib(struct mpx_insn *insn)
+{
+	unsigned char modrm = (unsigned char)insn->modrm.value;
+
+	if (X86_MODRM_MOD(modrm) != 3 && X86_MODRM_RM(modrm) == 4) {
+		insn->sib.value = get_next(unsigned char, insn);
+		insn->sib.nbytes = 1;
+	}
+
+err_out:
+	return;
+}
+
+static void mpx_insn_get_displacement(struct mpx_insn *insn)
+{
+	unsigned char mod, rm, base;
+
+	/*
+	 * Interpreting the modrm byte:
+	 * mod = 00 - no displacement fields (exceptions below)
+	 * mod = 01 - 1-byte displacement field
+	 * mod = 10 - displacement field is 4 bytes
+	 * mod = 11 - no memory operand
+	 *
+	 * mod != 11, r/m = 100 - SIB byte exists
+	 * mod = 00, SIB base = 101 - displacement field is 4 bytes
+	 * mod = 00, r/m = 101 - rip-relative addressing, displacement
+	 *	field is 4 bytes
+	 */
+	mod = X86_MODRM_MOD(insn->modrm.value);
+	rm = X86_MODRM_RM(insn->modrm.value);
+	base = X86_SIB_BASE(insn->sib.value);
+	if (mod == 3)
+		return;
+	if (mod == 1) {
+		insn->displacement.value = get_next(unsigned char, insn);
+		insn->displacement.nbytes = 1;
+	} else if ((mod == 0 && rm == 5) || mod == 2 ||
+			(mod == 0 && base == 5)) {
+		insn->displacement.value = get_next(int, insn);
+		insn->displacement.nbytes = 4;
+	}
+
+err_out:
+	return;
+}
+
+static void mpx_insn_init(struct mpx_insn *insn, struct pt_regs *regs)
+{
+	unsigned char buf[MAX_MPX_INSN_SIZE];
+	int bytes;
+
+	memset(insn, 0, sizeof(*insn));
+
+	bytes = copy_from_user(buf, (void __user *)regs->ip, MAX_MPX_INSN_SIZE);
+	insn->limit = MAX_MPX_INSN_SIZE - bytes;
+	insn->kaddr = buf;
+	insn->next_byte = buf;
+
+	/*
+	 * In 64-bit Mode, all Intel MPX instructions use 64-bit
+	 * operands for bounds and 64 bit addressing, i.e. REX.W &
+	 * 67H have no effect on data or address size.
+	 *
+	 * In compatibility and legacy modes (including 16-bit code
+	 * segments, real and virtual 8086 modes) all Intel MPX
+	 * instructions use 32-bit operands for bounds and 32 bit
+	 * addressing.
+	 */
+#ifdef CONFIG_X86_64
+	insn->x86_64 = 1;
+	insn->addr_bytes = 8;
+#else
+	insn->x86_64 = 0;
+	insn->addr_bytes = 4;
+#endif
+}
+
+static unsigned long mpx_insn_decode(struct mpx_insn *insn, struct pt_regs *regs)
+{
+	mpx_insn_init(insn, regs);
+
+	/*
+	 * In this case, we only need decode bndcl/bndcn/bndcu,
+	 * so we can use private diassembly interfaces to get
+	 * prefixes, modrm, sib, displacement, etc..
+	 */
+	mpx_insn_get_prefixes(insn);
+	insn->next_byte += 2; /* ignore opcode */
+	mpx_insn_get_modrm(insn);
+	mpx_insn_get_sib(insn);
+	mpx_insn_get_displacement(insn);
+
+	return get_addr_ref(insn, regs);
+}
+
 static bool allocate_bt(unsigned long bd_entry)
 {
 	unsigned long bt_size = 1UL << (MPX_L2_BITS+MPX_L2_SHIFT);
@@ -126,3 +389,27 @@ void do_mpx_bt_fault(struct xsave_struct *xsave_buf)
 	if ((bd_entry >= bd_base) && (bd_entry < bd_base + bd_size))
 		allocate_bt(bd_entry);
 }
+
+void do_mpx_bounds(struct pt_regs *regs, siginfo_t *info,
+		struct xsave_struct *xsave_buf)
+{
+	struct mpx_insn insn;
+	uint8_t bndregno;
+	unsigned long addr_vio;
+
+	addr_vio = mpx_insn_decode(&insn, regs);
+
+	bndregno = X86_MODRM_REG(insn.modrm.value);
+	if (bndregno > 3)
+		return;
+
+	info->si_lower =
+		(void __user *)(xsave_buf->bndregs.bndregs[2*bndregno]);
+	info->si_upper =
+		(void __user *)(~xsave_buf->bndregs.bndregs[2*bndregno+1]);
+	info->si_addr_lsb = 0;
+	info->si_signo = SIGSEGV;
+	info->si_errno = 0;
+	info->si_code = SEGV_BNDERR;
+	info->si_addr = (void __user *)addr_vio;
+}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 6b284a4..4fda5c6 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -269,6 +269,7 @@ dotraplinkage void do_bounds(struct pt_regs *regs, long error_code)
 	unsigned long status;
 	struct xsave_struct *xsave_buf;
 	struct task_struct *tsk = current;
+	siginfo_t info;
 
 	prev_state = exception_enter();
 	if (notify_die(DIE_TRAP, "bounds", regs, error_code,
@@ -304,6 +305,11 @@ dotraplinkage void do_bounds(struct pt_regs *regs, long error_code)
 		break;
 
 	case 1: /* Bound violation. */
+		do_mpx_bounds(regs, &info, xsave_buf);
+		do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs,
+				error_code, &info);
+		break;
+
 	case 0: /* No MPX exception. */
 		do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code, NULL);
 		break;
diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index ba5be7f..1e35520 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -91,6 +91,10 @@ typedef struct siginfo {
 			int _trapno;	/* TRAP # which caused the signal */
 #endif
 			short _addr_lsb; /* LSB of the reported address */
+			struct {
+				void __user *_lower;
+				void __user *_upper;
+			} _addr_bnd;
 		} _sigfault;
 
 		/* SIGPOLL */
@@ -131,6 +135,8 @@ typedef struct siginfo {
 #define si_trapno	_sifields._sigfault._trapno
 #endif
 #define si_addr_lsb	_sifields._sigfault._addr_lsb
+#define si_lower	_sifields._sigfault._addr_bnd._lower
+#define si_upper	_sifields._sigfault._addr_bnd._upper
 #define si_band		_sifields._sigpoll._band
 #define si_fd		_sifields._sigpoll._fd
 #ifdef __ARCH_SIGSYS
@@ -199,7 +205,8 @@ typedef struct siginfo {
  */
 #define SEGV_MAPERR	(__SI_FAULT|1)	/* address not mapped to object */
 #define SEGV_ACCERR	(__SI_FAULT|2)	/* invalid permissions for mapped object */
-#define NSIGSEGV	2
+#define SEGV_BNDERR	(__SI_FAULT|3)  /* failed address bound checks */
+#define NSIGSEGV	3
 
 /*
  * SIGBUS si_codes
diff --git a/kernel/signal.c b/kernel/signal.c
index 940b30e..7b774d9 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2771,6 +2771,10 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 		if (from->si_code == BUS_MCEERR_AR || from->si_code == BUS_MCEERR_AO)
 			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
 #endif
+#ifdef SEGV_BNDERR
+		err |= __put_user(from->si_lower, &to->si_lower);
+		err |= __put_user(from->si_upper, &to->si_upper);
+#endif
 		break;
 	case __SI_CHLD:
 		err |= __put_user(from->si_pid, &to->si_pid);
-- 
1.7.1

