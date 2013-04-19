Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968108Ab3DSJnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:43:15 -0400
Received: from smtp-out-134.synserver.de ([212.40.185.134]:1143 "EHLO
	smtp-out-130.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758414Ab3DSJnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:43:12 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7393
From: Lars-Peter Clausen <lars@metafoo.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/2] dma:of: Use a mutex to protect the of_dma_list
Date: Fri, 19 Apr 2013 11:42:14 +0200
Message-Id: <1366364534-3298-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1366364534-3298-1-git-send-email-lars@metafoo.de>
References: <1366364534-3298-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the OF DMA code uses a spin lock to protect the of_dma_list from
concurrent access and a per controller reference count to protect the controller
from being freed while a request operation is in progress. If
of_dma_controller_free() is called for a controller who's reference count is not
zero it will return -EBUSY and not remove the controller. This is fine up until
here, but leaves the question what the caller of of_dma_controller_free() is
supposed to do if the controller couldn't be freed.  The only viable solution
for the caller is to spin on of_dma_controller_free() until it returns success.
E.g.

	do {
		ret = of_dma_controller_free(dev->of_node)
	} while (ret != -EBUSY);

This is rather ugly and unnecessary and non of the current users of
of_dma_controller_free() check it's return value anyway. Instead protect the
list by a mutex. The mutex will be held as long as a request operation is in
progress. So if of_dma_controller_free() is called while a request operation is
in progress it will be put to sleep and only wake up once the request operation
has finished.

This means that it is no longer possible to register or unregister OF DMA
controllers from a context where it's not possible to sleep. But I doubt that
we'll ever need this.

Also rename of_dma_get_controller back to of_dma_find_controller.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/dma/of-dma.c   | 76 +++++++++++++-------------------------------------
 include/linux/of_dma.h |  6 ++--
 2 files changed, 22 insertions(+), 60 deletions(-)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 2882403..7aa0864 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -13,38 +13,31 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/module.h>
-#include <linux/rculist.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_dma.h>
 
 static LIST_HEAD(of_dma_list);
-static DEFINE_SPINLOCK(of_dma_lock);
+static DEFINE_MUTEX(of_dma_lock);
 
 /**
- * of_dma_get_controller - Get a DMA controller in DT DMA helpers list
+ * of_dma_find_controller - Get a DMA controller in DT DMA helpers list
  * @dma_spec:	pointer to DMA specifier as found in the device tree
  *
  * Finds a DMA controller with matching device node and number for dma cells
- * in a list of registered DMA controllers. If a match is found the use_count
- * variable is increased and a valid pointer to the DMA data stored is retuned.
- * A NULL pointer is returned if no match is found.
+ * in a list of registered DMA controllers. If a match is found a valid pointer
+ * to the DMA data stored is retuned. A NULL pointer is returned if no match is
+ * found.
  */
-static struct of_dma *of_dma_get_controller(struct of_phandle_args *dma_spec)
+static struct of_dma *of_dma_find_controller(struct of_phandle_args *dma_spec)
 {
 	struct of_dma *ofdma;
 
-	spin_lock(&of_dma_lock);
-
 	list_for_each_entry(ofdma, &of_dma_list, of_dma_controllers)
 		if ((ofdma->of_node == dma_spec->np) &&
-		    (ofdma->of_dma_nbcells == dma_spec->args_count)) {
-			ofdma->use_count++;
-			spin_unlock(&of_dma_lock);
+		    (ofdma->of_dma_nbcells == dma_spec->args_count))
 			return ofdma;
-		}
-
-	spin_unlock(&of_dma_lock);
 
 	pr_debug("%s: can't find DMA controller %s\n", __func__,
 		 dma_spec->np->full_name);
