Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaGAVTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:19:17 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61558 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaGAVTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:19:15 -0400
Date: Wed, 2 Jul 2014 02:49:08 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH v2] iio:trigger: Introduce the use of devm_kzalloc
Message-ID: <20140701211908.GA23193@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of the managed version of kzalloc and
removes the kfrees in the probe and remove functions. More return
paths are added and the labels are renamed to order them.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
v2: add more return paths
Not compile tested.
 drivers/staging/iio/trigger/iio-trig-bfin-timer.c | 31 ++++++++---------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/iio/trigger/iio-trig-bfin-timer.c b/drivers/staging/iio/trigger/iio-trig-bfin-timer.c
index 16f1a06..a21b7c5 100644
--- a/drivers/staging/iio/trigger/iio-trig-bfin-timer.c
+++ b/drivers/staging/iio/trigger/iio-trig-bfin-timer.c
@@ -182,45 +182,40 @@ static int iio_bfin_tmr_trigger_probe(struct platform_device *pdev)
 	unsigned int config;
 	int ret;
 
-	st = kzalloc(sizeof(*st), GFP_KERNEL);
-	if (st == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	st = devm_kzalloc(&pdev->dev, sizeof(*st), GFP_KERNEL);
+	if (st == NULL)
+		return -ENOMEM;
 
 	st->irq = platform_get_irq(pdev, 0);
 	if (!st->irq) {
 		dev_err(&pdev->dev, "No IRQs specified");
-		ret = -ENODEV;
-		goto out1;
+		return -ENODEV;
 	}
 
 	ret = iio_bfin_tmr_get_number(st->irq);
 	if (ret < 0)
-		goto out1;
+		return ret;
 
 	st->timer_num = ret;
 	st->t = &iio_bfin_timer_code[st->timer_num];
 
 	st->trig = iio_trigger_alloc("bfintmr%d", st->timer_num);
-	if (!st->trig) {
-		ret = -ENOMEM;
-		goto out1;
-	}
+	if (!st->trig)
+		return -ENOMEM;
 
 	st->trig->ops = &iio_bfin_tmr_trigger_ops;
 	st->trig->dev.groups = iio_bfin_tmr_trigger_attr_groups;
 	iio_trigger_set_drvdata(st->trig, st);
 	ret = iio_trigger_register(st->trig);
 	if (ret)
-		goto out2;
+		goto out;
 
 	ret = request_irq(st->irq, iio_bfin_tmr_trigger_isr,
 			  0, st->trig->name, st);
 	if (ret) {
 		dev_err(&pdev->dev,
 			"request IRQ-%d failed", st->irq);
-		goto out4;
+		goto out1;
 	}
 
 	config = PWM_OUT | PERIOD_CNT | IRQ_ENA;
@@ -260,13 +255,10 @@ static int iio_bfin_tmr_trigger_probe(struct platform_device *pdev)
 	return 0;
 out_free_irq:
 	free_irq(st->irq, st);
-out4:
-	iio_trigger_unregister(st->trig);
-out2:
-	iio_trigger_put(st->trig);
 out1:
-	kfree(st);
+	iio_trigger_unregister(st->trig);
 out:
+	iio_trigger_put(st->trig);
 	return ret;
 }
 
@@ -280,7 +272,6 @@ static int iio_bfin_tmr_trigger_remove(struct platform_device *pdev)
 	free_irq(st->irq, st);
 	iio_trigger_unregister(st->trig);
 	iio_trigger_put(st->trig);
-	kfree(st);
 
 	return 0;
 }
-- 
1.9.1

