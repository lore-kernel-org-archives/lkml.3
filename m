Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab3LIKxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:53:24 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36190 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526Ab3LIKxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:53:18 -0500
Subject: [PATCH -tip v5 07/18] kprobes/x86: Allow probe on some kprobe
 preparation functions
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 09 Dec 2013 10:47:34 +0000
Message-ID: <20131209104734.13397.77134.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
References: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to prohibit probing on the functions
used in preparation phase. Those are safely probed because
those are not invoked from breakpoint/fault/debug handlers,
there is no chance to cause recursive exceptions.

Following functions are now removed from the kprobes blacklist.
 can_boost
 can_probe
 can_optimize
 is_IF_modifier
 __copy_instruction
 copy_optimized_instructions
 arch_copy_kprobe
 arch_prepare_kprobe
 arch_arm_kprobe
 arch_disarm_kprobe
 arch_remove_kprobe
 arch_trampoline_kprobe
 arch_prepare_kprobe_ftrace
 arch_prepare_optimized_kprobe
 arch_check_optimized_kprobe
 arch_within_optimized_kprobe
 __arch_remove_optimized_kprobe
 arch_remove_optimized_kprobe
 arch_optimize_kprobes
 arch_unoptimize_kprobe

I tested the safety via kprobe-tracer as below;

 # cd /sys/kernel/debug/tracing
 # cat above-coverted-symbols-list | while read s; do
   echo "p $s"; done > kprobe_events
 (Note: some symbols are not found, those are inlined)
 # echo 1 > events/kprobes/enable
 # echo p:foo vfs_symlink >> kprobe_events
 # echo p:bar vfs_symlink+5 >> kprobe_events
 # echo p vfs_symlink+5 >> kprobe_events
 # echo 1 > events/kprobes/foo/enable
 # ln -sf /tmp/foo /tmp/bar
 # echo 0 > events/kprobes/foo/enable
 # echo -:foo >> kprobe_events
 # head -n 20 trace
 # echo 0 > events/kprobes/enable
 # echo > kprobe_events
 # echo > trace

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/x86/kernel/kprobes/core.c   |   20 ++++++++++----------
 arch/x86/kernel/kprobes/ftrace.c |    2 +-
 arch/x86/kernel/kprobes/opt.c    |   24 ++++++++++++------------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 4d7dbe1..41a942f 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -159,7 +159,7 @@ static kprobe_opcode_t *__kprobes skip_prefixes(kprobe_opcode_t *insn)
  * Returns non-zero if opcode is boostable.
  * RIP relative instructions are adjusted at copying time in 64 bits mode
  */
