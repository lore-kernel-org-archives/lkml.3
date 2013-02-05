Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab3BETtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:49:32 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:58497 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756697Ab3BETtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:49:22 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 02/14] mfd: ab8500: provide a irq_set_type() function
Date: Tue, 5 Feb 2013 20:48:23 +0100
Message-ID: <1360093715-6348-3-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

In the AB8500 IRQ mask and unmask functions, we rely on testing for
IRQ_TYPE_EDGE_RISING and IRQ_TYPE_EDGE_FALLING interrupts to
physically mask and unmask the correct interrupt lines. In order
for us to do that, the trigger needs to be set in the associated
flags. However, unless a irq_set_type() function pointer is passed
when registering the IRQ chip, the IRQ subsystem will refuse to do
it. For that reason, we're providing one.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Sam, it'd be nice if you could ACK these first four patches,
the series basically simplifies things a lot by not cascading
the AB8500 IRQs and duplicate code in the pinctrl driver.
---
 drivers/mfd/ab8500-core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index e1ba0be..aa5937e 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -403,6 +403,11 @@ static void ab8500_irq_unmask(struct irq_data *data)
 		ab8500->mask[index] &= ~mask;
 }
 
+static int ab8500_irq_set_type(struct irq_data *data, unsigned int type)
+{
+	return 0;
+}
+
 static struct irq_chip ab8500_irq_chip = {
 	.name			= "ab8500",
 	.irq_bus_lock		= ab8500_irq_lock,
@@ -410,6 +415,7 @@ static struct irq_chip ab8500_irq_chip = {
 	.irq_mask		= ab8500_irq_mask,
 	.irq_disable		= ab8500_irq_mask,
 	.irq_unmask		= ab8500_irq_unmask,
+	.irq_set_type		= ab8500_irq_set_type,
 };
 
 static int ab8500_handle_hierarchical_line(struct ab8500 *ab8500,
-- 
1.7.11.3

