Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab3EGKlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:41:50 -0400
Received: from git.silcnet.org ([81.89.56.81]:43894 "EHLO git.silcnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab3EGKls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:41:48 -0400
X-Greylist: delayed 1685 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 06:41:48 EDT
Date: Tue, 7 May 2013 12:13:32 +0200 (CEST)
From: Pekka Riikonen <priikone@iki.fi>
X-X-Sender: priikone@git.silcnet.org
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] irq_fpu_usable returns false negatives with eagerfpu
Message-ID: <alpine.GSO.2.00.1305062000140.23067@git.silcnet.org>
User-Agent: Alpine 2.00 (GSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With the addition of eagerfpu the irq_fpu_usable() now returns false 
negatives especially in the case of ksoftirqd and interrupted idle task, 
two common cases for FPU use for example in networking.  This is because 
of the eagerfpu check in interrupted_kernel_fpu_idle():

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

This should be fixed as eagerfpu is commonly "on" by default on those CPUs 
that also have the features like AES-NI.

The enclosed patch changes the eagerfpu check to return 1 in case the 
kernel_fpu_begin() has not been said yet.  Once it has been the 
__thread_has_fpu() will start returning 0.  The state is restored in 
kernel_fpu_end().  The state is thus always saved no matter what task is 
under us, unless it has been saved already with kernel_fpu_begin().

This does cause the penalty of unnecessary FPU saving in the cases of 
ksoftirqd and interrupted idle task but presumably it is cheaper than 
clts/stts.  Still, there could also be separate checks for ksoftirqd (new 
check like in_ksoftirqd()) and idle task and then not save the state at 
all.  As far as I can see it would always be safe.  This is not in the 
patch.

I've tested this lightly, but it seems to work.  Have I missed something?

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
