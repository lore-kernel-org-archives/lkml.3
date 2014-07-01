Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbaGAQQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:16:59 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53063 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453AbaGAQQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/20] drbd: silence -Wmissing-prototypes warnings
Date: Tue,  1 Jul 2014 18:16:32 +0200
Message-Id: <1404231410-29852-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c     | 2 +-
 drivers/block/drbd/drbd_nl.c       | 2 +-
 drivers/block/drbd/drbd_receiver.c | 3 +--
 drivers/block/drbd/drbd_req.h      | 1 +
 drivers/block/drbd/drbd_state.c    | 6 +++---
 lib/lru_cache.c                    | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index ed35d52..68ec774 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2877,7 +2877,7 @@ void drbd_delete_device(struct drbd_device *device)
 	kref_sub(&device->kref, refs, drbd_destroy_device);
 }
 
-int __init drbd_init(void)
+static int __init drbd_init(void)
 {
 	int err;
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 628167d..81949d6 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2913,7 +2913,7 @@ static struct drbd_connection *the_only_connection(struct drbd_resource *resourc
 	return list_first_entry(&resource->connections, struct drbd_connection, connections);
 }
 
-int nla_put_status_info(struct sk_buff *skb, struct drbd_device *device,
+static int nla_put_status_info(struct sk_buff *skb, struct drbd_device *device,
 		const struct sib_info *sib)
 {
 	struct drbd_resource *resource = device->resource;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index cfc3d43..2fcc3af 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3371,8 +3371,7 @@ disconnect:
  * return: NULL (alg name was "")
  *         ERR_PTR(error) if something goes wrong
  *         or the crypto hash ptr, if it worked out ok. */
-static
-struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_device *device,
+static struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_device *device,
 		const char *alg, const char *name)
 {
 	struct crypto_hash *tfm;
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 8566cd5..9f6a040 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -288,6 +288,7 @@ extern void complete_master_bio(struct drbd_device *device,
 extern void request_timer_fn(unsigned long data);
 extern void tl_restart(struct drbd_connection *connection, enum drbd_req_event what);
 extern void _tl_restart(struct drbd_connection *connection, enum drbd_req_event what);
+extern void tl_abort_disk_io(struct drbd_device *device);
 
 /* this is in drbd_main.c */
 extern void drbd_restart_request(struct drbd_request *req);
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 6629f46..a7772e2 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -410,7 +410,7 @@ _drbd_request_state(struct drbd_device *device, union drbd_state mask,
 	return rv;
 }
 
-static void print_st(struct drbd_device *device, char *name, union drbd_state ns)
+static void print_st(struct drbd_device *device, const char *name, union drbd_state ns)
 {
 	drbd_err(device, " %s = { cs:%s ro:%s/%s ds:%s/%s %c%c%c%c%c%c }\n",
 	    name,
@@ -1606,7 +1606,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 	return 0;
 }
 
-void conn_old_common_state(struct drbd_connection *connection, union drbd_state *pcs, enum chg_state_flags *pf)
+static void conn_old_common_state(struct drbd_connection *connection, union drbd_state *pcs, enum chg_state_flags *pf)
 {
 	enum chg_state_flags flags = ~0;
 	struct drbd_peer_device *peer_device;
@@ -1695,7 +1695,7 @@ conn_is_valid_transition(struct drbd_connection *connection, union drbd_state ma
 	return rv;
 }
 
-void
+static void
 conn_set_state(struct drbd_connection *connection, union drbd_state mask, union drbd_state val,
 	       union drbd_state *pns_min, union drbd_state *pns_max, enum chg_state_flags flags)
 {
diff --git a/lib/lru_cache.c b/lib/lru_cache.c
index 4a83ecd..6111cd1 100644
--- a/lib/lru_cache.c
+++ b/lib/lru_cache.c
@@ -169,7 +169,7 @@ out_fail:
 	return NULL;
 }
 
-void lc_free_by_index(struct lru_cache *lc, unsigned i)
+static void lc_free_by_index(struct lru_cache *lc, unsigned i)
 {
 	void *p = lc->lc_element[i];
 	WARN_ON(!p);
-- 
1.9.1

