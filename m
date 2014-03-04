Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbaCDUqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:46:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:36887 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037AbaCDUnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:43:31 -0500
Message-Id: <20140304203100.744800502@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 04 Mar 2014 20:43:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 2/5] mips: Validate online cpus in irq_set_affinity() callbacks
References: <20140304202425.102779779@linutronix.de>
Content-Disposition: inline;
 filename=mips-validate-online-cpus-in-irq-set-affinity-callback.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The [user space] interface does not filter out offline cpus. It merily
guarantees that the mask contains at least one online cpu.

So the selector in the irq chip implementation needs to make sure to
pick only an online cpu because otherwise:

     Offline Core 1
     Set affinity to 0xe (is valid due to online mask 0xd)
     cpumask_first will pick core 1, which is offline

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/sibyte/bcm1480/irq.c |    2 +-
 arch/mips/sibyte/sb1250/irq.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: tip/arch/mips/sibyte/bcm1480/irq.c
===================================================================
--- tip.orig/arch/mips/sibyte/bcm1480/irq.c
+++ tip/arch/mips/sibyte/bcm1480/irq.c
@@ -95,7 +95,7 @@ static int bcm1480_set_affinity(struct i
 	u64 cur_ints;
 	unsigned long flags;
 
-	i = cpumask_first(mask);
+	i = cpumask_first_and(mask< cpu_online_mask);
 
 	/* Convert logical CPU to physical CPU */
 	cpu = cpu_logical_map(i);
Index: tip/arch/mips/sibyte/sb1250/irq.c
===================================================================
--- tip.orig/arch/mips/sibyte/sb1250/irq.c
+++ tip/arch/mips/sibyte/sb1250/irq.c
@@ -88,7 +88,7 @@ static int sb1250_set_affinity(struct ir
 	u64 cur_ints;
 	unsigned long flags;
 
-	i = cpumask_first(mask);
+	i = cpumask_first_and(mask< cpu_online_mask);
 
 	/* Convert logical CPU to physical CPU */
 	cpu = cpu_logical_map(i);


