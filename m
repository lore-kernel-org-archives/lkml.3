Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3LBUY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:24:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3LBTRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Pfaff <tpfaff@pcs.com>, Ivo Sieben <meltedpianoman@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.12 026/212] genirq: Set the irq thread policy without checking CAP_SYS_NICE
Date: Mon,  2 Dec 2013 11:13:37 -0800
Message-Id: <20131202191251.547725120@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/manage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -956,7 +956,7 @@ __setup_irq(unsigned int irq, struct irq
 			goto out_mput;
 		}
 
-		sched_setscheduler(t, SCHED_FIFO, &param);
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &param);
 
 		/*
 		 * We keep the reference to the task struct even if


