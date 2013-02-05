Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3BETtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:49:24 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:48865 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756280Ab3BETtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:49:20 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 01/14] mfd: ab8500: prepare to handle AB8500 GPIO's IRQs correctly
Date: Tue, 5 Feb 2013 20:48:22 +0100
Message-ID: <1360093715-6348-2-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

In an upcoming patch, the gpio-ab8500 driver will relinquish all
IRQ handling capability and pass it back into the AB8500 core
driver. This will aid in reducing massive code duplication within
the kernel. Also, most of the functionality is already in the
AB8500 core driver, as the GPIO IRQs are actually sandwiched
between lots of other IRQs which the core driver already handles.

All we're doing here is providing the core driver with knowledge
that each GPIO has two IRQs assigned to it; one for rising and
a separate one for falling.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Sam, it'd be nice if you could ACK these first four patches,
the series basically simplifies things a lot by not cascading
the AB8500 IRQs and duplicate code in the pinctrl driver.
---
 drivers/mfd/ab8500-core.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index e1650ba..e1ba0be 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -367,16 +367,40 @@ static void ab8500_irq_mask(struct irq_data *data)
 	int mask = 1 << (offset % 8);
 
 	ab8500->mask[index] |= mask;
+
+	/* The AB8500 GPIOs have two interrupts each (rising & falling). */
+	if (offset >= AB8500_INT_GPIO6R && offset <= AB8500_INT_GPIO41R)
+		ab8500->mask[index + 2] |= mask;
+	if (offset >= AB9540_INT_GPIO50R && offset <= AB9540_INT_GPIO54R)
+		ab8500->mask[index + 1] |= mask;
+	if (offset == AB8540_INT_GPIO43R || offset == AB8540_INT_GPIO44R)
+		ab8500->mask[index] |= (mask >> 1);
 }
 
 static void ab8500_irq_unmask(struct irq_data *data)
 {
 	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(data);
+	unsigned int type = irqd_get_trigger_type(data);
 	int offset = data->hwirq;
 	int index = offset / 8;
 	int mask = 1 << (offset % 8);
 
-	ab8500->mask[index] &= ~mask;
+	if (type & IRQ_TYPE_EDGE_RISING)
+		ab8500->mask[index] &= ~mask;
+
+	/* The AB8500 GPIOs have two interrupts each (rising & falling). */
+	if (type & IRQ_TYPE_EDGE_FALLING) {
+		if (offset >= AB8500_INT_GPIO6R && offset <= AB8500_INT_GPIO41R)
+			ab8500->mask[index + 2] &= ~mask;
+		else if (offset >= AB9540_INT_GPIO50R && offset <= AB9540_INT_GPIO54R)
+			ab8500->mask[index + 1] &= ~mask;
+		else if (offset == AB8540_INT_GPIO43R || offset == AB8540_INT_GPIO44R)
+			ab8500->mask[index] &= ~(mask >> 1);
+		else
+			ab8500->mask[index] &= ~mask;
+	} else
+		/* Satisfies the case where type is not set. */
+		ab8500->mask[index] &= ~mask;
 }
 
 static struct irq_chip ab8500_irq_chip = {
-- 
1.7.11.3

