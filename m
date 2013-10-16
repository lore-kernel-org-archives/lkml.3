Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934820Ab3JPR7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:59:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934548Ab3JPRqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Kolesov <akolesov@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [ 18/50] ARC: Ignore ptrace SETREGSET request for synthetic register "stop_pc"
Date: Wed, 16 Oct 2013 10:45:04 -0700
Message-Id: <20131016174400.590312903@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@synopsys.com>

commit 5b24282846c064ee90d40fcb3a8f63b8e754fd28 upstream.

ARCompact TRAP_S insn used for breakpoints, commits before exception is
taken (updating architectural PC). So ptregs->ret contains next-PC and
not the breakpoint PC itself. This is different from other restartable
exceptions such as TLB Miss where ptregs->ret has exact faulting PC.
gdb needs to know exact-PC hence ARC ptrace GETREGSET provides for
@stop_pc which returns ptregs->ret vs. EFA depending on the
situation.

However, writing stop_pc (SETREGSET request), which updates ptregs->ret
doesn't makes sense stop_pc doesn't always correspond to that reg as
described above.

This was not an issue so far since user_regs->ret / user_regs->stop_pc
had same value and both writing to ptregs->ret was OK, needless, but NOT
broken, hence not observed.

With gdb "jump", they diverge, and user_regs->ret updating ptregs is
overwritten immediately with stop_pc, which this patch fixes.

Reported-by: Anton Kolesov <akolesov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arc/kernel/ptrace.c
+++ b/arch/arc/kernel/ptrace.c
@@ -102,7 +102,7 @@ static int genregs_set(struct task_struc
 	REG_IGNORE_ONE(pad2);
 	REG_IN_CHUNK(callee, efa, cregs);	/* callee_regs[r25..r13] */
 	REG_IGNORE_ONE(efa);			/* efa update invalid */
-	REG_IN_ONE(stop_pc, &ptregs->ret);	/* stop_pc: PC update */
+	REG_IGNORE_ONE(stop_pc);			/* PC updated via @ret */
 
 	return ret;
 }


