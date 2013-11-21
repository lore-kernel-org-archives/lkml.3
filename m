Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3KUSn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:43:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:65433 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755052Ab3KUSmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:42:21 -0500
Message-Id: <20131121184218.021475847@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 21 Nov 2013 13:42:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, Ivo Sieben <meltedpianoman@gmail.com>,
        Thomas Pfaff <tpfaff@pcs.com>
Subject: [PATCH RT 1/5] genirq: Set the irq thread policy without checking CAP_SYS_NICE
References: <20131121184159.676777537@goodmis.org>
Content-Disposition: inline; filename=0001-genirq-Set-the-irq-thread-policy-without-checking-CA.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4.69-rt86-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Thomas Pfaff <tpfaff@pcs.com>

In commit ee23871389 ("genirq: Set irq thread to RT priority on
creation") we moved the assigment of the thread's priority from the
thread's function into __setup_irq(). That function may run in user
context for instance if the user opens an UART node and then driver
calls requests in the ->open() callback. That user may not have
CAP_SYS_NICE and so the irq thread won't run with the SCHED_OTHER
policy.

This patch uses sched_setscheduler_nocheck() so we omit the CAP_SYS_NICE
check which is otherwise required for the SCHED_OTHER policy.

Cc: Ivo Sieben <meltedpianoman@gmail.com>
Cc: stable@vger.kernel.org
Cc: stable-rt@vger.kernel.org
Signed-off-by: Thomas Pfaff <tpfaff@pcs.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[bigeasy: rewrite the changelog]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/irq/manage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index a6bea19..30211a7 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1024,7 +1024,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			goto out_mput;
 		}
 
-		sched_setscheduler(t, SCHED_FIFO, &param);
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &param);
 
 		/*
 		 * We keep the reference to the task struct even if
-- 
1.8.4.rc3


