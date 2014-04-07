Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaDGO22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:28:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbaDGO20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:28:26 -0400
Date: Mon, 7 Apr 2014 16:28:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] uprobes/x86: Emulate rip-relative conditional
	"near" jmp's
Message-ID: <20140407142823.GB8881@redhat.com>
References: <20140406201524.GA32694@redhat.com> <20140406201636.GA521@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140406201636.GA521@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06, Oleg Nesterov wrote:
>
> But I'll try to cleanup this patch...

See v2 below.

-------------------------------------------------------------------------------
Subject: [RFC PATCH v2 6/6] uprobes/x86: Emulate rip-relative conditional "near" jmp's

It seems that 16bit condi jmp is just 0x0f + short_jump_opc_plus_0x10.

Reported-by: Jonathan Lebon <jlebon@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 3865d8b..dae02f9 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -591,6 +591,10 @@ static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 		auprobe->ttt.opc1 = opc1;
 		break;
 
+	case 0x0f:
+		if (insn->opcode.nbytes != 2)
+			return -ENOSYS;
+		opc1 = OPCODE2(insn) - 0x10;
 	default:
 		if (!is_cond_jmp_opcode(opc1))
 			return -ENOSYS;
-- 
1.5.5.1


