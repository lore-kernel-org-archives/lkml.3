Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934661Ab3DKJJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:09:49 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:59563 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667Ab3DKJJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:09:47 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] MFD: ab8500: pass AB8500 IRQ to debugfs code by resource
Date: Thu, 11 Apr 2013 10:42:59 +0200
Message-ID: <1365669779-14953-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The AB8500 debug code which was merged in parallell with the
multiplatform work incidentally introduced a new instance using
the <mach/irqs.h> header which is now deleted, causing this
build regression:

drivers/mfd/ab8500-debugfs.c:95:23:
fatal error: mach/irqs.h: No such file or directory
compilation terminated.
make[4]: *** [drivers/mfd/ab8500-debugfs.o] Error 1

The code most certainly never worked with device tree either
since that does not rely on this kind of hard-coded interrupt
numbers.

Fix the problem at the root by passing it as a named resource
from the ab8500-core driver.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Sam this would have to go into the v3.10-targetted stuff...
Either immediately before you send it upstream or as a fixup.
---
 drivers/mfd/ab8500-core.c    | 11 +++++++++++
 drivers/mfd/ab8500-debugfs.c | 14 ++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 8e8a016..dd72914 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -868,6 +868,11 @@ static struct resource ab8500_chargalg_resources[] = {};
 #ifdef CONFIG_DEBUG_FS
 static struct resource ab8500_debug_resources[] = {
 	{
+		.name	= "IRQ_AB8500",
+		/* Number will be filled in */
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
 		.name	= "IRQ_FIRST",
 		.start	= AB8500_INT_MAIN_EXT_CH_NOT_OK,
 		.end	= AB8500_INT_MAIN_EXT_CH_NOT_OK,
@@ -1712,6 +1717,12 @@ static int ab8500_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+#if CONFIG_DEBUG_FS
+	/* Pass to debugfs */
+	ab8500_debug_resources[0].start = ab8500->irq;
+	ab8500_debug_resources[0].end = ab8500->irq;
+#endif
+
 	if (is_ab9540(ab8500))
 		ret = mfd_add_devices(ab8500->dev, 0, ab9540_devs,
 				ARRAY_SIZE(ab9540_devs), NULL,
diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index b88bbbc..bd39146 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -91,12 +91,10 @@
 #include <linux/ctype.h>
 #endif
 
-/* TODO: this file should not reference IRQ_DB8500_AB8500! */
-#include <mach/irqs.h>
-
 static u32 debug_bank;
 static u32 debug_address;
 
+static int irq_ab8500;
 static int irq_first;
 static int irq_last;
 static u32 *irq_count;
@@ -1589,7 +1587,7 @@ void ab8500_debug_register_interrupt(int line)
 {
 	if (line < num_interrupt_lines) {
 		num_interrupts[line]++;
-		if (suspend_test_wake_cause_interrupt_is_mine(IRQ_DB8500_AB8500))
+		if (suspend_test_wake_cause_interrupt_is_mine(irq_ab8500))
 			num_wake_interrupts[line]++;
 	}
 }
@@ -2959,6 +2957,14 @@ static int ab8500_debug_probe(struct platform_device *plf)
 	if (!event_name)
 		goto out_freedev_attr;
 
+	irq_ab8500 = platform_get_irq_byname(plf, "IRQ_AB8500");
+	if (irq_ab8500 < 0) {
+		dev_err(&plf->dev, "AB8500 irq not found, err %d\n",
+			irq_first);
+		ret = irq_ab8500;
+		goto out_freeevent_name;
+	}
+
 	irq_first = platform_get_irq_byname(plf, "IRQ_FIRST");
 	if (irq_first < 0) {
 		dev_err(&plf->dev, "First irq not found, err %d\n",
-- 
1.7.11.3

