Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbbASSxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:53:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbbASSxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:53:20 -0500
Date: Mon, 19 Jan 2015 19:52:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: [PATCH 3/3] x86, fpu: don't abuse FPU in kernel threads if
	use_eager_fpu()
Message-ID: <20150119185212.GD16427@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <20150115191918.GA27332@redhat.com> <20150119185109.GA16427@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119185109.GA16427@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Afaics there is no reason why kernel threads should have FPU context
even if use_eager_fpu() == T. Now that interrupted_kernel_fpu_idle()
does not check __thread_has_fpu() we can remove the init_fpu() code
from eager_fpu_init() and change flush_thread() called by do_execve()
to initialize FPU.

Note: of course, the change in flush_thread() is horrible and must be
cleanuped. We need the new helper, and flush_thread() should return the
error if init_fpu() fails.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/process.c |    7 +++++++
 arch/x86/kernel/xsave.c   |   13 +------------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e127dda..dd9a069 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -130,6 +130,7 @@ void flush_thread(void)
 
 	flush_ptrace_hw_breakpoint(tsk);
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
+
 	drop_init_fpu(tsk);
 	/*
 	 * Free the FPU state for non xsave platforms. They get reallocated
@@ -137,6 +138,12 @@ void flush_thread(void)
 	 */
 	if (!use_eager_fpu())
 		free_thread_xstate(tsk);
+	else if (!used_math()) {
+		/* kthread execs. TODO: cleanup this horror. */
+		if (WARN_ON(init_fpu(current)))
+			force_sig(SIGKILL, current);
+		math_state_restore();
+	}
 }
 
 static void hard_disable_TSC(void)
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 0de1fae..de9dcf8 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -688,7 +688,7 @@ void eager_fpu_init(void)
 {
 	static __refdata void (*boot_func)(void) = eager_fpu_init_bp;
 
-	clear_used_math();
+	WARN_ON(used_math());
 	current_thread_info()->status = 0;
 
 	if (eagerfpu == ENABLE)
@@ -703,17 +703,6 @@ void eager_fpu_init(void)
 		boot_func();
 		boot_func = NULL;
 	}
-
-	/*
-	 * This is same as math_state_restore(). But use_xsave() is
-	 * not yet patched to use math_state_restore().
-	 */
-	init_fpu(current);
-	__thread_fpu_begin(current);
-	if (cpu_has_xsave)
-		xrstor_state(init_xstate_buf, -1);
-	else
-		fxrstor_checking(&init_xstate_buf->i387);
 }
 
 /*
-- 
1.5.5.1


