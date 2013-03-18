Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab3CRLM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:12:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34255 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3CRLMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:12:54 -0400
Date: Mon, 18 Mar 2013 04:11:30 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-9a556ab998071457e79b319f2527642dd6e50617@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, davem@davemloft.net, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de, timo.lindfors@iki.fi
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, davem@davemloft.net, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        timo.lindfors@iki.fi, tglx@linutronix.de
In-Reply-To: <20130314115242.19690.33573.stgit@mhiramat-M0-7522>
References: <20130314115242.19690.33573.stgit@mhiramat-M0-7522>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes/x86:
  Check Interrupt Flag modifier when registering probe
Git-Commit-ID: 9a556ab998071457e79b319f2527642dd6e50617
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 04:11:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a556ab998071457e79b319f2527642dd6e50617
Gitweb:     http://git.kernel.org/tip/9a556ab998071457e79b319f2527642dd6e50617
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Mar 2013 20:52:43 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Mar 2013 10:21:23 +0100

kprobes/x86: Check Interrupt Flag modifier when registering probe

Currently kprobes check whether the copied instruction modifies
IF (interrupt flag) on each probe hit. This results not only in
introducing overhead but also involving
inat_get_opcode_attribute into the kprobes hot path, and it can
cause an infinite recursive call (and kernel panic in the end).

Actually, since the copied instruction itself can never be modified
on the buffer, it is needless to analyze the instruction on every
probe hit.

To fix this issue, we check it only once when registering probe
and store the result on ainsn->if_modifier.

Reported-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20130314115242.19690.33573.stgit@mhiramat-M0-7522
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/kprobes.h | 1 +
 arch/x86/kernel/kprobes/core.c | 5 ++++-
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
 
