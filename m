Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbbAGQR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:17:26 -0500
Received: from service87.mimecast.com ([91.220.42.44]:34052 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbbAGQRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:17:23 -0500
From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: leo.yan@linaro.org, yexl@marvell.com, will.deacon@arm.com,
        mark.rultand@arm.com, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org,
        "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Subject: [PATCH 2/2] arm64: Emulate SETEND for AArch32 tasks
Date: Wed,  7 Jan 2015 16:16:45 +0000
Message-Id: <1420647405-3907-3-git-send-email-suzuki.poulose@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420647405-3907-1-git-send-email-suzuki.poulose@arm.com>
References: <1420647405-3907-1-git-send-email-suzuki.poulose@arm.com>
X-OriginalArrivalTime: 07 Jan 2015 16:17:20.0987 (UTC) FILETIME=[69F482B0:01D02A95]
X-MC-Unique: 115010716172200301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id t07GHXN0024512

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

Emulate deprecated 'setend' instruction for AArch32 bit tasks.

	setend [le/be] - Sets the endianness of EL0

The hardware support for the instruction can be enabled by setting the
SCTLR_EL1.SED bit. Like the other emulated instructions it is controlled by
an entry in /proc/sys/abi/. For more information see :
	Documentation/arm64/legacy_instructions.txt

The instruction is emulated by setting/clearing the SPSR_EL1.E bit, which
will be reflected in the PSTATE.E in AArch32 context.

This patch also restores the native endianness for the execution of signal
handlers, since the process could have changed the endianness.

Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
---
 Documentation/arm64/legacy_instructions.txt |    5 ++
 arch/arm64/Kconfig                          |   10 ++++
 arch/arm64/include/asm/ptrace.h             |    7 +++
 arch/arm64/kernel/armv8_deprecated.c        |   75 +++++++++++++++++++++++++++
 arch/arm64/kernel/signal32.c                |    5 +-
 5 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/legacy_instructions.txt b/Documentation/arm64/legacy_instructions.txt
index a3b3da2..20e5621 100644
--- a/Documentation/arm64/legacy_instructions.txt
+++ b/Documentation/arm64/legacy_instructions.txt
@@ -43,3 +43,8 @@ Default: Undef (0)
 Node: /proc/sys/abi/cp15_barrier
 Status: Deprecated
 Default: Emulate (1)
+
+* SETEND
+Node: /proc/sys/abi/setend
+Status: Deprecated
+Default: Emulate (1)
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b1f9a20..c6d1fd9 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -540,6 +540,16 @@ config CP15_BARRIER_EMULATION
 
 	  If unsure, say Y
 
+config SETEND_EMULATION
+	bool "Emulate SETEND instruction"
+	help
+	  The SETEND instruction alters the data-endianness of the
+	  AArch32 EL0, and is deprecated in ARMv8.
+
+	  Say Y here to enable software emulation of the instruction
+	  for AArch32 userspace code.
+
+	  If unsure, say Y
 endif
 
 endmenu
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 41ed9e1..d6dd9fd 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -58,6 +58,13 @@
 #define COMPAT_PSR_Z_BIT	0x40000000
 #define COMPAT_PSR_N_BIT	0x80000000
 #define COMPAT_PSR_IT_MASK	0x0600fc00	/* If-Then execution state mask */
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#define COMPAT_PSR_ENDSTATE	COMPAT_PSR_E_BIT
+#else
+#define COMPAT_PSR_ENDSTATE	0
+#endif
+
 /*
  * These are 'magic' values for PTRACE_PEEKUSR that return info about where a
  * process is located in memory.
diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index 9054447..dc91bac 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -477,6 +477,7 @@ ret:
 }
 
 #define SCTLR_EL1_CP15BEN 	(1 << 5)
+#define SCTLR_EL1_SED		(1 << 8)
 
 static inline void config_sctlr_el1(u32 clear, u32 set)
 {
@@ -521,6 +522,77 @@ static struct insn_emulation_ops cp15_barrier_ops = {
 	.set_hw_mode = cp15_barrier_set_hw_mode,
 };
 
+static void setend_set_hw_mode(void *enable)
+{
+	if (enable)
+		config_sctlr_el1(SCTLR_EL1_SED, 0);
+	else
+		config_sctlr_el1(0, SCTLR_EL1_SED);
+}
+
+static int compat_setend_handler(struct pt_regs *regs, u32 endian)
+{
+	char insn[16] = "setend _e";
+
+	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, regs->pc);
+
+	if (endian) {
+		/* Big Endian */
+		insn[7] = 'b';
+		regs->pstate |= COMPAT_PSR_E_BIT;
+	} else {
+		/* Little Endian */
+		insn[7] = 'l';
+		regs->pstate &= ~COMPAT_PSR_E_BIT;
+	}
+
+	trace_instruction_emulation(insn, regs->pc);
+	pr_warn_ratelimited("\"%s\" (%ld) uses deprecated setend instruction at 0x%llx\n",
+			current->comm, (unsigned long)current->pid, regs->pc);
+
+	return 0;
+}
+
+static int a32_setend_handler(struct pt_regs *regs, u32 instr)
+{
+	int rc = compat_setend_handler(regs, (instr >> 9) & 1);
+	regs->pc += 4;
+	return rc;
+}
+
+static int t16_setend_handler(struct pt_regs *regs, u32 instr)
+{
+	int rc = compat_setend_handler(regs, (instr >> 3) & 1);
+	regs->pc += 2;
+	return rc;
+}
+
+static struct undef_hook setend_hooks[] = {
+	{
+		.instr_mask	= 0xfffffdff,
+		.instr_val	= 0xf1010000,
+		.pstate_mask	= COMPAT_PSR_MODE_MASK,
+		.pstate_val	= COMPAT_PSR_MODE_USR,
+		.fn		= a32_setend_handler,
+	},
+	{
+		/* Thumb mode */
+		.instr_mask	= 0x0000fff7,
+		.instr_val	= 0x0000b650,
+		.pstate_mask	= (COMPAT_PSR_T_BIT | COMPAT_PSR_MODE_MASK),
+		.pstate_val	= (COMPAT_PSR_T_BIT | COMPAT_PSR_MODE_USR),
+		.fn		= t16_setend_handler,
+	},
+	{}
+};
+
+static struct insn_emulation_ops setend_ops = {
+	.name = "setend",
+	.status = INSN_DEPRECATED,
+	.hooks = setend_hooks,
+	.set_hw_mode = setend_set_hw_mode,
+};
+
 static int insn_cpu_hotplug_notify(struct notifier_block *b,
 			      unsigned long action, void *hcpu)
 {
@@ -545,6 +617,9 @@ static int __init armv8_deprecated_init(void)
 	if (IS_ENABLED(CONFIG_CP15_BARRIER_EMULATION))
 		register_insn_emulation(&cp15_barrier_ops);
 
+	if (IS_ENABLED(CONFIG_SETEND_EMULATION))
+		register_insn_emulation(&setend_ops);
+
 	register_cpu_notifier(&insn_cpu_hotplug_notifier);
 	register_insn_emulation_sysctl(ctl_abi);
 
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index 5a1ba6e..aa763a5 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -440,7 +440,7 @@ static void compat_setup_return(struct pt_regs *regs, struct k_sigaction *ka,
 {
 	compat_ulong_t handler = ptr_to_compat(ka->sa.sa_handler);
 	compat_ulong_t retcode;
-	compat_ulong_t spsr = regs->pstate & ~PSR_f;
+	compat_ulong_t spsr = regs->pstate & ~(PSR_f | COMPAT_PSR_E_BIT);
 	int thumb;
 
 	/* Check if the handler is written for ARM or Thumb */
@@ -454,6 +454,9 @@ static void compat_setup_return(struct pt_regs *regs, struct k_sigaction *ka,
 	/* The IT state must be cleared for both ARM and Thumb-2 */
 	spsr &= ~COMPAT_PSR_IT_MASK;
 
+	/* Restore the original endianness */
+	spsr |= COMPAT_PSR_ENDSTATE;
+
 	if (ka->sa.sa_flags & SA_RESTORER) {
 		retcode = ptr_to_compat(ka->sa.sa_restorer);
 	} else {
-- 
1.7.9.5


