Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3IZRhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:37:37 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:63746 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3IZRhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:37:35 -0400
Message-ID: <201309261737.r8QHb2oP007688@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 26 Sep 2013 13:22:40 -0400
Subject: [PATCH] tile: ensure interrupts disabled for preempt_schedule_irq()
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When coming from a page fault (for example), interrupts might
be enabled as we enter the code to return from interrupt.

Cc: stable@vger.kernel.org
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_32.S | 3 +++
 arch/tile/kernel/intvec_64.S | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 088d5c1..2cbe6d5 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -815,6 +815,9 @@ STD_ENTRY(interrupt_return)
 	}
 	bzt     r28, 1f
 	bnz     r29, 1f
+	/* Disable interrupts explicitly for preemption. */
+	IRQ_DISABLE(r20,r21)
+	TRACE_IRQS_OFF
 	jal     preempt_schedule_irq
 	FEEDBACK_REENTER(interrupt_return)
 1:
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index ec755d3..b8fc497 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -841,6 +841,9 @@ STD_ENTRY(interrupt_return)
 	}
 	beqzt   r28, 1f
 	bnez    r29, 1f
+	/* Disable interrupts explicitly for preemption. */
+	IRQ_DISABLE(r20,r21)
+	TRACE_IRQS_OFF
 	jal     preempt_schedule_irq
 	FEEDBACK_REENTER(interrupt_return)
 1:
-- 
1.8.3.1

