Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaHXTtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 15:49:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbaHXTtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 15:49:31 -0400
Date: Sun, 24 Aug 2014 21:47:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] x86, fpu: make use_eager_fpu() more eager
Message-ID: <20140824194700.GA27281@redhat.com>
References: <20140822171142.GA14812@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822171142.GA14812@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Oleg Nesterov wrote:
>
> Al, Linus, could you take a look?
>
> Looks simple, but I have to admit that every time I read FPU code
> I feel that I never read it before. And I never really understood
> it in details.
>
> See the changelog, but in short drop_init_fpu() in save_xstate_sig()
> looks wrong. This assumes that we are going to call the handler and
> thus we need the new FPU state. But this is only true if setup_frame()
> won't fail after that. If it fails, we simply lose the FPU state.

Add more cc's. Suresh, could you please review?

While at it, can't we cleanup the use_eager_fpu() logic? Just look at
switch_fpu_prepare(),

	else if (!use_eager_fpu())
		 stts();

looks "obviously buggy" if use_eager_fpu() && !tsk_used_math(new). In
this case the "new" task will use the unitialized fpu state if it starts
to use fpu. Yes, in fact this is not a bug, this is only possible when
we know that the task can't return to usermode (__restore_xstate_sig(),
exit_thread()).

But still this doesn't look clean, see 5/5. And I think we can do a lot
more cleanups on top of this change.

But! I know absolutely nothing about i387, and I do not know how can I
test these changes. In any case these patches should be ignored without
authoritative acks. However the kernel seems to boot/run fine with the
additional debugging patch below.

Oleg.

 arch/x86/include/asm/fpu-internal.h |   10 +++---
 arch/x86/kernel/i387.c              |    6 ++--
 arch/x86/kernel/process.c           |    3 +-
 arch/x86/kernel/xsave.c             |   55 +++++++++++++++++++---------------
 4 files changed, 41 insertions(+), 33 deletions(-)

-------------------------------------------------------------------------------
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 593257d..511e824 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -283,8 +283,18 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	unsigned fsindex, gsindex;
 	fpu_switch_t fpu;
 
+	if (use_eager_fpu()) {
+		BUG_ON(!__thread_has_fpu(prev_p));
+		BUG_ON(!tsk_used_math(prev_p));
+		BUG_ON(!tsk_used_math(next_p));
+	}
+
 	fpu = switch_fpu_prepare(prev_p, next_p, cpu);
 
+	if (use_eager_fpu()) {
+		BUG_ON(!__thread_has_fpu(next_p));
+	}
+
 	/*
 	 * Reload esp0, LDT and the page table pointer:
 	 */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 857ba40..a74e873 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1923,7 +1923,7 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
  * child is not running and in turn not changing child->flags
  * at the same time the parent does it.
  */
-#define clear_stopped_child_used_math(child) do { (child)->flags &= ~PF_USED_MATH; } while (0)
+#define clear_stopped_child_used_math(child) do { BUG_ON(use_eager_fpu()); (child)->flags &= ~PF_USED_MATH; } while (0)
 #define set_stopped_child_used_math(child) do { (child)->flags |= PF_USED_MATH; } while (0)
 #define clear_used_math() clear_stopped_child_used_math(current)
 #define set_used_math() set_stopped_child_used_math(current)

