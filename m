Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbaDMRqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 13:46:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057AbaDMRpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 13:45:53 -0400
Date: Sun, 13 Apr 2014 19:45:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 07/15] uprobes/x86: Conditionalize the usage of
	handle_riprel_insn()
Message-ID: <20140413174546.GA11859@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413174508.GA11811@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_uprobe_analyze_insn() calls handle_riprel_insn() at the start,
but only "0xff" and "default" cases need the UPROBE_FIX_RIP_ logic.
Move the callsite into "default" case and change the "0xff" case to
fall-through.

We are going to add the various hooks to handle the rip-relative
jmp/call instructions (and more), we need this change to enforce the
fact that the new code can not conflict with is_riprel_insn() logic
which, after this change, can only be used by default_xol_ops.

Note: arch_uprobe_abort_xol() still calls handle_riprel_post_xol()
directly. This is fine unless another _xol_ops we may add later will
need to reuse "UPROBE_FIX_RIP_AX|UPROBE_FIX_RIP_CX" bits in ->fixup.
In this case we can add uprobe_xol_ops->abort() hook, which (perhaps)
we will need anyway in the long term.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 arch/x86/kernel/uprobes.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 6ba6705..f4b436b 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -482,8 +482,6 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	 * and annotate arch_uprobe->fixups accordingly. To start with, ->fixups
 	 * is either zero or it reflects rip-related fixups.
 	 */
-	handle_riprel_insn(auprobe, &insn);
-
 	switch (OPCODE1(&insn)) {
 	case 0x9d:		/* popf */
 		auprobe->fixups |= UPROBE_FIX_SETF;
@@ -512,9 +510,9 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 		case 4: case 5:			/* jmp or ljmp, indirect */
 			fix_ip = false;
 		}
-		break;
+		/* fall through */
 	default:
-		break;
+		handle_riprel_insn(auprobe, &insn);
 	}
 
 	if (fix_ip)
-- 
1.5.5.1

