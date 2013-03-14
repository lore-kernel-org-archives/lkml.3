Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3CNLyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:54:39 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42679 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab3CNLyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:54:33 -0400
X-AuditID: 85900ec0-d38c8b900000151e-1e-5141ba76c0d1
Subject: [PATCH -tip v2 2/2] [BUGFIX] kprobes/x86: Check Interrupt Flag
 modifier when registering probe
To: Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        yrl.pp-manager.tt@hitachi.com, Steven Rostedt <rostedt@goodmis.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 14 Mar 2013 20:52:43 +0900
Message-ID: <20130314115242.19690.33573.stgit@mhiramat-M0-7522>
In-Reply-To: <20130314115230.19690.39387.stgit@mhiramat-M0-7522>
References: <20130314115230.19690.39387.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kprobes check whether the copied instruction modifies
IF (interrupt flag) on each probe hit. This means not only
introducing overhead but also involving inat_get_opcode_attribute
into kprobes hot path, and it can cause an infinit recursive
call (and kernel panic in the end).

Actually, since the copied instruction itself never be modified
on the buffer, it is needless to analyze the instruction every
probe hit.

To fix this issue, we checks it only once when registering probe
and store the result on ainsn->if_modifier.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/include/asm/kprobes.h |    1 +
 arch/x86/kernel/kprobes/core.c |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index d3ddd17..5a6d287 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -77,6 +77,7 @@ struct arch_specific_insn {
 	 * a post_handler or break_handler).
 	 */
 	int boostable;
+	bool if_modifier;
 };
 
 struct arch_optimized_insn {
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 3f06e61..7bfe318 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -375,6 +375,9 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)
 	else
 		p->ainsn.boostable = -1;
 
+	/* Check whether the instruction modifies Interrupt Flag or not */
+	p->ainsn.if_modifier = is_IF_modifier(p->ainsn.insn);
+
 	/* Also, displacement change doesn't affect the first byte */
 	p->opcode = p->ainsn.insn[0];
 }
@@ -434,7 +437,7 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 	__this_cpu_write(current_kprobe, p);
 	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
 		= (regs->flags & (X86_EFLAGS_TF | X86_EFLAGS_IF));
-	if (is_IF_modifier(p->ainsn.insn))
+	if (p->ainsn.if_modifier)
 		kcb->kprobe_saved_flags &= ~X86_EFLAGS_IF;
 }
 

