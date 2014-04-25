Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbaDYRsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:48:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbaDYRry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:47:54 -0400
Date: Fri, 25 Apr 2014 19:47:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] uprobes/x86: Cleanup the usage of
	UPROBE_FIX_IP/UPROBE_FIX_CALL
Message-ID: <20140425174731.GA7979@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425174704.GA7898@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that UPROBE_FIX_IP/UPROBE_FIX_CALL are mutually exclusive we can
use a single "fix_ip_or_call" enum instead of 2 fix_* booleans. This
way the logic looks more understandable and clean to me.

While at it, join "case 0xea" with other "ip is correct" ret/lret cases.
Also change default_post_xol_op() to use "else if" for the same reason.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 4c60b7a..4ae2406 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -424,10 +424,9 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
 	long correction = (long)(utask->vaddr - utask->xol_vaddr);
 
 	handle_riprel_post_xol(auprobe, regs, &correction);
-	if (auprobe->def.fixups & UPROBE_FIX_IP)
+	if (auprobe->def.fixups & UPROBE_FIX_IP) {
 		regs->ip += correction;
-
-	if (auprobe->def.fixups & UPROBE_FIX_CALL) {
+	} else if (auprobe->def.fixups & UPROBE_FIX_CALL) {
 		regs->sp += sizeof_long();
 		if (push_ret_address(regs, utask->vaddr + auprobe->def.ilen))
 			return -ERESTART;
@@ -612,7 +611,7 @@ static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long addr)
 {
 	struct insn insn;
-	bool fix_ip = true, fix_call = false;
+	u8 fix_ip_or_call = UPROBE_FIX_IP;
 	int ret;
 
 	ret = uprobe_init_insn(auprobe, &insn, is_64bit_mm(mm));
@@ -636,21 +635,20 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	case 0xcb:
 	case 0xc2:
 	case 0xca:
-		fix_ip = false;
+	case 0xea:		/* jmp absolute -- ip is correct */
+		fix_ip_or_call = 0;
 		break;
 	case 0x9a:		/* call absolute - Fix return addr, not ip */
-		fix_call = true;
-		fix_ip = false;
-		break;
-	case 0xea:		/* jmp absolute -- ip is correct */
-		fix_ip = false;
+		fix_ip_or_call = UPROBE_FIX_CALL;
 		break;
 	case 0xff:
 		switch (MODRM_REG(&insn)) {
 		case 2: case 3:			/* call or lcall, indirect */
-			fix_call = true;
+			fix_ip_or_call = UPROBE_FIX_CALL;
+			break;
 		case 4: case 5:			/* jmp or ljmp, indirect */
-			fix_ip = false;
+			fix_ip_or_call = 0;
+			break;
 		}
 		/* fall through */
 	default:
@@ -658,10 +656,7 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	}
 
 	auprobe->def.ilen = insn.length;
-	if (fix_ip)
-		auprobe->def.fixups |= UPROBE_FIX_IP;
-	if (fix_call)
-		auprobe->def.fixups |= UPROBE_FIX_CALL;
+	auprobe->def.fixups |= fix_ip_or_call;
 
 	auprobe->ops = &default_xol_ops;
 	return 0;
-- 
1.5.5.1

