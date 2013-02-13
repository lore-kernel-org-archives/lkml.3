Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934392Ab3BMQRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:17:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:59726 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934358Ab3BMQNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:13:16 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 06/16] softirq: Add more debugging
Date: Wed, 13 Feb 2013 17:12:01 +0100
Message-Id: <1360771932-27150-7-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

We really want to find code which calls __raise_softirq_irqsoff() and
runs neither in hardirq context nor in a local_bh disabled
region. This is even wrong on mainline as that code relies on random
events to take care of it's newly raised softirq.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/softirq.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 66999ad..385fcea 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -605,7 +605,7 @@ void thread_do_softirq(void)
 	}
 }
 
-void __raise_softirq_irqoff(unsigned int nr)
+static void do_raise_softirq_irqoff(unsigned int nr)
 {
 	trace_softirq_raise(nr);
 	or_softirq_pending(1UL << nr);
@@ -622,12 +622,19 @@ void __raise_softirq_irqoff(unsigned int nr)
 		__this_cpu_read(ksoftirqd)->softirqs_raised |= (1U << nr);
 }
 
+void __raise_softirq_irqoff(unsigned int nr)
+{
+	do_raise_softirq_irqoff(nr);
+	if (!in_irq() && !current->softirq_nestcnt)
+		wakeup_softirqd();
+}
+
 /*
  * This function must run with irqs disabled!
  */
 void raise_softirq_irqoff(unsigned int nr)
 {
-	__raise_softirq_irqoff(nr);
+	do_raise_softirq_irqoff(nr);
 
 	/*
 	 * If we're in an hard interrupt we let irq return code deal
@@ -649,11 +656,6 @@ void raise_softirq_irqoff(unsigned int nr)
 		wakeup_softirqd();
 }
 
-void do_raise_softirq_irqoff(unsigned int nr)
-{
-	raise_softirq_irqoff(nr);
-}
-
 static inline int ksoftirqd_softirq_pending(void)
 {
 	return current->softirqs_raised;
-- 
1.7.10.4

