Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab3GQRbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:31:48 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64873 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab3GQR1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:07 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 07/21] iio: TI-am335x-adc: Cleanup
Date: Wed, 17 Jul 2013 18:26:36 +0100
Message-Id: <1374082010-28095-8-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaned up the code a bit. Some formatting.
Some error handling paths corrected

This patch is based on work in the 3.2 tree by TI
Original Author is Patil Rachna

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 1f6e800..31665fa 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -311,13 +311,11 @@ static const struct iio_buffer_setup_ops tiadc_buffer_setup_ops = {
 static int tiadc_config_sw_ring(struct iio_dev *idev)
 {
         struct tiadc_device *adc_dev = iio_priv(idev);
-      //int ret;
 
         idev->buffer = iio_kfifo_allocate(idev);
         if (!idev->buffer)
                 return(-ENOMEM);
 
- //     idev->buffer->access = &ring_sw_access_funcs;
         idev->setup_ops = &tiadc_buffer_setup_ops;
 
         INIT_WORK(&adc_dev->poll_work, &tiadc_poll_handler);
@@ -506,21 +504,22 @@ static int tiadc_probe(struct platform_device *pdev)
 	err = tiadc_channel_init(indio_dev, adc_dev->channels);
 	if (err < 0)
 		goto err_free_device;
-    init_waitqueue_head(&adc_dev->wq_data_avail);
 
-    err = request_irq(adc_dev->irq, tiadc_irq, IRQF_SHARED,
-            indio_dev->name, indio_dev);
-    if (err)
-            goto err_free_irq;
+	init_waitqueue_head(&adc_dev->wq_data_avail);
 
-    err = tiadc_config_sw_ring(indio_dev);
-    if (err < 0)
-            goto err_unregister;
+	err = request_irq(adc_dev->irq, tiadc_irq, IRQF_SHARED,
+		indio_dev->name, indio_dev);
+	if (err)
+		goto err_free_irq;
+
+	err = tiadc_config_sw_ring(indio_dev);
+	if (err < 0)
+		goto err_unregister;
  
-    err = iio_buffer_register(indio_dev,
-                    indio_dev->channels, indio_dev->num_channels);
-    if (err < 0)
-            goto err_unregister;
+	err = iio_buffer_register(indio_dev,
+		indio_dev->channels, indio_dev->num_channels);
+	if (err < 0)
+		goto err_unregister;
 
 	err = iio_device_register(indio_dev);
 	if (err)
@@ -531,9 +530,9 @@ static int tiadc_probe(struct platform_device *pdev)
 	return 0;
 
 err_unregister:
-
+	iio_buffer_unregister(indio_dev);
 err_free_irq:
-   free_irq(adc_dev->irq, indio_dev);
+	free_irq(adc_dev->irq, indio_dev);
 err_free_channels:
 	tiadc_channels_remove(indio_dev);
 err_free_device:
@@ -548,7 +547,9 @@ static int tiadc_remove(struct platform_device *pdev)
 	struct tiadc_device *adc_dev = iio_priv(indio_dev);
 	u32 step_en;
 
+	free_irq(adc_dev->irq, indio_dev);
 	iio_device_unregister(indio_dev);
+	iio_buffer_unregister(indio_dev);
 	tiadc_channels_remove(indio_dev);
 
 	step_en = get_adc_step_mask(adc_dev);
-- 
1.7.9.5

