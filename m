Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbaDJQOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:14:16 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36761 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaDJQOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:14:15 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: konrad.wilk@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        srostedt@redhat.com, andrew.cooper3@citrix.com, JBeulich@suse.com,
        boris.ostrovsky@oracle.com
Subject: [PATCH v2] x86/xen: Fix 32-bit PV guests's usage of kernel_stack
Date: Thu, 10 Apr 2014 12:17:09 -0400
Message-Id: <1397146629-7159-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 198d208df4371734ac4728f69cb585c284d20a15 ("x86: Keep thread_info
on thread stack in x86_32") made 32-bit kernels use kernel_stack to point to
thread_info. That change missed a couple of updates needed by Xen's
32-bit PV guests:

1. kernel_stack needs to be initialized for secondary CPUs
2. GET_THREAD_INFO() now uses %fs register which may not be the kernel's
version when executing xen_iret().

With respect to the second issue, we don't need GET_THREAD_INFO()
anymore: we used it as an intermediate step to get to per_cpu xen_vcpu and avoid
referencing %fs. Now that we are going to use %fs anyway we may as well go
directly to xen_vcpu.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/xen/smp.c        |    3 ++-
 arch/x86/xen/xen-asm_32.S |   25 +++++++++++++++++--------
 2 files changed, 19 insertions(+), 9 deletions(-)

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
index 33ca6e4..fd92a64 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -75,6 +75,17 @@ ENDPROC(xen_sysexit)
  * stack state in whatever form its in, we keep things simple by only
  * using a single register which is pushed/popped on the stack.
  */
+
+.macro POP_FS
+1:
+	popw %fs
+.pushsection .fixup, "ax"
+2:	movw $0, (%esp)
+	jmp 1b
+.popsection
+	_ASM_EXTABLE(1b,2b)
+.endm
+
 ENTRY(xen_iret)
 	/* test eflags for special cases */
 	testl $(X86_EFLAGS_VM | XEN_EFLAGS_NMI), 8(%esp)
@@ -83,15 +94,13 @@ ENTRY(xen_iret)
 	push %eax
 	ESP_OFFSET=4	# bytes pushed onto stack
 
-	/*
-	 * Store vcpu_info pointer for easy access.  Do it this way to
-	 * avoid having to reload %fs
-	 */
+	/* Store vcpu_info pointer for easy access */
 #ifdef CONFIG_SMP
-	GET_THREAD_INFO(%eax)
-	movl %ss:TI_cpu(%eax), %eax
-	movl %ss:__per_cpu_offset(,%eax,4), %eax
-	mov %ss:xen_vcpu(%eax), %eax
+	pushw %fs
+	movl $(__KERNEL_PERCPU), %eax
+	movl %eax, %fs
+	movl %fs:xen_vcpu, %eax
+	POP_FS
 #else
 	movl %ss:xen_vcpu, %eax
 #endif
-- 
1.7.10.4

