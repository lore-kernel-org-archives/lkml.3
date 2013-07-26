Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3GZJEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:04:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51237 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748Ab3GZJET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:04:19 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <linux@arm.linux.org.uk>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH 1/2] usb: musb: omap: remove using PLATFORM_DEVID_AUTO in omap2430.c
Date: Fri, 26 Jul 2013 14:33:37 +0530
Message-ID: <1374829418-27503-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374829418-27503-1-git-send-email-kishon@ti.com>
References: <1374829418-27503-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the platform devices are created using PLATFORM_DEVID_AUTO, the
device names given in usb_bind_phy (in board file) does not match with
the actual device name causing the USB PHY library not to return the
PHY reference when the MUSB controller request for the PHY in the non-dt boot
case.
So removed creating platform devices using PLATFORM_DEVID_AUTO in omap2430.c.
This is also needed for the Generic PHY Framework.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/musb_core.c |   31 ++++++++++++++++++++++++++++++-
 drivers/usb/musb/musb_core.h |    2 ++
 drivers/usb/musb/omap2430.c  |   16 ++++++++++++++--
 3 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 29a24ce..eb5d876 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -121,7 +121,7 @@ MODULE_DESCRIPTION(DRIVER_INFO);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" MUSB_DRIVER_NAME);
-
+static DEFINE_IDA(musb_ida);
 
 /*-------------------------------------------------------------------------*/
 
@@ -132,6 +132,35 @@ static inline struct musb *dev_to_musb(struct device *dev)
 
 /*-------------------------------------------------------------------------*/
 
+int musb_get_id(struct device *dev, gfp_t gfp_mask)
+{
+	int ret;
+	int id;
+
+	ret = ida_pre_get(&musb_ida, gfp_mask);
+	if (!ret) {
+		dev_err(dev, "failed to reserve resource for id\n");
+		return -ENOMEM;
+	}
+
+	ret = ida_get_new(&musb_ida, &id);
+	if (ret < 0) {
+		dev_err(dev, "failed to allocate a new id\n");
+		return ret;
+		}
+
+	return id;
+}
+EXPORT_SYMBOL_GPL(musb_get_id);
+
+void musb_put_id(struct device *dev, int id)
+{
+
+	dev_dbg(dev, "removing id %d\n", id);
+	ida_remove(&musb_ida, id);
+}
+EXPORT_SYMBOL_GPL(musb_put_id);
+
 #ifndef CONFIG_BLACKFIN
 static int musb_ulpi_read(struct usb_phy *phy, u32 offset)
 {
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index 7d341c3..79545a4 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -511,6 +511,8 @@ static inline void musb_configure_ep0(struct musb *musb)
 extern const char musb_driver_name[];
 
 extern void musb_stop(struct musb *musb);
+extern int musb_get_id(struct device *dev, gfp_t gfp_mask);
+extern void musb_put_id(struct device *dev, int id);
 
 extern void musb_write_fifo(struct musb_hw_ep *ep, u16 len, const u8 *src);
 extern void musb_read_fifo(struct musb_hw_ep *ep, u16 len, u8 *dst);
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 6708a3b..812a7fc 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -489,6 +489,7 @@ static int omap2430_probe(struct platform_device *pdev)
 	struct device_node		*np = pdev->dev.of_node;
 	struct musb_hdrc_config		*config;
 	int				ret = -ENOMEM;
+	int				musbid;
 
 	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
@@ -496,10 +497,18 @@ static int omap2430_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
-	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
+	/* get the musb id */
+	musbid = musb_get_id(&pdev->dev, GFP_KERNEL);
+	if (musbid < 0) {
+		dev_err(&pdev->dev, "failed to allocate musb id\n");
+		ret = -ENOMEM;
+		goto err0;
+	}
+
+	musb = platform_device_alloc("musb-hdrc", musbid);
 	if (!musb) {
 		dev_err(&pdev->dev, "failed to allocate musb device\n");
-		goto err0;
+		goto err1;
 	}
 
 	musb->dev.parent		= &pdev->dev;
@@ -607,6 +616,9 @@ static int omap2430_probe(struct platform_device *pdev)
 err2:
 	platform_device_put(musb);
 
+err1:
+	musb_put_id(&pdev->dev, musbid);
+
 err0:
 	return ret;
 }
-- 
1.7.10.4

