Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbaGDRUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:20:06 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60389 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaGDRUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:20:05 -0400
Date: Fri, 4 Jul 2014 22:49:57 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] staging: goldfish: Introduce the use of managed interfaces
Message-ID: <20140704171957.GA6154@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of managed interfaces like devm_kzalloc,
devm_ioremap, dmam_alloc_coherent, devm_request_irq and does away with
the calls to functions to free the allocated memory in the probe and
remove functions. Also, the labels are removed in the probe function.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/staging/goldfish/goldfish_audio.c | 53 ++++++++-----------------------
 1 file changed, 13 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
index a166424..9df4ad8 100644
--- a/drivers/staging/goldfish/goldfish_audio.c
+++ b/drivers/staging/goldfish/goldfish_audio.c
@@ -274,11 +274,9 @@ static int goldfish_audio_probe(struct platform_device *pdev)
 	struct goldfish_audio *data;
 	dma_addr_t buf_addr;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (data == NULL) {
-		ret = -ENOMEM;
-		goto err_data_alloc_failed;
-	}
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
 	spin_lock_init(&data->lock);
 	init_waitqueue_head(&data->wait);
 	platform_set_drvdata(pdev, data);
@@ -286,38 +284,33 @@ static int goldfish_audio_probe(struct platform_device *pdev)
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
 		dev_err(&pdev->dev, "platform_get_resource failed\n");
-		ret = -ENODEV;
-		goto err_no_io_base;
-	}
-	data->reg_base = ioremap(r->start, PAGE_SIZE);
-	if (data->reg_base == NULL) {
-		ret = -ENOMEM;
-		goto err_no_io_base;
+		return -ENODEV;
 	}
+	data->reg_base = devm_ioremap(&pdev->dev, r->start, PAGE_SIZE);
+	if (data->reg_base == NULL)
+		return -ENOMEM;
 
 	data->irq = platform_get_irq(pdev, 0);
 	if (data->irq < 0) {
 		dev_err(&pdev->dev, "platform_get_irq failed\n");
-		ret = -ENODEV;
-		goto err_no_irq;
+		return -ENODEV;
 	}
-	data->buffer_virt = dma_alloc_coherent(&pdev->dev,
+	data->buffer_virt = dmam_alloc_coherent(&pdev->dev,
 				COMBINED_BUFFER_SIZE, &buf_addr, GFP_KERNEL);
 	if (data->buffer_virt == 0) {
-		ret = -ENOMEM;
 		dev_err(&pdev->dev, "allocate buffer failed\n");
-		goto err_alloc_write_buffer_failed;
+		return -ENOMEM;
 	}
 	data->buffer_phys = buf_addr;
 	data->write_buffer1 = data->buffer_virt;
 	data->write_buffer2 = data->buffer_virt + WRITE_BUFFER_SIZE;
 	data->read_buffer = data->buffer_virt + 2 * WRITE_BUFFER_SIZE;
 
-	ret = request_irq(data->irq, goldfish_audio_interrupt,
+	ret = devm_request_irq(&pdev->dev, data->irq, goldfish_audio_interrupt,
 					IRQF_SHARED, pdev->name, data);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
-		goto err_request_irq_failed;
+		return ret;
 	}
 
 	ret = misc_register(&goldfish_audio_device);
@@ -325,7 +318,7 @@ static int goldfish_audio_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev,
 			"misc_register returned %d in goldfish_audio_init\n",
 								ret);
-		goto err_misc_register_failed;
+		return ret;
 	}
 
 	AUDIO_WRITE64(data, AUDIO_SET_WRITE_BUFFER_1,
@@ -344,31 +337,11 @@ static int goldfish_audio_probe(struct platform_device *pdev)
 
 	audio_data = data;
 	return 0;
-
-err_misc_register_failed:
-	free_irq(data->irq, data);
-err_request_irq_failed:
-	dma_free_coherent(&pdev->dev, COMBINED_BUFFER_SIZE,
-					data->buffer_virt, data->buffer_phys);
-err_alloc_write_buffer_failed:
-err_no_irq:
-	iounmap(data->reg_base);
-err_no_io_base:
-	kfree(data);
-err_data_alloc_failed:
-	return ret;
 }
 
 static int goldfish_audio_remove(struct platform_device *pdev)
 {
-	struct goldfish_audio *data = platform_get_drvdata(pdev);
-
 	misc_deregister(&goldfish_audio_device);
-	free_irq(data->irq, data);
-	dma_free_coherent(&pdev->dev, COMBINED_BUFFER_SIZE,
-					data->buffer_virt, data->buffer_phys);
-	iounmap(data->reg_base);
-	kfree(data);
 	audio_data = NULL;
 	return 0;
 }
-- 
1.9.1

