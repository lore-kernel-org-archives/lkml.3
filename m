Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152AbaDIToK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:44:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847AbaDIToH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:44:07 -0400
Date: Wed, 9 Apr 2014 21:44:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 0/6] uprobes/x86: fix the reprel jmp/call handling
Message-ID: <20140409194401.GA5854@redhat.com>
References: <20140404185038.GA14679@redhat.com> <20140404193226.GA23092@redhat.com> <1396655065.4769.8.camel@oc7886638347.ibm.com.usor.ibm.com> <20140406201524.GA32694@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140406201524.GA32694@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06, Oleg Nesterov wrote:
>
> OK. Please see the RFC changes. Obviously not for inclusion yet. And
> totally untested, except I verified that the test-case from 4/6 works.

Still not really tested, but seems to work.

Please see v2. All changes are minor except the s/ENOSYS/-ENOSYS/ fix.
Please see the intediff below. I also move "Introduce sizeof_long() ..."
to the head of this series.

Jim, I am still thinking how I can improve the commenents in 4/6 as you
asked me, and I obviously need to write the changelogs and change "ttt"
prefix.

Will you agree with s/ttt/branch/ ?

Do you think the code is fine in v2 ?

Oleg.


--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -500,16 +500,13 @@ static bool check_jmp_cond(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	unsigned long flags = regs->flags;
 
 	switch (auprobe->ttt.opc1) {
-	case 0x00:	/* not a conditional jmp */
-		return true;
-
 	#define DO(expr)	\
 		return expr;
 	CASE_COND
 	#undef	DO
 
-	default:
-		BUG();
+	default:	/* not a conditional jmp */
+		return true;
 	}
 }
 
@@ -520,7 +517,7 @@ static bool check_jmp_cond(struct arch_uprobe *auprobe, struct pt_regs *regs)
 static bool ttt_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	unsigned long new_ip = regs->ip += auprobe->ttt.ilen;
-	unsigned long disp = auprobe->ttt.disp;
+	unsigned long disp = (long)auprobe->ttt.disp;
 
 	if (ttt_is_call(auprobe)) {
 		unsigned long new_sp = regs->sp - sizeof_long();
@@ -562,8 +559,8 @@ static void ttt_clear_displacement(struct arch_uprobe *auprobe, struct insn *ins
 	 * divorce ->insn[] and ->ixol[]. We need to preserve the 1st byte
 	 * of ->insn[] for set_orig_insn().
 	 */
-	memset(auprobe->insn + insn_offset_displacement(insn),
-		0, insn->moffset1.nbytes);
+	memset(auprobe->insn + insn_offset_immediate(insn),
+		0, insn->immediate.nbytes);
 }
 
 static struct uprobe_xol_ops ttt_xol_ops = {
@@ -571,6 +568,7 @@ static struct uprobe_xol_ops ttt_xol_ops = {
 	.post_xol = ttt_post_xol_op,
 };
 
+/* Returns -ENOSYS if ttt_xol_ops doesn't handle this insn */
 static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 {
 	u8 opc1 = OPCODE1(insn);
@@ -588,24 +586,24 @@ static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 
 	case 0xe8:	/* call relative */
 		ttt_clear_displacement(auprobe, insn);
-		auprobe->ttt.opc1 = opc1;
 		break;
 
 	case 0x0f:
 		if (insn->opcode.nbytes != 2)
 			return -ENOSYS;
+		/*
+		 * If it is a "near" conditional jmp, OPCODE2() - 0x10 matches
+		 * OPCODE1() of the "short" jmp which checks the same condition.
+		 */
 		opc1 = OPCODE2(insn) - 0x10;
 	default:
 		if (!is_cond_jmp_opcode(opc1))
 			return -ENOSYS;
-		auprobe->ttt.opc1 = opc1;
 	}
 
+	auprobe->ttt.opc1 = opc1;
 	auprobe->ttt.ilen = insn->length;
-	auprobe->ttt.disp = insn->moffset1.value;
-	/* so far we assume that it fits into ->moffset1 */
-	if (WARN_ON_ONCE(insn->moffset2.nbytes))
-		return -ENOEXEC;
+	auprobe->ttt.disp = insn->immediate.value;
 
 	auprobe->ops = &ttt_xol_ops;
 	return 0;
@@ -629,7 +627,7 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 		return ret;
 
 	ret = ttt_setup_xol_ops(auprobe, &insn);
-	if (ret == 0 || ret != ENOSYS)
+	if (ret != -ENOSYS)
 		return ret;
 
 	/*

