Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab3E3Ud5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:33:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50520 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3E3Udv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:33:51 -0400
Date: Thu, 30 May 2013 13:33:10 -0700
From: tip-bot for Pekka Riikonen <tipbot@zytor.com>
Message-ID: <tip-b61601079f974b9ffd3caf08ecb3a71142adf821@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        priikone@iki.fi, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        priikone@iki.fi, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <alpine.GSO.2.00.1305131356320.18@git.silcnet.org>
References: <alpine.GSO.2.00.1305131356320.18@git.silcnet.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Allow FPU to be used at interrupt time even with eagerfpu
Git-Commit-ID: b61601079f974b9ffd3caf08ecb3a71142adf821
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

Commit-ID:  b61601079f974b9ffd3caf08ecb3a71142adf821
Gitweb:     http://git.kernel.org/tip/b61601079f974b9ffd3caf08ecb3a71142adf821
Author:     Pekka Riikonen <priikone@iki.fi>
AuthorDate: Mon, 13 May 2013 14:32:07 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 30 May 2013 11:49:31 -0700

x86: Allow FPU to be used at interrupt time even with eagerfpu

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
Cc: <stable@vger.kernel.org> v3.7+
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
