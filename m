Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbaCDUnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:43:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:36911 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732AbaCDUnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:43:37 -0500
Message-Id: <20140304203100.650414633@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 04 Mar 2014 20:43:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        ia64 <linux-ia64@vger.kernel.org>
Subject: [patch 1/5] ia64: Validate online cpus in irq_set_affinity() callbacks
References: <20140304202425.102779779@linutronix.de>
Content-Disposition: inline;
 filename=ia64-filter-offline-cpus-in-irq-set-affinity.patch
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
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: ia64 <linux-ia64@vger.kernel.org>
---
 arch/ia64/kernel/msi_ia64.c  |    5 +----
 arch/ia64/sn/kernel/irq.c    |    4 ++--
 arch/ia64/sn/kernel/msi_sn.c |    2 +-
 3 files changed, 4 insertions(+), 7 deletions(-)

Index: tip/arch/ia64/kernel/msi_ia64.c
===================================================================
--- tip.orig/arch/ia64/kernel/msi_ia64.c
+++ tip/arch/ia64/kernel/msi_ia64.c
@@ -17,12 +17,9 @@ static int ia64_set_msi_irq_affinity(str
 {
 	struct msi_msg msg;
 	u32 addr, data;
-	int cpu = first_cpu(*cpu_mask);
+	int cpu = cpumask_first_and(cpu_mask, cpu_online_mask);
 	unsigned int irq = idata->irq;
 
-	if (!cpu_online(cpu))
-		return -1;
-
 	if (irq_prepare_move(irq, cpu))
 		return -1;
 
Index: tip/arch/ia64/sn/kernel/irq.c
===================================================================
--- tip.orig/arch/ia64/sn/kernel/irq.c
+++ tip/arch/ia64/sn/kernel/irq.c
@@ -209,8 +209,8 @@ static int sn_set_affinity_irq(struct ir
 	nasid_t nasid;
 	int slice;
 
-	nasid = cpuid_to_nasid(cpumask_first(mask));
-	slice = cpuid_to_slice(cpumask_first(mask));
+	nasid = cpuid_to_nasid(cpumask_first_and(mask, cpu_online_mask));
+	slice = cpuid_to_slice(cpumask_first_and(mask, cpu_online_mask));
 
 	list_for_each_entry_safe(sn_irq_info, sn_irq_info_safe,
 				 sn_irq_lh[irq], list)
Index: tip/arch/ia64/sn/kernel/msi_sn.c
===================================================================
--- tip.orig/arch/ia64/sn/kernel/msi_sn.c
+++ tip/arch/ia64/sn/kernel/msi_sn.c
@@ -166,7 +166,7 @@ static int sn_set_msi_irq_affinity(struc
 	struct sn_pcibus_provider *provider;
 	unsigned int cpu, irq = data->irq;
 
-	cpu = cpumask_first(cpu_mask);
+	cpu = cpumask_first_and(cpu_mask, cpu_online_mask);
 	sn_irq_info = sn_msi_info[irq].sn_irq_info;
 	if (sn_irq_info == NULL || sn_irq_info->irq_int_bit >= 0)
 		return -1;


