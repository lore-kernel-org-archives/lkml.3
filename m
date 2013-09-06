Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854Ab3IFXRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 19:17:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60910 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3IFXRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 19:17:21 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, ldewangan@nvidia.com,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] mfd: tps6586x: implement irq_set_wake
Date: Fri,  6 Sep 2013 17:17:13 -0600
Message-Id: <1378509433-26404-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

rtc-tps6586x calls enable/disable_irq_wake() during suspend/resume. Since
the main tps6586x irq_chip doesn't implement .irq_set_wake, this causes
the RTC's enable_irq_wake() to fail, and the disable_irq_wake() to spew a
WARN about unbalanced wake disable. Solve this by implementing
.irq_set_wake.

Also, I assume that enable_irq_wake() shouldn't be called unconditionally
in tps6586x_irq_init(), since this is now triggered by IRQ children
setting up their cascaded IRQs for wake. So, remove that.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
I'm tempted to Cc stable here, since this bug is certainly present in
older kernel releases. However, the only user-visible aspect is the WARN
on resume, so I'm not sure if it's worth it?
---
 drivers/mfd/tps6586x.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index f54fe4d..68906b1 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -124,6 +124,7 @@ struct tps6586x {
 	struct i2c_client	*client;
 	struct regmap		*regmap;
 
+	int			irq;
 	struct irq_chip		irq_chip;
 	struct mutex		irq_lock;
 	int			irq_base;
@@ -261,12 +262,23 @@ static void tps6586x_irq_sync_unlock(struct irq_data *data)
 	mutex_unlock(&tps6586x->irq_lock);
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int tps6586x_irq_set_wake(struct irq_data *irq_data, unsigned int on)
+{
+	struct tps6586x *tps6586x = irq_data_get_irq_chip_data(irq_data);
+	return irq_set_irq_wake(tps6586x->irq, on);
+}
+#else
+#define tps6586x_irq_set_wake NULL
+#endif
+
 static struct irq_chip tps6586x_irq_chip = {
 	.name = "tps6586x",
 	.irq_bus_lock = tps6586x_irq_lock,
 	.irq_bus_sync_unlock = tps6586x_irq_sync_unlock,
 	.irq_disable = tps6586x_irq_disable,
 	.irq_enable = tps6586x_irq_enable,
+	.irq_set_wake = tps6586x_irq_set_wake,
 };
 
 static int tps6586x_irq_map(struct irq_domain *h, unsigned int virq,
@@ -331,6 +343,8 @@ static int tps6586x_irq_init(struct tps6586x *tps6586x, int irq,
 	int new_irq_base;
 	int irq_num = ARRAY_SIZE(tps6586x_irqs);
 
+	tps6586x->irq = irq;
+
 	mutex_init(&tps6586x->irq_lock);
 	for (i = 0; i < 5; i++) {
 		tps6586x->mask_reg[i] = 0xff;
@@ -360,10 +374,8 @@ static int tps6586x_irq_init(struct tps6586x *tps6586x, int irq,
 	ret = request_threaded_irq(irq, NULL, tps6586x_irq, IRQF_ONESHOT,
 				   "tps6586x", tps6586x);
 
-	if (!ret) {
+	if (!ret)
 		device_init_wakeup(tps6586x->dev, 1);
-		enable_irq_wake(irq);
-	}
 
 	return ret;
 }
-- 
1.8.1.5

