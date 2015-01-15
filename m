Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbbAOTVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:21:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306AbbAOTVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:21:36 -0500
Date: Thu, 15 Jan 2015 20:20:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: [PATCH 3/3] x86, fpu: fix math_state_restore() race with
	kernel_fpu_begin()
Message-ID: <20150115192028.GD27332@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <20150115191918.GA27332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115191918.GA27332@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

math_state_restore() can race with kernel_fpu_begin() if irq comes
right after __thread_fpu_begin(), __save_init_fpu() will overwrite
fpu->state we are going to restore.

Add 2 simple helpers, kernel_fpu_disable() and kernel_fpu_enable()
which simply set/clear in_kernel_fpu, and change math_state_restore()
to exclude kernel_fpu_begin() in between.

Alternatively we could use local_irq_save/restore, but probably these
new helpers can have more users.

Perhaps they should disable/enable preemption themselves, in this case
we can remove preempt_disable() in __restore_xstate_sig().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/i387.h |    4 ++++
 arch/x86/kernel/i387.c      |   11 +++++++++++
 arch/x86/kernel/traps.c     |   12 +++++-------
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 5e275d3..6eb6fcb 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -51,6 +51,10 @@ static inline void kernel_fpu_end(void)
 	preempt_enable();
 }
 
+/* Must be called with preempt disabled */
+extern void kernel_fpu_disable(void);
+extern void kernel_fpu_enable(void);
+
 /*
  * Some instructions like VIA's padlock instructions generate a spurious
  * DNA fault but don't modify SSE registers. And these instructions
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 12088a3..81049ff 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -21,6 +21,17 @@
 
 static DEFINE_PER_CPU(bool, in_kernel_fpu);
 
+void kernel_fpu_disable(void)
+{
+	WARN_ON(this_cpu_read(in_kernel_fpu));
+	this_cpu_write(in_kernel_fpu, true);
+}
+
+void kernel_fpu_enable(void)
+{
+	this_cpu_write(in_kernel_fpu, false);
+}
+
 /*
  * Were we in an interrupt that interrupted kernel mode?
  *
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 88900e2..fb4cb6a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -788,18 +788,16 @@ void math_state_restore(void)
 		local_irq_disable();
 	}
 
+	/* Avoid __kernel_fpu_begin() right after __thread_fpu_begin() */
+	kernel_fpu_disable();
 	__thread_fpu_begin(tsk);
-
-	/*
-	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
-	 */
 	if (unlikely(restore_fpu_checking(tsk))) {
 		drop_init_fpu(tsk);
 		force_sig_info(SIGSEGV, SEND_SIG_PRIV, tsk);
-		return;
+	} else {
+		tsk->thread.fpu_counter++;
 	}
-
-	tsk->thread.fpu_counter++;
+	kernel_fpu_enable();
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
-- 
1.5.5.1


