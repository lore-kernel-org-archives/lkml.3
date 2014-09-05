Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbaIENqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:46:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411AbaIENqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:46:20 -0400
Date: Fri, 5 Sep 2014 15:43:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <sbsiddha@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] x86, fpu: irq_fpu_usable: always return true if
	use_eager_fpu()
Message-ID: <20140905134347.GA14252@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905134325.GA14228@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the comment and the changelog in 5187b28f "x86: Allow FPU
to be used at interrupt time even with eagerfpu", the __thread_has_fpu()
check was added to avoid the nested kernel_fpu_begin(). Now that we have
in_kernel_fpu we can remove this check and always return true.

__thread_has_fpu() can be false even if use_eager_fpu(), but this case
doesn't differ from !use_eager_fpu() case except we should not worry
about X86_CR0_TS, __kernel_fpu_begin/end will not touch this bit. And I
still think that "use_eager_fpu && (!__thread_has_fpu || !used_math)"
special cases should die, but this is off-topic right now.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/i387.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 19dd36d..7bc8236 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -30,8 +30,8 @@ static DEFINE_PER_CPU(bool, in_kernel_fpu);
  * be set (so that the clts/stts pair does nothing that is
  * visible in the interrupted kernel thread).
  *
- * Except for the eagerfpu case when we return 1 unless we've already
- * been eager and saved the state in kernel_fpu_begin().
+ * Except for the eagerfpu case when we return true; in the likely case
+ * the thread has FPU but we are not going to set/clear TS.
  */
 static inline bool interrupted_kernel_fpu_idle(void)
 {
@@ -39,7 +39,7 @@ static inline bool interrupted_kernel_fpu_idle(void)
 		return false;
 
 	if (use_eager_fpu())
-		return __thread_has_fpu(current);
+		return true;
 
 	return !__thread_has_fpu(current) &&
 		(read_cr0() & X86_CR0_TS);
-- 
1.5.5.1

