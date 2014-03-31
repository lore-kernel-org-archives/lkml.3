Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaCaUpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:45:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaCaUpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:45:01 -0400
Date: Mon, 31 Mar 2014 21:44:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] uprobes/x86: Conditionalize the usage of
	handle_riprel_insn()
Message-ID: <20140331194402.GA9287@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331194337.GA9257@redhat.com>
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
fact that the new code can't conflict with is_riprel_insn() code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 098e56e..d72dfbf 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -376,8 +376,6 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	 * and annotate arch_uprobe->fixups accordingly. To start with, ->fixups
 	 * is either zero or it reflects rip-related fixups.
 	 */
-	handle_riprel_insn(auprobe, mm, &insn);
-
 	switch (OPCODE1(&insn)) {
 	case 0x9d:		/* popf */
 		auprobe->fixups |= UPROBE_FIX_SETF;
@@ -406,9 +404,9 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 		case 4: case 5:			/* jmp or ljmp, indirect */
 			fix_ip = false;
 		}
-		break;
+		/* fall through */
 	default:
-		break;
+		handle_riprel_insn(auprobe, mm, &insn);
 	}
 
 	if (fix_ip)
-- 
1.5.5.1

