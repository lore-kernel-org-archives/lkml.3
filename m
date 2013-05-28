Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924Ab3E1Myz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:54:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49939 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933886Ab3E1Myy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:54:54 -0400
Date: Tue, 28 May 2013 05:54:07 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-ddd40da4ccbabdd2e941837aa987e08dfa4396b4@git.kernel.org>
Cc: eranian@google.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, acme@ghostprotocols.net,
        jolsa@redhat.com, fweisbec@gmail.com, akpm@linux-foundation.org,
        tglx@linutronix.de, oleg@redhat.com, cjashfor@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
        andi@firstfloor.org, vincent.weaver@maine.edu, mingo@elte.hu
Reply-To: mingo@kernel.org, eranian@google.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, jolsa@redhat.com,
        fweisbec@gmail.com, akpm@linux-foundation.org, oleg@redhat.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
        andi@firstfloor.org, vincent.weaver@maine.edu, mingo@elte.hu
In-Reply-To: <1367421944-19082-4-git-send-email-jolsa@redhat.com>
References: <1367421944-19082-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/signals:
  Merge EFLAGS bit clearing into a single statement
Git-Commit-ID: ddd40da4ccbabdd2e941837aa987e08dfa4396b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddd40da4ccbabdd2e941837aa987e08dfa4396b4
Gitweb:     http://git.kernel.org/tip/ddd40da4ccbabdd2e941837aa987e08dfa4396b4
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 1 May 2013 17:25:43 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 08:46:53 +0200

x86/signals: Merge EFLAGS bit clearing into a single statement

Merging EFLAGS bit clearing into a single statement, to
ensure EFLAGS bits are being cleared in a single instruction.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Originally-Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Stephane Eranian <eranian@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1367421944-19082-4-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
