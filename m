Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab3FRO0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:26:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45617 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3FRO0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:26:37 -0400
Date: Tue, 18 Jun 2013 16:26:34 +0200
From: Pavel Machek <pavel@denx.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Detlev Zundel <dzu@denx.de>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        trivial <trivial@kernel.org>
Subject: Re: [PATCH] fix UIO with device tree but no assigned interrupt
Message-ID: <20130618142634.GB17361@amd.pavel.ucw.cz>
References: <20130617134957.GA15602@amd.pavel.ucw.cz>
 <CACxGe6sO6Tes8en905cyJwP69w82PHjwKV9+XxxXhAPMRyGYkA@mail.gmail.com>
 <20130618125235.GA15122@amd.pavel.ucw.cz>
 <CACxGe6tLPfJ3KS6+4aO8s8emq8=ajuc+gmBtaEDqd60m4_vx6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6tLPfJ3KS6+4aO8s8emq8=ajuc+gmBtaEDqd60m4_vx6w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If device is initialized from device tree, but has no interrupt
assigned, uio will still try to request and interrupt old way,
fails, and fails registration.

This is wrong; don't try initializing irq using platform data if
device tree is available.

Simplified code based on suggestion by Grant Likely.

Fixed memory leak in "irq can not be registered" error path.

Signed-off-by: Pavel Machek <pavel@denx.de>
Reported-by: Detlev Zundel <dzu@denx.de>

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index c122bca..d594dd9 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -103,24 +103,16 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	int i;
 
 	if (pdev->dev.of_node) {
-		int irq;
-
 		/* alloc uioinfo for one device */
 		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
 		if (!uioinfo) {
 			ret = -ENOMEM;
 			dev_err(&pdev->dev, "unable to kmalloc\n");
-			goto bad2;
+			return ret;
 		}
 		uioinfo->name = pdev->dev.of_node->name;
 		uioinfo->version = "devicetree";
-
 		/* Multiple IRQs are not supported */
-		irq = platform_get_irq(pdev, 0);
-		if (irq == -ENXIO)
-			uioinfo->irq = UIO_IRQ_NONE;
-		else
-			uioinfo->irq = irq;
 	}
 
 	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
@@ -148,12 +140,15 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 
 	if (!uioinfo->irq) {
 		ret = platform_get_irq(pdev, 0);
-		if (ret < 0) {
+		uioinfo->irq = ret;
+		if (ret == -ENXIO && pdev->dev.of_node)
+			uioinfo->irq = UIO_IRQ_NONE;
+		else if (ret < 0) {
 			dev_err(&pdev->dev, "failed to get IRQ\n");
-			goto bad0;
+			goto bad1;
 		}
-		uioinfo->irq = ret;
 	}
+
 	uiomem = &uioinfo->mem[0];
 
 	for (i = 0; i < pdev->num_resources; ++i) {
@@ -206,19 +201,19 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	ret = uio_register_device(&pdev->dev, priv->uioinfo);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to register uio device\n");
-		goto bad1;
+		goto bad2;
 	}
 
 	platform_set_drvdata(pdev, priv);
 	return 0;
+ bad2:
+	pm_runtime_disable(&pdev->dev);
  bad1:
 	kfree(priv);
-	pm_runtime_disable(&pdev->dev);
  bad0:
 	/* kfree uioinfo for OF */
 	if (pdev->dev.of_node)
 		kfree(uioinfo);
- bad2:
 	return ret;
 }
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
