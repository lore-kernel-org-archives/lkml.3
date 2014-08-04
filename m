Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaHDNCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:02:41 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.102]:40082 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaHDNCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:02:39 -0400
From: Christoph Jaeger <email@christophjaeger.info>
To: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <email@christophjaeger.info>
Subject: [PATCH 09/10] staging: ozwpan: Use slab cache for oz_tx_frame allocation
Date: Mon,  4 Aug 2014 14:54:55 +0200
Message-Id: <1407156896-3246-10-git-send-email-email@christophjaeger.info>
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
 drivers/staging/ozwpan/ozpd.c    | 43 +++++++---------------------------------
 drivers/staging/ozwpan/ozpd.h    |  3 +--
 drivers/staging/ozwpan/ozproto.c |  8 ++++++++
 drivers/staging/ozwpan/ozproto.h |  1 +
 4 files changed, 17 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index c6fddb8..8048ea3 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -21,8 +21,6 @@
 #include <linux/uaccess.h>
 #include <net/psnap.h>
 
-#define OZ_MAX_TX_POOL_SIZE	6
-
 static struct oz_tx_frame *oz_tx_frame_alloc(struct oz_pd *pd);
 static void oz_tx_frame_free(struct oz_pd *pd, struct oz_tx_frame *f);
 static void oz_tx_isoc_free(struct oz_pd *pd, struct oz_tx_frame *f);
@@ -177,13 +175,6 @@ static void oz_pd_free(struct work_struct *work)
 		e = e->next;
 		kfree(fwell);
 	}
-	/* Deallocate all frames in tx pool.
-	 */
-	while (pd->tx_pool) {
-		e = pd->tx_pool;
-		pd->tx_pool = e->next;
-		kfree(container_of(e, struct oz_tx_frame, link));
-	}
 	if (pd->net_dev)
 		dev_put(pd->net_dev);
 	kfree(pd);
@@ -333,18 +324,10 @@ int oz_pd_sleep(struct oz_pd *pd)
  */
 static struct oz_tx_frame *oz_tx_frame_alloc(struct oz_pd *pd)
 {
-	struct oz_tx_frame *f = NULL;
+	struct oz_tx_frame *f;
 
-	spin_lock_bh(&pd->tx_frame_lock);
-	if (pd->tx_pool) {
-		f = container_of(pd->tx_pool, struct oz_tx_frame, link);
-		pd->tx_pool = pd->tx_pool->next;
-		pd->tx_pool_count--;
-	}
-	spin_unlock_bh(&pd->tx_frame_lock);
-	if (f == NULL)
-		f = kmalloc(sizeof(struct oz_tx_frame), GFP_ATOMIC);
-	if (f) {
+	f = kmem_cache_alloc(oz_tx_frame_cache, GFP_ATOMIC);
+	if (likely(f)) {
 		f->total_size = sizeof(struct oz_hdr);
 		INIT_LIST_HEAD(&f->link);
 		INIT_LIST_HEAD(&f->elt_list);
@@ -359,13 +342,9 @@ static void oz_tx_isoc_free(struct oz_pd *pd, struct oz_tx_frame *f)
 {
 	pd->nb_queued_isoc_frames--;
 	list_del_init(&f->link);
-	if (pd->tx_pool_count < OZ_MAX_TX_POOL_SIZE) {
-		f->link.next = pd->tx_pool;
-		pd->tx_pool = &f->link;
-		pd->tx_pool_count++;
-	} else {
-		kfree(f);
-	}
+
+	kmem_cache_free(oz_tx_frame_cache, f);
+
 	oz_dbg(TX_FRAMES, "Releasing ISOC Frame isoc_nb= %d\n",
 	       pd->nb_queued_isoc_frames);
 }
@@ -375,15 +354,7 @@ static void oz_tx_isoc_free(struct oz_pd *pd, struct oz_tx_frame *f)
  */
 static void oz_tx_frame_free(struct oz_pd *pd, struct oz_tx_frame *f)
 {
-	spin_lock_bh(&pd->tx_frame_lock);
-	if (pd->tx_pool_count < OZ_MAX_TX_POOL_SIZE) {
-		f->link.next = pd->tx_pool;
-		pd->tx_pool = &f->link;
-		pd->tx_pool_count++;
-		f = NULL;
-	}
-	spin_unlock_bh(&pd->tx_frame_lock);
-	kfree(f);
+	kmem_cache_free(oz_tx_frame_cache, f);
 }
 
 /*
diff --git a/drivers/staging/ozwpan/ozpd.h b/drivers/staging/ozwpan/ozpd.h
index 43a26ea..212fab0 100644
--- a/drivers/staging/ozwpan/ozpd.h
+++ b/drivers/staging/ozwpan/ozpd.h
@@ -90,8 +90,6 @@ struct oz_pd {
 	unsigned	max_stream_buffering;
 	int		nb_queued_frames;
 	int		nb_queued_isoc_frames;
-	struct list_head *tx_pool;
-	int		tx_pool_count;
 	spinlock_t	tx_frame_lock;
 	struct list_head *last_sent_frame;
 	struct list_head tx_queue;
@@ -131,5 +129,6 @@ void oz_apps_init(void);
 void oz_apps_term(void);
 
 extern struct kmem_cache *oz_elt_info_cache;
+extern struct kmem_cache *oz_tx_frame_cache;
 
 #endif /* Sentry */
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 00d245b..c1fb442 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -53,6 +53,7 @@ static u16 g_apps = 0x1;
 static int g_processing_rx;
 
 struct kmem_cache *oz_elt_info_cache;
+struct kmem_cache *oz_tx_frame_cache;
 
 /*
  * Context: softirq-serialized
@@ -483,6 +484,7 @@ void oz_protocol_term(void)
 	spin_unlock_bh(&g_polling_lock);
 	oz_dbg(ON, "Protocol stopped\n");
 
+	kmem_cache_destroy(oz_tx_frame_cache);
 	kmem_cache_destroy(oz_elt_info_cache);
 }
 
@@ -771,6 +773,12 @@ int oz_protocol_init(char *devs)
 	if (unlikely(!oz_elt_info_cache))
 		return -ENOMEM;
 
+	oz_tx_frame_cache = KMEM_CACHE(oz_tx_frame, 0);
+	if (unlikely(!oz_tx_frame_cache)) {
+		kmem_cache_destroy(oz_elt_info_cache);
+		return -ENOMEM;
+	}
+
 	skb_queue_head_init(&g_rx_queue);
 	if (devs[0] == '*') {
 		oz_binding_add(NULL);
diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
index b0f7459..73cc69b 100644
--- a/drivers/staging/ozwpan/ozproto.h
+++ b/drivers/staging/ozwpan/ozproto.h
@@ -66,5 +66,6 @@ int oz_get_pd_status_list(char *pd_list, int max_count);
 int oz_get_binding_list(char *buf, int max_if);
 
 extern struct kmem_cache *oz_elt_info_cache;
+extern struct kmem_cache *oz_tx_frame_cache;
 
 #endif /* _OZPROTO_H */
-- 
1.9.1

