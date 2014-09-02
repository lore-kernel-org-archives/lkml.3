Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbaIBWUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:20:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40577 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759AbaIBWUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:20:16 -0400
Date: Tue, 2 Sep 2014 15:19:57 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-6f46b3aef0031c08a7b439d63013dad2aeb093b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        oleg@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, oleg@redhat.com, hpa@linux.intel.com
In-Reply-To: <20140902175733.GA21676@redhat.com>
References: <20140902175733.GA21676@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86: copy_thread: Don't nullify ->ptrace_bps twice
Git-Commit-ID: 6f46b3aef0031c08a7b439d63013dad2aeb093b2
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

Commit-ID:  6f46b3aef0031c08a7b439d63013dad2aeb093b2
Gitweb:     http://git.kernel.org/tip/6f46b3aef0031c08a7b439d63013dad2aeb093b2
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 2 Sep 2014 19:57:33 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 2 Sep 2014 14:51:17 -0700

x86: copy_thread: Don't nullify ->ptrace_bps twice

Both 32bit and 64bit versions of copy_thread() do memset(ptrace_bps)
twice for no reason, kill the 2nd memset().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20140902175733.GA21676@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/process_32.c | 4 +---
 arch/x86/kernel/process_64.c | 2 --
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index c73b3c1..8f3ebfe 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -138,6 +138,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 
 	p->thread.sp = (unsigned long) childregs;
 	p->thread.sp0 = (unsigned long) (childregs+1);
+	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		/* kernel thread */
@@ -153,7 +154,6 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		childregs->cs = __KERNEL_CS | get_kernel_rpl();
 		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 		p->thread.io_bitmap_ptr = NULL;
-		memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 		return 0;
 	}
 	*childregs = *current_pt_regs();
@@ -168,8 +168,6 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	tsk = current;
 	err = -ENOMEM;
 
-	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
-
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
 						IO_BITMAP_BYTES, GFP_KERNEL);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 593257d..3ed4a68 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -192,8 +192,6 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		childregs->sp = sp;
 
 	err = -ENOMEM;
-	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
-
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(me->thread.io_bitmap_ptr,
 						  IO_BITMAP_BYTES, GFP_KERNEL);
