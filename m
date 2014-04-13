Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbaDMRvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 13:51:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbaDMRqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 13:46:07 -0400
Date: Sun, 13 Apr 2014 19:46:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 11/15] uprobes/x86: Emulate unconditional relative jmp's
Message-ID: <20140413174600.GA11885@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413174508.GA11811@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we always execute all insns out-of-line, including relative
jmp's and call's. This assumes that even if regs->ip points to nowhere
after the single-step, default_post_xol_op(UPROBE_FIX_IP) logic will
update it correctly.

However, this doesn't work if this regs->ip == xol_vaddr + insn_offset
is not canonical. In this case CPU generates #GP and general_protection()
kills the task which tries to execute this insn out-of-line.

Now that we have uprobe_xol_ops we can teach uprobes to emulate these
insns and solve the problem. This patch adds branch_xol_ops which has
a single branch_emulate_op() hook, so far it can only handle rel8/32
relative jmp's.

TODO: move ->fixup into the union along with rip_rela_target_address.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Jonathan Lebon <jlebon@redhat.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/x86/include/asm/uprobes.h |    8 +++++++-
 arch/x86/kernel/uprobes.c      |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 9f8210b..e9fd4d5 100644
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
+			s32	offs;
+			u8	ilen;
+		}				branch;
+	};
 };
 
 struct arch_uprobe_task {
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index ef59ef9..b1d129d 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -461,6 +461,40 @@ static struct uprobe_xol_ops default_xol_ops = {
 	.post_xol = default_post_xol_op,
 };
 
+static bool branch_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	regs->ip += auprobe->branch.ilen + auprobe->branch.offs;
+	return true;
+}
+
+static struct uprobe_xol_ops branch_xol_ops = {
+	.emulate  = branch_emulate_op,
+};
+
+/* Returns -ENOSYS if branch_xol_ops doesn't handle this insn */
+static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
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
+	auprobe->branch.ilen = insn->length;
+	auprobe->branch.offs = insn->immediate.value;
+
+	auprobe->ops = &branch_xol_ops;
+	return 0;
+}
+
 /**
  * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
  * @mm: the probed address space.
@@ -478,6 +512,10 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	if (ret)
 		return ret;
 
+	ret = branch_setup_xol_ops(auprobe, &insn);
+	if (ret != -ENOSYS)
+		return ret;
+
 	/*
 	 * Figure out which fixups arch_uprobe_post_xol() will need to perform,
 	 * and annotate arch_uprobe->fixups accordingly. To start with, ->fixups
-- 
1.5.5.1

