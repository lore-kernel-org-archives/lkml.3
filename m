Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422692AbaJaBKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:10:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3352 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161391AbaJaBKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:10:11 -0400
Message-Id: <20141031011009.702592774@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 30 Oct 2014 21:09:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH RT 1/2] lockdep: Fix backport of "Correctly annotate hardirq context in
 irq_exit()"
References: <20141031010945.211059309@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-lockdep-Fix-backport-of-Correctly-annotate-hardirq-c.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rt93-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The backport of f1a83e652bed "lockdep: Correctly annotate hardirq context
in irq_exit()" to v3.2.53-rt76 wasn't correct because v3.2-rt had two
calls to invoke_softirq(). One when __ARCH_IRQ_EXIT_IRQS_DISABLED is defined
and another when it is not defined. v3.14 which introduced this change
only had one version.

When I backported this change, I didn't see the two places and only one
was added. Unfortunately, it was the one that x86 does not use, and this
caused a lockdep splat on one of my tests. It only affected the -rt patch
when PREEMPT_RT_FULL was not set, so I did not spend much time looking to
see what broke.

Well, I finally spent a little time and found the cause, and this was
a simple fix. Now my all my tests pass on the v3.2-rt kernel, even the
one where I test CONFIG_PREEMPT_RT_FULL not set.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/softirq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7d882ccfa22b..56d30853345d 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -637,9 +637,10 @@ static inline void invoke_softirq(void)
 static inline void invoke_softirq(void)
 {
 #ifndef CONFIG_PREEMPT_RT_FULL
-	if (!force_irqthreads)
+	if (!force_irqthreads) {
+		lockdep_softirq_from_hardirq();
 		do_softirq();
-	else {
+	} else {
 		__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
 		wakeup_softirqd();
-- 
2.1.1


