Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab3LFNZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:25:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44492 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300Ab3LFND5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Pfaff <tpfaff@pcs.com>, Ivo Sieben <meltedpianoman@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 197/272] genirq: Set the irq thread policy without checking CAP_SYS_NICE
Date: Fri,  6 Dec 2013 12:58:06 +0000
Message-Id: <1386334761-25517-198-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Pfaff <tpfaff@pcs.com>

commit bbfe65c219c638e19f1da5adab1005b2d68ca810 upstream.

In commit ee23871389 ("genirq: Set irq thread to RT priority on
creation") we moved the assigment of the thread's priority from the
thread's function into __setup_irq(). That function may run in user
context for instance if the user opens an UART node and then driver
calls requests in the ->open() callback. That user may not have
CAP_SYS_NICE and so the irq thread won't run with the SCHED_OTHER
policy.

This patch uses sched_setscheduler_nocheck() so we omit the CAP_SYS_NICE
check which is otherwise required for the SCHED_OTHER policy.

[bigeasy: Rewrite the changelog]

Signed-off-by: Thomas Pfaff <tpfaff@pcs.com>
Cc: Ivo Sieben <meltedpianoman@gmail.com>
Link: http://lkml.kernel.org/r/1381489240-29626-1-git-send-email-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.8.3.2

