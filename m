Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3LPPyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:54:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45665 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3LPPye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:54:34 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <marek.belisko@gmail.com>
CC: <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <hns@goldelico.com>
Subject: [PATCH v3 1/2] usb: musb: omap: remove using PLATFORM_DEVID_AUTO in omap2430.c
Date: Mon, 16 Dec 2013 21:23:44 +0530
Message-ID: <1387209225-11520-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387209225-11520-1-git-send-email-kishon@ti.com>
References: <1387209225-11520-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 2f7711 (usb: musb: remove hand-crafted id handling) used
PLATFORM_DEVID_AUTO while creating MUSB core device.
After the platform devices are created using PLATFORM_DEVID_AUTO, the
device names given in usb_bind_phy (in board file) does not match with
the actual device name causing the USB PHY library not to return the
PHY reference when the MUSB controller request for the PHY in the non-dt boot
case.
So removed creating platform devices using PLATFORM_DEVID_AUTO in omap2430.c.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/musb_core.c |   31 ++++++++++++++++++++++++++++++-
 drivers/usb/musb/musb_core.h |    2 ++
 drivers/usb/musb/omap2430.c  |   19 +++++++++++++++++--
 3 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 0a43329..aaf734c 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -94,6 +94,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/init.h>
+#include <linux/idr.h>
 #include <linux/list.h>
 #include <linux/kobject.h>
 #include <linux/prefetch.h>
@@ -120,7 +121,7 @@ MODULE_DESCRIPTION(DRIVER_INFO);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" MUSB_DRIVER_NAME);
-
+static DEFINE_IDA(musb_ida);
 
 /*-------------------------------------------------------------------------*/
 
@@ -131,6 +132,34 @@ static inline struct musb *dev_to_musb(struct device *dev)
 
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
+	dev_dbg(dev, "removing id %d\n", id);
+	ida_remove(&musb_ida, id);
+}
+EXPORT_SYMBOL_GPL(musb_put_id);
+
 #ifndef CONFIG_BLACKFIN
 static int musb_ulpi_read(struct usb_phy *phy, u32 offset)
 {
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index 29f7cd7..63614283 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -506,6 +506,8 @@ extern const char musb_driver_name[];
 
 extern void musb_stop(struct musb *musb);
 extern void musb_start(struct musb *musb);
+int musb_get_id(struct device *dev, gfp_t gfp_mask);
+void musb_put_id(struct device *dev, int id);
 
 extern void musb_write_fifo(struct musb_hw_ep *ep, u16 len, const u8 *src);
 extern void musb_read_fifo(struct musb_hw_ep *ep, u16 len, u8 *dst);
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 2a408cd..14a612c 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -45,6 +45,7 @@
 
 struct omap2430_glue {
 	struct device		*dev;
+	int			id;
 	struct platform_device	*musb;
 	enum omap_musb_vbus_id_status status;
 	struct work_struct	omap_musb_mailbox_work;
@@ -508,6 +509,7 @@ static int omap2430_probe(struct platform_device *pdev)
 	struct device_node		*np = pdev->dev.of_node;
 	struct musb_hdrc_config		*config;
 	int				ret = -ENOMEM;
+	int				musbid;
 
 	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
@@ -515,10 +517,18 @@ static int omap2430_probe(struct platform_device *pdev)
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
@@ -528,6 +538,7 @@ static int omap2430_probe(struct platform_device *pdev)
 	glue->dev			= &pdev->dev;
 	glue->musb			= musb;
 	glue->status			= OMAP_MUSB_UNKNOWN;
+	glue->id			= musbid;
 	glue->control_otghs = ERR_PTR(-ENODEV);
 
 	if (np) {
@@ -633,6 +644,9 @@ static int omap2430_probe(struct platform_device *pdev)
 err2:
 	platform_device_put(musb);
 
+err1:
+	musb_put_id(&pdev->dev, musbid);
+
 err0:
 	return ret;
 }
@@ -643,6 +657,7 @@ static int omap2430_remove(struct platform_device *pdev)
 
 	cancel_work_sync(&glue->omap_musb_mailbox_work);
 	platform_device_unregister(glue->musb);
+	musb_put_id(&pdev->dev, glue->id);
 
 	return 0;
 }
-- 
1.7.10.4

