Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaIBWTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:19:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40511 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaIBWS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:18:58 -0400
Date: Tue, 2 Sep 2014 15:18:32 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-66463db4fc5605d51c7bb81d009d5bf30a783a2c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bean@azulsystems.com, oleg@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, oleg@redhat.com, bean@azulsystems.com,
        hpa@linux.intel.com
In-Reply-To: <20140902175713.GA21646@redhat.com>
References: <20140902175713.GA21646@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: shift drop_init_fpu()
  from save_xstate_sig() to handle_signal()
Git-Commit-ID: 66463db4fc5605d51c7bb81d009d5bf30a783a2c
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

Commit-ID:  66463db4fc5605d51c7bb81d009d5bf30a783a2c
Gitweb:     http://git.kernel.org/tip/66463db4fc5605d51c7bb81d009d5bf30a783a2c
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 2 Sep 2014 19:57:13 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 2 Sep 2014 14:51:14 -0700

x86, fpu: shift drop_init_fpu() from save_xstate_sig() to handle_signal()

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
Cc: <stable@kernel.org> # v3.7+
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/signal.c | 5 +++++
 arch/x86/kernel/xsave.c  | 2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 2851d63..ed37a76 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -675,6 +675,11 @@ handle_signal(struct ksignal *ksig, struct pt_regs *regs)
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
index 940b142..cf0b830 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -271,8 +271,6 @@ int save_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 	if (use_fxsr() && save_xstate_epilog(buf_fx, ia32_fxstate))
 		return -1;
 
-	drop_init_fpu(tsk);	/* trigger finit */
-
 	return 0;
 }
 
