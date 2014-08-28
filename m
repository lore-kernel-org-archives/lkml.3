Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965831AbaH1LTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:19:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965685AbaH1LTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:19:02 -0400
Date: Thu, 28 Aug 2014 13:16:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] x86, fpu: copy_process's FPU paths cleanups
Message-ID: <20140828111628.GB15276@redhat.com>
References: <20140827185138.GA12487@redhat.com> <CA+55aFwi-S27_maZXU+baOqPAYfi_NTGcfbnRnk45+B8+i4hVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwi-S27_maZXU+baOqPAYfi_NTGcfbnRnk45+B8+i4hVQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27, Linus Torvalds wrote:
>
> On Wed, Aug 27, 2014 at 11:51 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Who can review this? And where should I send FPU changes?
>
> FWIW, I have nothing against this series (or, indeed, the last series
> with the exception of 2/5 that got replaced by just the preemption
> disable).

OK, thanks. (that last series needs more work, kernel_fpu_begin/end).

> Although with the whole i387 state I always hope somebody else checks
> it too,

Of course! And I do not know whom else I should ask to review, I simply
do not know who might be interested.

> and it's obviously not 3.17 material any more

Yes, sure.

> (possibly with
> the exception of the afore-mentioned preemption patch, although even
> that might be better off as 3.18 + stable)

OK.

But this all is not that important, I started to spam you just because
I tried to understand this code and came to conclusion it deserves
some cleanups.

My real concern is the first fix. Because this bug was not foung by me,
Bean actually hit this bug. I attached it below just in case. If I
resend it I'll optimistically assume that you do not see any problem
in this patch too.

Thanks,

Oleg.

------------------------------------------------------------------------------
Subject: [PATCH 1/1] x86, fpu: shift drop_init_fpu() from save_xstate_sig() to handle_signal()

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
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/signal.c |    5 +++++
 arch/x86/kernel/xsave.c  |    2 --
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
index a4b451c..74b34c2 100644
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
1.5.5.1



