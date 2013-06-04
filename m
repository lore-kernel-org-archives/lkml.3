Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab3FDRAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:00:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48372 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823Ab3FDRAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:00:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pekka Riikonen <priikone@iki.fi>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 70/75] x86: Allow FPU to be used at interrupt time even with eagerfpu
Date: Tue,  4 Jun 2013 09:55:54 -0700
Message-Id: <1370364959-9475-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pekka Riikonen <priikone@iki.fi>

commit 5187b28ff08249ab8a162e802209ed04e271ca02 upstream.

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

[ hpa: this is a performance regression, not a correctness regression,
  but since it can be quite serious on CPUs which need encryption at
  interrupt time I am marking this for urgent/stable. ]

Signed-off-by: Pekka Riikonen <priikone@iki.fi>
Link: http://lkml.kernel.org/r/alpine.GSO.2.00.1305131356320.18@git.silcnet.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/i387.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

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
-- 
1.8.1.2

