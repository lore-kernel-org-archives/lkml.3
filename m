Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934395AbaDITov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:44:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934377AbaDITor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:44:47 -0400
Date: Wed, 9 Apr 2014 21:44:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 6/6] uprobes/x86: Emulate rip-relative conditional
	"near" jmp's
Message-ID: <20140409194442.GA6245@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409194401.GA5854@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that 16bit condi jmp is just 0x0f + short_jump_opc_plus_0x10.

Reported-by: Jonathan Lebon <jlebon@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index ab9342a..cdad38d 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -588,6 +588,14 @@ static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 		ttt_clear_displacement(auprobe, insn);
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

