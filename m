Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaCaUpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:45:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaCaUpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:45:02 -0400
Date: Mon, 31 Mar 2014 21:44:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] uprobes/x86: Kill the "ia32_compat" check in
	handle_riprel_insn(), remove "mm" arg
Message-ID: <20140331194405.GA9290@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331194337.GA9257@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill the "mm->context.ia32_compat" check in handle_riprel_insn(), if
it is true insn_rip_relative() must return false. validate_insn_bits()
passed "ia32_compat" as !x86_64 to insn_init(), and insn_rip_relative()
checks insn->x86_64.

Also, remove the no longer needed "struct mm_struct *mm" argument and
the unnecessary "return" at the end.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index d72dfbf..382a69d 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -253,14 +253,11 @@ static int validate_insn_32bits(struct arch_uprobe *auprobe, struct insn *insn)
  *  - The displacement is always 4 bytes.
  */
 static void
-handle_riprel_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, struct insn *insn)
+handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
 {
 	u8 *cursor;
 	u8 reg;
 
-	if (mm->context.ia32_compat)
-		return;
-
 	if (!insn_rip_relative(insn))
 		return;
 
@@ -314,7 +311,6 @@ handle_riprel_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, struct ins
 		cursor++;
 		memmove(cursor, cursor + insn->displacement.nbytes, insn->immediate.nbytes);
 	}
-	return;
 }
 
 static int validate_insn_64bits(struct arch_uprobe *auprobe, struct insn *insn)
@@ -343,7 +339,7 @@ static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	return validate_insn_64bits(auprobe, insn);
 }
 #else /* 32-bit: */
-static void handle_riprel_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, struct insn *insn)
+static void handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
 {
 	/* No RIP-relative addressing on 32-bit */
 }
@@ -406,7 +402,7 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 		}
 		/* fall through */
 	default:
-		handle_riprel_insn(auprobe, mm, &insn);
+		handle_riprel_insn(auprobe, &insn);
 	}
 
 	if (fix_ip)
-- 
1.5.5.1

