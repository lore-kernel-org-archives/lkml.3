Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964956AbaH0Syd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:54:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964884AbaH0Sya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:54:30 -0400
Date: Wed, 27 Aug 2014 20:52:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
Cc: Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] x86, fpu: shift "fpu_counter = 0" from copy_thread()
	to arch_dup_task_struct()
Message-ID: <20140827185205.GA12522@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140827185138.GA12487@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic, but I think thread.fpu_counter should be initialized in
arch_dup_task_struct() too, along with other "fpu" variables. And
probably it make sense to turn it into thread.fpu->counter.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/process.c    |    1 +
 arch/x86/kernel/process_32.c |    2 --
 arch/x86/kernel/process_64.c |    1 -
 3 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 36dfb1d..7474f56 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -66,6 +66,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	*dst = *src;
 
+	dst->thread.fpu_counter = 0;
 	dst->thread.fpu.has_fpu = 0;
 	dst->thread.fpu.last_cpu = ~0;
 	dst->thread.fpu.state = NULL;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7bc86bb..c73b3c1 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -152,7 +152,6 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		childregs->orig_ax = -1;
 		childregs->cs = __KERNEL_CS | get_kernel_rpl();
 		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
-		p->thread.fpu_counter = 0;
 		p->thread.io_bitmap_ptr = NULL;
 		memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 		return 0;
@@ -165,7 +164,6 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.ip = (unsigned long) ret_from_fork;
 	task_user_gs(p) = get_user_gs(current_pt_regs());
 
-	p->thread.fpu_counter = 0;
 	p->thread.io_bitmap_ptr = NULL;
 	tsk = current;
 	err = -ENOMEM;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ca5b02d..593257d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -163,7 +163,6 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.sp = (unsigned long) childregs;
 	p->thread.usersp = me->thread.usersp;
 	set_tsk_thread_flag(p, TIF_FORK);
-	p->thread.fpu_counter = 0;
 	p->thread.io_bitmap_ptr = NULL;
 
 	savesegment(gs, p->thread.gsindex);
-- 
1.5.5.1

