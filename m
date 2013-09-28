Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3I1CLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 22:11:42 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52736 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab3I1CLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 22:11:39 -0400
From: Huacai Chen <chenhc@lemote.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Huacai Chen <chenhc@lemote.com>
Subject: [PATCH] genirq: Avoid NULL OOPS in irq handling
Date: Sat, 28 Sep 2013 10:11:24 +0800
Message-Id: <1380334284-12690-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices (e.g. serial port) setup irq handler at dev open and free
it at dev close. So, sometimes there is no irqaction for a specific
irq. But some buggy devices may send irqs at any time. This patch avoid
the NULL OOPS when irqaction isn't registered.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 kernel/irq/handle.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 131ca17..1c78e69 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -135,6 +135,9 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 	irqreturn_t retval = IRQ_NONE;
 	unsigned int flags = 0, irq = desc->irq_data.irq;
 
+	if (!action)
+		goto out;
+
 	do {
 		irqreturn_t res;
 
@@ -174,6 +177,7 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 
 	add_interrupt_randomness(irq, flags);
 
+out:
 	if (!noirqdebug)
 		note_interrupt(irq, desc, retval);
 	return retval;
-- 
1.7.7.3

