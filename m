Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3GBPqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:46:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50818 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3GBPp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:45:58 -0400
Date: Tue, 2 Jul 2013 17:45:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: "Koul, Vinod" <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH 1/3] DMA: shdma: switch to managed resource allocation
In-Reply-To: <Pine.LNX.4.64.1307021738500.1965@axis700.grange>
Message-ID: <Pine.LNX.4.64.1307021744110.1965@axis700.grange>
References: <Pine.LNX.4.64.1307021738500.1965@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:sWJroojLxDBV8zSCJkKIEL/JUMuNv3sAfROt5sRps5l
 vmJDsS0N4bSM8sPpUtLxfQdwKzdCKzFSySHjLf4eMSH90WrZFU
 +3a04pbibK6rxYR56quiUaJv+I8KyNNXvw3Vt9LCLozj0WMQqE
 HKkONJXFKt5smDSD9MgEbATN/vF04CLMXY2a+X/DZ0RdJ0LGmc
 Ci7jbGNoSewWKi44+5qS1x7hPedaQ7ASoB4LwKdoQ0BptqfDZ1
 qBdAmvkwHfWf9hdr5D3rKJRw+n5CdwQ3aiy3s2gw+g1HAgz6F7
 qjreDNcGRjTIVSeuNivpvW3G2SL6osESmEJG3mKQH28OAUdpQP
 i7IEds1KFIeb3sRvzhxxBdVNHZV880HSeLzF9l+q6y1ixktc5/
 SsWuSyynZAc6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch shdma to using devm_* managed functions for allocation of memory,
requesting IRQs, mapping IO resources etc.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/dma/sh/shdma-base.c |   11 +-----
 drivers/dma/sh/shdma.c      |   71 ++++++++-----------------------------------
 drivers/dma/sh/sudmac.c     |    1 -
 include/linux/shdma-base.h  |    1 -
 4 files changed, 15 insertions(+), 69 deletions(-)

diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index 28ca361..c5ea256 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -831,8 +831,8 @@ static irqreturn_t chan_irqt(int irq, void *dev)
 int shdma_request_irq(struct shdma_chan *schan, int irq,
 			   unsigned long flags, const char *name)
 {
-	int ret = request_threaded_irq(irq, chan_irq, chan_irqt,
-				       flags, name, schan);
+	int ret = devm_request_threaded_irq(schan->dev, irq, chan_irq,
+					    chan_irqt, flags, name, schan);
 
 	schan->irq = ret < 0 ? ret : irq;
 
@@ -840,13 +840,6 @@ int shdma_request_irq(struct shdma_chan *schan, int irq,
 }
 EXPORT_SYMBOL(shdma_request_irq);
 
-void shdma_free_irq(struct shdma_chan *schan)
-{
-	if (schan->irq >= 0)
-		free_irq(schan->irq, schan);
-}
-EXPORT_SYMBOL(shdma_free_irq);
-
 void shdma_chan_probe(struct shdma_dev *sdev,
 			   struct shdma_chan *schan, int id)
 {
diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index c7950be..3083d62 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -507,7 +507,8 @@ static int sh_dmae_chan_probe(struct sh_dmae_device *shdev, int id,
 	struct shdma_chan *schan;
 	int err;
 
-	sh_chan = kzalloc(sizeof(struct sh_dmae_chan), GFP_KERNEL);
+	sh_chan = devm_kzalloc(sdev->dma_dev.dev, sizeof(struct sh_dmae_chan),
+			       GFP_KERNEL);
 	if (!sh_chan) {
 		dev_err(sdev->dma_dev.dev,
 			"No free memory for allocating dma channels!\n");
@@ -543,7 +544,6 @@ static int sh_dmae_chan_probe(struct sh_dmae_device *shdev, int id,
 err_no_irq:
 	/* remove from dmaengine device node */
 	shdma_chan_remove(schan);
-	kfree(sh_chan);
 	return err;
 }
 
@@ -554,14 +554,9 @@ static void sh_dmae_chan_remove(struct sh_dmae_device *shdev)
 	int i;
 
 	shdma_for_each_chan(schan, &shdev->shdma_dev, i) {
-		struct sh_dmae_chan *sh_chan = container_of(schan,
-					struct sh_dmae_chan, shdma_chan);
 		BUG_ON(!schan);
 
-		shdma_free_irq(&sh_chan->shdma_chan);
-
 		shdma_chan_remove(schan);
-		kfree(sh_chan);
 	}
 	dma_dev->chancnt = 0;
 }
@@ -698,33 +693,22 @@ static int sh_dmae_probe(struct platform_device *pdev)
 	if (!chan || !errirq_res)
 		return -ENODEV;
 
-	if (!request_mem_region(chan->start, resource_size(chan), pdev->name)) {
-		dev_err(&pdev->dev, "DMAC register region already claimed\n");
-		return -EBUSY;
-	}
-
-	if (dmars && !request_mem_region(dmars->start, resource_size(dmars), pdev->name)) {
-		dev_err(&pdev->dev, "DMAC DMARS region already claimed\n");
-		err = -EBUSY;
-		goto ermrdmars;
-	}
-
-	err = -ENOMEM;
-	shdev = kzalloc(sizeof(struct sh_dmae_device), GFP_KERNEL);
+	shdev = devm_kzalloc(&pdev->dev, sizeof(struct sh_dmae_device),
+			     GFP_KERNEL);
 	if (!shdev) {
 		dev_err(&pdev->dev, "Not enough memory\n");
-		goto ealloc;
+		return -ENOMEM;
 	}
 
 	dma_dev = &shdev->shdma_dev.dma_dev;
 
-	shdev->chan_reg = ioremap(chan->start, resource_size(chan));
-	if (!shdev->chan_reg)
-		goto emapchan;
+	shdev->chan_reg = devm_ioremap_resource(&pdev->dev, chan);
+	if (IS_ERR(shdev->chan_reg))
+		return PTR_ERR(shdev->chan_reg);
 	if (dmars) {
-		shdev->dmars = ioremap(dmars->start, resource_size(dmars));
-		if (!shdev->dmars)
-			goto emapdmars;
+		shdev->dmars = devm_ioremap_resource(&pdev->dev, dmars);
+		if (IS_ERR(shdev->dmars))
+			return PTR_ERR(shdev->dmars);
 	}
 
 	if (!pdata->slave_only)
@@ -785,8 +769,8 @@ static int sh_dmae_probe(struct platform_device *pdev)
 
 	errirq = errirq_res->start;
 
-	err = request_irq(errirq, sh_dmae_err, irqflags,
-			  "DMAC Address Error", shdev);
+	err = devm_request_irq(&pdev->dev, errirq, sh_dmae_err, irqflags,
+			       "DMAC Address Error", shdev);
 	if (err) {
 		dev_err(&pdev->dev,
 			"DMA failed requesting irq #%d, error %d\n",
@@ -875,7 +859,6 @@ chan_probe_err:
 	sh_dmae_chan_remove(shdev);
 
 #if defined(CONFIG_CPU_SH4) || defined(CONFIG_ARCH_SHMOBILE)
-	free_irq(errirq, shdev);
 eirq_err:
 #endif
 rst_err:
@@ -889,18 +872,7 @@ rst_err:
 	platform_set_drvdata(pdev, NULL);
 	shdma_cleanup(&shdev->shdma_dev);
 eshdma:
-	if (dmars)
-		iounmap(shdev->dmars);
-emapdmars:
-	iounmap(shdev->chan_reg);
 	synchronize_rcu();
-emapchan:
-	kfree(shdev);
-ealloc:
-	if (dmars)
-		release_mem_region(dmars->start, resource_size(dmars));
-ermrdmars:
-	release_mem_region(chan->start, resource_size(chan));
 
 	return err;
 }
@@ -909,17 +881,12 @@ static int sh_dmae_remove(struct platform_device *pdev)
 {
 	struct sh_dmae_device *shdev = platform_get_drvdata(pdev);
 	struct dma_device *dma_dev = &shdev->shdma_dev.dma_dev;
-	struct resource *res;
-	int errirq = platform_get_irq(pdev, 0);
 
 	dma_async_device_unregister(dma_dev);
 
 	/* Is a NOP if this controller isn't registered with of-dma */
 	of_dma_controller_free(pdev->dev.of_node);
 
-	if (errirq > 0)
-		free_irq(errirq, shdev);
-
 	spin_lock_irq(&sh_dmae_lock);
 	list_del_rcu(&shdev->node);
 	spin_unlock_irq(&sh_dmae_lock);
@@ -929,21 +896,9 @@ static int sh_dmae_remove(struct platform_device *pdev)
 	sh_dmae_chan_remove(shdev);
 	shdma_cleanup(&shdev->shdma_dev);
 
-	if (shdev->dmars)
-		iounmap(shdev->dmars);
-	iounmap(shdev->chan_reg);
-
 	platform_set_drvdata(pdev, NULL);
 
 	synchronize_rcu();
-	kfree(shdev);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res)
-		release_mem_region(res->start, resource_size(res));
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (res)
-		release_mem_region(res->start, resource_size(res));
 
 	return 0;
 }
diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index e7c94bb..3477901 100644
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -302,7 +302,6 @@ static void sudmac_chan_remove(struct sudmac_device *su_dev)
 
 		BUG_ON(!schan);
 
-		shdma_free_irq(&sc->shdma_chan);
 		shdma_chan_remove(schan);
 	}
 	dma_dev->chancnt = 0;
diff --git a/include/linux/shdma-base.h b/include/linux/shdma-base.h
index 9d67bb1..1aa1f19 100644
--- a/include/linux/shdma-base.h
+++ b/include/linux/shdma-base.h
@@ -116,7 +116,6 @@ struct shdma_dev {
 
 int shdma_request_irq(struct shdma_chan *, int,
 			   unsigned long, const char *);
-void shdma_free_irq(struct shdma_chan *);
 bool shdma_reset(struct shdma_dev *sdev);
 void shdma_chan_probe(struct shdma_dev *sdev,
 			   struct shdma_chan *schan, int id);
-- 
1.7.2.5

