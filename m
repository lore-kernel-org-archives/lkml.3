Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3EMMvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:51:32 -0400
Received: from git.silcnet.org ([81.89.56.81]:52972 "EHLO git.silcnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab3EMMvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:51:31 -0400
Date: Mon, 13 May 2013 14:32:07 +0200 (CEST)
From: Pekka Riikonen <priikone@iki.fi>
X-X-Sender: priikone@git.silcnet.org
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] x86: irq_fpu_usable returns false negatives with
 eagerfpu 
Message-ID: <alpine.GSO.2.00.1305131356320.18@git.silcnet.org>
User-Agent: Alpine 2.00 (GSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of eagerfpu the irq_fpu_usable() now returns false 
negatives especially in the case of ksoftirqd and interrupted idle task, 
two common cases for FPU use for example in networking/crypto.  With 
eagerfpu=off FPU use is possible in those contexts.  This is because of 
the eagerfpu check in interrupted_kernel_fpu_idle():

...
  * For now, with eagerfpu we will return interrupted kernel FPU
  * state as not-idle. TBD: Ideally we can change the return value
  * to something like __thread_has_fpu(current). But we need to
  * be careful of doing __thread_clear_has_fpu() before saving
  * the FPU etc for supporting nested uses etc. For now, take
  * the simple route!
...
 	if (use_eager_fpu())
 		return 0;

As eagerfpu is automatically "on" on those CPUs that also have the 
features like AES-NI this patch changes the eagerfpu check to return 1 in 
case the kernel_fpu_begin() has not been said yet.  Once it has been the 
__thread_has_fpu() will start returning 0.

Notice that with eagerfpu the __thread_has_fpu is always true initially. 
FPU use is thus always possible no matter what task is under us, unless 
the state has already been saved with kernel_fpu_begin().

Signed-off-by: Pekka Riikonen <priikone@iki.fi>
---
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 245a71d..cb33909 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -22,23 +22,19 @@
  /*
   * Were we in an interrupt that interrupted kernel mode?
   *
- * For now, with eagerfpu we will return interrupted kernel FPU
- * state as not-idle. TBD: Ideally we can change the return value
- * to something like __thread_has_fpu(current). But we need to
- * be careful of doing __thread_clear_has_fpu() before saving
- * the FPU etc for supporting nested uses etc. For now, take
- * the simple route!
- *
   * On others, we can do a kernel_fpu_begin/end() pair *ONLY* if that
   * pair does nothing at all: the thread must not have fpu (so
   * that we don't try to save the FPU state), and TS must
   * be set (so that the clts/stts pair does nothing that is
   * visible in the interrupted kernel thread).
+ *
+ * Except for the eagerfpu case when we return 1 unless we've already
+ * been eager and saved the state in kernel_fpu_begin().
   */
  static inline bool interrupted_kernel_fpu_idle(void)
  {
  	if (use_eager_fpu())
-		return 0;
+		return __thread_has_fpu(current);

  	return !__thread_has_fpu(current) &&
  		(read_cr0() & X86_CR0_TS);
@@ -78,8 +74,8 @@ void __kernel_fpu_begin(void)
  	struct task_struct *me = current;

  	if (__thread_has_fpu(me)) {
-		__save_init_fpu(me);
  		__thread_clear_has_fpu(me);
+		__save_init_fpu(me);
  		/* We do 'stts()' in __kernel_fpu_end() */
  	} else if (!use_eager_fpu()) {
  		this_cpu_write(fpu_owner_task, NULL);
