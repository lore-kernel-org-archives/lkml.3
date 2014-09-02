Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbaIBWUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:20:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbaIBWUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:20:01 -0400
Date: Tue, 2 Sep 2014 15:19:44 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-dc56c0f9b870fba7a4eef2bb463db6881284152b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sbsiddha@gmail.com, oleg@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sbsiddha@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        hpa@linux.intel.com
In-Reply-To: <20140902175730.GA21669@redhat.com>
References: <20140902175730.GA21669@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: Shift "fpu_counter = 0" from copy_thread(
 ) to arch_dup_task_struct()
Git-Commit-ID: dc56c0f9b870fba7a4eef2bb463db6881284152b
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

Commit-ID:  dc56c0f9b870fba7a4eef2bb463db6881284152b
Gitweb:     http://git.kernel.org/tip/dc56c0f9b870fba7a4eef2bb463db6881284152b
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 2 Sep 2014 19:57:30 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 2 Sep 2014 14:51:16 -0700

x86, fpu: Shift "fpu_counter = 0" from copy_thread() to arch_dup_task_struct()

Cosmetic, but I think thread.fpu_counter should be initialized in
arch_dup_task_struct() too, along with other "fpu" variables. And
probably it make sense to turn it into thread.fpu->counter.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20140902175730.GA21669@redhat.com
Reviewed-by: Suresh Siddha <sbsiddha@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/process.c    | 1 +
 arch/x86/kernel/process_32.c | 2 --
 arch/x86/kernel/process_64.c | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index a44268c..e127dda 100644
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
