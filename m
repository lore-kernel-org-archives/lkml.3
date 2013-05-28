Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909Ab3E1Mwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:52:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49890 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933886Ab3E1Mws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:52:48 -0400
Date: Tue, 28 May 2013 05:51:34 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-5e219b3c671b34b2d79468fe89c44c0460c0f02b@git.kernel.org>
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
In-Reply-To: <1367421944-19082-2-git-send-email-jolsa@redhat.com>
References: <1367421944-19082-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/signals:
  Propagate RF EFLAGS bit through the signal restore call
Git-Commit-ID: 5e219b3c671b34b2d79468fe89c44c0460c0f02b
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

Commit-ID:  5e219b3c671b34b2d79468fe89c44c0460c0f02b
Gitweb:     http://git.kernel.org/tip/5e219b3c671b34b2d79468fe89c44c0460c0f02b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 1 May 2013 17:25:41 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 08:46:50 +0200

x86/signals: Propagate RF EFLAGS bit through the signal restore call

While porting Vince's perf overflow tests I found perf event
breakpoint overflow does not work properly.

I found the x86 RF EFLAG bit not being set when returning
from debug exception after triggering signal handler. Which
is exactly what you get when you set perf breakpoint overflow
SIGIO handler.

This patch and the next two patches fix the underlying bugs.

This patch adds the RF EFLAGS bit to be restored on return from
signal from the original register context before the signal was
entered.

This will prevent the RF flag to disappear when returning
from exception due to the signal handler being executed.

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
Link: http://lkml.kernel.org/r/1367421944-19082-2-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/ia32/ia32_signal.c        | 2 --
 arch/x86/include/asm/sighandling.h | 4 ++--
 arch/x86/kernel/signal.c           | 6 ------
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index cf1a471..bccfca6 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -34,8 +34,6 @@
 #include <asm/sys_ia32.h>
 #include <asm/smap.h>
 
-#define FIX_EFLAGS	__FIX_EFLAGS
-
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
 	int err = 0;
diff --git a/arch/x86/include/asm/sighandling.h b/arch/x86/include/asm/sighandling.h
index beff97f..7a95816 100644
--- a/arch/x86/include/asm/sighandling.h
+++ b/arch/x86/include/asm/sighandling.h
@@ -7,10 +7,10 @@
 
 #include <asm/processor-flags.h>
 
-#define __FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
+#define FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
 			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
 			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
-			 X86_EFLAGS_CF)
+			 X86_EFLAGS_CF | X86_EFLAGS_RF)
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 6956299..9df4c0b 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -43,12 +43,6 @@
 
 #include <asm/sigframe.h>
 
-#ifdef CONFIG_X86_32
-# define FIX_EFLAGS	(__FIX_EFLAGS | X86_EFLAGS_RF)
-#else
-# define FIX_EFLAGS	__FIX_EFLAGS
-#endif
-
 #define COPY(x)			do {			\
 	get_user_ex(regs->x, &sc->x);			\
 } while (0)
