Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaEAXTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 19:19:03 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29826 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbaEAXS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 19:18:57 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/8] x86, irq: Remove not needed irq_reserve_irqs calling
Date: Thu,  1 May 2014 16:18:15 -0700
Message-Id: <1398986302-30455-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1398986302-30455-1-git-send-email-yinghai@kernel.org>
References: <1398986302-30455-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now x86 only support sparseirq path, for that path, calling path like:
	early_irq_init
		==> arch_probe_nr_irqs : return legacy irq number
		==> alloc_desc for legacy irqs and set bits in allocated_irqs
		==> arch_early_irq_init
			==> irq_reserve_irqs : set bits again

so we can kill one irq_reserve_irqs calling.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6ad4658..398f9c4 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -206,9 +206,6 @@ int __init arch_early_irq_init(void)
 	count = ARRAY_SIZE(irq_cfgx);
 	node = cpu_to_node(0);
 
-	/* Make sure the legacy interrupts are marked in the bitmap */
-	irq_reserve_irqs(0, legacy_pic->nr_legacy_irqs);
-
 	for (i = 0; i < count; i++) {
 		irq_set_chip_data(i, &cfg[i]);
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_KERNEL, node);
-- 
1.8.4.5

