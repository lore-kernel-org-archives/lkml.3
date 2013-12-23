Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab3LWWBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:01:21 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60685 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454Ab3LWV7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:59:00 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/27] drbd: drbd_csum_bio(), drbd_csum_ee(): Remove unused device argument
Date: Mon, 23 Dec 2013 22:50:39 +0100
Message-Id: <1387835456-29695-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    5 ++---
 drivers/block/drbd/drbd_main.c     |    6 +++---
 drivers/block/drbd/drbd_receiver.c |    4 ++--
 drivers/block/drbd/drbd_worker.c   |   13 ++++++-------
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c9eea4d..7ba1db8 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1315,9 +1315,8 @@ static inline void ov_out_of_sync_print(struct drbd_device *device)
 }
 
 
-extern void drbd_csum_bio(struct drbd_device *, struct crypto_hash *, struct bio *, void *);
-extern void drbd_csum_ee(struct drbd_device *, struct crypto_hash *,
-			 struct drbd_peer_request *, void *);
+extern void drbd_csum_bio(struct crypto_hash *, struct bio *, void *);
+extern void drbd_csum_ee(struct crypto_hash *, struct drbd_peer_request *, void *);
 /* worker callbacks */
 extern int w_e_end_data_req(struct drbd_work *, int);
 extern int w_e_end_rsdata_req(struct drbd_work *, int);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a7f992f..7df2de8 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1646,7 +1646,7 @@ int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
 	}
 	p->dp_flags = cpu_to_be32(dp_flags);
 	if (dgs)
-		drbd_csum_bio(device, first_peer_device(device)->connection->integrity_tfm, req->master_bio, p + 1);
+		drbd_csum_bio(first_peer_device(device)->connection->integrity_tfm, req->master_bio, p + 1);
 	err = __send_command(first_peer_device(device)->connection, device->vnr, sock, P_DATA, sizeof(*p) + dgs, NULL, req->i.size);
 	if (!err) {
 		/* For protocol A, we have to memcpy the payload into
@@ -1670,7 +1670,7 @@ int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
 			/* 64 byte, 512 bit, is the largest digest size
 			 * currently supported in kernel crypto. */
 			unsigned char digest[64];
-			drbd_csum_bio(device, first_peer_device(device)->connection->integrity_tfm, req->master_bio, digest);
+			drbd_csum_bio(first_peer_device(device)->connection->integrity_tfm, req->master_bio, digest);
 			if (memcmp(p + 1, digest, dgs)) {
 				drbd_warn(device,
 					"Digest mismatch, buffer modified by upper layers during write: %llus +%u\n",
@@ -1710,7 +1710,7 @@ int drbd_send_block(struct drbd_device *device, enum drbd_packet cmd,
 	p->seq_num = 0;  /* unused */
 	p->dp_flags = 0;
 	if (dgs)
-		drbd_csum_ee(device, first_peer_device(device)->connection->integrity_tfm, peer_req, p + 1);
+		drbd_csum_ee(first_peer_device(device)->connection->integrity_tfm, peer_req, p + 1);
 	err = __send_command(first_peer_device(device)->connection, device->vnr, sock, cmd, sizeof(*p) + dgs, NULL, peer_req->i.size);
 	if (!err)
 		err = _drbd_send_zc_ee(device, peer_req);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 9349113..cb37e23 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1560,7 +1560,7 @@ read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 	}
 
 	if (dgs) {
-		drbd_csum_ee(device, first_peer_device(device)->connection->peer_integrity_tfm, peer_req, dig_vv);
+		drbd_csum_ee(first_peer_device(device)->connection->peer_integrity_tfm, peer_req, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			drbd_err(device, "Digest integrity check FAILED: %llus +%u\n",
 				(unsigned long long)sector, data_size);
@@ -1637,7 +1637,7 @@ static int recv_dless_read(struct drbd_device *device, struct drbd_request *req,
 	}
 
 	if (dgs) {
-		drbd_csum_bio(device, first_peer_device(device)->connection->peer_integrity_tfm, bio, dig_vv);
+		drbd_csum_bio(first_peer_device(device)->connection->peer_integrity_tfm, bio, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			drbd_err(device, "Digest integrity check FAILED. Broken NICs?\n");
 			return -EINVAL;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 167c198..cf40a8a 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -282,8 +282,7 @@ void drbd_request_endio(struct bio *bio, int error)
 		complete_master_bio(device, &m);
 }
 
-void drbd_csum_ee(struct drbd_device *device, struct crypto_hash *tfm,
-		  struct drbd_peer_request *peer_req, void *digest)
+void drbd_csum_ee(struct crypto_hash *tfm, struct drbd_peer_request *peer_req, void *digest)
 {
 	struct hash_desc desc;
 	struct scatterlist sg;
@@ -310,7 +309,7 @@ void drbd_csum_ee(struct drbd_device *device, struct crypto_hash *tfm,
 	crypto_hash_final(&desc, digest);
 }
 
-void drbd_csum_bio(struct drbd_device *device, struct crypto_hash *tfm, struct bio *bio, void *digest)
+void drbd_csum_bio(struct crypto_hash *tfm, struct bio *bio, void *digest)
 {
 	struct hash_desc desc;
 	struct scatterlist sg;
@@ -350,7 +349,7 @@ static int w_e_send_csum(struct drbd_work *w, int cancel)
 	if (digest) {
 		sector_t sector = peer_req->i.sector;
 		unsigned int size = peer_req->i.size;
-		drbd_csum_ee(device, first_peer_device(device)->connection->csums_tfm, peer_req, digest);
+		drbd_csum_ee(first_peer_device(device)->connection->csums_tfm, peer_req, digest);
 		/* Free peer_req and pages before send.
 		 * In case we block on congestion, we could otherwise run into
 		 * some distributed deadlock, if the other side blocks on
@@ -1103,7 +1102,7 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 			digest = kmalloc(digest_size, GFP_NOIO);
 		}
 		if (digest) {
-			drbd_csum_ee(device, first_peer_device(device)->connection->csums_tfm, peer_req, digest);
+			drbd_csum_ee(first_peer_device(device)->connection->csums_tfm, peer_req, digest);
 			eq = !memcmp(digest, di->digest, digest_size);
 			kfree(digest);
 		}
@@ -1155,7 +1154,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	}
 
 	if (likely(!(peer_req->flags & EE_WAS_ERROR)))
-		drbd_csum_ee(device, first_peer_device(device)->connection->verify_tfm, peer_req, digest);
+		drbd_csum_ee(first_peer_device(device)->connection->verify_tfm, peer_req, digest);
 	else
 		memset(digest, 0, digest_size);
 
@@ -1221,7 +1220,7 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 		digest_size = crypto_hash_digestsize(first_peer_device(device)->connection->verify_tfm);
 		digest = kmalloc(digest_size, GFP_NOIO);
 		if (digest) {
-			drbd_csum_ee(device, first_peer_device(device)->connection->verify_tfm, peer_req, digest);
+			drbd_csum_ee(first_peer_device(device)->connection->verify_tfm, peer_req, digest);
 
 			D_ASSERT(device, digest_size == di->digest_size);
 			eq = !memcmp(digest, di->digest, digest_size);
-- 
1.7.9.5

