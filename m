Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbaIENqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:46:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438AbaIENqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:46:22 -0400
Date: Fri, 5 Sep 2014 15:43:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <sbsiddha@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] x86, fpu: introduce try_to_restore_fpu()
Message-ID: <20140905134353.GA14262@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905134325.GA14228@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic. Every caller of restore_fpu_checking() does drop_init_fpu()
on failure, add the trivial helper and update the callers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/fpu-internal.h |   15 +++++++++++----
 arch/x86/kernel/i387.c              |    8 +++-----
 arch/x86/kernel/traps.c             |    8 +++-----
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 4cbb40e..e71c7f5 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -384,6 +384,15 @@ static inline void drop_init_fpu(struct task_struct *tsk)
 	}
 }
 
+static inline bool try_to_restore_fpu(struct task_struct *tsk)
+{
+	if (unlikely(restore_fpu_checking(tsk))) {
+		drop_init_fpu(tsk);
+		return false;
+	}
+	return true;
+}
+
 /*
  * FPU state switching for scheduling.
  *
@@ -462,10 +471,8 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
  */
 static inline void switch_fpu_finish(struct task_struct *new, fpu_switch_t fpu)
 {
-	if (fpu.preload) {
-		if (unlikely(restore_fpu_checking(new)))
-			drop_init_fpu(new);
-	}
+	if (fpu.preload)
+		try_to_restore_fpu(new);
 }
 
 /*
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index ece91cf..1918f67 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -104,12 +104,10 @@ void __kernel_fpu_end(void)
 {
 	struct task_struct *me = current;
 
-	if (__thread_has_fpu(me)) {
-		if (WARN_ON(restore_fpu_checking(me)))
-			drop_init_fpu(me);
-	} else if (!use_eager_fpu()) {
+	if (__thread_has_fpu(me))
+		WARN_ON(!try_to_restore_fpu(me));
+	else if (!use_eager_fpu())
 		stts();
-	}
 
 	this_cpu_write(in_kernel_fpu, false);
 }
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c632843..f516cf1 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -670,12 +670,10 @@ void math_state_restore(void)
 	/* Avoid __kernel_fpu_begin() right after __thread_fpu_begin() */
 	kernel_fpu_disable();
 	__thread_fpu_begin(tsk);
-	if (unlikely(restore_fpu_checking(tsk))) {
-		drop_init_fpu(tsk);
-		force_sig_info(SIGSEGV, SEND_SIG_PRIV, tsk);
-	} else {
+	if (likely(try_to_restore_fpu(tsk)))
 		tsk->thread.fpu_counter++;
-	}
+	else
+		force_sig_info(SIGSEGV, SEND_SIG_PRIV, tsk);
 	kernel_fpu_enable();
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
-- 
1.5.5.1

