Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaKBRcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 12:32:48 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46233 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaKBRco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 12:32:44 -0500
X-Originating-IP: 50.43.41.112
Date: Sun, 2 Nov 2014 09:32:34 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v4 06/10] x86: process: Introduce helper to clear a thread's
 IO bitmap
Message-ID: <502c33cf56eed0a4cf98df1fe8ad665788d20284.1414870871.git.josh@joshtriplett.org>
References: <cover.1414870871.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414870871.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will make it easier to make the io_bitmap_ptr field optional later.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/process-io.h | 5 +++++
 arch/x86/kernel/process_32.c | 4 ++--
 arch/x86/kernel/process_64.c | 2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process-io.h b/arch/x86/kernel/process-io.h
index d884444..ffa65e8 100644
--- a/arch/x86/kernel/process-io.h
+++ b/arch/x86/kernel/process-io.h
@@ -1,6 +1,11 @@
 #ifndef _X86_KERNEL_PROCESS_IO_H
 #define _X86_KERNEL_PROCESS_IO_H
 
+static inline void clear_thread_io_bitmap(struct task_struct *p)
+{
+	p->thread.io_bitmap_ptr = NULL;
+}
+
 static inline int copy_io_bitmap(struct task_struct *me,
 				 struct task_struct *p)
 {
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 07550ff..b55f78e 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -154,7 +154,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		childregs->orig_ax = -1;
 		childregs->cs = __KERNEL_CS | get_kernel_rpl();
 		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
-		p->thread.io_bitmap_ptr = NULL;
+		clear_thread_io_bitmap(p);
 		return 0;
 	}
 	*childregs = *current_pt_regs();
@@ -165,7 +165,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.ip = (unsigned long) ret_from_fork;
 	task_user_gs(p) = get_user_gs(current_pt_regs());
 
-	p->thread.io_bitmap_ptr = NULL;
+	clear_thread_io_bitmap(p);
 	tsk = current;
 
 	/*
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b1babb4..d18f3fc 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -164,7 +164,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.sp = (unsigned long) childregs;
 	p->thread.usersp = me->thread.usersp;
 	set_tsk_thread_flag(p, TIF_FORK);
-	p->thread.io_bitmap_ptr = NULL;
+	clear_thread_io_bitmap(p);
 
 	savesegment(gs, p->thread.gsindex);
 	p->thread.gs = p->thread.gsindex ? 0 : me->thread.gs;
-- 
2.1.1

