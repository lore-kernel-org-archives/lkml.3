Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab3CJSls (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 14:41:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab3CJSlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 14:41:45 -0400
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
Subject: [PATCH 2/6] signal x86: Clear RF EFLAGS bit for signal handler
Date: Sun, 10 Mar 2013 19:41:07 +0100
Message-Id: <1362940871-24486-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
References: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clearing RF EFLAGS bit for signal handler. The reason is,
that this flag is set by debug exception code to prevent
the recursive exception entry.

Leaving it set for signal handler might prevent debug
exception of the signal handler itself.

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
 arch/x86/kernel/signal.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 9df4c0b..cb12fc9 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -665,6 +665,12 @@ handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 		 */
 		regs->flags &= ~X86_EFLAGS_DF;
 		/*
+		 * Clear RF when entering the signal handler, because
+		 * it might disable possible debug exception from the
+		 * signal handler.
+		 */
+		regs->flags &= ~X86_EFLAGS_RF;
+		/*
 		 * Clear TF when entering the signal handler, but
 		 * notify any tracer that was single-stepping it.
 		 * The tracer may want to single-step inside the
-- 
1.7.11.7

