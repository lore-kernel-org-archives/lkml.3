Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161793Ab3BOM5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:57:52 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50968 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161476Ab3BOM5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:47 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/35] mfd: ab8500-debug: Add wake-up info
Date: Fri, 15 Feb 2013 12:56:44 +0000
Message-Id: <1360933026-30325-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Add information regarding what ab interrupt that caused
a wake-up from suspend in <debugfs>/ab8500/interrupts.
Also print the name of the interrupts, not just the numbers.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Per FORLIN <per.forlin@stericsson.com>
Tested-by: Mattias WALLIN <mattias.wallin@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 8b15fc2..51b0e97 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -80,6 +80,7 @@
 #include <linux/interrupt.h>
 #include <linux/kobject.h>
 #include <linux/slab.h>
+#include <linux/irq.h>
 
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ab8500-gpadc.h>
@@ -802,22 +803,46 @@ static ssize_t ab8500_val_write(struct file *file,
  * Interrupt status
  */
 static u32 num_interrupts[AB8500_MAX_NR_IRQS];
+static u32 num_wake_interrupts[AB8500_MAX_NR_IRQS];
 static int num_interrupt_lines;
 
+bool __attribute__((weak)) suspend_test_wake_cause_interrupt_is_mine(u32 my_int)
+{
+	return false;
+}
+
 void ab8500_debug_register_interrupt(int line)
 {
-	if (line < num_interrupt_lines)
+	if (line < num_interrupt_lines) {
 		num_interrupts[line]++;
+		if (suspend_test_wake_cause_interrupt_is_mine(IRQ_DB8500_AB8500))
+			num_wake_interrupts[line]++;
+	}
 }
 
 static int ab8500_interrupts_print(struct seq_file *s, void *p)
 {
 	int line;
 
-	seq_printf(s, "irq:  number of\n");
+	seq_printf(s, "name: number:  number of: wake:\n");
+
+	for (line = 0; line < num_interrupt_lines; line++) {
+		struct irq_desc *desc = irq_to_desc(line + irq_first);
+		struct irqaction *action = desc->action;
 
-	for (line = 0; line < num_interrupt_lines; line++)
-		seq_printf(s, "%3i:  %6i\n", line, num_interrupts[line]);
+		seq_printf(s, "%3i:  %6i %4i", line,
+			   num_interrupts[line],
+			   num_wake_interrupts[line]);
+
+		if (desc && desc->name)
+			seq_printf(s, "-%-8s", desc->name);
+		if (action) {
+			seq_printf(s, "  %s", action->name);
+			while ((action = action->next) != NULL)
+				seq_printf(s, ", %s", action->name);
+		}
+		seq_putc(s, '\n');
+	}
 
 	return 0;
 }
@@ -1869,7 +1894,7 @@ static int ab8500_debug_probe(struct platform_device *plf)
 		dev_err(&plf->dev, "Last irq not found, err %d\n",
 				irq_last);
 		ret = irq_last;
-                goto out_freeevent_name;
+		goto out_freeevent_name;
 	}
 
 	ab8500_dir = debugfs_create_dir(AB8500_NAME_STRING, NULL);
-- 
1.7.10.4

