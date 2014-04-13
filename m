Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaDMRsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 13:48:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501AbaDMRqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 13:46:21 -0400
Date: Sun, 13 Apr 2014 19:46:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 15/15] uprobes/x86: Emulate relative conditional "near"
	jmp's
Message-ID: <20140413174613.GA11905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413174508.GA11811@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change branch_setup_xol_ops() to simply use opc1 = OPCODE2(insn) - 0x10
if OPCODE1() == 0x0f; this matches the "short" jmp which checks the same
condition.

Thanks to lib/insn.c, it does the rest correctly. branch->ilen/offs are
correct no matter if this jmp is "near" or "short".

Reported-by: Jonathan Lebon <jlebon@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/x86/kernel/uprobes.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index b5f2fa4..d7e9d04 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -599,6 +599,14 @@ static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 		branch_clear_offset(auprobe, insn);
 		break;
 
+	case 0x0f:
+		if (insn->opcode.nbytes != 2)
+			return -ENOSYS;
+		/*
+		 * If it is a "near" conditional jmp, OPCODE2() - 0x10 matches
+		 * OPCODE1() of the "short" jmp which checks the same condition.
+		 */
+		opc1 = OPCODE2(insn) - 0x10;
 	default:
 		if (!is_cond_jmp_opcode(opc1))
 			return -ENOSYS;
-- 
1.5.5.1

