Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaDNUPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:15:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:28677 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183AbaDNUPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:15:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,859,1389772800"; 
   d="scan'208";a="520341998"
From: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [PATCH 6/8] misc: mic: add threaded irq support in card driver
Date: Mon, 14 Apr 2014 13:15:03 -0700
Message-Id: <973118e079189e9ba166b6d6be025646b4af1f1a.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
References: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
In-Reply-To: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
References: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add threaded irq support in mic_request_card_irq which will be used
for virtual devices added on mic bus.

Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
---
 drivers/misc/mic/card/mic_device.c | 21 +++++++++++----------
 drivers/misc/mic/card/mic_device.h |  5 +++--
 drivers/misc/mic/card/mic_virtio.c |  4 ++--
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/mic/card/mic_device.c b/drivers/misc/mic/card/mic_device.c
index d0980ff..ff485b7 100644
--- a/drivers/misc/mic/card/mic_device.c
+++ b/drivers/misc/mic/card/mic_device.c
@@ -83,8 +83,8 @@ static int mic_shutdown_init(void)
 	int shutdown_db;
 
 	shutdown_db = mic_next_card_db();
-	shutdown_cookie = mic_request_card_irq(mic_shutdown_isr,
-			"Shutdown", mdrv, shutdown_db);
+	shutdown_cookie = mic_request_card_irq(mic_shutdown_isr, NULL,
+					       "Shutdown", mdrv, shutdown_db);
 	if (IS_ERR(shutdown_cookie))
 		rc = PTR_ERR(shutdown_cookie);
 	else
@@ -136,7 +136,8 @@ static void mic_dp_uninit(void)
 /**
  * mic_request_card_irq - request an irq.
  *
- * @func: The callback function that handles the interrupt.
+ * @handler: interrupt handler passed to request_threaded_irq.
+ * @thread_fn: thread fn. passed to request_threaded_irq.
  * @name: The ASCII name of the callee requesting the irq.
  * @data: private data that is returned back when calling the
  * function handler.
@@ -149,17 +150,17 @@ static void mic_dp_uninit(void)
  * error code.
  *
  */
-struct mic_irq *mic_request_card_irq(irqreturn_t (*func)(int irq, void *data),
-	const char *name, void *data, int index)
+struct mic_irq *mic_request_card_irq(irq_handler_t handler,
+	irq_handler_t thread_fn, const char *name, void *data, int index)
 {
 	int rc = 0;
 	unsigned long cookie;
 	struct mic_driver *mdrv = g_drv;
 
-	rc  = request_irq(mic_db_to_irq(mdrv, index), func,
-		0, name, data);
+	rc  = request_threaded_irq(mic_db_to_irq(mdrv, index), handler,
+				   thread_fn, 0, name, data);
 	if (rc) {
-		dev_err(mdrv->dev, "request_irq failed rc = %d\n", rc);
+		dev_err(mdrv->dev, "request_threaded_irq failed rc = %d\n", rc);
 		goto err;
 	}
 	mdrv->irq_info.irq_usage_count[index]++;
@@ -172,9 +173,9 @@ err:
 /**
  * mic_free_card_irq - free irq.
  *
- * @cookie: cookie obtained during a successful call to mic_request_irq
+ * @cookie: cookie obtained during a successful call to mic_request_threaded_irq
  * @data: private data specified by the calling function during the
- * mic_request_irq
+ * mic_request_threaded_irq
  *
  * returns: none.
  */
diff --git a/drivers/misc/mic/card/mic_device.h b/drivers/misc/mic/card/mic_device.h
index 306f502..e12a0c2 100644
--- a/drivers/misc/mic/card/mic_device.h
+++ b/drivers/misc/mic/card/mic_device.h
@@ -30,6 +30,7 @@
 #include <linux/workqueue.h>
 #include <linux/io.h>
 #include <linux/irqreturn.h>
+#include <linux/interrupt.h>
 
 /**
  * struct mic_intr_info - Contains h/w specific interrupt sources info
@@ -116,8 +117,8 @@ mic_mmio_write(struct mic_mw *mw, u32 val, u32 offset)
 int mic_driver_init(struct mic_driver *mdrv);
 void mic_driver_uninit(struct mic_driver *mdrv);
 int mic_next_card_db(void);
-struct mic_irq *mic_request_card_irq(irqreturn_t (*func)(int irq, void *data),
-	const char *name, void *data, int intr_src);
+struct mic_irq *mic_request_card_irq(irq_handler_t handler,
+	irq_handler_t thread_fn, const char *name, void *data, int intr_src);
 void mic_free_card_irq(struct mic_irq *cookie, void *data);
 u32 mic_read_spad(struct mic_device *mdev, unsigned int idx);
 void mic_send_intr(struct mic_device *mdev, int doorbell);
diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index 653799b..8cdbc68 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -417,7 +417,7 @@ static int mic_add_device(struct mic_device_desc __iomem *d,
 
 	virtio_db = mic_next_card_db();
 	mvdev->virtio_cookie = mic_request_card_irq(mic_virtio_intr_handler,
-			"virtio intr", mvdev, virtio_db);
+			NULL, "virtio intr", mvdev, virtio_db);
 	if (IS_ERR(mvdev->virtio_cookie)) {
 		ret = PTR_ERR(mvdev->virtio_cookie);
 		goto kfree;
@@ -606,7 +606,7 @@ int mic_devices_init(struct mic_driver *mdrv)
 	mic_scan_devices(mdrv, !REMOVE_DEVICES);
 
 	config_db = mic_next_card_db();
-	virtio_config_cookie = mic_request_card_irq(mic_extint_handler,
+	virtio_config_cookie = mic_request_card_irq(mic_extint_handler, NULL,
 			"virtio_config_intr", mdrv, config_db);
 	if (IS_ERR(virtio_config_cookie)) {
 		rc = PTR_ERR(virtio_config_cookie);
-- 
1.8.2.2

