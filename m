Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbaDHT0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:26:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222AbaDHT0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:26:08 -0400
Date: Tue, 8 Apr 2014 21:26:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] uprobes/x86: fix the reprel jmp/call handling
Message-ID: <20140408192600.GA6690@redhat.com>
References: <20140404185038.GA14679@redhat.com> <20140404193226.GA23092@redhat.com> <1396655065.4769.8.camel@oc7886638347.ibm.com.usor.ibm.com> <20140406201524.GA32694@redhat.com> <5343E0E3.70808@hitachi.com> <20140408162850.GC31460@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408162850.GC31460@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08, Oleg Nesterov wrote:
>
> OK... bu I'm afraid I'll ask a stupid question before I update this
> series accordinly.

And I guess I should also use insn_offset_immediate() in ttt_clear_displacement().
Which should be renamed, but I have no idea how.

OK. Unless I am totally confused (very possible) the necessary changes are
trivial. I do not want to spam lkml, so let me just show the cumulative diff
(1/6 and 4/6 should be trivially updated).

Anything else I missed?

Lets ignore j*cxz. I tried to read the intel docs and it seems that this
insn is always rel8, so we do not need to emulate it to fix the problem.
But I'll make the "Emulate j*cxz" later anyway, just for completeness.

Oleg.

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index dae02f9..f0a8afa 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -562,8 +562,8 @@ static void ttt_clear_displacement(struct arch_uprobe *auprobe, struct insn *ins
 	 * divorce ->insn[] and ->ixol[]. We need to preserve the 1st byte
 	 * of ->insn[] for set_orig_insn().
 	 */
-	memset(auprobe->insn + insn_offset_displacement(insn),
-		0, insn->moffset1.nbytes);
+	memset(auprobe->insn + insn_offset_immediate(insn),
+		0, insn->immediate.nbytes);
 }
 
 static struct uprobe_xol_ops ttt_xol_ops = {
@@ -602,10 +602,7 @@ static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 	}
 
 	auprobe->ttt.ilen = insn->length;
-	auprobe->ttt.disp = insn->moffset1.value;
-	/* so far we assume that it fits into ->moffset1 */
-	if (WARN_ON_ONCE(insn->moffset2.nbytes))
-		return -ENOEXEC;
+	auprobe->ttt.disp = insn->immediate.value;
 
 	auprobe->ops = &ttt_xol_ops;
 	return 0;

