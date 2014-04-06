Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaDFFjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 01:39:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19160 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbaDFFiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 01:38:22 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 1/5] x86, irq: Remove not needed irq_reserve_irqs calling
Date: Sat,  5 Apr 2014 22:39:22 -0700
Message-Id: <1396762766-4942-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1396762766-4942-1-git-send-email-yinghai@kernel.org>
References: <1396762766-4942-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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

