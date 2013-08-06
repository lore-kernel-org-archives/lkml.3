Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3HFVrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:47:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43520 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab3HFVoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:44:06 -0400
Date: Tue, 6 Aug 2013 14:43:42 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-04bb591ca74fb8ea06d5ab7fadfb7bf5b11fb28e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davem@davemloft.net, anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, ak@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, ak@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1375740170-7446-8-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-8-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage:
  Make kprobes code visible and fix assembler code
Git-Commit-ID: 04bb591ca74fb8ea06d5ab7fadfb7bf5b11fb28e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:43:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04bb591ca74fb8ea06d5ab7fadfb7bf5b11fb28e
Gitweb:     http://git.kernel.org/tip/04bb591ca74fb8ea06d5ab7fadfb7bf5b11fb28e
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:41 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:19:48 -0700

x86, asmlinkage: Make kprobes code visible and fix assembler code

- Make all the external assembler template symbols __visible
- Move the templates inline assembler code into a top level
  assembler statement, not inside a function. This avoids it being
  optimized away or cloned.

Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-8-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/kprobes.h | 10 +++++-----
 arch/x86/kernel/kprobes/core.c |  2 +-
 arch/x86/kernel/kprobes/opt.c  |  5 +----
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 5a6d287..9454c16 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -49,10 +49,10 @@ typedef u8 kprobe_opcode_t;
 #define flush_insn_slot(p)	do { } while (0)
 
 /* optinsn template addresses */
-extern kprobe_opcode_t optprobe_template_entry;
-extern kprobe_opcode_t optprobe_template_val;
-extern kprobe_opcode_t optprobe_template_call;
-extern kprobe_opcode_t optprobe_template_end;
+extern __visible kprobe_opcode_t optprobe_template_entry;
+extern __visible kprobe_opcode_t optprobe_template_val;
+extern __visible kprobe_opcode_t optprobe_template_call;
+extern __visible kprobe_opcode_t optprobe_template_end;
 #define MAX_OPTIMIZED_LENGTH (MAX_INSN_SIZE + RELATIVE_ADDR_SIZE)
 #define MAX_OPTINSN_SIZE 				\
 	(((unsigned long)&optprobe_template_end -	\
@@ -62,7 +62,7 @@ extern kprobe_opcode_t optprobe_template_end;
 extern const int kretprobe_blacklist_size;
 
 void arch_remove_kprobe(struct kprobe *p);
-void kretprobe_trampoline(void);
+asmlinkage void kretprobe_trampoline(void);
 
 /* Architecture specific copy of original instruction*/
 struct arch_specific_insn {
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 211bce4..048852d 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -661,7 +661,7 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 /*
  * Called from kretprobe_trampoline
  */
-static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
+__visible __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 76dc6f0..2c1ac28 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -88,9 +88,7 @@ static void __kprobes synthesize_set_arg1(kprobe_opcode_t *addr, unsigned long v
 	*(unsigned long *)addr = val;
 }
 
-static void __used __kprobes kprobes_optinsn_template_holder(void)
-{
-	asm volatile (
+asm (
 			".global optprobe_template_entry\n"
 			"optprobe_template_entry:\n"
 #ifdef CONFIG_X86_64
@@ -129,7 +127,6 @@ static void __used __kprobes kprobes_optinsn_template_holder(void)
 #endif
 			".global optprobe_template_end\n"
 			"optprobe_template_end:\n");
-}
 
 #define TMPL_MOVE_IDX \
 	((long)&optprobe_template_val - (long)&optprobe_template_entry)
