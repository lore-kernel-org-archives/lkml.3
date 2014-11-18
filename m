Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619AbaKRPIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:08:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbaKROJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:37 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 068/206] x86, fpu: shift drop_init_fpu() from save_xstate_sig() to handle_signal()
Date: Tue, 18 Nov 2014 15:07:03 +0100
Message-Id: <2a57185838f4b505cd8ce0ea8ac3e1da6f2a3ff4.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 66463db4fc5605d51c7bb81d009d5bf30a783a2c upstream.

save_xstate_sig()->drop_init_fpu() doesn't look right. setup_rt_frame()
can fail after that, in this case the next setup_rt_frame() triggered
by SIGSEGV won't save fpu simply because the old state was lost. This
obviously mean that fpu won't be restored after sys_rt_sigreturn() from
SIGSEGV handler.

Shift drop_init_fpu() into !failed branch in handle_signal().

Test-case (needs -O2):

	#include <stdio.h>
	#include <signal.h>
	#include <unistd.h>
	#include <sys/syscall.h>
	#include <sys/mman.h>
	#include <pthread.h>
	#include <assert.h>

	volatile double D;

	void test(double d)
	{
		int pid = getpid();

		for (D = d; D == d; ) {
			/* sys_tkill(pid, SIGHUP); asm to avoid save/reload
			 * fp regs around "C" call */
			asm ("" : : "a"(200), "D"(pid), "S"(1));
			asm ("syscall" : : : "ax");
		}

		printf("ERR!!\n");
	}

	void sigh(int sig)
	{
	}

	char altstack[4096 * 10] __attribute__((aligned(4096)));

	void *tfunc(void *arg)
	{
		for (;;) {
			mprotect(altstack, sizeof(altstack), PROT_READ);
			mprotect(altstack, sizeof(altstack), PROT_READ|PROT_WRITE);
		}
	}

	int main(void)
	{
		stack_t st = {
			.ss_sp = altstack,
			.ss_size = sizeof(altstack),
			.ss_flags = SS_ONSTACK,
		};

		struct sigaction sa = {
			.sa_handler = sigh,
		};

		pthread_t pt;

		sigaction(SIGSEGV, &sa, NULL);
		sigaltstack(&st, NULL);
		sa.sa_flags = SA_ONSTACK;
		sigaction(SIGHUP, &sa, NULL);

		pthread_create(&pt, NULL, tfunc, NULL);

		test(123.456);
		return 0;
	}

Reported-by: Bean Anderson <bean@azulsystems.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20140902175713.GA21646@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/signal.c | 5 +++++
 arch/x86/kernel/xsave.c  | 2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 9e5de6813e1f..b88fc86309bc 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -673,6 +673,11 @@ handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 		 * handler too.
 		 */
 		regs->flags &= ~(X86_EFLAGS_DF|X86_EFLAGS_RF|X86_EFLAGS_TF);
+		/*
+		 * Ensure the signal handler starts with the new fpu state.
+		 */
+		if (used_math())
+			drop_init_fpu(current);
 	}
 	signal_setup_done(failed, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 7305625c2767..f5869fc65d66 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -268,8 +268,6 @@ int save_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 	if (use_fxsr() && save_xstate_epilog(buf_fx, ia32_fxstate))
 		return -1;
 
-	drop_init_fpu(tsk);	/* trigger finit */
-
 	return 0;
 }
 
-- 
2.1.3

