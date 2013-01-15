Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab3AOM5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:57:09 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63072 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab3AOM47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:59 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/26] mfd: ab8500-debugfs: Allow number of IRQs to be provided more dynamically
Date: Tue, 15 Jan 2013 12:55:59 +0000
Message-Id: <1358254566-12419-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@stericsson.com>

With the introduction of new AB* platforms, it's important to allow
as much code reuse as possible. By allowing a system's number of IRQs
to be dynamically passed, we can reuse almost all of the -debugfs
driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |   51 +++++++++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index ec57e43..d23b6cc 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -94,10 +94,11 @@ static u32 debug_address;
 
 static int irq_first;
 static int irq_last;
-static u32 irq_count[AB8500_NR_IRQS];
+static u32 *irq_count;
+static int num_irqs;
 
-static struct device_attribute *dev_attr[AB8500_NR_IRQS];
-static char *event_name[AB8500_NR_IRQS];
+static struct device_attribute **dev_attr;
+static char **event_name;
 
 /**
  * struct ab8500_reg_range
@@ -483,7 +484,7 @@ static irqreturn_t ab8500_debug_handler(int irq, void *data)
 	struct kobject *kobj = (struct kobject *)data;
 	unsigned int irq_abb = irq - irq_first;
 
-	if (irq_abb < AB8500_NR_IRQS)
+	if (irq_abb < num_irqs)
 		irq_count[irq_abb]++;
 	/*
 	 * This makes it possible to use poll for events (POLLPRI | POLLERR)
@@ -1338,7 +1339,7 @@ static ssize_t show_irq(struct device *dev,
 		return err;
 
 	irq_index = name - irq_first;
-	if (irq_index >= AB8500_NR_IRQS)
+	if (irq_index >= num_irqs)
 		return -EINVAL;
 	else
 		return sprintf(buf, "%u\n", irq_count[irq_index]);
@@ -1374,7 +1375,7 @@ static ssize_t ab8500_subscribe_write(struct file *file,
 	}
 
 	irq_index = user_val - irq_first;
-	if (irq_index >= AB8500_NR_IRQS)
+	if (irq_index >= num_irqs)
 		return -EINVAL;
 
 	/*
@@ -1438,7 +1439,7 @@ static ssize_t ab8500_unsubscribe_write(struct file *file,
 	}
 
 	irq_index = user_val - irq_first;
-	if (irq_index >= AB8500_NR_IRQS)
+	if (irq_index >= num_irqs)
 		return -EINVAL;
 
 	/* Set irq count to 0 when unsubscribe */
@@ -1519,21 +1520,40 @@ static struct dentry *ab8500_gpadc_dir;
 static int __devinit ab8500_debug_probe(struct platform_device *plf)
 {
 	struct dentry *file;
+	int ret = -ENOMEM;
+	struct ab8500 *ab8500;
 	debug_bank = AB8500_MISC;
 	debug_address = AB8500_REV_REG & 0x00FF;
 
+	ab8500 = dev_get_drvdata(plf->dev.parent);
+	num_irqs = ab8500->mask_size;
+
+	irq_count = kzalloc(sizeof(irq_count)*num_irqs, GFP_KERNEL);
+	if (!irq_count)
+		return -ENOMEM;
+
+	dev_attr = kzalloc(sizeof(*dev_attr)*num_irqs,GFP_KERNEL);
+	if (!dev_attr)
+		goto out_freeirq_count;
+
+	event_name = kzalloc(sizeof(*event_name)*num_irqs, GFP_KERNEL);
+	if (!event_name)
+		goto out_freedev_attr;
+
 	irq_first = platform_get_irq_byname(plf, "IRQ_FIRST");
 	if (irq_first < 0) {
 		dev_err(&plf->dev, "First irq not found, err %d\n",
 				irq_first);
-		return irq_first;
+		ret = irq_first;
+		goto out_freeevent_name;
 	}
 
 	irq_last = platform_get_irq_byname(plf, "IRQ_LAST");
 	if (irq_last < 0) {
 		dev_err(&plf->dev, "Last irq not found, err %d\n",
 				irq_last);
-		return irq_last;
+		ret = irq_last;
+                goto out_freeevent_name;
 	}
 
 	ab8500_dir = debugfs_create_dir(AB8500_NAME_STRING, NULL);
@@ -1656,12 +1676,23 @@ err:
 	if (ab8500_dir)
 		debugfs_remove_recursive(ab8500_dir);
 	dev_err(&plf->dev, "failed to create debugfs entries.\n");
-	return -ENOMEM;
+out_freeevent_name:
+	kfree(event_name);
+out_freedev_attr:
+	kfree(dev_attr);
+out_freeirq_count:
+	kfree(irq_count);
+
+	return ret;
 }
 
 static int __devexit ab8500_debug_remove(struct platform_device *plf)
 {
 	debugfs_remove_recursive(ab8500_dir);
+	kfree(event_name);
+	kfree(dev_attr);
+	kfree(irq_count);
+
 	return 0;
 }
 
-- 
1.7.9.5

