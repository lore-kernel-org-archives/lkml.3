Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbaFYJbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:31:25 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51362 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752091AbaFYJ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:28:59 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, eric.auger@linaro.org,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [RFC PATCH 1/9] genirq: Add IRQD_IRQ_FORWARDED flag and accessors
Date: Wed, 25 Jun 2014 10:28:42 +0100
Message-Id: <1403688530-23273-2-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some interrupt controllers support a split EOI behaviour, where
an active interrupt can be forwarded to a VM, and directly EOIed
from the guest.

Allow the irq_data to carry a flag describing this setup.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irq.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 0d998d8..b4b3120 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -186,6 +186,7 @@ enum {
 	IRQD_IRQ_DISABLED		= (1 << 16),
 	IRQD_IRQ_MASKED			= (1 << 17),
 	IRQD_IRQ_INPROGRESS		= (1 << 18),
+	IRQD_IRQ_FORWARDED		= (1 << 19),
 };
 
 static inline bool irqd_is_setaffinity_pending(struct irq_data *d)
@@ -272,6 +273,21 @@ static inline void irqd_clr_chained_irq_inprogress(struct irq_data *d)
 	d->state_use_accessors &= ~IRQD_IRQ_INPROGRESS;
 }
 
+static inline void irqd_set_irq_forwarded(struct irq_data *d)
+{
+	d->state_use_accessors |= IRQD_IRQ_FORWARDED;
+}
+
+static inline void irqd_clr_irq_forwarded(struct irq_data *d)
+{
+	d->state_use_accessors &= ~IRQD_IRQ_FORWARDED;
+}
+
+static inline bool irqd_irq_forwarded(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_IRQ_FORWARDED;
+}
+
 static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
 {
 	return d->hwirq;
-- 
1.8.3.4

