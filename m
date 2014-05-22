Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaEVAqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:46:53 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:54933 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaEVAqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:46:52 -0400
Date: Thu, 22 May 2014 09:46:12 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: hjk@hansjkoch.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: uio_dmem_genirq: Fix memory leak in
 uio_dmem_genirq_probe()
Message-ID: <20140522004611.GA1216@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When platform_get_irq() is failed after "priv" allocated,
it need to free "priv". But the label of bad0 doesn't try
to free about "priv". So this patch changes that lable to "bad1".
But "bad1" has pm_runtime_disable() call, this function should
be called when uio_register_device() is failed. So it is moved
into handling error for uio_register_device().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/uio/uio_dmem_genirq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
index 1270f3b..8d0bba4 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -204,7 +204,7 @@ static int uio_dmem_genirq_probe(struct platform_device *pdev)
 		ret = platform_get_irq(pdev, 0);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to get IRQ\n");
-			goto bad0;
+			goto bad1;
 		}
 		uioinfo->irq = ret;
 	}
@@ -275,6 +275,7 @@ static int uio_dmem_genirq_probe(struct platform_device *pdev)
 	ret = uio_register_device(&pdev->dev, priv->uioinfo);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to register uio device\n");
+		pm_runtime_disable(&pdev->dev);
 		goto bad1;
 	}
 
@@ -282,7 +283,6 @@ static int uio_dmem_genirq_probe(struct platform_device *pdev)
 	return 0;
  bad1:
 	kfree(priv);
-	pm_runtime_disable(&pdev->dev);
  bad0:
 	/* kfree uioinfo for OF */
 	if (pdev->dev.of_node)
-- 
1.7.1

