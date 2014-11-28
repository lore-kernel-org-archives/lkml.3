Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbaK1EdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 23:33:12 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35086 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaK1EdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 23:33:08 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V4 02/16] irqchip: brcmstb-l2: don't clear wakeable interrupts at init time
Date: Thu, 27 Nov 2014 20:32:08 -0800
Message-Id: <1417149142-3756-3-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
References: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Norris <computersforpeace@gmail.com>

Wakeable interrupts might be pending at boot/init time, because wakeup
interrupts might have triggered a resume from S5. So don't clear such
wakeups.

This means that any driver which requests a wakeable interrupt bit
should be prepared to handle an interrupt as soon as they call
request_irq(). (This is technically already the correct development
practice, but some drivers probably expect not to receive interrupts
until they have performed some I/O.)

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/irqchip/irq-brcmstb-l2.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
index 4aa653a0ac72..4edd27c486c4 100644
--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -136,7 +136,11 @@ int __init brcmstb_l2_intc_of_init(struct device_node *np,
 
 	/* Disable all interrupts by default */
 	writel(0xffffffff, data->base + CPU_MASK_SET);
-	writel(0xffffffff, data->base + CPU_CLEAR);
+
+	/* Wakeup interrupts may be retained from S5 (cold boot) */
+	data->can_wake = of_property_read_bool(np, "brcm,irq-can-wake");
+	if (!data->can_wake)
+		writel(0xffffffff, data->base + CPU_CLEAR);
 
 	data->parent_irq = irq_of_parse_and_map(np, 0);
 	if (data->parent_irq < 0) {
@@ -188,8 +192,7 @@ int __init brcmstb_l2_intc_of_init(struct device_node *np,
 	ct->chip.irq_suspend = brcmstb_l2_intc_suspend;
 	ct->chip.irq_resume = brcmstb_l2_intc_resume;
 
-	if (of_property_read_bool(np, "brcm,irq-can-wake")) {
-		data->can_wake = true;
+	if (data->can_wake) {
 		/* This IRQ chip can wake the system, set all child interrupts
 		 * in wake_enabled mask
 		 */
-- 
2.1.0

