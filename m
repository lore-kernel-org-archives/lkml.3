Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3CASMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 13:12:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab3CASMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 13:12:31 -0500
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
        Vince Weaver <vincent.weaver@maine.edu>
Subject: [PATCH 2/5] signal x86: Clear RF EFLAGS bit for signal handler
Date: Fri,  1 Mar 2013 19:11:49 +0100
Message-Id: <1362161512-16803-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1362161512-16803-1-git-send-email-jolsa@redhat.com>
References: <1362161512-16803-1-git-send-email-jolsa@redhat.com>
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
---
 arch/x86/kernel/signal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index b6fe116..e273571 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -726,6 +726,13 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	regs->flags &= ~X86_EFLAGS_DF;
 
 	/*
+	 * Clear RF when entering the signal handler, because
+	 * it might disable possible debug exception from the
+	 * signal handler.
+	 */
+	regs->flags &= ~X86_EFLAGS_RF;
+
+	/*
 	 * Clear TF when entering the signal handler, but
 	 * notify any tracer that was single-stepping it.
 	 * The tracer may want to single-step inside the
-- 
1.7.11.7

