Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911Ab3FCWWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:22:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13545 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763Ab3FCWL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:11:58 -0400
X-Authority-Analysis: v=2.0 cv=Et5QXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=HGH7F2NRVdIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=aLFKpM8whU8A:10 a=VnNF1IyMAAAA:8 a=hGzw-44bAAAA:8 a=VwQbUJbxAAAA:8 a=wMNdZWldAAAA:8 a=KmqCZUEVAza2QQZapJAA:9 a=dowx1zmaLagA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221155.506877506@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [20/65] powerpc/kexec: Fix kexec when using VMX optimised memcpy
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0020-powerpc-kexec-Fix-kexec-when-using-VMX-optimised-mem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@au1.ibm.com>

[ Upstream commit 79c66ce8f6448a3295a32efeac88c9debd7f7094 ]

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
Cc: <stable@vger.kernel.org> # 3.6+
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/kernel/machine_kexec_64.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index d7f6090..7e5ff43 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -17,6 +17,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/cpu.h>
+#include <linux/hardirq.h>
 
 #include <asm/page.h>
 #include <asm/current.h>
@@ -330,10 +331,13 @@ void default_machine_kexec(struct kimage *image)
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
1.7.10.4


