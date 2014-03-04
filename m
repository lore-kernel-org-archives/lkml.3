Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833AbaCDUpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:45:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:36892 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040AbaCDUnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:43:31 -0500
Message-Id: <20140304203100.859489993@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 04 Mar 2014 20:43:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: [patch 3/5] parisc: Validate online cpus in irq_set_affinity()
 callbacks
References: <20140304202425.102779779@linutronix.de>
Content-Disposition: inline;
 filename=parisc-validate-online-cpus-in-irq-set-affinity-callback.patch
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
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
---
 arch/parisc/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/arch/parisc/kernel/irq.c
===================================================================
--- tip.orig/arch/parisc/kernel/irq.c
+++ tip/arch/parisc/kernel/irq.c
@@ -117,7 +117,7 @@ int cpu_check_affinity(struct irq_data *
 		return -EINVAL;
 
 	/* whatever mask they set, we just allow one CPU */
-	cpu_dest = first_cpu(*dest);
+	cpu_dest = cpumask_first_and(dest, cpu_online_mask);
 
 	return cpu_dest;
 }


