Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762AbaDIODr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:03:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22906 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933448AbaDIODo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:03:44 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: konrad.wilk@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        srostedt@redhat.com, boris.ostrovsky@oracle.com
Subject: [PATCH] x86/xen: Fix 32-bit PV guests's usage of kernel_stack
Date: Wed,  9 Apr 2014 10:06:41 -0400
Message-Id: <1397052401-20220-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 198d208df4371734ac4728f69cb585c284d20a15 made 32-bit kernels use
kernel_stack to point to thread_info. That change missed a couple of
updates needed by Xen's PV guests:

1. kernel_stack needs to be initialized for secondary CPUs
2. GET_THREAD_INFO() now uses %fs register which may not be the kernel's
version when executing xen_iret()

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/xen/smp.c        |    3 ++-
 arch/x86/xen/xen-asm_32.S |    4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index a18eadd..7005974 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -441,10 +441,11 @@ static int xen_cpu_up(unsigned int cpu, struct task_struct *idle)
 	irq_ctx_init(cpu);
 #else
 	clear_tsk_thread_flag(idle, TIF_FORK);
+#endif
 	per_cpu(kernel_stack, cpu) =
 		(unsigned long)task_stack_page(idle) -
 		KERNEL_STACK_OFFSET + THREAD_SIZE;
-#endif
+
 	xen_setup_runstate_info(cpu);
 	xen_setup_timer(cpu);
 	xen_init_lock_cpu(cpu);
diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index 33ca6e4..d433637 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -88,7 +88,11 @@ ENTRY(xen_iret)
 	 * avoid having to reload %fs
 	 */
 #ifdef CONFIG_SMP
+	pushw %fs
+	movl $(__KERNEL_PERCPU), %eax
+	movl %eax, %fs
 	GET_THREAD_INFO(%eax)
+	popw %fs
 	movl %ss:TI_cpu(%eax), %eax
 	movl %ss:__per_cpu_offset(,%eax,4), %eax
 	mov %ss:xen_vcpu(%eax), %eax
-- 
1.7.10.4

