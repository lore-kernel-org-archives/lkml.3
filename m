Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbaIBSAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:00:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbaIBR76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:59:58 -0400
Date: Tue, 2 Sep 2014 19:57:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Suresh Siddha <sbsiddha@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Bean Anderson <bean@azulsystems.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] x86: copy_thread: don't nullify ->ptrace_bps twice
Message-ID: <20140902175733.GA21676@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902175654.GA21626@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both 32bit and 64bit versions of copy_thread() do memset(ptrace_bps)
twice for no reason, kill the 2nd memset().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/process_32.c |    4 +---
 arch/x86/kernel/process_64.c |    2 --
 2 files changed, 1 insertions(+), 5 deletions(-)

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
-- 
1.5.5.1