-int __kprobes can_boost(kprobe_opcode_t *opcodes)
+int can_boost(kprobe_opcode_t *opcodes)
 {
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;
@@ -260,7 +260,7 @@ unsigned long recover_probed_instruction(kprobe_opcode_t *buf, unsigned long add
 }
 
 /* Check if paddr is at an instruction boundary */
-static int __kprobes can_probe(unsigned long paddr)
+static int can_probe(unsigned long paddr)
 {
 	unsigned long addr, __addr, offset = 0;
 	struct insn insn;
@@ -299,7 +299,7 @@ static int __kprobes can_probe(unsigned long paddr)
 /*
  * Returns non-zero if opcode modifies the interrupt flag.
  */
-static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
+static int is_IF_modifier(kprobe_opcode_t *insn)
 {
 	/* Skip prefixes */
 	insn = skip_prefixes(insn);
@@ -322,7 +322,7 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
  * If not, return null.
  * Only applicable to 64-bit x86.
  */
-int __kprobes __copy_instruction(u8 *dest, u8 *src)
+int __copy_instruction(u8 *dest, u8 *src)
 {
 	struct insn insn;
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
@@ -365,7 +365,7 @@ int __kprobes __copy_instruction(u8 *dest, u8 *src)
 	return insn.length;
 }
 
-static int __kprobes arch_copy_kprobe(struct kprobe *p)
+static int arch_copy_kprobe(struct kprobe *p)
 {
 	int ret;
 
@@ -392,7 +392,7 @@ static int __kprobes arch_copy_kprobe(struct kprobe *p)
 	return 0;
 }
 
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
+int arch_prepare_kprobe(struct kprobe *p)
 {
 	if (alternatives_text_reserved(p->addr, p->addr))
 		return -EINVAL;
@@ -407,17 +407,17 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	return arch_copy_kprobe(p);
 }
 
-void __kprobes arch_arm_kprobe(struct kprobe *p)
+void arch_arm_kprobe(struct kprobe *p)
 {
 	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
 }
 
-void __kprobes arch_disarm_kprobe(struct kprobe *p)
+void arch_disarm_kprobe(struct kprobe *p)
 {
 	text_poke(p->addr, &p->opcode, 1);
 }
 
-void __kprobes arch_remove_kprobe(struct kprobe *p)
+void arch_remove_kprobe(struct kprobe *p)
 {
 	if (p->ainsn.insn) {
 		free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
@@ -1061,7 +1061,7 @@ int __init arch_init_kprobes(void)
 	return 0;
 }
 
-int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+int arch_trampoline_kprobe(struct kprobe *p)
 {
 	return 0;
 }
diff --git a/arch/x86/kernel/kprobes/ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
index 23ef5c5..dcaa131 100644
--- a/arch/x86/kernel/kprobes/ftrace.c
+++ b/arch/x86/kernel/kprobes/ftrace.c
@@ -85,7 +85,7 @@ end:
 	local_irq_restore(flags);
 }
 
-int __kprobes arch_prepare_kprobe_ftrace(struct kprobe *p)
+int arch_prepare_kprobe_ftrace(struct kprobe *p)
 {
 	p->ainsn.insn = NULL;
 	p->ainsn.boostable = -1;
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 898160b..fba7fb0 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -77,7 +77,7 @@ found:
 }
 
 /* Insert a move instruction which sets a pointer to eax/rdi (1st arg). */
-static void __kprobes synthesize_set_arg1(kprobe_opcode_t *addr, unsigned long val)
+static void synthesize_set_arg1(kprobe_opcode_t *addr, unsigned long val)
 {
 #ifdef CONFIG_X86_64
 	*addr++ = 0x48;
@@ -169,7 +169,7 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op, struct pt_
 	local_irq_restore(flags);
 }
 
-static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
+static int copy_optimized_instructions(u8 *dest, u8 *src)
 {
 	int len = 0, ret;
 
@@ -189,7 +189,7 @@ static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
 }
 
 /* Check whether insn is indirect jump */
-static int __kprobes insn_is_indirect_jump(struct insn *insn)
+static int insn_is_indirect_jump(struct insn *insn)
 {
 	return ((insn->opcode.bytes[0] == 0xff &&
 		(X86_MODRM_REG(insn->modrm.value) & 6) == 4) || /* Jump */
@@ -224,7 +224,7 @@ static int insn_jump_into_range(struct insn *insn, unsigned long start, int len)
 }
 
 /* Decode whole function to ensure any instructions don't jump into target */
-static int __kprobes can_optimize(unsigned long paddr)
+static int can_optimize(unsigned long paddr)
 {
 	unsigned long addr, size = 0, offset = 0;
 	struct insn insn;
@@ -275,7 +275,7 @@ static int __kprobes can_optimize(unsigned long paddr)
 }
 
 /* Check optimized_kprobe can actually be optimized. */
-int __kprobes arch_check_optimized_kprobe(struct optimized_kprobe *op)
+int arch_check_optimized_kprobe(struct optimized_kprobe *op)
 {
 	int i;
 	struct kprobe *p;
@@ -290,15 +290,15 @@ int __kprobes arch_check_optimized_kprobe(struct optimized_kprobe *op)
 }
 
 /* Check the addr is within the optimized instructions. */
-int __kprobes
-arch_within_optimized_kprobe(struct optimized_kprobe *op, unsigned long addr)
+int arch_within_optimized_kprobe(struct optimized_kprobe *op,
+				 unsigned long addr)
 {
 	return ((unsigned long)op->kp.addr <= addr &&
 		(unsigned long)op->kp.addr + op->optinsn.size > addr);
 }
 
 /* Free optimized instruction slot */
-static __kprobes
+static
 void __arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
 {
 	if (op->optinsn.insn) {
@@ -308,7 +308,7 @@ void __arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
 	}
 }
 
-void __kprobes arch_remove_optimized_kprobe(struct optimized_kprobe *op)
+void arch_remove_optimized_kprobe(struct optimized_kprobe *op)
 {
 	__arch_remove_optimized_kprobe(op, 1);
 }
@@ -318,7 +318,7 @@ void __kprobes arch_remove_optimized_kprobe(struct optimized_kprobe *op)
  * Target instructions MUST be relocatable (checked inside)
  * This is called when new aggr(opt)probe is allocated or reused.
  */
-int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
+int arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
 {
 	u8 *buf;
 	int ret;
@@ -372,7 +372,7 @@ int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
  * Replace breakpoints (int3) with relative jumps.
  * Caller must call with locking kprobe_mutex and text_mutex.
  */
-void __kprobes arch_optimize_kprobes(struct list_head *oplist)
+void arch_optimize_kprobes(struct list_head *oplist)
 {
 	struct optimized_kprobe *op, *tmp;
 	u8 insn_buf[RELATIVEJUMP_SIZE];
@@ -398,7 +398,7 @@ void __kprobes arch_optimize_kprobes(struct list_head *oplist)
 }
 
 /* Replace a relative jump with a breakpoint (int3).  */
-void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
+void arch_unoptimize_kprobe(struct optimized_kprobe *op)
 {
 	u8 insn_buf[RELATIVEJUMP_SIZE];
 


