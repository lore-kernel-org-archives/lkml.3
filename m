Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbaIENqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:46:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411AbaIENqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:46:18 -0400
Date: Fri, 5 Sep 2014 15:43:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <sbsiddha@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] x86, fpu: fix math_state_restore() race with
	kernel_fpu_begin()
Message-ID: <20140905134350.GA14259@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905134325.GA14228@redhat.com>
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

Perhaps we should export in_kernel_fpu and make these helpers inline.
Probably they will have more users.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/i387.h |    4 ++++
 arch/x86/kernel/i387.c      |   12 +++++++++++-
 arch/x86/kernel/traps.c     |   12 +++++-------
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 5e275d3..605b1eb 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -51,6 +51,10 @@ static inline void kernel_fpu_end(void)
 	preempt_enable();
 }
 
+/* Must be called woth preempt disabled */
+extern void kernel_fpu_disable(void);
+extern void kernel_fpu_enable(void);
+
 /*
  * Some instructions like VIA's padlock instructions generate a spurious
  * DNA fault but don't modify SSE registers. And these instructions
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 7bc8236..ece91cf 100644
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
@@ -80,7 +91,6 @@ void __kernel_fpu_begin(void)
 
 	this_cpu_write(in_kernel_fpu, true);
 
-	/* FIXME: race with math_state_restore()-like code */
 	if (__thread_has_fpu(me)) {
 		__save_init_fpu(me);
 	} else if (!use_eager_fpu()) {
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 0d0e922..c632843 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -667,18 +667,16 @@ void math_state_restore(void)
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

