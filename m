Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbaCDUpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:45:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:36904 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758153AbaCDUnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:43:33 -0500
Message-Id: <20140304203100.978031089@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 04 Mar 2014 20:43:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xen <xen-devel@lists.xenproject.org>
Subject: [patch 4/5] xen: Validate online cpus in set_affinity
References: <20140304202425.102779779@linutronix.de>
Content-Disposition: inline;
 filename=xen-validate-online-cpus-in-set-affinity.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user space interface does not filter out offline cpus. It merily
verifies that the mask contains at least one online cpu. So the
selector in the irq chip implementation needs to make sure to pick
only an online cpu because otherwise:

     Offline Core 1
     Set affinity to 0xe
     Selector will pick first set bit, i.e. core 1

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xen <xen-devel@lists.xenproject.org>
---
 drivers/xen/events/events_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/drivers/xen/events/events_base.c
===================================================================
--- tip.orig/drivers/xen/events/events_base.c
+++ tip/drivers/xen/events/events_base.c
@@ -1324,7 +1324,7 @@ static int rebind_irq_to_cpu(unsigned ir
 static int set_affinity_irq(struct irq_data *data, const struct cpumask *dest,
 			    bool force)
 {
-	unsigned tcpu = cpumask_first(dest);
+	unsigned tcpu = cpumask_first_and(dest, cpu_online_mask);
 
 	return rebind_irq_to_cpu(data->irq, tcpu);
 }


