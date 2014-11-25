Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaKYGas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 01:30:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33971 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaKYGar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 01:30:47 -0500
Date: Mon, 24 Nov 2014 22:30:30 -0800
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-7ddc6a2199f1da405a2fb68c40db8899b1a8cd87@git.kernel.org>
Cc: hpa@zytor.com, luto@amacapital.net, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@kernel.org
Reply-To: mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, luto@amacapital.net,
        hpa@zytor.com
In-Reply-To: <50e33d26adca60816f3ba968875801652507d0c4.1416870125.git.luto@amacapital.net>
References: <50e33d26adca60816f3ba968875801652507d0c4.1416870125.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86/asm/traps:
  Disable tracing and kprobes in fixup_bad_iret and sync_regs
Git-Commit-ID: 7ddc6a2199f1da405a2fb68c40db8899b1a8cd87
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ddc6a2199f1da405a2fb68c40db8899b1a8cd87
Gitweb:     http://git.kernel.org/tip/7ddc6a2199f1da405a2fb68c40db8899b1a8cd87
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Mon, 24 Nov 2014 17:39:06 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 25 Nov 2014 07:26:55 +0100

x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and sync_regs

These functions can be executed on the int3 stack, so kprobes
are dangerous. Tracing is probably a bad idea, too.

Fixes: b645af2d5905 ("x86_64, traps: Rework bad_iret")
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: <stable@vger.kernel.org> # Backport as far back as it would apply
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/50e33d26adca60816f3ba968875801652507d0c4.1416870125.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/traps.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index de801f2..07ab8e9 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -387,7 +387,7 @@ NOKPROBE_SYMBOL(do_int3);
  * for scheduling or signal handling. The actual stack switch is done in
  * entry.S
  */
-asmlinkage __visible struct pt_regs *sync_regs(struct pt_regs *eregs)
+asmlinkage __visible notrace struct pt_regs *sync_regs(struct pt_regs *eregs)
 {
 	struct pt_regs *regs = eregs;
 	/* Did already sync */
@@ -413,7 +413,7 @@ struct bad_iret_stack {
 	struct pt_regs regs;
 };
 
-asmlinkage __visible
+asmlinkage __visible notrace
 struct bad_iret_stack *fixup_bad_iret(struct bad_iret_stack *s)
 {
 	/*
@@ -436,6 +436,7 @@ struct bad_iret_stack *fixup_bad_iret(struct bad_iret_stack *s)
 	BUG_ON(!user_mode_vm(&new_stack->regs));
 	return new_stack;
 }
+NOKPROBE_SYMBOL(fixup_bad_iret);
 #endif
 
 /*
