Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3LCDpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:45:11 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39649 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab3LCDok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:44:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>, <lee.jones@linaro.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 03/15] mfd: menelaus: Convert to threaded irq
Date: Mon, 2 Dec 2013 21:42:56 -0600
Message-ID: <1386042188-12246-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1386042188-12246-1-git-send-email-balbi@ti.com>
References: <1386042188-12246-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we don't need that extra workqueue when we
have generic threaded irq handlers support.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 8bd97ca..11d7d81 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -36,7 +36,6 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/mutex.h>
-#include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <linux/rtc.h>
 #include <linux/bcd.h>
@@ -161,12 +160,9 @@
 #define MCT_PIN_ST_S1_CD_ST		(1 << 0)
 #define MCT_PIN_ST_S2_CD_ST		(1 << 1)
 
-static void menelaus_work(struct work_struct *_menelaus);
-
 struct menelaus_chip {
 	struct mutex		lock;
 	struct i2c_client	*client;
-	struct work_struct	work;
 #ifdef CONFIG_RTC_DRV_TWL92330
 	struct rtc_device	*rtc;
 	u8			rtc_control;
@@ -795,11 +791,9 @@ out:
 
 /*-----------------------------------------------------------------------*/
 
-/* Handles Menelaus interrupts. Does not run in interrupt context */
-static void menelaus_work(struct work_struct *_menelaus)
+static irqreturn_t menelaus_irq(int irq, void *_menelaus)
 {
-	struct menelaus_chip *menelaus =
-			container_of(_menelaus, struct menelaus_chip, work);
+	struct menelaus_chip *menelaus = _menelaus;
 	void (*handler)(struct menelaus_chip *menelaus);
 
 	while (1) {
@@ -826,18 +820,6 @@ static void menelaus_work(struct work_struct *_menelaus)
 			mutex_unlock(&menelaus->lock);
 		}
 	}
-	enable_irq(menelaus->client->irq);
-}
-
-/*
- * We cannot use I2C in interrupt context, so we just schedule work.
- */
-static irqreturn_t menelaus_irq(int irq, void *_menelaus)
-{
-	struct menelaus_chip *menelaus = _menelaus;
-
-	disable_irq_nosync(irq);
-	(void)schedule_work(&menelaus->work);
 
 	return IRQ_HANDLED;
 }
@@ -1225,8 +1207,8 @@ static int menelaus_probe(struct i2c_client *client,
 	menelaus_write_reg(MENELAUS_MCT_CTRL1, 0x73);
 
 	if (client->irq > 0) {
-		err = request_irq(client->irq, menelaus_irq, 0,
-				  DRIVER_NAME, menelaus);
+		err = request_threaded_irq(client->irq, NULL, menelaus_irq,
+				IRQF_ONESHOT, DRIVER_NAME, menelaus);
 		if (err) {
 			dev_dbg(&client->dev,  "can't get IRQ %d, err %d\n",
 					client->irq, err);
@@ -1235,7 +1217,6 @@ static int menelaus_probe(struct i2c_client *client,
 	}
 
 	mutex_init(&menelaus->lock);
-	INIT_WORK(&menelaus->work, menelaus_work);
 
 	pr_info("Menelaus rev %d.%d\n", rev >> 4, rev & 0x0f);
 
@@ -1258,7 +1239,6 @@ static int menelaus_probe(struct i2c_client *client,
 	return 0;
 fail:
 	free_irq(client->irq, menelaus);
-	flush_work(&menelaus->work);
 	return err;
 }
 
@@ -1267,7 +1247,6 @@ static int menelaus_remove(struct i2c_client *client)
 	struct menelaus_chip	*menelaus = i2c_get_clientdata(client);
 
 	free_irq(client->irq, menelaus);
-	flush_work(&menelaus->work);
 	the_menelaus = NULL;
 	return 0;
 }
-- 
1.8.4.GIT

