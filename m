Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933824Ab3E1VZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:25:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59813 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933709Ab3E1VZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 44/78] powerpc/kexec: Fix kexec when using VMX optimised memcpy
Date: Tue, 28 May 2013 14:19:53 -0700
Message-Id: <1369776027-17859-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/kernel/machine_kexec_64.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 466a290..611acdf 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -17,6 +17,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/cpu.h>
+#include <linux/hardirq.h>
 
 #include <asm/page.h>
 #include <asm/current.h>
@@ -335,10 +336,13 @@ void default_machine_kexec(struct kimage *image)
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
-- 
1.8.1.2

