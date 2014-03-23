Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaCWPNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:13:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:57990 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaCWPJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:09:18 -0400
Message-Id: <20140323150753.205530990@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Mar 2014 15:09:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@freedesktop.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [patch 06/16] rcu: torture: Add missing destroy_timer_on_stack()
References: <20140323150557.288925975@linutronix.de>
Content-Disposition: inline;
 filename=rcu-torture-add-missing-destroy_timer_on_stack.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we leak a tracking object if DEBUG_OBJECTS is enabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Josh Triplett <josh@freedesktop.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/torture.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: tip/kernel/rcu/torture.c
===================================================================
--- tip.orig/kernel/rcu/torture.c
+++ tip/kernel/rcu/torture.c
@@ -1038,8 +1038,10 @@ rcu_torture_reader(void *arg)
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
 	rcutorture_shutdown_absorb("rcu_torture_reader");
-	if (irqreader && cur_ops->irq_capable)
+	if (irqreader && cur_ops->irq_capable) {
 		del_timer_sync(&t);
+		destroy_timer_on_stack(&t);
+	}
 	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
 	return 0;


