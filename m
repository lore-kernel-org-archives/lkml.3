Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaDFURc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 16:17:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbaDFUQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 16:16:37 -0400
Date: Sun, 6 Apr 2014 22:16:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 6/6] uprobes/x86: Emulate rip-relative conditional
	"near" jmp's
Message-ID: <20140406201636.GA521@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140406201524.GA32694@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that 16bit conditional jmp is just
0x0f + short_jump_opcode_incremented by 0x10.

But I'll try to cleanup this patch...

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 797b8a4..8f92cbf 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -564,6 +564,19 @@ static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 	if (WARN_ON_ONCE(!insn_complete(insn)))
 		return -ENOEXEC;
 
+#define CASE(op_y, op_n, cond)	\
+		case 0x ## op_y: case 0x ## op_n:
+
+	if (insn->opcode.nbytes == 2 && opc1 == 0x0f) {
+		opc1 = OPCODE2(insn) - 0x10;
+
+		switch (opc1) {
+		X86_COND_OPCODES
+		default:
+			return -ENOSYS;
+		}
+	}
+
 	switch (opc1) {
 	case 0xeb:	/* jmp 8 */
 	case 0xe9:	/* jmp 32 */
@@ -573,10 +586,7 @@ static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 	case 0xe8:	/* call relative */
 		ttt_clear_displacement(auprobe, insn);
 		/* fall through */
-	#define CASE(op_y, op_n, cond)	\
-			case 0x ## op_y: case 0x ## op_n:
 	X86_COND_OPCODES
-	#undef CASE
 		auprobe->ttt.opc1 = opc1;
 		break;
 
@@ -584,6 +594,8 @@ static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 		return -ENOSYS;
 	}
 
+#undef CASE
+
 	auprobe->ttt.ilen = insn->length;
 	auprobe->ttt.disp = insn->moffset1.value;
 	/* so far we assume that it fits into ->moffset1 */
-- 
1.5.5.1

