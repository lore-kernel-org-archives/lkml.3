Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaAIMx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:53:26 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.175]:19838 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755490AbaAIMxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:53:02 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-9.tower-39.messagelabs.com!1389271977!16114668!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201401091252.s09CqsOr042762@swsrvapps-02.lan>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Thu, 9 Jan 2014 12:51:37 +0000
Subject: [PATCH V1] input: use device managed memory in da9052 touchscreen driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The touchscreen component driver for the da9052/3 Dialog PMICs
is changed to use device managed memory allocation.

This results in simpler error paths as failures in the probe()
function do not require explicit calls to free the devm_...
allocated memory.
The allocation functions used in this driver are:
    devm_kzalloc()
    devm_input_allocate_device()
    devm_request_threaded_irq()

Suggested-by: Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>
Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
---
This patch is relative to linux-next repository tag next-20140109

Many thanks to Huqiu Liu who instigated this patch.

 drivers/input/touchscreen/da9052_tsi.c |   62 ++++++++++++++++----------------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/input/touchscreen/da9052_tsi.c b/drivers/input/touchscreen/da9052_tsi.c
index ab64d58..dcc4cf1 100644
--- a/drivers/input/touchscreen/da9052_tsi.c
+++ b/drivers/input/touchscreen/da9052_tsi.c
@@ -233,18 +233,30 @@ static int da9052_ts_probe(struct platform_device *pdev)
 	struct da9052_tsi *tsi;
 	struct input_dev *input_dev;
 	int error;
+	int pdown_irq;
+	int ready_irq;
 
 	da9052 = dev_get_drvdata(pdev->dev.parent);
 	if (!da9052)
 		return -EINVAL;
 
-	tsi = kzalloc(sizeof(struct da9052_tsi), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!tsi || !input_dev) {
-		error = -ENOMEM;
-		goto err_free_mem;
-	}
+	pdown_irq = regmap_irq_get_virq(da9052->irq_data, DA9052_IRQ_PENDOWN);
+	if (pdown_irq < 0)
+		return pdown_irq;
+
+	ready_irq = regmap_irq_get_virq(da9052->irq_data, DA9052_IRQ_TSIREADY);
+	if (ready_irq < 0)
+		return ready_irq;
+
+	tsi = devm_kzalloc(&pdev->dev, sizeof(struct da9052_tsi), GFP_KERNEL);
+	if (!tsi)
+		return -ENOMEM;
+
+	input_dev = devm_input_allocate_device(&pdev->dev);
+	if (!input_dev)
+		return -ENOMEM;
 
+	platform_set_drvdata(pdev, tsi);
 	tsi->da9052 = da9052;
 	tsi->dev = input_dev;
 	tsi->stopped = true;
@@ -274,20 +286,24 @@ static int da9052_ts_probe(struct platform_device *pdev)
 	/* Disable ADC */
 	da9052_ts_adc_toggle(tsi, false);
 
-	error = da9052_request_irq(tsi->da9052, DA9052_IRQ_PENDOWN,
-				"pendown-irq", da9052_ts_pendwn_irq, tsi);
+	error = devm_request_threaded_irq(&pdev->dev, pdown_irq,
+				NULL, da9052_ts_pendwn_irq,
+				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				"pendown-irq", tsi);
 	if (error) {
 		dev_err(tsi->da9052->dev,
 			"Failed to register PENDWN IRQ: %d\n", error);
-		goto err_free_mem;
+		return error;
 	}
 
-	error = da9052_request_irq(tsi->da9052, DA9052_IRQ_TSIREADY,
-				"tsiready-irq", da9052_ts_datardy_irq, tsi);
+	error = devm_request_threaded_irq(&pdev->dev, ready_irq,
+				NULL, da9052_ts_datardy_irq,
+				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				"tsiready-irq", tsi);
 	if (error) {
 		dev_err(tsi->da9052->dev,
 			"Failed to register TSIRDY IRQ :%d\n", error);
-		goto err_free_pendwn_irq;
+		return error;
 	}
 
 	/* Mask PEN_DOWN and TSI_READY events */
@@ -296,25 +312,13 @@ static int da9052_ts_probe(struct platform_device *pdev)
 
 	error = da9052_configure_tsi(tsi);
 	if (error)
-		goto err_free_datardy_irq;
+		return error;
 
 	error = input_register_device(tsi->dev);
 	if (error)
-		goto err_free_datardy_irq;
-
-	platform_set_drvdata(pdev, tsi);
+		return error;
 
 	return 0;
-
-err_free_datardy_irq:
-	da9052_free_irq(tsi->da9052, DA9052_IRQ_TSIREADY, tsi);
-err_free_pendwn_irq:
-	da9052_free_irq(tsi->da9052, DA9052_IRQ_PENDOWN, tsi);
-err_free_mem:
-	kfree(tsi);
-	input_free_device(input_dev);
-
-	return error;
 }
 
 static int  da9052_ts_remove(struct platform_device *pdev)
@@ -323,12 +327,6 @@ static int  da9052_ts_remove(struct platform_device *pdev)
 
 	da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x19);
 
-	da9052_free_irq(tsi->da9052, DA9052_IRQ_TSIREADY, tsi);
-	da9052_free_irq(tsi->da9052, DA9052_IRQ_PENDOWN, tsi);
-
-	input_unregister_device(tsi->dev);
-	kfree(tsi);
-
 	return 0;
 }
 
-- 
end-of-patch for input: use device managed memory in da9052 touchscreen driver V1

