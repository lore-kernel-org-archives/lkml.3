Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3JIFcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 01:32:33 -0400
Received: from smtprelay0133.hostedemail.com ([216.40.44.133]:39570 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751461Ab3JIFca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 01:32:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:800:960:966:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1431:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:2899:3138:3139:3140:3141:3142:3622:3865:3867:3868:3871:4321:4385:4605:5007:6119:6120:6691:7652:7875:7903:7904:8603:10004:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gun10_6cee43160aa27
X-Filterd-Recvd-Size: 5617
Message-ID: <1381296747.2040.17.camel@joe-AO722>
Subject: [RFC PATCH] device: Add kernel standard devm_k.alloc functions
From: Joe Perches <joe@perches.com>
To: Tejun Heo <tj@kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Sangjung Woo <sangjung.woo@samsung.com>
Date: Tue, 08 Oct 2013 22:32:27 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, devm_ managed memory only supports kzalloc.

Convert the devm_kzalloc implementation to devm_kmalloc
and remove the complete memset to 0 but still set the
initial struct devres header and whatever padding before
data to 0.

Add the other normal alloc variants as static inlines with
__GFP_ZERO added to the gfp flag where appropriate:

	devm_kzalloc
	devm_kcalloc
	devm_kmalloc_array

Add gfp.h to device.h for the newly added static inlines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/base/devres.c  | 27 ++++++++++++++++-----------
 include/linux/device.h | 21 +++++++++++++++++++--
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 507379e..37e67a2 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -91,7 +91,8 @@ static __always_inline struct devres * alloc_dr(dr_release_t release,
 	if (unlikely(!dr))
 		return NULL;
 
-	memset(dr, 0, tot_size);
+	memset(dr, 0, offsetof(struct devres, data));
+
 	INIT_LIST_HEAD(&dr->node.entry);
 	dr->node.release = release;
 	return dr;
@@ -745,58 +746,62 @@ void devm_remove_action(struct device *dev, void (*action)(void *), void *data)
 EXPORT_SYMBOL_GPL(devm_remove_action);
 
 /*
- * Managed kzalloc/kfree
+ * Managed kmalloc/kfree
  */
-static void devm_kzalloc_release(struct device *dev, void *res)
+static void devm_kmalloc_release(struct device *dev, void *res)
 {
 	/* noop */
 }
 
-static int devm_kzalloc_match(struct device *dev, void *res, void *data)
+static int devm_kmalloc_match(struct device *dev, void *res, void *data)
 {
 	return res == data;
 }
 
 /**
- * devm_kzalloc - Resource-managed kzalloc
+ * devm_kmalloc - Resource-managed kmalloc
  * @dev: Device to allocate memory for
  * @size: Allocation size
  * @gfp: Allocation gfp flags
  *
- * Managed kzalloc.  Memory allocated with this function is
+ * Managed kmalloc.  Memory allocated with this function is
  * automatically freed on driver detach.  Like all other devres
  * resources, guaranteed alignment is unsigned long long.
  *
  * RETURNS:
  * Pointer to allocated memory on success, NULL on failure.
  */
-void * devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
+void * devm_kmalloc(struct device *dev, size_t size, gfp_t gfp)
 {
 	struct devres *dr;
 
 	/* use raw alloc_dr for kmalloc caller tracing */
-	dr = alloc_dr(devm_kzalloc_release, size, gfp);
+	dr = alloc_dr(devm_kmalloc_release, size, gfp);
 	if (unlikely(!dr))
 		return NULL;
 
+	/*
+	 * This is named devm_kzalloc_release for historical reasons
+	 * The initial implementation did not support kmalloc, only kzalloc
+	 */
 	set_node_dbginfo(&dr->node, "devm_kzalloc_release", size);
 	devres_add(dev, dr->data);
 	return dr->data;
 }
-EXPORT_SYMBOL_GPL(devm_kzalloc);
+EXPORT_SYMBOL_GPL(devm_kmalloc);
 
 /**
  * devm_kfree - Resource-managed kfree
  * @dev: Device this memory belongs to
  * @p: Memory to free
  *
- * Free memory allocated with devm_kzalloc().
+ * Free memory allocated with devm_kmalloc().
  */
 void devm_kfree(struct device *dev, void *p)
 {
 	int rc;
 
-	rc = devres_destroy(dev, devm_kzalloc_release, devm_kzalloc_match, p);
+	rc = devres_destroy(dev, devm_kmalloc_release, devm_kmalloc_match, p);
 	WARN_ON(rc);
 }
 EXPORT_SYMBOL_GPL(devm_kfree);
diff --git a/include/linux/device.h b/include/linux/device.h
index ce690ea..46540f8 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -26,6 +26,7 @@
 #include <linux/atomic.h>
 #include <linux/ratelimit.h>
 #include <linux/uidgid.h>
+#include <linux/gfp.h>
 #include <asm/device.h>
 
 struct device;
@@ -614,8 +615,24 @@ extern void devres_close_group(struct device *dev, void *id);
 extern void devres_remove_group(struct device *dev, void *id);
 extern int devres_release_group(struct device *dev, void *id);
 
-/* managed kzalloc/kfree for device drivers, no kmalloc, always use kzalloc */
-extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
+/* managed devm_k.alloc/kfree for device drivers */
+extern void *devm_kmalloc(struct device *dev, size_t size, gfp_t gfp);
+static inline void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
+{
+	return devm_kmalloc(dev, size, gfp | __GFP_ZERO);
+}
+static inline void *devm_kmalloc_array(struct device *dev,
+				       size_t n, size_t size, gfp_t flags)
+{
+	if (size != 0 && n > SIZE_MAX / size)
+		return NULL;
+	return devm_kmalloc(dev, n * size, flags);
+}
+static inline void *devm_kcalloc(struct device *dev,
+				 size_t n, size_t size, gfp_t flags)
+{
+	return devm_kmalloc_array(dev, n, size, flags | __GFP_ZERO);
+}
 extern void devm_kfree(struct device *dev, void *p);
 
 void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);


