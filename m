Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbaFTVma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 17:42:30 -0400
Received: from mail-pd0-f201.google.com ([209.85.192.201]:46029 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbaFTVm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 17:42:28 -0400
From: Doug Anderson <dianders@chromium.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sebastian Reichel <sre@kernel.org>
Cc: olof@lixom.net, Sachin Kamat <sachin.kamat@linaro.org>,
        ajaykumar.rs@samsung.com, linux-samsung-soc@vger.kernel.org,
        broonie@kernel.org, lee.jones@linaro.org,
        Anton Vorontsov <anton@enomsg.org>, javier.martinez@collabora.co.uk,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v3] charger: tps65090: Allow charger module to be used when no irq
Date: Fri, 20 Jun 2014 14:42:03 -0700
Message-Id: <1403300523-17310-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the ARM Chromebook tps65090 has two masters: the AP (the main
processor running linux) and the EC (the embedded controller).  The AP
is allowed to mess with FETs but the EC is in charge of charge control.

The tps65090 interupt line is routed to both the AP and the EC, which
can cause quite a headache.  Having two people adjusting masks and
acking interrupts is a recipe for disaster.

In the shipping kernel we had a hack to have the AP pay attention to
the IRQ but not to ack it.  It also wasn't supposed to configure the
IRQ in any way.  That hack allowed us to detect when the device was
charging without messing with the EC's state.

The current tps65090 infrastructure makes the above difficult, and it
was a bit of a hack to begin with.  Rather than uglify the driver to
support it, just extend the driver's existing notion of "no irq" to
the charger.  This makes the charger code poll every 2 seconds for AC
detect, which is sufficient.

For proper functioning, requires (mfd: tps65090: Don't tell child
devices we have an IRQ if we don't).  If we don't have that patch
we'll simply fail to probe on devices without an interrupt (just like
we did before this patch).

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Split noirq (polling mode) changes into MFD and charger

This patch has been sent up a number of times with no response.  It's
needed to make the charger work on exynos5250-snow,
exynos5420-peach-pit, and exynos5800-peach-pi.  It was originally part
of a series as <https://patchwork.kernel.org/patch/4042751/> and the
rest of the series has long since landed.

This is the third resend.

 drivers/power/tps65090-charger.c | 76 +++++++++++++++++++++++++++++++---------
 1 file changed, 59 insertions(+), 17 deletions(-)

diff --git a/drivers/power/tps65090-charger.c b/drivers/power/tps65090-charger.c
index 1685f63..31a3ba4 100644
--- a/drivers/power/tps65090-charger.c
+++ b/drivers/power/tps65090-charger.c
@@ -17,9 +17,11 @@
  */
 #include <linux/delay.h>
 #include <linux/err.h>
+#include <linux/freezer.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
+#include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
@@ -32,11 +34,15 @@
 #define TPS65090_VACG		BIT(1)
 #define TPS65090_NOITERM	BIT(5)
 
+#define POLL_INTERVAL		(HZ * 2)	/* Used when no irq */
+
 struct tps65090_charger {
 	struct	device	*dev;
 	int	ac_online;
 	int	prev_ac_online;
 	int	irq;
+	struct task_struct	*poll_task;
+	bool			passive_mode;
 	struct power_supply	ac;
 	struct tps65090_platform_data *pdata;
 };
