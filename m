Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaDDSvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:51:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbaDDSvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:51:18 -0400
Date: Fri, 4 Apr 2014 20:51:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/9] uprobes/x86: Kill the "ia32_compat" check in
	handle_riprel_insn(), remove "mm" arg
Message-ID: <20140404185120.GA14723@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140404185038.GA14679@redhat.com>
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
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/x86/kernel/uprobes.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 098e56e..963c121 100644
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
@@ -376,7 +372,7 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	 * and annotate arch_uprobe->fixups accordingly. To start with, ->fixups
 	 * is either zero or it reflects rip-related fixups.
 	 */
-	handle_riprel_insn(auprobe, mm, &insn);
+	handle_riprel_insn(auprobe, &insn);
 
 	switch (OPCODE1(&insn)) {
 	case 0x9d:		/* popf */
-- 
1.5.5.1

