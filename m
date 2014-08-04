Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaHDNCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:02:49 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.102]:45560 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaHDNCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:02:47 -0400
From: Christoph Jaeger <email@christophjaeger.info>
To: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <email@christophjaeger.info>
Subject: [PATCH 08/10] staging: ozwpan: Use slab cache for oz_elt_info allocation
Date: Mon,  4 Aug 2014 14:54:54 +0200
Message-Id: <1407156896-3246-9-git-send-email-email@christophjaeger.info>
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
 drivers/staging/ozwpan/ozeltbuf.c | 70 +++------------------------------------
 drivers/staging/ozwpan/ozeltbuf.h |  5 ---
 drivers/staging/ozwpan/ozpd.c     |  2 --
 drivers/staging/ozwpan/ozpd.h     |  2 ++
 drivers/staging/ozwpan/ozproto.c  |  9 +++++
 drivers/staging/ozwpan/ozproto.h  |  2 ++
 6 files changed, 17 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/ozwpan/ozeltbuf.c b/drivers/staging/ozwpan/ozeltbuf.c
index f6e6481..81580cb 100644
--- a/drivers/staging/ozwpan/ozeltbuf.c
+++ b/drivers/staging/ozwpan/ozeltbuf.c
@@ -10,9 +10,6 @@
 #include "ozeltbuf.h"
 #include "ozpd.h"
 
-#define OZ_ELT_INFO_MAGIC_USED	0x35791057
-#define OZ_ELT_INFO_MAGIC_FREE	0x78940102
-
 /*
  * Context: softirq-serialized
  */
@@ -22,7 +19,6 @@ void oz_elt_buf_init(struct oz_elt_buf *buf)
 	INIT_LIST_HEAD(&buf->stream_list);
 	INIT_LIST_HEAD(&buf->order_list);
 	INIT_LIST_HEAD(&buf->isoc_list);
-	buf->max_free_elts = 32;
 	spin_lock_init(&buf->lock);
 }
 
@@ -49,14 +45,6 @@ void oz_elt_buf_term(struct oz_elt_buf *buf)
 			kfree(ei);
 		}
 	}
-	/* Free any elelment in the pool. */
-	while (buf->elt_pool) {
-		struct oz_elt_info *ei =
-			container_of(buf->elt_pool, struct oz_elt_info, link);
-		buf->elt_pool = buf->elt_pool->next;
-		kfree(ei);
-	}
-	buf->free_elts = 0;
 }
 
 /*
@@ -66,27 +54,8 @@ struct oz_elt_info *oz_elt_info_alloc(struct oz_elt_buf *buf)
 {
 	struct oz_elt_info *ei;
 
-	spin_lock_bh(&buf->lock);
-	if (buf->free_elts && buf->elt_pool) {
-		ei = container_of(buf->elt_pool, struct oz_elt_info, link);
-		buf->elt_pool = ei->link.next;
-		buf->free_elts--;
-		spin_unlock_bh(&buf->lock);
-		if (ei->magic != OZ_ELT_INFO_MAGIC_FREE) {
-			oz_dbg(ON, "%s: ei with bad magic: 0x%x\n",
-			       __func__, ei->magic);
-		}
-	} else {
-		spin_unlock_bh(&buf->lock);
-		ei = kmalloc(sizeof(struct oz_elt_info), GFP_ATOMIC);
-	}
-	if (ei) {
-		ei->flags = 0;
-		ei->app_id = 0;
-		ei->callback = NULL;
-		ei->context = 0;
-		ei->stream = NULL;
-		ei->magic = OZ_ELT_INFO_MAGIC_USED;
+	ei = kmem_cache_zalloc(oz_elt_info_cache, GFP_ATOMIC);
+	if (likely(ei)) {
 		INIT_LIST_HEAD(&ei->link);
 		INIT_LIST_HEAD(&ei->link_order);
 	}
@@ -99,17 +68,8 @@ struct oz_elt_info *oz_elt_info_alloc(struct oz_elt_buf *buf)
  */
 void oz_elt_info_free(struct oz_elt_buf *buf, struct oz_elt_info *ei)
 {
-	if (ei) {
-		if (ei->magic == OZ_ELT_INFO_MAGIC_USED) {
-			buf->free_elts++;
-			ei->link.next = buf->elt_pool;
-			buf->elt_pool = &ei->link;
-			ei->magic = OZ_ELT_INFO_MAGIC_FREE;
-		} else {
-			oz_dbg(ON, "%s: bad magic ei: %p magic: 0x%x\n",
-			       __func__, ei, ei->magic);
-		}
-	}
+	if (likely(ei))
+		kmem_cache_free(oz_elt_info_cache, ei);
 }
 
 /*------------------------------------------------------------------------------
@@ -313,25 +273,3 @@ int oz_are_elts_available(struct oz_elt_buf *buf)
 {
 	return buf->order_list.next != &buf->order_list;
 }
-
-void oz_trim_elt_pool(struct oz_elt_buf *buf)
-{
-	struct list_head *free = NULL;
-	struct list_head *e;
-
-	spin_lock_bh(&buf->lock);
-	while (buf->free_elts > buf->max_free_elts) {
-		e = buf->elt_pool;
-		buf->elt_pool = e->next;
-		e->next = free;
-		free = e;
-		buf->free_elts--;
-	}
-	spin_unlock_bh(&buf->lock);
-	while (free) {
-		struct oz_elt_info *ei =
-			container_of(free, struct oz_elt_info, link);
-		free = free->next;
-		kfree(ei);
-	}
-}
diff --git a/drivers/staging/ozwpan/ozeltbuf.h b/drivers/staging/ozwpan/ozeltbuf.h
index 3846432..f09f5fe 100644
--- a/drivers/staging/ozwpan/ozeltbuf.h
+++ b/drivers/staging/ozwpan/ozeltbuf.h
@@ -34,7 +34,6 @@ struct oz_elt_info {
 	struct oz_elt_stream *stream;
 	u8 data[sizeof(struct oz_elt) + OZ_MAX_ELT_PAYLOAD];
 	int length;
-	unsigned magic;
 };
 /* Flags values */
 #define OZ_EI_F_MARKED		0x1
