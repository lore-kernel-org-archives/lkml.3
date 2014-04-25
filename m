Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaDYX5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 19:57:50 -0400
Received: from ring0.de ([5.45.105.125]:53201 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaDYX4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 19:56:35 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv3 3/5] Input: tsc2005: convert driver to use devm_*
Date: Sat, 26 Apr 2014 01:56:17 +0200
Message-Id: <1398470179-20880-4-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398470179-20880-1-git-send-email-sre@kernel.org>
References: <1398470179-20880-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the driver by using managed resources for memory allocation of
internal struct, input device allocation and irq request.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/input/touchscreen/tsc2005.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2005.c b/drivers/input/touchscreen/tsc2005.c
index 520e673..9daaddd 100644
--- a/drivers/input/touchscreen/tsc2005.c
+++ b/drivers/input/touchscreen/tsc2005.c
@@ -604,12 +604,10 @@ static int tsc2005_probe(struct spi_device *spi)
 	if (error)
 		return error;
 
-	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!ts || !input_dev) {
-		error = -ENOMEM;
-		goto err_free_mem;
-	}
+	ts = devm_kzalloc(&spi->dev, sizeof(*ts), GFP_KERNEL);
+	input_dev = devm_input_allocate_device(&spi->dev);
+	if (!ts || !input_dev)
+		return -ENOMEM;
 
 	ts->spi = spi;
 	ts->idev = input_dev;
@@ -649,12 +647,13 @@ static int tsc2005_probe(struct spi_device *spi)
 	/* Ensure the touchscreen is off */
 	tsc2005_stop_scan(ts);
 
-	error = request_threaded_irq(spi->irq, NULL, tsc2005_irq_thread,
-				     IRQF_TRIGGER_RISING | IRQF_ONESHOT,
-				     "tsc2005", ts);
+	error = devm_request_threaded_irq(&spi->dev, spi->irq, NULL,
+					  tsc2005_irq_thread,
+					  IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					  "tsc2005", ts);
 	if (error) {
 		dev_err(&spi->dev, "Failed to request irq, err: %d\n", error);
-		goto err_free_mem;
+		return error;
 	}
 
 	spi_set_drvdata(spi, ts);
@@ -662,7 +661,7 @@ static int tsc2005_probe(struct spi_device *spi)
 	if (error) {
 		dev_err(&spi->dev,
 			"Failed to create sysfs attributes, err: %d\n", error);
-		goto err_clear_drvdata;
+		return error;
 	}
 
 	error = input_register_device(ts->idev);
@@ -677,11 +676,6 @@ static int tsc2005_probe(struct spi_device *spi)
 
 err_remove_sysfs:
 	sysfs_remove_group(&spi->dev.kobj, &tsc2005_attr_group);
-err_clear_drvdata:
-	free_irq(spi->irq, ts);
-err_free_mem:
-	input_free_device(input_dev);
-	kfree(ts);
 	return error;
 }
 
@@ -691,10 +685,6 @@ static int tsc2005_remove(struct spi_device *spi)
 
 	sysfs_remove_group(&ts->spi->dev.kobj, &tsc2005_attr_group);
 
-	free_irq(ts->spi->irq, ts);
-	input_unregister_device(ts->idev);
-	kfree(ts);
-
 	return 0;
 }
 
-- 
1.9.2

