Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbaGASoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:44:22 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51023 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbaGASoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:44:20 -0400
Date: Wed, 2 Jul 2014 00:14:13 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] staging: iio: Introduce the use of devm_ioremap_resource
Message-ID: <20140701184413.GA2980@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of devm_ioremap_resource. It does away
with call to request_mem_region and the error checking on
platform_get_resource. Also, the calls to free the allocated resources
like release_mem_region and iounmap are done away with. The ret variable
in the probe function is also eliminated. Also, a bug is fixed as the
goto in the error handling of request_mem_region should not have
called release_mem_region which releases a resource that has not been
allocated.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/staging/iio/adc/ad7606_par.c | 37 ++++++------------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/iio/adc/ad7606_par.c b/drivers/staging/iio/adc/ad7606_par.c
index 8a48d18..7511839 100644
--- a/drivers/staging/iio/adc/ad7606_par.c
+++ b/drivers/staging/iio/adc/ad7606_par.c
@@ -53,7 +53,7 @@ static int ad7606_par_probe(struct platform_device *pdev)
 	struct iio_dev *indio_dev;
 	void __iomem *addr;
 	resource_size_t remap_size;
-	int ret, irq;
+	int irq;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -62,56 +62,31 @@ static int ad7606_par_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
+	addr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(addr))
+		return PTR_ERR(addr);
 
 	remap_size = resource_size(res);
 
-	/* Request the regions */
-	if (!request_mem_region(res->start, remap_size, "iio-ad7606")) {
-		ret = -EBUSY;
-		goto out1;
-	}
-	addr = ioremap(res->start, remap_size);
-	if (!addr) {
-		ret = -ENOMEM;
-		goto out1;
-	}
-
 	indio_dev = ad7606_probe(&pdev->dev, irq, addr,
 			  platform_get_device_id(pdev)->driver_data,
 			  remap_size > 1 ? &ad7606_par16_bops :
 			  &ad7606_par8_bops);
 
-	if (IS_ERR(indio_dev))  {
-		ret = PTR_ERR(indio_dev);
-		goto out2;
-	}
+	if (IS_ERR(indio_dev))
+		return PTR_ERR(indio_dev);
 
 	platform_set_drvdata(pdev, indio_dev);
 
 	return 0;
-
-out2:
-	iounmap(addr);
-out1:
-	release_mem_region(res->start, remap_size);
-
-	return ret;
 }
 
 static int ad7606_par_remove(struct platform_device *pdev)
 {
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
-	struct resource *res;
-	struct ad7606_state *st = iio_priv(indio_dev);
 
 	ad7606_remove(indio_dev, platform_get_irq(pdev, 0));
 
-	iounmap(st->base_address);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
 	return 0;
 }
 
-- 
1.9.1