@@ -44,9 +43,6 @@ struct oz_elt_buf {
 	struct list_head stream_list;
 	struct list_head order_list;
 	struct list_head isoc_list;
-	struct list_head *elt_pool;
-	int free_elts;
-	int max_free_elts;
 	u8 tx_seq_num[OZ_NB_APPS];
 };
 
@@ -64,7 +60,6 @@ int oz_queue_elt_info(struct oz_elt_buf *buf, u8 isoc, u8 id,
 int oz_select_elts_for_tx(struct oz_elt_buf *buf, u8 isoc, unsigned *len,
 		unsigned max_len, struct list_head *list);
 int oz_are_elts_available(struct oz_elt_buf *buf);
-void oz_trim_elt_pool(struct oz_elt_buf *buf);
 
 #endif /* _OZELTBUF_H */
 
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 6c4b13f..c6fddb8 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -504,8 +504,6 @@ static void oz_retire_frame(struct oz_pd *pd, struct oz_tx_frame *f)
 		spin_unlock_bh(&pd->elt_buff.lock);
 	}
 	oz_tx_frame_free(pd, f);
-	if (pd->elt_buff.free_elts > pd->elt_buff.max_free_elts)
-		oz_trim_elt_pool(&pd->elt_buff);
 }
 
 /*
diff --git a/drivers/staging/ozwpan/ozpd.h b/drivers/staging/ozwpan/ozpd.h
index 3b3b3ce..43a26ea 100644
--- a/drivers/staging/ozwpan/ozpd.h
+++ b/drivers/staging/ozwpan/ozpd.h
@@ -130,4 +130,6 @@ void oz_handle_app_elt(struct oz_pd *pd, u8 app_id, struct oz_elt *elt);
 void oz_apps_init(void);
 void oz_apps_term(void);
 
+extern struct kmem_cache *oz_elt_info_cache;
+
 #endif /* Sentry */
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 549fe7f..00d245b 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -11,6 +11,7 @@
 #include <linux/etherdevice.h>
 #include <linux/errno.h>
 #include <linux/ieee80211.h>
+#include <linux/slab.h>
 #include "ozdbg.h"
 #include "ozprotocol.h"
 #include "ozeltbuf.h"
@@ -51,6 +52,8 @@ static u8 g_session_id;
 static u16 g_apps = 0x1;
 static int g_processing_rx;
 
+struct kmem_cache *oz_elt_info_cache;
+
 /*
  * Context: softirq-serialized
  */
@@ -479,6 +482,8 @@ void oz_protocol_term(void)
 	}
 	spin_unlock_bh(&g_polling_lock);
 	oz_dbg(ON, "Protocol stopped\n");
+
+	kmem_cache_destroy(oz_elt_info_cache);
 }
 
 /*
@@ -762,6 +767,10 @@ static char *oz_get_next_device_name(char *s, char *dname, int max_size)
  */
 int oz_protocol_init(char *devs)
 {
+	oz_elt_info_cache = KMEM_CACHE(oz_elt_info, 0);
+	if (unlikely(!oz_elt_info_cache))
+		return -ENOMEM;
+
 	skb_queue_head_init(&g_rx_queue);
 	if (devs[0] == '*') {
 		oz_binding_add(NULL);
diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
index f1d30c4..b0f7459 100644
--- a/drivers/staging/ozwpan/ozproto.h
+++ b/drivers/staging/ozwpan/ozproto.h
@@ -65,4 +65,6 @@ enum hrtimer_restart oz_pd_timeout_event(struct hrtimer *timer);
 int oz_get_pd_status_list(char *pd_list, int max_count);
 int oz_get_binding_list(char *buf, int max_if);
 
+extern struct kmem_cache *oz_elt_info_cache;
+
 #endif /* _OZPROTO_H */
-- 
1.9.1

