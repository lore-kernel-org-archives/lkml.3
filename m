Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab3BSD4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 22:56:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29372 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3BSD4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 22:56:46 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=RelP6ITE0icA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Cec_VKZm9Y0A:10 a=VwQbUJbxAAAA:8 a=P3vMpniSKFg0jnI0z7IA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130219035645.585688682@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 18 Feb 2013 22:56:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 1/7] x86/32: Use kmap switch for non highmem as well
References: <20130219035623.277664914@goodmis.org>
Content-Disposition: inline; filename=0001-x86-32-Use-kmap-switch-for-non-highmem-as-well.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Even with CONFIG_HIGHMEM=n we need to take care of the "atomic"
mappings which are installed via iomap_atomic.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/process_32.c |    2 +-
 include/linux/sched.h        |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 20f1573..66ee590 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -340,7 +340,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
 		__switch_to_xtra(prev_p, next_p, tss);
 
-#if defined CONFIG_PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
+#ifdef CONFIG_PREEMPT_RT_FULL
 	/*
 	 * Save @prev's kmap_atomic stack
 	 */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e2f9e3b..a26bd7e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1608,9 +1608,11 @@ struct task_struct {
 	struct rcu_head put_rcu;
 	int softirq_nestcnt;
 #endif
-#if defined CONFIG_PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
+#ifdef CONFIG_PREEMPT_RT_FULL
+# if defined CONFIG_HIGHMEM || defined CONFIG_X86_32
 	int kmap_idx;
 	pte_t kmap_pte[KM_TYPE_NR];
+# endif
 #endif
 
 #ifdef CONFIG_DEBUG_PREEMPT
-- 
1.7.10.4


