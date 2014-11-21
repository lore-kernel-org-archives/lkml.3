Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbaKUC33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:29:29 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45112 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877AbaKUC31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:29:27 -0500
Subject: [PATCH ftrace/core v6 1/5] kprobes/ftrace: Recover original IP if
 pre_handler doesn't change it
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 21 Nov 2014 05:25:09 -0500
Message-ID: <20141121102509.11844.64671.stgit@localhost.localdomain>
In-Reply-To: <20141121102502.11844.82696.stgit@localhost.localdomain>
References: <20141121102502.11844.82696.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recover original IP register if the pre_handler doesn't change it.
Since current kprobes doesn't expect that another ftrace handler
may change regs->ip, it sets kprobe.addr + MCOUNT_INSN_SIZE to
regs->ip and returns to ftrace.
This seems wrong behavior since kprobes can recover regs->ip
and safely pass it to another handler.

This adds a code which recovers original regs->ip passed from
ftrace right before returning to ftrace, so that another ftrace
user can change regs->ip.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

---
Changes in v4:
 - Fix description and remove bugfix tag.
---
 arch/x86/kernel/kprobes/ftrace.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kprobes/ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
index 717b02a..5f8f0b3 100644
--- a/arch/x86/kernel/kprobes/ftrace.c
+++ b/arch/x86/kernel/kprobes/ftrace.c
@@ -27,7 +27,7 @@
 
 static nokprobe_inline
 int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
-		      struct kprobe_ctlblk *kcb)
+		      struct kprobe_ctlblk *kcb, unsigned long orig_ip)
 {
 	/*
 	 * Emulate singlestep (and also recover regs->ip)
@@ -39,6 +39,8 @@ int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
 		p->post_handler(p, regs, 0);
 	}
 	__this_cpu_write(current_kprobe, NULL);
+	if (orig_ip)
+		regs->ip = orig_ip;
 	return 1;
 }
 
@@ -46,7 +48,7 @@ int skip_singlestep(struct kprobe *p, struct pt_regs *regs,
 		    struct kprobe_ctlblk *kcb)
 {
 	if (kprobe_ftrace(p))
-		return __skip_singlestep(p, regs, kcb);
+		return __skip_singlestep(p, regs, kcb, 0);
 	else
 		return 0;
 }
@@ -71,13 +73,14 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 	if (kprobe_running()) {
 		kprobes_inc_nmissed_count(p);
 	} else {
+		unsigned long orig_ip = regs->ip;
 		/* Kprobe handler expects regs->ip = ip + 1 as breakpoint hit */
 		regs->ip = ip + sizeof(kprobe_opcode_t);
 
 		__this_cpu_write(current_kprobe, p);
 		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
 		if (!p->pre_handler || !p->pre_handler(p, regs))
-			__skip_singlestep(p, regs, kcb);
+			__skip_singlestep(p, regs, kcb, orig_ip);
 		/*
 		 * If pre_handler returns !0, it sets regs->ip and
 		 * resets current kprobe.


