Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaDSRCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 13:02:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081AbaDSRCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 13:02:09 -0400
Date: Sat, 19 Apr 2014 19:01:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] uprobes/x86: Add is_64bit_mm(), kill
	validate_insn_bits()
Message-ID: <20140419170151.GA30857@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140419170104.GA30667@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Extract the ->ia32_compat check from 64bit validate_insn_bits()
   into the new helper, is_64bit_mm(), it will have more users.

   TODO: this checks is actually wrong if mm owner is X32 task,
   we need another fix which changes set_personality_ia32().

   TODO: even worse, the whole 64-or-32-bit logic is very broken
   and the fix is not simple, we need the nontrivial changes in
   the core uprobes code.

2. Kill validate_insn_bits() and change its single caller to use
   uprobe_init_insn(is_64bit_mm(mm).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 68c63ab..5876ba5 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -231,6 +231,11 @@ static int uprobe_init_insn(struct arch_uprobe *auprobe, struct insn *insn, bool
 }
 
 #ifdef CONFIG_X86_64
+static inline bool is_64bit_mm(struct mm_struct *mm)
+{
+	return	!config_enabled(CONFIG_IA32_EMULATION) ||
+		!mm->context.ia32_compat;
+}
 /*
  * If arch_uprobe->insn doesn't use rip-relative addressing, return
  * immediately.  Otherwise, rewrite the instruction so that it accesses
@@ -355,13 +360,11 @@ handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *
 			*correction += 4;
 	}
 }
-
-static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm, struct insn *insn)
+#else /* 32-bit: */
+static inline bool is_64bit_mm(struct mm_struct *mm)
 {
-	bool x86_64 = !mm->context.ia32_compat;
-	return uprobe_init_insn(auprobe, insn, x86_64);
+	return false;
 }
-#else /* 32-bit: */
 /*
  * No RIP-relative addressing on 32-bit
  */
@@ -376,11 +379,6 @@ static void handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *
 					long *correction)
 {
 }
-
-static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,  struct insn *insn)
-{
-	return uprobe_init_insn(auprobe, insn, false);
-}
 #endif /* CONFIG_X86_64 */
 
 struct uprobe_xol_ops {
@@ -614,7 +612,7 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	bool fix_ip = true, fix_call = false;
 	int ret;
 
-	ret = validate_insn_bits(auprobe, mm, &insn);
+	ret = uprobe_init_insn(auprobe, &insn, is_64bit_mm(mm));
 	if (ret)
 		return ret;
 
-- 
1.5.5.1

