Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaH2ST1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:19:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbaH2ST0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:19:26 -0400
Date: Fri, 29 Aug 2014 20:17:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] x86, fpu: irq_fpu_usable: always return true if
	use_eager_fpu()
Message-ID: <20140829181701.GD30659@redhat.com>
References: <20140827185138.GA12487@redhat.com> <CA+55aFwi-S27_maZXU+baOqPAYfi_NTGcfbnRnk45+B8+i4hVQ@mail.gmail.com> <20140828111628.GB15276@redhat.com> <20140829181533.GA30659@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829181533.GA30659@redhat.com>
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
 arch/x86/kernel/i387.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 19dd36d..9fb2899 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -30,8 +30,7 @@ static DEFINE_PER_CPU(bool, in_kernel_fpu);
  * be set (so that the clts/stts pair does nothing that is
  * visible in the interrupted kernel thread).
  *
- * Except for the eagerfpu case when we return 1 unless we've already
- * been eager and saved the state in kernel_fpu_begin().
+ * Except for the eagerfpu case when we return 1.
  */
 static inline bool interrupted_kernel_fpu_idle(void)
 {
@@ -39,7 +38,7 @@ static inline bool interrupted_kernel_fpu_idle(void)
 		return false;
 
 	if (use_eager_fpu())
-		return __thread_has_fpu(current);
+		return true;
 
 	return !__thread_has_fpu(current) &&
 		(read_cr0() & X86_CR0_TS);
-- 
1.5.5.1


