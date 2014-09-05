Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbaIENqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:46:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438AbaIENq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:46:26 -0400
Date: Fri, 5 Sep 2014 15:43:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <sbsiddha@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] x86, fpu: introduce per-cpu "bool in_kernel_fpu"
Message-ID: <20140905134340.GA14242@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905134325.GA14228@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interrupted_kernel_fpu_idle() tries to detect if kernel_fpu_begin()
is safe or not. In particular it should obviously deny the nested
kernel_fpu_begin() and this logic doesn't look clean.

If use_eager_fpu() == T we rely on a) __thread_has_fpu() check in
interrupted_kernel_fpu_idle(), and b) on the fact that _begin() does
__thread_clear_has_fpu().

Otherwise we demand that the interrupted task has no FPU if it is in
kernel mode, this works because __kernel_fpu_begin() does clts() and
interrupted_kernel_fpu_idle() checks X86_CR0_TS.

Add the per-cpu "bool in_kernel_fpu" variable, and change this code
to check/set/clear it. This allows to do some cleanups and fixes.

Note that the current code looks racy. Say, kernel_fpu_begin() right
after math_state_restore()->__thread_fpu_begin() will overwrite the
regs we are going to restore. This patch doesn't try to fix this, it
only adds a comment, but "in_kernel_fpu" can also be used to implement
kernel_fpu_disable() / kernel_fpu_enable().

The patch also moves WARN_ON_ONCE() under preempt_disable() just to
make this_cpu_read() look better, this is not really needed. And in
fact I think we should move it into __kernel_fpu_begin().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/i387.h |    2 +-
 arch/x86/kernel/i387.c      |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index ed8089d..5e275d3 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -40,8 +40,8 @@ extern void __kernel_fpu_end(void);
 
 static inline void kernel_fpu_begin(void)
 {
-	WARN_ON_ONCE(!irq_fpu_usable());
 	preempt_disable();
+	WARN_ON_ONCE(!irq_fpu_usable());
 	__kernel_fpu_begin();
 }
 
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index d5dd808..8fb8868 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -19,6 +19,8 @@
 #include <asm/fpu-internal.h>
 #include <asm/user.h>
 
+static DEFINE_PER_CPU(bool, in_kernel_fpu);
+
 /*
  * Were we in an interrupt that interrupted kernel mode?
  *
@@ -33,6 +35,9 @@
  */
 static inline bool interrupted_kernel_fpu_idle(void)
 {
+	if (this_cpu_read(in_kernel_fpu))
+		return false;
+
 	if (use_eager_fpu())
 		return __thread_has_fpu(current);
 
@@ -73,6 +78,9 @@ void __kernel_fpu_begin(void)
 {
 	struct task_struct *me = current;
 
+	this_cpu_write(in_kernel_fpu, true);
+
+	/* FIXME: race with math_state_restore()-like code */
 	if (__thread_has_fpu(me)) {
 		__thread_clear_has_fpu(me);
 		__save_init_fpu(me);
@@ -99,6 +107,8 @@ void __kernel_fpu_end(void)
 	} else {
 		stts();
 	}
+
+	this_cpu_write(in_kernel_fpu, false);
 }
 EXPORT_SYMBOL(__kernel_fpu_end);
 
-- 
1.5.5.1

