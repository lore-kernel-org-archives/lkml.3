Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaFZHNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:13:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48352 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbaFZHNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:13:37 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V4 05/16] irqchip: crossbar: Change allocation logic by reversing search for free irqs
Date: Thu, 26 Jun 2014 12:40:23 +0530
Message-ID: <1403766634-18543-6-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
References: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
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
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/irqchip/irq-crossbar.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 4be30c0..a39cb31 100644
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

