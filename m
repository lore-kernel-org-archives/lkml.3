Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaFPL0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:26:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43245 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbaFPL0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:26:04 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V3 05/16] irqchip: crossbar: change allocation logic by reversing search for free irqs
Date: Mon, 16 Jun 2014 16:53:05 +0530
Message-ID: <1402917796-31574-6-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
References: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

Reverse the search algorithm to ensure that address mapping and IRQ
allocation logics are proper. This makes the below bugs visible sooner.

class 1. address space errors -> example:
reg = <a size_b>
ti,max-irqs =  is a wrong parameter

class 2: irq-reserved list - which decides which entries in the
address space is not actually wired in

class 3: wrong list of routable-irqs.

In general allocating from max to min tends to have benefits in
ensuring the different issues that may be present in dts is easily
caught at definition time, rather than at a later point in time.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
[V3] Added more description to commit log.

 drivers/irqchip/irq-crossbar.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index d1f67f6..9528cf2 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -58,7 +58,7 @@ static inline int get_prev_map_irq(int cb_no)
 {
 	int i;
 
-	for (i = 0; i < cb->int_max; i++)
+	for (i = cb->int_max - 1; i >= 0; i--)
 		if (cb->irq_map[i] == cb_no)
 			return i;
 
@@ -69,7 +69,7 @@ static inline int allocate_free_irq(int cb_no)
 {
 	int i;
 
-	for (i = 0; i < cb->int_max; i++) {
+	for (i = cb->int_max - 1; i >= 0; i--) {
 		if (cb->irq_map[i] == IRQ_FREE) {
 			cb->irq_map[i] = cb_no;
 			return i;
-- 
1.7.9.5

