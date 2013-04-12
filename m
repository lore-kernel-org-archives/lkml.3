Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab3DLP2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:28:41 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:36909 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586Ab3DLP2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:28:40 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2] MFD: ab8500: pass AB8500 IRQ to debugfs code by resource
Date: Fri, 12 Apr 2013 17:02:09 +0200
Message-ID: <1365778929-27168-1-git-send-email-linus.walleij@stericsson.com>
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
from the ab8500-core driver. Use an untyped resource to
stop the MFD core from remapping this IRQ relative to the
AB8500 irqdomain.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Pass an untyped resource to avoid problems due to IRQ
  remapping.

Sam this would have to go into the v3.10-targetted stuff...
Either immediately before you send it upstream or as a fixup.
---
 drivers/mfd/ab8500-core.c    | 15 +++++++++++++++
 drivers/mfd/ab8500-debugfs.c | 16 ++++++++++++----
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 8e8a016..65cd46b 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -868,6 +868,15 @@ static struct resource ab8500_chargalg_resources[] = {};
 #ifdef CONFIG_DEBUG_FS
 static struct resource ab8500_debug_resources[] = {
 	{
+		.name	= "IRQ_AB8500",
+		/*
+		 * Number will be filled in. NOTE: this is deliberately
+		 * not flagged as an IRQ in ordet to avoid remapping using
+		 * the irqdomain in the MFD core, so that this IRQ passes
+		 * unremapped to the debug code.
+		 */
+	},
+	{
 		.name	= "IRQ_FIRST",
 		.start	= AB8500_INT_MAIN_EXT_CH_NOT_OK,
 		.end	= AB8500_INT_MAIN_EXT_CH_NOT_OK,
@@ -1712,6 +1721,12 @@ static int ab8500_probe(struct platform_device *pdev)
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
index b88bbbc..37b7ce4 100644
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
@@ -2941,6 +2939,7 @@ static int ab8500_debug_probe(struct platform_device *plf)
 	struct dentry *file;
 	int ret = -ENOMEM;
 	struct ab8500 *ab8500;
+	struct resource *res;
 	debug_bank = AB8500_MISC;
 	debug_address = AB8500_REV_REG & 0x00FF;
 
@@ -2959,6 +2958,15 @@ static int ab8500_debug_probe(struct platform_device *plf)
 	if (!event_name)
 		goto out_freedev_attr;
 
+	res = platform_get_resource_byname(plf, 0, "IRQ_AB8500");
+	if (!res) {
+		dev_err(&plf->dev, "AB8500 irq not found, err %d\n",
+			irq_first);
+		ret = -ENXIO;
+		goto out_freeevent_name;
+	}
+	irq_ab8500 = res->start;
+
 	irq_first = platform_get_irq_byname(plf, "IRQ_FIRST");
 	if (irq_first < 0) {
 		dev_err(&plf->dev, "First irq not found, err %d\n",
-- 
1.7.11.3