@@ -49,6 +55,9 @@ static int tps65090_low_chrg_current(struct tps65090_charger *charger)
 {
 	int ret;
 
+	if (charger->passive_mode)
+		return 0;
+
 	ret = tps65090_write(charger->dev->parent, TPS65090_REG_CG_CTRL5,
 			TPS65090_NOITERM);
 	if (ret < 0) {
@@ -64,6 +73,9 @@ static int tps65090_enable_charging(struct tps65090_charger *charger)
 	int ret;
 	uint8_t ctrl0 = 0;
 
+	if (charger->passive_mode)
+		return 0;
+
 	ret = tps65090_read(charger->dev->parent, TPS65090_REG_CG_CTRL0,
 			    &ctrl0);
 	if (ret < 0) {
@@ -87,6 +99,9 @@ static int tps65090_config_charger(struct tps65090_charger *charger)
 	uint8_t intrmask = 0;
 	int ret;
 
+	if (charger->passive_mode)
+		return 0;
+
 	if (charger->pdata->enable_low_current_chrg) {
 		ret = tps65090_low_chrg_current(charger);
 		if (ret < 0) {
@@ -164,10 +179,14 @@ static irqreturn_t tps65090_charger_isr(int irq, void *dev_id)
 	}
 
 	/* Clear interrupts. */
-	ret = tps65090_write(charger->dev->parent, TPS65090_REG_INTR_STS, 0x00);
-	if (ret < 0) {
-		dev_err(charger->dev, "%s(): Error in writing reg 0x%x\n",
+	if (!charger->passive_mode) {
+		ret = tps65090_write(charger->dev->parent,
+				     TPS65090_REG_INTR_STS, 0x00);
+		if (ret < 0) {
+			dev_err(charger->dev,
+				"%s(): Error in writing reg 0x%x\n",
 				__func__, TPS65090_REG_INTR_STS);
+		}
 	}
 
 	if (charger->prev_ac_online != charger->ac_online)
@@ -198,6 +217,18 @@ static struct tps65090_platform_data *
 
 }
 
+static int tps65090_charger_poll_task(void *data)
+{
+	set_freezable();
+
+	while (!kthread_should_stop()) {
+		schedule_timeout_interruptible(POLL_INTERVAL);
+		try_to_freeze();
+		tps65090_charger_isr(-1, data);
+	}
+	return 0;
+}
+
 static int tps65090_charger_probe(struct platform_device *pdev)
 {
 	struct tps65090_charger *cdata;
@@ -244,22 +275,10 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
-		dev_warn(&pdev->dev, "Unable to get charger irq = %d\n", irq);
-		ret = irq;
-		goto fail_unregister_supply;
-	}
-
+	if (irq < 0)
+		irq = NO_IRQ;
 	cdata->irq = irq;
 
-	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
-		tps65090_charger_isr, 0, "tps65090-charger", cdata);
-	if (ret) {
-		dev_err(cdata->dev, "Unable to register irq %d err %d\n", irq,
-			ret);
-		goto fail_unregister_supply;
-	}
-
 	ret = tps65090_config_charger(cdata);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "charger config failed, err %d\n", ret);
@@ -285,6 +304,27 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 		power_supply_changed(&cdata->ac);
 	}
 
+	if (irq != NO_IRQ) {
+		ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+			tps65090_charger_isr, 0, "tps65090-charger", cdata);
+		if (ret) {
+			dev_err(cdata->dev,
+				"Unable to register irq %d err %d\n", irq,
+				ret);
+			goto fail_unregister_supply;
+		}
+	} else {
+		cdata->poll_task = kthread_run(tps65090_charger_poll_task,
+					      cdata, "ktps65090charger");
+		cdata->passive_mode = true;
+		if (IS_ERR(cdata->poll_task)) {
+			ret = PTR_ERR(cdata->poll_task);
+			dev_err(cdata->dev,
+				"Unable to run kthread err %d\n", ret);
+			goto fail_unregister_supply;
+		}
+	}
+
 	return 0;
 
 fail_unregister_supply:
@@ -297,6 +337,8 @@ static int tps65090_charger_remove(struct platform_device *pdev)
 {
 	struct tps65090_charger *cdata = platform_get_drvdata(pdev);
 
+	if (cdata->irq == NO_IRQ)
+		kthread_stop(cdata->poll_task);
 	power_supply_unregister(&cdata->ac);
 
 	return 0;
-- 
2.0.0.526.g5318336

