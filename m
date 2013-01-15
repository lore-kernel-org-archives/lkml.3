Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab3AONB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:01:29 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:32927 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355Ab3AOM4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:40 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/26] mfd: abx500-core: Provide an API to dump all ABx500 registers
Date: Tue, 15 Jan 2013 12:55:48 +0000
Message-Id: <1358254566-12419-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>

Some drivers can detect subsystem failures e.g. shared memory driver
can detect modem sub system failures. It would be helpful in analyzing
these failures if AB register dump is available at that point. This
patch adds the API for the drivers to dump AB registers in the kernel
log.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Reviewed-by: Linus WALLEIJ <linus.walleij@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/mfd/abx500-core.c  |   16 ++++++++++++++++
 include/linux/mfd/abx500.h |    2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/mfd/abx500-core.c b/drivers/mfd/abx500-core.c
index 7ce65f4..9818afb 100644
--- a/drivers/mfd/abx500-core.c
+++ b/drivers/mfd/abx500-core.c
@@ -153,6 +153,22 @@ int abx500_startup_irq_enabled(struct device *dev, unsigned int irq)
 }
 EXPORT_SYMBOL(abx500_startup_irq_enabled);
 
+void abx500_dump_all_banks(void)
+{
+	struct abx500_ops *ops;
+	struct device dummy_child = {0};
+	struct abx500_device_entry *dev_entry;
+
+	list_for_each_entry(dev_entry, &abx500_list, list) {
+		dummy_child.parent = dev_entry->dev;
+		ops = &dev_entry->ops;
+
+		if ((ops != NULL) && (ops->dump_all_banks != NULL))
+			ops->dump_all_banks(&dummy_child);
+	}
+}
+EXPORT_SYMBOL(abx500_dump_all_banks);
+
 MODULE_AUTHOR("Mattias Wallin <mattias.wallin@stericsson.com>");
 MODULE_DESCRIPTION("ABX500 core driver");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 5d5298d..2667af4 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -326,6 +326,7 @@ int abx500_mask_and_set_register_interruptible(struct device *dev, u8 bank,
 int abx500_get_chip_id(struct device *dev);
 int abx500_event_registers_startup_state_get(struct device *dev, u8 *event);
 int abx500_startup_irq_enabled(struct device *dev, unsigned int irq);
+void abx500_dump_all_banks(void);
 
 struct abx500_ops {
 	int (*get_chip_id) (struct device *);
@@ -336,6 +337,7 @@ struct abx500_ops {
 	int (*mask_and_set_register) (struct device *, u8, u8, u8, u8);
 	int (*event_registers_startup_state_get) (struct device *, u8 *);
 	int (*startup_irq_enabled) (struct device *, unsigned int);
+	void (*dump_all_banks) (struct device *);
 };
 
 int abx500_register_ops(struct device *core_dev, struct abx500_ops *ops);
-- 
1.7.9.5

