Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaHXTuG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 15:50:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbaHXTuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 15:50:03 -0400
Date: Sun, 24 Aug 2014 21:47:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] x86, fpu: shift init_fpu() from eager_fpu_init() to
	eager_fpu_init_bp()
Message-ID: <20140824194743.GA27451@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140824194700.GA27281@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not strictly needed, eager_fpu_init() is called before
the very first schedule() on this CPU, but let's remove the last
unconditional clear_used_math().

eager_fpu_init() does init_fpu() every time, but this is only needed
on boot CPU, otherwise this idle thread already has a valid fpu state
copied by arch_dup_task_struct().

And this allows to remove clear_used_math(). swapper/0 doesn't have
this flag when start_kernel() calls us, other idle threads correctly
have this flag set.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/xsave.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 51be404..33f4ebe 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -601,19 +601,20 @@ void xsave_init(void)
 	this_func();
 }
 
-static inline void __init eager_fpu_init_bp(void)
+static void __init eager_fpu_init_bp(void)
 {
 	current->thread.fpu.state =
 	    alloc_bootmem_align(xstate_size, __alignof__(struct xsave_struct));
 	if (!init_xstate_buf)
 		setup_init_fpu_buf();
+
+	init_fpu(current);
 }
 
 void eager_fpu_init(void)
 {
 	static __refdata void (*boot_func)(void) = eager_fpu_init_bp;
 
-	clear_used_math();
 	current_thread_info()->status = 0;
 
 	if (eagerfpu == ENABLE)
@@ -633,7 +634,6 @@ void eager_fpu_init(void)
 	 * This is same as math_state_restore(). But use_xsave() is
 	 * not yet patched to use math_state_restore().
 	 */
-	init_fpu(current);
 	__thread_fpu_begin(current);
 	if (cpu_has_xsave)
 		xrstor_state(init_xstate_buf, -1);
-- 
1.5.5.1

