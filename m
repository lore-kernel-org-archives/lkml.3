Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300AbaFCVYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:24:42 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:63829 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907AbaFCVYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:24:40 -0400
Date: Wed, 4 Jun 2014 02:54:32 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH 2/2] usb: gadget: mv_u3d_core: use devm_ functions
Message-ID: <9a0a0e7db8587a6f8fa8cb7f5e4835f73f4d7ad3.1401828520.git.himangi774@gmail.com>
References: <cover.1401828519.git.himangi774@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1401828519.git.himangi774@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various devm_ functions allocate memory that is released when a
driver detaches.  This patch uses devm_kzalloc, devm_request_irq,
devm_ioremap, dmam_pool_destroy, dmam_alloc_coherent,
dmam_pool_create etc. for data that is allocated in the probe function
of a platform device and is only freed in the remove function. The
corresponding free functions are removed and many labels are done away
with. Also, linux/device.h is added to make sure the devm_*()
routine declarations are unambiguously available.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
 drivers/usb/gadget/mv_u3d_core.c | 128 +++++++++++----------------------------
 1 file changed, 34 insertions(+), 94 deletions(-)

diff --git a/drivers/usb/gadget/mv_u3d_core.c b/drivers/usb/gadget/mv_u3d_core.c
index c6db4a8..5fb9cea 100644
--- a/drivers/usb/gadget/mv_u3d_core.c
+++ b/drivers/usb/gadget/mv_u3d_core.c
@@ -26,6 +26,7 @@
 #include <linux/pm.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/mv_usb.h>
 #include <linux/clk.h>
@@ -1762,29 +1763,6 @@ static int mv_u3d_remove(struct platform_device *dev)
 
 	usb_del_gadget_udc(&u3d->gadget);
 
-	/* free memory allocated in probe */
-	if (u3d->trb_pool)
-		dma_pool_destroy(u3d->trb_pool);
-
-	if (u3d->ep_context)
-		dma_free_coherent(&dev->dev, u3d->ep_context_size,
-			u3d->ep_context, u3d->ep_context_dma);
-
-	kfree(u3d->eps);
-
-	if (u3d->irq)
-		free_irq(u3d->irq, u3d);
-
-	if (u3d->cap_regs)
-		iounmap(u3d->cap_regs);
-	u3d->cap_regs = NULL;
-
-	kfree(u3d->status_req);
-
-	clk_put(u3d->clk);
-
-	kfree(u3d);
-
 	return 0;
 }
 
@@ -1798,15 +1776,12 @@ static int mv_u3d_probe(struct platform_device *dev)
 
 	if (!dev_get_platdata(&dev->dev)) {
 		dev_err(&dev->dev, "missing platform_data\n");
-		retval = -ENODEV;
-		goto err_pdata;
+		return -ENODEV;
 	}
 
-	u3d = kzalloc(sizeof(*u3d), GFP_KERNEL);
-	if (!u3d) {
-		retval = -ENOMEM;
-		goto err_alloc_private;
-	}
+	u3d = devm_kzalloc(&dev->dev, sizeof(*u3d), GFP_KERNEL);
+	if (!u3d)
+		return -ENOMEM;
 
 	spin_lock_init(&u3d->lock);
 
@@ -1815,25 +1790,21 @@ static int mv_u3d_probe(struct platform_device *dev)
 	u3d->dev = &dev->dev;
 	u3d->vbus = pdata->vbus;
 
-	u3d->clk = clk_get(&dev->dev, NULL);
-	if (IS_ERR(u3d->clk)) {
-		retval = PTR_ERR(u3d->clk);
-		goto err_get_clk;
-	}
+	u3d->clk = devm_clk_get(&dev->dev, NULL);
+	if (IS_ERR(u3d->clk))
+		return PTR_ERR(u3d->clk);
 
 	r = platform_get_resource_byname(dev, IORESOURCE_MEM, "capregs");
 	if (!r) {
 		dev_err(&dev->dev, "no I/O memory resource defined\n");
-		retval = -ENODEV;
-		goto err_get_cap_regs;
+		return -ENODEV;
 	}
 
 	u3d->cap_regs = (struct mv_u3d_cap_regs __iomem *)
