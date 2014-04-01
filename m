Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaDAWqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 18:46:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56088 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaDAWqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 18:46:49 -0400
From: Felipe Balbi <balbi@ti.com>
To: <r.sricharan@ti.com>, <tglx@linutronix.de>
CC: <galak@codeaurora.org>, <santosh.shilimkar@ti.com>,
        Darren Etheridge <detheridge@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] irq: crossbar: improve allocate_free_irq() complexity
Date: Tue, 1 Apr 2014 17:44:19 -0500
Message-ID: <1396392259-27437-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

current algorithm in allocate_free_irq() is O(n),
by just keeping track of last allocated IRQ with a
simple unsigned integer, we can find a free IRQ
in O(1).

Signed-off-by: Felipe Balbi <balbi@ti.com>
---

compile-tested only as J6 DTS is currently missing crossbar
altogether :-(

There's a drawback with this patch which I'm not sure if we
should care a lot because I couldn't entirely grasp when is
domain->xlate() called and if we will map/unmap IRQs in runtime
or will this *always* be done only during boot.

If we're talking about runtime IRQ remapping, then this, clearly,
won't work. But if this will be done only during boot up, then we
avoid iterating over the irq_map array each time we try to translate
a new IRQ prior to mapping it.

Comments are highly welcome as I'll probably learn something new
about the IRQ subsystem ;-)

 drivers/irqchip/irq-crossbar.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index fc817d2..1c4da5a 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -31,6 +31,7 @@ struct crossbar_device {
 	void __iomem *crossbar_base;
 	int *register_offsets;
 	void (*write) (int, int);
+	unsigned int current_irq;
 };
 
 static struct crossbar_device *cb;
@@ -52,16 +53,15 @@ static inline void crossbar_writeb(int irq_no, int cb_no)
 
 static inline int allocate_free_irq(int cb_no)
 {
-	int i;
+	int current_irq;
 
-	for (i = 0; i < cb->int_max; i++) {
-		if (cb->irq_map[i] == IRQ_FREE) {
-			cb->irq_map[i] = cb_no;
-			return i;
-		}
-	}
+	if (cb->current_irq == cb->int_max)
+		return -ENODEV;
+
+	current_irq = cb->current_irq++;
+	cb->irq_map[current_irq++] = cb_no;
 
-	return -ENODEV;
+	return current_irq;
 }
 
 static int crossbar_domain_map(struct irq_domain *d, unsigned int irq,
-- 
1.9.1.286.g5172cb3

