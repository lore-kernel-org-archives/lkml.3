Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbaEHTNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:13:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbaEHTMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:12:24 -0400
Date: Thu, 8 May 2014 21:11:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] x86/traps: Use SEND_SIG_PRIV instead of force_sig()
Message-ID: <20140508191156.GA16913@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508191140.GA16892@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

force_sig() is just force_sig_info(SEND_SIG_PRIV). Imho it should die,
we have too many ugly "send signal" helpers.

And do_trap() looks just ugly because it uses force_sig_info() or
force_sig() depending on info != NULL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/traps.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 8eddd62..2cd4291 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -168,10 +168,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	}
 #endif
 
-	if (info)
-		force_sig_info(signr, info, tsk);
-	else
-		force_sig(signr, tsk);
+	force_sig_info(signr, info ?: SEND_SIG_PRIV, tsk);
 }
 
 #define DO_ERROR(trapnr, signr, str, name)				\
@@ -305,7 +302,7 @@ do_general_protection(struct pt_regs *regs, long error_code)
 		pr_cont("\n");
 	}
 
-	force_sig(SIGSEGV, tsk);
+	force_sig_info(SIGSEGV, SEND_SIG_PRIV, tsk);
 exit:
 	exception_exit(prev_state);
 }
@@ -645,7 +642,7 @@ void math_state_restore(void)
 	 */
 	if (unlikely(restore_fpu_checking(tsk))) {
 		drop_init_fpu(tsk);
-		force_sig(SIGSEGV, tsk);
+		force_sig_info(SIGSEGV, SEND_SIG_PRIV, tsk);
 		return;
 	}
 
-- 
1.5.5.1

