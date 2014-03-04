Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaCDQpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:45:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41599 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaCDQms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:42:48 -0500
Date: Tue, 4 Mar 2014 08:42:13 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-bc5dfcff65f24f15567f766d8bd081d594ef8cc2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        schwidefsky@de.ibm.com, peterz@infradead.org,
        linux-s390@vger.kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, schwidefsky@de.ibm.com,
        linux-s390@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20140223212737.983433636@linutronix.de>
References: <20140223212737.983433636@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] s390: Cio: Use the core irq stats function
Git-Commit-ID: bc5dfcff65f24f15567f766d8bd081d594ef8cc2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc5dfcff65f24f15567f766d8bd081d594ef8cc2
Gitweb:     http://git.kernel.org/tip/bc5dfcff65f24f15567f766d8bd081d594ef8cc2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:17 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:54 +0100

s390: Cio: Use the core irq stats function

Let the core do the irq_desc resolution.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: s390 <linux-s390@vger.kernel.org>
Link: http://lkml.kernel.org/r/20140223212737.983433636@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/s390/cio/cio.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 8ee88c4..f711f0b 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -584,8 +584,6 @@ static irqreturn_t do_cio_interrupt(int irq, void *dummy)
 	return IRQ_HANDLED;
 }
 
-static struct irq_desc *irq_desc_io;
-
 static struct irqaction io_interrupt = {
 	.name	 = "IO",
 	.handler = do_cio_interrupt,
@@ -596,7 +594,6 @@ void __init init_cio_interrupts(void)
 	irq_set_chip_and_handler(IO_INTERRUPT,
 				 &dummy_irq_chip, handle_percpu_irq);
 	setup_irq(IO_INTERRUPT, &io_interrupt);
-	irq_desc_io = irq_to_desc(IO_INTERRUPT);
 }
 
 #ifdef CONFIG_CCW_CONSOLE
@@ -623,7 +620,7 @@ void cio_tsch(struct subchannel *sch)
 		local_bh_disable();
 		irq_enter();
 	}
-	kstat_incr_irqs_this_cpu(IO_INTERRUPT, irq_desc_io);
+	kstat_incr_irq_this_cpu(IO_INTERRUPT);
 	if (sch->driver && sch->driver->irq)
 		sch->driver->irq(sch);
 	else
