Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbaLLGog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:44:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51766 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758738AbaLLGQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:55 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Andy Lutomirski" <luto@amacapital.net>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Steven Rostedt" <rostedt@goodmis.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.492349132@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 153/164] x86/asm/traps: Disable tracing and kprobes in
 fixup_bad_iret and sync_regs
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 7ddc6a2199f1da405a2fb68c40db8899b1a8cd87 upstream.

These functions can be executed on the int3 stack, so kprobes
are dangerous. Tracing is probably a bad idea, too.

Fixes: b645af2d5905 ("x86_64, traps: Rework bad_iret")
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/50e33d26adca60816f3ba968875801652507d0c4.1416870125.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.2:
 - Use __kprobes instead of NOKPROBE_SYMBOL()
 - Don't use __visible]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/traps.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -344,7 +344,7 @@ dotraplinkage void __kprobes do_int3(str
  * for scheduling or signal handling. The actual stack switch is done in
  * entry.S
  */
-asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
+asmlinkage notrace __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 {
 	struct pt_regs *regs = eregs;
 	/* Did already sync */
@@ -369,7 +369,7 @@ struct bad_iret_stack {
 	struct pt_regs regs;
 };
 
-asmlinkage
+asmlinkage notrace __kprobes
 struct bad_iret_stack *fixup_bad_iret(struct bad_iret_stack *s)
 {
 	/*

