Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3AUVSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:18:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab3AUVRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:17:31 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=gRBsQyv1wqEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=D2Ip8jhJiBQA:10 a=20KFwNOVAAAA:8 a=RRJkvCJWSpkH0ut7dy0A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130121211728.501681064@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 21 Jan 2013 16:14:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/13 -next] tracing/lockdep: Disable lockdep first in entering NMI
References: <20130121211403.337052956@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-lockdep-Disable-lockdep-first-in-entering-NM.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When function tracing with either debug locks enabled or tracing
preempt disabled, the add_preempt_count() is traced. This is an
issue with lockdep and function tracing. As function tracing
can disable interrupts, and lockdep records that change,
lockdep may not be able to handle this recursion if it happens from
an NMI context.

The first thing that an NMI does is:

 #define nmi_enter()					\
	do {							\
		ftrace_nmi_enter();				\
		BUG_ON(in_nmi());				\
		add_preempt_count(NMI_OFFSET + HARDIRQ_OFFSET);	\
		lockdep_off();					\
		rcu_nmi_enter();				\
		trace_hardirq_enter();				\
	} while (0)

When the add_preempt_count() is traced, and the tracing callback
disables interrupts, it will jump into the lockdep code. There's
some places in lockdep that can't handle this re-entrance, and
causes lockdep to fail.

As the lockdep_off() (and lockdep_on) is a simple:

void lockdep_off(void)
{
	current->lockdep_recursion++;
}

and is never traced, it can be called first in nmi_enter()
and lockdep_on() last in nmi_exit().

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/hardirq.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 624ef3f..57bfdce 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -180,10 +180,10 @@ extern void irq_exit(void);
 
 #define nmi_enter()						\
 	do {							\
+		lockdep_off();					\
 		ftrace_nmi_enter();				\
 		BUG_ON(in_nmi());				\
 		add_preempt_count(NMI_OFFSET + HARDIRQ_OFFSET);	\
-		lockdep_off();					\
 		rcu_nmi_enter();				\
 		trace_hardirq_enter();				\
 	} while (0)
@@ -192,10 +192,10 @@ extern void irq_exit(void);
 	do {							\
 		trace_hardirq_exit();				\
 		rcu_nmi_exit();					\
-		lockdep_on();					\
 		BUG_ON(!in_nmi());				\
 		sub_preempt_count(NMI_OFFSET + HARDIRQ_OFFSET);	\
 		ftrace_nmi_exit();				\
+		lockdep_on();					\
 	} while (0)
 
 #endif /* LINUX_HARDIRQ_H */
-- 
1.7.10.4


