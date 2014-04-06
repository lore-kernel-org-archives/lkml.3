Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbaDFUQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 16:16:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbaDFUQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 16:16:26 -0400
Date: Sun, 6 Apr 2014 22:16:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/6] uprobes/x86: Emulate unconditional rip-relative
	jmp's
Message-ID: <20140406201617.GA493@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140406201524.GA32694@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0xeb and 0xe9. Anything else?

TODO: move ->fixup into the union along with rip_rela_target_address.

Reported-by: Jonathan Lebon <jlebon@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/uprobes.h |    8 +++++++-
 arch/x86/kernel/uprobes.c      |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 9f8210b..cca62c5 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -44,9 +44,15 @@ struct arch_uprobe {
 	u16				fixups;
 	const struct uprobe_xol_ops	*ops;
 
+	union {
 #ifdef CONFIG_X86_64
-	unsigned long			rip_rela_target_address;
+		unsigned long			rip_rela_target_address;
 #endif
+		struct {
+			s32	disp;
+			u8	ilen;
+		}				ttt;
+	};
 };
 
 struct arch_uprobe_task {
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 1ea7e1a..32ab147 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -466,6 +466,42 @@ static struct uprobe_xol_ops default_xol_ops = {
 	.post_xol = default_post_xol_op,
 };
 
+static bool ttt_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	regs->ip += auprobe->ttt.ilen + auprobe->ttt.disp;
+	return true;
+}
+
+static struct uprobe_xol_ops ttt_xol_ops = {
+	.emulate  = ttt_emulate_op,
+};
+
+static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
+{
+
+	switch (OPCODE1(insn)) {
+	case 0xeb:	/* jmp 8 */
+	case 0xe9:	/* jmp 32 */
+		break;
+	default:
+		return -ENOSYS;
+	}
+
+	/* has the side-effect of processing the entire instruction */
+	insn_get_length(insn);
+	if (WARN_ON_ONCE(!insn_complete(insn)))
+		return -ENOEXEC;
+
+	auprobe->ttt.ilen = insn->length;
+	auprobe->ttt.disp = insn->moffset1.value;
+	/* so far we assume that it fits into ->moffset1 */
+	if (WARN_ON_ONCE(insn->moffset2.nbytes))
+		return -ENOEXEC;
+
+	auprobe->ops = &ttt_xol_ops;
+	return 0;
+}
+
 /**
  * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
  * @mm: the probed address space.
@@ -483,6 +519,10 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	if (ret)
 		return ret;
 
+	ret = ttt_setup_xol_ops(auprobe, &insn);
+	if (ret == 0 || ret != ENOSYS)
+		return ret;
+
 	/*
 	 * Figure out which fixups arch_uprobe_post_xol() will need to perform,
 	 * and annotate arch_uprobe->fixups accordingly. To start with, ->fixups
-- 
1.5.5.1

