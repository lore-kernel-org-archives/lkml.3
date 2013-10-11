Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab3JKLAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:00:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:60626 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094Ab3JKLAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:00:42 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ivo Sieben <meltedpianoman@gmail.com>, Thomas Pfaff <tpfaff@pcs.com>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] genirq: Set the irq thread policy without checking CAP_SYS_NICE
Date: Fri, 11 Oct 2013 13:00:40 +0200
Message-Id: <1381489240-29626-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Thomas Pfaff <tpfaff@pcs.com>
[bigeasy: rewrite the changelog]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/irq/manage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 514bcfd..3e59f95 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -956,7 +956,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			goto out_mput;
 		}
 
-		sched_setscheduler(t, SCHED_FIFO, &param);
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &param);
 
 		/*
 		 * We keep the reference to the task struct even if
-- 
1.8.4.rc3

