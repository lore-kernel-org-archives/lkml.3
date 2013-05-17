Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab3EQWSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:18:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935Ab3EQVh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 041/102] powerpc/kexec: Fix kexec when using VMX optimised memcpy
Date: Fri, 17 May 2013 14:35:56 -0700
Message-Id: <20130517213248.622424514@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@au1.ibm.com>

commit 79c66ce8f6448a3295a32efeac88c9debd7f7094 upstream.

commit b3f271e86e5a (powerpc: POWER7 optimised memcpy using VMX and
enhanced prefetch) uses VMX when it is safe to do so (ie not in
interrupt). It also looks at the task struct to decide if we have to
save the current tasks' VMX state.

kexec calls memcpy() at a point where the task struct may have been
overwritten by the new kexec segments. If it has been overwritten
then when memcpy -> enable_altivec looks up current->thread.regs->msr
we get a cryptic oops or lockup.

I also notice we aren't initialising thread_info->cpu, which means
smp_processor_id is broken. Fix that too.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/machine_kexec_64.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -17,6 +17,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/cpu.h>
+#include <linux/hardirq.h>
 
 #include <asm/page.h>
 #include <asm/current.h>
@@ -335,10 +336,13 @@ void default_machine_kexec(struct kimage
 	pr_debug("kexec: Starting switchover sequence.\n");
 
 	/* switch to a staticly allocated stack.  Based on irq stack code.
+	 * We setup preempt_count to avoid using VMX in memcpy.
 	 * XXX: the task struct will likely be invalid once we do the copy!
 	 */
 	kexec_stack.thread_info.task = current_thread_info()->task;
 	kexec_stack.thread_info.flags = 0;
+	kexec_stack.thread_info.preempt_count = HARDIRQ_OFFSET;
+	kexec_stack.thread_info.cpu = current_thread_info()->cpu;
 
 	/* We need a static PACA, too; copy this CPU's PACA over and switch to
 	 * it.  Also poison per_cpu_offset to catch anyone using non-static


