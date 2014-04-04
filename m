Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaDDTca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:32:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbaDDTc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:32:27 -0400
Date: Fri, 4 Apr 2014 21:32:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] uprobes/x86: preparations to fix the reprel
	jmp/call handling.
Message-ID: <20140404193226.GA23092@redhat.com>
References: <20140404185038.GA14679@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140404185038.GA14679@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04, Oleg Nesterov wrote:
>
> Now let me send the draft RFC patch which fixes the "call" handling...

Damn. apparently I can't understand lib/insn.c...

Please see the draft below. Lets ignore 32bit tasks, lets ignore jmp's,
please ignore how the (pseudo) code written, I'll change it anyway.

Questions:

	1. Why insn_get_displacement() doesn't work? See "HELP!!!"
	   below.

	2. Do I use lib/insn.c correctly (ignoring displacement) ?

           In particular, is 'turn this insn into "1: call 1b;"'
           below correct?

	3. Jim, do you still think it would be better to rewrite the
	   call insns using a scratch register ?

	4. Is there other call insns with OPCODE1() != 0xe8 which
	   should be fixed too?

Thanks,

Oleg.


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
index b820668..423ae86 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -461,6 +461,52 @@ static struct uprobe_xol_ops default_xol_ops = {
 	.post_xol = default_post_xol_op,
 };
 
+static bool ttt_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+
+	if (put_user(regs->ip + auprobe->ttt.ilen, (long __user *)(regs->sp - 8)))
+		return false;
+
+	regs->sp -= 8;
+	regs->ip += auprobe->ttt.ilen + auprobe->ttt.disp;
+
+	return true;
+}
+
+static int ttt_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	regs->sp += 8;
+	if (ttt_emulate_op(auprobe, regs))
+		return 0;
+	return -ERESTART;
+}
+
+static struct uprobe_xol_ops ttt_xol_ops = {
+	.emulate  = ttt_emulate_op,
+	.post_xol = ttt_post_xol_op,
+};
+
+static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
+{
+	s32 *disp;
+
+	insn_get_length(insn);
+	auprobe->ttt.ilen = insn->length;
+
+	insn_get_displacement(insn);
+	auprobe->ttt.disp = insn->displacement.value;
+	// HELP!!! the above doesn't work, ->displacement.value == 0
+	auprobe->ttt.disp = *(s32 *)(auprobe->insn + 1);
+
+	// turn this insn into "1: call 1b;", we only need to xol it
+	// to expand the stack if ->emulate() fails.
+	disp = (void *)auprobe->insn + insn_offset_displacement(insn);
+	*disp = -(s32)auprobe->ttt.ilen;
+
+	auprobe->ops = &ttt_xol_ops;
+	return 0;
+}
+
 /**
  * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
  * @mm: the probed address space.
@@ -484,6 +530,9 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	 * is either zero or it reflects rip-related fixups.
 	 */
 	switch (OPCODE1(&insn)) {
+	case 0xe8:		/* call relative - has its own xol_ops */
+		return ttt_setup_xol_ops(auprobe, &insn);
+
 	case 0x9d:		/* popf */
 		auprobe->fixups |= UPROBE_FIX_SETF;
 		break;
@@ -493,9 +542,6 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	case 0xca:
 		fix_ip = false;
 		break;
-	case 0xe8:		/* call relative - Fix return addr */
-		fix_call = true;
-		break;
 	case 0x9a:		/* call absolute - Fix return addr, not ip */
 		fix_call = true;
 		fix_ip = false;