@@ -53,22 +46,6 @@ static struct of_dma *of_dma_get_controller(struct of_phandle_args *dma_spec)
 }
 
 /**
- * of_dma_put_controller - Decrement use count for a registered DMA controller
- * @of_dma:	pointer to DMA controller data
- *
- * Decrements the use_count variable in the DMA data structure. This function
- * should be called only when a valid pointer is returned from
- * of_dma_get_controller() and no further accesses to data referenced by that
- * pointer are needed.
- */
-static void of_dma_put_controller(struct of_dma *ofdma)
-{
-	spin_lock(&of_dma_lock);
-	ofdma->use_count--;
-	spin_unlock(&of_dma_lock);
-}
-
-/**
  * of_dma_controller_register - Register a DMA controller to DT DMA helpers
  * @np:			device node of DMA controller
  * @of_dma_xlate:	translation function which converts a phandle
@@ -114,12 +91,11 @@ int of_dma_controller_register(struct device_node *np,
 	ofdma->of_dma_nbcells = nbcells;
 	ofdma->of_dma_xlate = of_dma_xlate;
 	ofdma->of_dma_data = data;
-	ofdma->use_count = 0;
 
 	/* Now queue of_dma controller structure in list */
-	spin_lock(&of_dma_lock);
+	mutex_lock(&of_dma_lock);
 	list_add_tail(&ofdma->of_dma_controllers, &of_dma_list);
-	spin_unlock(&of_dma_lock);
+	mutex_unlock(&of_dma_lock);
 
 	return 0;
 }
@@ -131,32 +107,20 @@ EXPORT_SYMBOL_GPL(of_dma_controller_register);
  *
  * Memory allocated by of_dma_controller_register() is freed here.
  */
-int of_dma_controller_free(struct device_node *np)
+void of_dma_controller_free(struct device_node *np)
 {
 	struct of_dma *ofdma;
 
-	spin_lock(&of_dma_lock);
-
-	if (list_empty(&of_dma_list)) {
-		spin_unlock(&of_dma_lock);
-		return -ENODEV;
-	}
+	mutex_lock(&of_dma_lock);
 
 	list_for_each_entry(ofdma, &of_dma_list, of_dma_controllers)
 		if (ofdma->of_node == np) {
-			if (ofdma->use_count) {
-				spin_unlock(&of_dma_lock);
-				return -EBUSY;
-			}
-
 			list_del(&ofdma->of_dma_controllers);
-			spin_unlock(&of_dma_lock);
 			kfree(ofdma);
-			return 0;
+			break;
 		}
 
-	spin_unlock(&of_dma_lock);
-	return -ENODEV;
+	mutex_unlock(&of_dma_lock);
 }
 EXPORT_SYMBOL_GPL(of_dma_controller_free);
 
@@ -219,15 +183,15 @@ struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
 		if (of_dma_match_channel(np, name, i, &dma_spec))
 			continue;
 
-		ofdma = of_dma_get_controller(&dma_spec);
+		mutex_lock(&of_dma_lock);
+		ofdma = of_dma_find_controller(&dma_spec);
 
-		if (ofdma) {
+		if (ofdma)
 			chan = ofdma->of_dma_xlate(&dma_spec, ofdma);
-
-			of_dma_put_controller(ofdma);
-		} else {
+		else
 			chan = NULL;
-		}
+
+		mutex_unlock(&of_dma_lock);
 
 		of_node_put(dma_spec.np);
 
diff --git a/include/linux/of_dma.h b/include/linux/of_dma.h
index ce6a8ab..364dda7 100644
--- a/include/linux/of_dma.h
+++ b/include/linux/of_dma.h
@@ -25,7 +25,6 @@ struct of_dma {
 	struct dma_chan		*(*of_dma_xlate)
 				(struct of_phandle_args *, struct of_dma *);
 	void			*of_dma_data;
-	int			use_count;
 };
 
 struct of_dma_filter_info {
@@ -38,7 +37,7 @@ extern int of_dma_controller_register(struct device_node *np,
 		struct dma_chan *(*of_dma_xlate)
 		(struct of_phandle_args *, struct of_dma *),
 		void *data);
-extern int of_dma_controller_free(struct device_node *np);
+extern void of_dma_controller_free(struct device_node *np);
 extern struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
 						     const char *name);
 extern struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
@@ -52,9 +51,8 @@ static inline int of_dma_controller_register(struct device_node *np,
 	return -ENODEV;
 }
 
-static inline int of_dma_controller_free(struct device_node *np)
+static inline void of_dma_controller_free(struct device_node *np)
 {
-	return -ENODEV;
 }
 
 static inline struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
-- 
1.8.0