-		ioremap(r->start, resource_size(r));
+		devm_ioremap(&dev->dev, r->start, resource_size(r));
 	if (!u3d->cap_regs) {
 		dev_err(&dev->dev, "failed to map I/O memory\n");
-		retval = -EBUSY;
-		goto err_map_cap_regs;
+		return -EBUSY;
 	} else {
 		dev_dbg(&dev->dev, "cap_regs address: 0x%lx/0x%lx\n",
 			(unsigned long) r->start,
@@ -1847,7 +1818,7 @@ static int mv_u3d_probe(struct platform_device *dev)
 		retval = pdata->phy_init(u3d->phy_regs);
 		if (retval) {
 			dev_err(&dev->dev, "init phy error %d\n", retval);
-			goto err_u3d_enable;
+			return retval;
 		}
 	}
 
@@ -1873,40 +1844,35 @@ static int mv_u3d_probe(struct platform_device *dev)
 	size = u3d->max_eps * sizeof(struct mv_u3d_ep_context) * 2;
 	size = (size + MV_U3D_EP_CONTEXT_ALIGNMENT - 1)
 		& ~(MV_U3D_EP_CONTEXT_ALIGNMENT - 1);
-	u3d->ep_context = dma_alloc_coherent(&dev->dev, size,
-					&u3d->ep_context_dma, GFP_KERNEL);
+	u3d->ep_context = dmam_alloc_coherent(&dev->dev, size,
+					      &u3d->ep_context_dma,
+					      GFP_KERNEL);
 	if (!u3d->ep_context) {
 		dev_err(&dev->dev, "allocate ep context memory failed\n");
-		retval = -ENOMEM;
-		goto err_alloc_ep_context;
+		return -ENOMEM;
 	}
 	u3d->ep_context_size = size;
 
 	/* create TRB dma_pool resource */
-	u3d->trb_pool = dma_pool_create("u3d_trb",
-			&dev->dev,
-			sizeof(struct mv_u3d_trb_hw),
-			MV_U3D_TRB_ALIGNMENT,
-			MV_U3D_DMA_BOUNDARY);
+	u3d->trb_pool = dmam_pool_create("u3d_trb", &dev->dev,
+					  sizeof(struct mv_u3d_trb_hw),
+					  MV_U3D_TRB_ALIGNMENT,
+					  MV_U3D_DMA_BOUNDARY);
 
-	if (!u3d->trb_pool) {
-		retval = -ENOMEM;
-		goto err_alloc_trb_pool;
-	}
+	if (!u3d->trb_pool)
+		return -ENOMEM;
 
 	size = u3d->max_eps * sizeof(struct mv_u3d_ep) * 2;
-	u3d->eps = kzalloc(size, GFP_KERNEL);
-	if (!u3d->eps) {
-		retval = -ENOMEM;
-		goto err_alloc_eps;
-	}
+	u3d->eps = devm_kzalloc(&dev->dev, size, GFP_KERNEL);
+	if (!u3d->eps)
+		return -ENOMEM;
 
 	/* initialize ep0 status request structure */
-	u3d->status_req = kzalloc(sizeof(struct mv_u3d_req) + 8, GFP_KERNEL);
-	if (!u3d->status_req) {
-		retval = -ENOMEM;
-		goto err_alloc_status_req;
-	}
+	u3d->status_req = devm_kzalloc(&dev->dev,
+				       sizeof(struct mv_u3d_req) + 8,
+				       GFP_KERNEL);
+	if (!u3d->status_req)
+		return -ENOMEM;
 	INIT_LIST_HEAD(&u3d->status_req->queue);
 
 	/* allocate a small amount of memory to get valid address */
@@ -1922,17 +1888,15 @@ static int mv_u3d_probe(struct platform_device *dev)
 	r = platform_get_resource(dev, IORESOURCE_IRQ, 0);
 	if (!r) {
 		dev_err(&dev->dev, "no IRQ resource defined\n");
-		retval = -ENODEV;
-		goto err_get_irq;
+		return -ENODEV;
 	}
 	u3d->irq = r->start;
-	if (request_irq(u3d->irq, mv_u3d_irq,
+	if (devm_request_irq(&dev->dev, u3d->irq, mv_u3d_irq,
 		IRQF_SHARED, driver_name, u3d)) {
 		u3d->irq = 0;
 		dev_err(&dev->dev, "Request irq %d for u3d failed\n",
 			u3d->irq);
-		retval = -ENODEV;
-		goto err_request_irq;
+		return -ENODEV;
 	}
 
 	/* initialize gadget structure */
@@ -1960,36 +1924,12 @@ static int mv_u3d_probe(struct platform_device *dev)
 
 	retval = usb_add_gadget_udc(&dev->dev, &u3d->gadget);
 	if (retval)
-		goto err_unregister;
+		return retval;
 
 	dev_dbg(&dev->dev, "successful probe usb3 device %s clock gating.\n",
 		u3d->clock_gating ? "with" : "without");
 
 	return 0;
-
-err_unregister:
-	free_irq(u3d->irq, u3d);
-err_request_irq:
-err_get_irq:
-	kfree(u3d->status_req);
-err_alloc_status_req:
-	kfree(u3d->eps);
-err_alloc_eps:
-	dma_pool_destroy(u3d->trb_pool);
-err_alloc_trb_pool:
-	dma_free_coherent(&dev->dev, u3d->ep_context_size,
-		u3d->ep_context, u3d->ep_context_dma);
-err_alloc_ep_context:
-err_u3d_enable:
-	iounmap(u3d->cap_regs);
-err_map_cap_regs:
-err_get_cap_regs:
-err_get_clk:
-	clk_put(u3d->clk);
-	kfree(u3d);
-err_alloc_private:
-err_pdata:
-	return retval;
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
1.9.1

