Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3CJSmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 14:42:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab3CJSmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 14:42:08 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/6] signal x86: Merge EFLAGS bit clearing into single statement
Date: Sun, 10 Mar 2013 19:41:08 +0100
Message-Id: <1362940871-24486-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
References: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merging EFLAGS bit clearing into a single statement, to
ensure EFLAGS bits being cleared in single instruction.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/signal.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index cb12fc9..cf91358 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -662,21 +662,17 @@ handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 	if (!failed) {
 		/*
 		 * Clear the direction flag as per the ABI for function entry.
-		 */
-		regs->flags &= ~X86_EFLAGS_DF;
-		/*
+		 *
 		 * Clear RF when entering the signal handler, because
 		 * it might disable possible debug exception from the
 		 * signal handler.
-		 */
-		regs->flags &= ~X86_EFLAGS_RF;
-		/*
+		 *
 		 * Clear TF when entering the signal handler, but
 		 * notify any tracer that was single-stepping it.
 		 * The tracer may want to single-step inside the
 		 * handler too.
 		 */
-		regs->flags &= ~X86_EFLAGS_TF;
+		regs->flags &= ~(X86_EFLAGS_DF|X86_EFLAGS_RF|X86_EFLAGS_TF);
 	}
 	signal_setup_done(failed, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
-- 
1.7.11.7

