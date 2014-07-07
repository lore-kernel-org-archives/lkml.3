Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaGGWjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:39:46 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:38247 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbaGGWid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:38:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Shan Wei <davidshan@tencent.com>,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: [PATCH tip/core/rcu 13/17] rcu: Use __this_cpu_read() instead of per_cpu_ptr()
Date: Mon,  7 Jul 2014 15:38:17 -0700
Message-Id: <1404772701-8804-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-3532-0000-0000-000002FA8B93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The __this_cpu_read() function produces better code than does
per_cpu_ptr() on both ARM and x86.  For example, gcc (Ubuntu/Linaro
4.7.3-12ubuntu1) 4.7.3 produces the following:

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

ARMv7 __this_cpu_read():

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

Because this change produces significant benefits for these two very
diverse architectures, this commit makes this change.

Signed-off-by: Shan Wei <davidshan@tencent.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 8f3e4d43d736..a6c5424ffa38 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2487,7 +2487,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 	struct rcu_node *rnp_old = NULL;
 
 	/* Funnel through hierarchy to reduce memory contention. */
-	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
+	rnp = __this_cpu_read(rsp->rda->mynode);
 	for (; rnp != NULL; rnp = rnp->parent) {
 		ret = (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) ||
 		      !raw_spin_trylock(&rnp->fqslock);
-- 
1.8.1.5

