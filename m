Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761755AbbA1UpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:45:10 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:33345 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415AbbA1UpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:45:06 -0500
From: Liu Hua <sdu.liu@huawei.com>
To: <tglx@linutronix.de>, <marc.zyngier@arm.com>, <will.deacon@arm.com>
CC: <peifeiyue@huawei.com>, <liusdu@126.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] irqchip: mark the irq status in handle_percpu_devid_irq
Date: Wed, 28 Jan 2015 17:30:46 +0800
Message-ID: <1422437446-31909-1-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function handle_percpu_devid_irq lacks of irq's state
changing. The handler may fail. So we should mark this
irq's status. It is very useful when we deploy kdump
and the handler fails with panic. The kdump can deal
with this situaton in machine_kexec_mask_interrupts,
which will do some works to the interrupt controller
(write EOI..).

Without this patch, kdump can not go through if first
kernel panics in per-cpu interrupt handler(like hrtimers).
I can reduce this bugs on ARM SMP platform with per cpu
timers.

I have send a related patchset. But I think that is not the
best way to solve this problem.

  link:lkml.org/lkml/2014/8/4/18

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
---
 kernel/irq/chip.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6f1c7a5..3328a45 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -710,10 +710,18 @@ void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc)
 	if (chip->irq_ack)
 		chip->irq_ack(&desc->irq_data);
 
+	raw_spin_lock(&desc->lock);
+	irqd_set(&desc->irq_data, IRQD_IRQ_INPROGRESS);
+	raw_spin_unlock(&desc->lock);
+
 	trace_irq_handler_entry(irq, action);
 	res = action->handler(irq, dev_id);
 	trace_irq_handler_exit(irq, action, res);
 
+	raw_spin_lock(&desc->lock);
+	irqd_clear(&desc->irq_data, IRQD_IRQ_INPROGRESS);
+	raw_spin_unlock(&desc->lock);
+
 	if (chip->irq_eoi)
 		chip->irq_eoi(&desc->irq_data);
 }
-- 
1.9.0

