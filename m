Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbaFSUMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:12:22 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:54176 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861AbaFSUML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:12:11 -0400
Message-ID: <53A3443E.8010102@gmail.com>
Date: Thu, 19 Jun 2014 16:12:46 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, josh@joshtriplett.org, davidshan@tencent.com,
        cl@linux.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] rcu: use __this_cpu_read helper instead of per_cpu_ptr(p,
 raw_smp_processor_id())
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __this_cpu_read() instead of per_cpu_ptr() for optimized access.

Last time when Shan Wei posted this, you wanted before/after code for ARM and x86.
(http://lkml.iu.edu//hypermail/linux/kernel/1211.2/00498.html).

There are few other location which use per_cpu_ops instead of this_cpu_ops. I
can convert them accordingly if you are accept this :)

Using gcc (Ubuntu/Linaro 4.7.3-12ubuntu1) 4.7.3, I get (trimmed to relevant assembly, from make kernel/rcu/tree.s)

ARMv7 per_cpu_ptr():

force_quiescent_state:
    mov    r3, sp    @,
    bic    r1, r3, #8128    @ tmp171,,
    ldr    r2, .L98    @ tmp169,
    bic    r1, r1, #63    @ tmp170, tmp171,
    ldr    r3, [r0, #220]    @ __ptr, rsp_6(D)->rda
    ldr    r1, [r1, #20]    @ D.35903_68->cpu, D.35903_68->cpu
    mov    r6, r0    @ rsp, rsp
    ldr    r2, [r2, r1, asl #2]    @ tmp173, __per_cpu_offset
    add    r3, r3, r2    @ tmp175, __ptr, tmp173
    ldr    r5, [r3, #12]    @ rnp_old, D.29162_13->mynode

ARMv7 using __this_cpu_read():

force_quiescent_state:
    ldr    r3, [r0, #220]    @ rsp_7(D)->rda, rsp_7(D)->rda
    mov    r6, r0    @ rsp, rsp
    add    r3, r3, #12    @ __ptr, rsp_7(D)->rda,
    ldr    r5, [r2, r3]    @ rnp_old, *D.29176_13

Using gcc 4.8.2:

x86_64 per_cpu_ptr():

    movl %gs:cpu_number,%edx    # cpu_number, pscr_ret__
    movslq    %edx, %rdx    # pscr_ret__, pscr_ret__
    movq    __per_cpu_offset(,%rdx,8), %rdx    # __per_cpu_offset, tmp93
    movq    %rdi, %r13    # rsp, rsp
    movq    1000(%rdi), %rax    # rsp_9(D)->rda, __ptr
    movq    24(%rdx,%rax), %r12    # _15->mynode, rnp_old

x86_64 __this_cpu_read():

    movq    %rdi, %r13    # rsp, rsp
    movq    1000(%rdi), %rax    # rsp_9(D)->rda, rsp_9(D)->rda
    movq %gs:24(%rax),%r12    # _10->mynode, rnp_old


Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Shan Wei <davidshan@tencent.com>
Acked-by: Christoph Lameter <cl@linux.com>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f1ba773..c6de285 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2404,7 +2404,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
     struct rcu_node *rnp_old = NULL;
 
     /* Funnel through hierarchy to reduce memory contention. */
-    rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
+    rnp = __this_cpu_read(rsp->rda->mynode);
     for (; rnp != NULL; rnp = rnp->parent) {
         ret = (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) ||
               !raw_spin_trylock(&rnp->fqslock);
-- 
2.0.0

