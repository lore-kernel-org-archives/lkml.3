Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaGHB0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:26:40 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:16426 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753559AbaGHB0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 21:26:32 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Lee Jones <lee.jones@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH 1/3] mfd: pm8921: Expose pm8xxx_read_irq_status
Date: Mon, 7 Jul 2014 18:26:23 -0700
Message-ID: <1404782785-1824-2-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most status bits, e.g. for GPIO and MPP input, is retrieved by reading
the interrupt status registers, so this needs to be exposed to clients.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/mfd/pm8921-core.c       |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/mfd/pm8921-core.h |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)
 create mode 100644 include/linux/mfd/pm8921-core.h

diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index 9595138..7dda0c2 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -26,6 +26,7 @@
 #include <linux/regmap.h>
 #include <linux/of_platform.h>
 #include <linux/mfd/core.h>
+#include <linux/mfd/pm8921-core.h>
 
 #define	SSBI_REG_ADDR_IRQ_BASE		0x1BB
 
@@ -65,6 +66,41 @@ struct pm_irq_chip {
 	u8			config[0];
 };
 
+int pm8xxx_read_irq_status(int irq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+	struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
+	unsigned int pmirq = irqd_to_hwirq(d);
+	unsigned int bits;
+	int irq_bit;
+	u8 block;
+	int rc;
+
+	if (!chip) {
+		pr_err("Failed to resolve pm_irq_chip\n");
+		return -EINVAL;
+	}
+
+	block = pmirq / 8;
+	irq_bit = pmirq % 8;
+
+	spin_lock(&chip->pm_irq_lock);
+	rc = regmap_write(chip->regmap, SSBI_REG_ADDR_IRQ_BLK_SEL, block);
+	if (rc) {
+		pr_err("Failed Selecting Block %d rc=%d\n", block, rc);
+		goto bail;
+	}
+
+	rc = regmap_read(chip->regmap, SSBI_REG_ADDR_IRQ_RT_STATUS, &bits);
+	if (rc)
+		pr_err("Failed Reading Status rc=%d\n", rc);
+bail:
+	spin_unlock(&chip->pm_irq_lock);
+
+	return rc ? rc : !!(bits & BIT(irq_bit));
+}
+EXPORT_SYMBOL(pm8xxx_read_irq_status);
+
 static int pm8xxx_read_block_irq(struct pm_irq_chip *chip, unsigned int bp,
 				 unsigned int *ip)
 {
diff --git a/include/linux/mfd/pm8921-core.h b/include/linux/mfd/pm8921-core.h
new file mode 100644
index 0000000..77f7cb5
--- /dev/null
+++ b/include/linux/mfd/pm8921-core.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (c) 2014, Sony Mobile Communications AB
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MFD_PM8921_CORE_H
+#define __MFD_PM8921_CORE_H
+
+#include <linux/err.h>
+
+#ifdef CONFIG_MFD_PM8921_CORE
+
+int pm8xxx_read_irq_status(int irq);
+
+#else
+
+static inline int pm8xxx_read_irq_status(int irq)
+{
+	return -ENOSYS;
+}
+
+#endif
+
+#endif
-- 
1.7.9.5

