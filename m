Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935023Ab3E2CLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:11:07 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48667 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934980Ab3E2CLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:11:00 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 1/3] irqchip: Add mask to block out invalid irqs
Date: Wed, 29 May 2013 03:10:52 +0100
Message-Id: <1369793454-19197-2-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369793454-19197-1-git-send-email-grant.likely@linaro.org>
References: <1369793454-19197-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some controllers have irqs that aren't wired up and must never be used.
For the generic chip attached to an irq_domain this provides a mask that
can be used to block out particular irqs so that they never get mapped.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h       | 2 ++
 kernel/irq/generic-chip.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index af7052c..298a9b9 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -679,6 +679,7 @@ struct irq_chip_type {
  * @num_ct:		Number of available irq_chip_type instances (usually 1)
  * @private:		Private data for non generic chip callbacks
  * @installed:		bitfield to denote installed interrupts
+ * @unused:		bitfield to denote unused interrupts
  * @domain:		irq domain pointer
  * @list:		List head for keeping track of instances
  * @chip_types:		Array of interrupt irq_chip_types
@@ -702,6 +703,7 @@ struct irq_chip_generic {
 	unsigned int		num_ct;
 	void			*private;
 	unsigned long		installed;
+	unsigned long		unused;
 	struct irq_domain	*domain;
 	struct list_head	list;
 	struct irq_chip_type	chip_types[0];
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 8e4d6bd..7b44aa2 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -359,6 +359,9 @@ static int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
 
 	idx = hw_irq % dgc->irqs_per_chip;
 
+	if (test_bit(idx, &gc->unused))
+		return -ENOTSUPP;
+
 	if (test_bit(idx, &gc->installed))
 		return -EBUSY;
 
-- 
1.8.1.2

