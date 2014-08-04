Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaHDNCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:02:38 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.95]:50971 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaHDNCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:02:36 -0400
From: Christoph Jaeger <email@christophjaeger.info>
To: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <email@christophjaeger.info>
Subject: [PATCH 07/10] staging: ozwpan: Use slab cache for oz_urb_link allocation
Date: Mon,  4 Aug 2014 14:54:53 +0200
Message-Id: <1407156896-3246-8-git-send-email-email@christophjaeger.info>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
References: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a slab cache rather than rolling our own free list.

Signed-off-by: Christoph Jaeger <email@christophjaeger.info>
---
 drivers/staging/ozwpan/ozhcd.c | 70 ++++++++----------------------------------
 1 file changed, 12 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 30bd928..3b603c5 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -45,10 +45,6 @@
  */
 #define OZ_PLAT_DEV_NAME	"ozwpan"
 
-/* Maximum number of free urb links that can be kept in the pool.
- */
-#define OZ_MAX_LINK_POOL_SIZE	16
-
 /* Get endpoint object from the containing link.
  */
 #define ep_from_link(__e) container_of((__e), struct oz_endpoint, link)
@@ -75,6 +71,8 @@ struct oz_urb_link {
 	unsigned submit_counter;
 };
 
+static struct kmem_cache *oz_urb_link_cache;
+
 /* Holds state information about a USB endpoint.
  */
 #define OZ_EP_BUFFER_SIZE_ISOC  (1024 * 24)
@@ -198,9 +196,6 @@ static struct platform_device *g_plat_dev;
 static struct oz_hcd *g_ozhcd;
 static DEFINE_SPINLOCK(g_hcdlock);	/* Guards g_ozhcd. */
 static const char g_hcd_name[] = "Ozmo WPAN";
-static struct list_head *g_link_pool;
-static int g_link_pool_size;
-static DEFINE_SPINLOCK(g_link_lock);
 static DEFINE_SPINLOCK(g_tasklet_lock);
 static struct tasklet_struct g_urb_process_tasklet;
 static struct tasklet_struct g_urb_cancel_tasklet;
@@ -265,68 +260,22 @@ static int oz_get_port_from_addr(struct oz_hcd *ozhcd, u8 bus_addr)
 }
 
 /*
- * Allocates an urb link, first trying the pool but going to heap if empty.
  * Context: any
  */
 static struct oz_urb_link *oz_alloc_urb_link(void)
 {
-	struct oz_urb_link *urbl = NULL;
-	unsigned long irq_state;
-
-	spin_lock_irqsave(&g_link_lock, irq_state);
-	if (g_link_pool) {
-		urbl = container_of(g_link_pool, struct oz_urb_link, link);
-		g_link_pool = urbl->link.next;
-		--g_link_pool_size;
-	}
-	spin_unlock_irqrestore(&g_link_lock, irq_state);
-	if (urbl == NULL)
-		urbl = kmalloc(sizeof(struct oz_urb_link), GFP_ATOMIC);
-	return urbl;
+	return kmem_cache_alloc(oz_urb_link_cache, GFP_ATOMIC);
 }
 
 /*
- * Frees an urb link by putting it in the pool if there is enough space or
- * deallocating it to heap otherwise.
  * Context: any
  */
 static void oz_free_urb_link(struct oz_urb_link *urbl)
 {
-	if (urbl) {
-		unsigned long irq_state;
-
-		spin_lock_irqsave(&g_link_lock, irq_state);
-		if (g_link_pool_size < OZ_MAX_LINK_POOL_SIZE) {
-			urbl->link.next = g_link_pool;
-			g_link_pool = &urbl->link;
-			urbl = NULL;
-			g_link_pool_size++;
-		}
-		spin_unlock_irqrestore(&g_link_lock, irq_state);
-		kfree(urbl);
-	}
-}
-
-/*
- * Deallocates all the urb links in the pool.
- * Context: unknown
- */
-static void oz_empty_link_pool(void)
-{
-	struct list_head *e;
-	unsigned long irq_state;
+	if (unlikely(!urbl))
+		return;
 
-	spin_lock_irqsave(&g_link_lock, irq_state);
-	e = g_link_pool;
-	g_link_pool = NULL;
-	g_link_pool_size = 0;
-	spin_unlock_irqrestore(&g_link_lock, irq_state);
-	while (e) {
-		struct oz_urb_link *urbl =
-			container_of(e, struct oz_urb_link, link);
-		e = e->next;
-		kfree(urbl);
-	}
+	kmem_cache_free(oz_urb_link_cache, urbl);
 }
 
 /*
@@ -2311,7 +2260,6 @@ static int oz_plat_remove(struct platform_device *dev)
 	oz_dbg(ON, "Removing hcd\n");
 	usb_remove_hcd(hcd);
 	usb_put_hcd(hcd);
-	oz_empty_link_pool();
 	return 0;
 }
 
@@ -2341,6 +2289,11 @@ int oz_hcd_init(void)
 
 	if (usb_disabled())
 		return -ENODEV;
+
+	oz_urb_link_cache = KMEM_CACHE(oz_urb_link, 0);
+	if (unlikely(!oz_urb_link_cache))
+		return -ENOMEM;
+
 	tasklet_init(&g_urb_process_tasklet, oz_urb_process_tasklet, 0);
 	tasklet_init(&g_urb_cancel_tasklet, oz_urb_cancel_tasklet, 0);
 	err = platform_driver_register(&g_oz_plat_drv);
@@ -2380,4 +2333,5 @@ void oz_hcd_term(void)
 	platform_device_unregister(g_plat_dev);
 	platform_driver_unregister(&g_oz_plat_drv);
 	oz_dbg(ON, "Pending urbs:%d\n", atomic_read(&g_pending_urbs));
+	kmem_cache_destroy(oz_urb_link_cache);
 }
-- 
1.9.1

