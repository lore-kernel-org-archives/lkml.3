Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3DUQvM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 12:51:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab3DUQvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 12:51:10 -0400
Date: Sun, 21 Apr 2013 18:47:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace/powerpc: dont flush_ptrace_hw_breakpoint() on fork()
Message-ID: <20130421164759.GA5537@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_dup_task_struct() does flush_ptrace_hw_breakpoint(src), this
destroys the parent's breakpoints for no reason. We should clear
child->thread.ptrace_bps[] copied by dup_task_struct() instead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michael Neuling <mikey@neuling.org>

--- x/arch/powerpc/kernel/process.c
+++ x/arch/powerpc/kernel/process.c
@@ -910,10 +910,6 @@ int arch_dup_task_struct(struct task_str
 	flush_altivec_to_thread(src);
 	flush_vsx_to_thread(src);
 	flush_spe_to_thread(src);
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-	flush_ptrace_hw_breakpoint(src);
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
-
 	*dst = *src;
 	return 0;
 }
@@ -984,6 +980,10 @@ int copy_thread(unsigned long clone_flag
 	p->thread.ksp_limit = (unsigned long)task_stack_page(p) +
 				_ALIGN_UP(sizeof(struct thread_info), 16);
 
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	p->thread.ptrace_bps[0] = NULL;
+#endif
+
 #ifdef CONFIG_PPC_STD_MMU_64
 	if (mmu_has_feature(MMU_FTR_SLB)) {
 		unsigned long sp_vsid;

