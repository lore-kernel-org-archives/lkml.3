Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbaIKMdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:33:50 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:47774 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbaIKM3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:29:17 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 1/9] drbd: Use better variable names
Date: Thu, 11 Sep 2014 14:29:05 +0200
Message-Id: <1410438553-30440-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
References: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Rename local variable 'ds' to 'disk_state' or 'data_size'.
'dgs' to 'digest_size'

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |  6 ++---
 drivers/block/drbd/drbd_main.c     | 28 +++++++++++------------
 drivers/block/drbd/drbd_receiver.c | 46 +++++++++++++++++++-------------------
 drivers/block/drbd/drbd_state.c    | 18 +++++++--------
 4 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 1a00001..9e1288e 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -2109,7 +2109,7 @@ static inline bool is_sync_state(enum drbd_conns connection_state)
 
 static inline void put_ldev(struct drbd_device *device)
 {
-	enum drbd_disk_state ds = device->state.disk;
+	enum drbd_disk_state disk_state = device->state.disk;
 	/* We must check the state *before* the atomic_dec becomes visible,
 	 * or we have a theoretical race where someone hitting zero,
 	 * while state still D_FAILED, will then see D_DISKLESS in the
@@ -2122,10 +2122,10 @@ static inline void put_ldev(struct drbd_device *device)
 	__release(local);
 	D_ASSERT(device, i >= 0);
 	if (i == 0) {
-		if (ds == D_DISKLESS)
+		if (disk_state == D_DISKLESS)
 			/* even internal references gone, safe to destroy */
 			drbd_device_post_work(device, DESTROY_DISK);
-		if (ds == D_FAILED)
+		if (disk_state == D_FAILED)
 			/* all application IO references gone. */
 			if (!test_and_set_bit(GOING_DISKLESS, &device->flags))
 				drbd_device_post_work(device, GO_DISKLESS);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9b465bb..973c185 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1622,13 +1622,13 @@ int drbd_send_dblock(struct drbd_peer_device *peer_device, struct drbd_request *
 	struct drbd_socket *sock;
 	struct p_data *p;
 	unsigned int dp_flags = 0;
-	int dgs;
+	int digest_size;
 	int err;
 
 	sock = &peer_device->connection->data;
 	p = drbd_prepare_command(peer_device, sock);
-	dgs = peer_device->connection->integrity_tfm ?
-	      crypto_hash_digestsize(peer_device->connection->integrity_tfm) : 0;
+	digest_size = peer_device->connection->integrity_tfm ?
+		      crypto_hash_digestsize(peer_device->connection->integrity_tfm) : 0;
 
 	if (!p)
 		return -EIO;
@@ -1659,9 +1659,9 @@ int drbd_send_dblock(struct drbd_peer_device *peer_device, struct drbd_request *
 
 	/* our digest is still only over the payload.
 	 * TRIM does not carry any payload. */
-	if (dgs)
+	if (digest_size)
 		drbd_csum_bio(peer_device->connection->integrity_tfm, req->master_bio, p + 1);
-	err = __send_command(peer_device->connection, device->vnr, sock, P_DATA, sizeof(*p) + dgs, NULL, req->i.size);
+	err = __send_command(peer_device->connection, device->vnr, sock, P_DATA, sizeof(*p) + digest_size, NULL, req->i.size);
 	if (!err) {
 		/* For protocol A, we have to memcpy the payload into
 		 * socket buffers, as we may complete right away
@@ -1674,23 +1674,23 @@ int drbd_send_dblock(struct drbd_peer_device *peer_device, struct drbd_request *
 		 * out ok after sending on this side, but does not fit on the
 		 * receiving side, we sure have detected corruption elsewhere.
 		 */
-		if (!(req->rq_state & (RQ_EXP_RECEIVE_ACK | RQ_EXP_WRITE_ACK)) || dgs)
+		if (!(req->rq_state & (RQ_EXP_RECEIVE_ACK | RQ_EXP_WRITE_ACK)) || digest_size)
 			err = _drbd_send_bio(peer_device, req->master_bio);
 		else
 			err = _drbd_send_zc_bio(peer_device, req->master_bio);
 
 		/* double check digest, sometimes buffers have been modified in flight. */
-		if (dgs > 0 && dgs <= 64) {
+		if (digest_size > 0 && digest_size <= 64) {
 			/* 64 byte, 512 bit, is the largest digest size
 			 * currently supported in kernel crypto. */
 			unsigned char digest[64];
 			drbd_csum_bio(peer_device->connection->integrity_tfm, req->master_bio, digest);
-			if (memcmp(p + 1, digest, dgs)) {
+			if (memcmp(p + 1, digest, digest_size)) {
 				drbd_warn(device,
 					"Digest mismatch, buffer modified by upper layers during write: %llus +%u\n",
 					(unsigned long long)req->i.sector, req->i.size);
 			}
-		} /* else if (dgs > 64) {
+		} /* else if (digest_size > 64) {
 		     ... Be noisy about digest too large ...
 		} */
 	}
@@ -1711,13 +1711,13 @@ int drbd_send_block(struct drbd_peer_device *peer_device, enum drbd_packet cmd,
 	struct drbd_socket *sock;
 	struct p_data *p;
 	int err;
-	int dgs;
+	int digest_size;
 
 	sock = &peer_device->connection->data;
 	p = drbd_prepare_command(peer_device, sock);
 
-	dgs = peer_device->connection->integrity_tfm ?
-	      crypto_hash_digestsize(peer_device->connection->integrity_tfm) : 0;
+	digest_size = peer_device->connection->integrity_tfm ?
+		      crypto_hash_digestsize(peer_device->connection->integrity_tfm) : 0;
 
 	if (!p)
 		return -EIO;
@@ -1725,9 +1725,9 @@ int drbd_send_block(struct drbd_peer_device *peer_device, enum drbd_packet cmd,
 	p->block_id = peer_req->block_id;
 	p->seq_num = 0;  /* unused */
 	p->dp_flags = 0;
-	if (dgs)
+	if (digest_size)
 		drbd_csum_ee(peer_device->connection->integrity_tfm, peer_req, p + 1);
-	err = __send_command(peer_device->connection, device->vnr, sock, cmd, sizeof(*p) + dgs, NULL, peer_req->i.size);
+	err = __send_command(peer_device->connection, device->vnr, sock, cmd, sizeof(*p) + digest_size, NULL, peer_req->i.size);
 	if (!err)
 		err = _drbd_send_zc_ee(peer_device, peer_req);
 	mutex_unlock(&sock->mutex);  /* locked by drbd_prepare_command() */
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 9342b8d..3ae769e 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1371,9 +1371,9 @@ int drbd_submit_peer_request(struct drbd_device *device,
 	struct bio *bio;
 	struct page *page = peer_req->pages;
 	sector_t sector = peer_req->i.sector;
-	unsigned ds = peer_req->i.size;
+	unsigned data_size = peer_req->i.size;
 	unsigned n_bios = 0;
-	unsigned nr_pages = (ds + PAGE_SIZE -1) >> PAGE_SHIFT;
+	unsigned nr_pages = (data_size + PAGE_SIZE -1) >> PAGE_SHIFT;
 	int err = -ENOMEM;
 
 	if (peer_req->flags & EE_IS_TRIM_USE_ZEROOUT) {
@@ -1388,7 +1388,7 @@ int drbd_submit_peer_request(struct drbd_device *device,
 		list_add_tail(&peer_req->w.list, &device->active_ee);
 		spin_unlock_irq(&device->resource->req_lock);
 		if (blkdev_issue_zeroout(device->ldev->backing_bdev,
-			sector, ds >> 9, GFP_NOIO))
+			sector, data_size >> 9, GFP_NOIO))
 			peer_req->flags |= EE_WAS_ERROR;
 		drbd_endio_write_sec_final(peer_req);
 		return 0;
@@ -1426,12 +1426,12 @@ next_bio:
 	++n_bios;
 
 	if (rw & REQ_DISCARD) {
-		bio->bi_iter.bi_size = ds;
+		bio->bi_iter.bi_size = data_size;
 		goto submit;
 	}
 
 	page_chain_for_each(page) {
-		unsigned len = min_t(unsigned, ds, PAGE_SIZE);
+		unsigned len = min_t(unsigned, data_size, PAGE_SIZE);
 		if (!bio_add_page(bio, page, len, 0)) {
 			/* A single page must always be possible!
 			 * But in case it fails anyways,
@@ -1446,11 +1446,11 @@ next_bio:
 			}
 			goto next_bio;
 		}
-		ds -= len;
+		data_size -= len;
 		sector += len >> 9;
 		--nr_pages;
 	}
-	D_ASSERT(device, ds == 0);
+	D_ASSERT(device, data_size == 0);
 submit:
 	D_ASSERT(device, page == NULL);
 
@@ -1591,24 +1591,24 @@ read_in_block(struct drbd_peer_device *peer_device, u64 id, sector_t sector,
 	const sector_t capacity = drbd_get_capacity(device->this_bdev);
 	struct drbd_peer_request *peer_req;
 	struct page *page;
-	int dgs, ds, err;
-	unsigned int data_size = pi->size;
+	int digest_size, err;
+	unsigned int data_size = pi->size, ds;
 	void *dig_in = peer_device->connection->int_dig_in;
 	void *dig_vv = peer_device->connection->int_dig_vv;
 	unsigned long *data;
 	struct p_trim *trim = (pi->cmd == P_TRIM) ? pi->data : NULL;
 
-	dgs = 0;
+	digest_size = 0;
 	if (!trim && peer_device->connection->peer_integrity_tfm) {
-		dgs = crypto_hash_digestsize(peer_device->connection->peer_integrity_tfm);
+		digest_size = crypto_hash_digestsize(peer_device->connection->peer_integrity_tfm);
 		/*
 		 * FIXME: Receive the incoming digest into the receive buffer
 		 *	  here, together with its struct p_data?
 		 */
-		err = drbd_recv_all_warn(peer_device->connection, dig_in, dgs);
+		err = drbd_recv_all_warn(peer_device->connection, dig_in, digest_size);
 		if (err)
 			return NULL;
-		data_size -= dgs;
+		data_size -= digest_size;
 	}
 
 	if (trim) {
@@ -1661,16 +1661,16 @@ read_in_block(struct drbd_peer_device *peer_device, u64 id, sector_t sector,
 		ds -= len;
 	}
 
-	if (dgs) {
+	if (digest_size) {
 		drbd_csum_ee(peer_device->connection->peer_integrity_tfm, peer_req, dig_vv);
-		if (memcmp(dig_in, dig_vv, dgs)) {
+		if (memcmp(dig_in, dig_vv, digest_size)) {
 			drbd_err(device, "Digest integrity check FAILED: %llus +%u\n",
 				(unsigned long long)sector, data_size);
 			drbd_free_peer_req(device, peer_req);
 			return NULL;
 		}
 	}
-	device->recv_cnt += data_size>>9;
+	device->recv_cnt += data_size >> 9;
 	return peer_req;
 }
 
@@ -1708,17 +1708,17 @@ static int recv_dless_read(struct drbd_peer_device *peer_device, struct drbd_req
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	struct bio *bio;
-	int dgs, err, expect;
+	int digest_size, err, expect;
 	void *dig_in = peer_device->connection->int_dig_in;
 	void *dig_vv = peer_device->connection->int_dig_vv;
 
-	dgs = 0;
+	digest_size = 0;
 	if (peer_device->connection->peer_integrity_tfm) {
-		dgs = crypto_hash_digestsize(peer_device->connection->peer_integrity_tfm);
-		err = drbd_recv_all_warn(peer_device->connection, dig_in, dgs);
+		digest_size = crypto_hash_digestsize(peer_device->connection->peer_integrity_tfm);
+		err = drbd_recv_all_warn(peer_device->connection, dig_in, digest_size);
 		if (err)
 			return err;
-		data_size -= dgs;
+		data_size -= digest_size;
 	}
 
 	/* optimistically update recv_cnt.  if receiving fails below,
@@ -1738,9 +1738,9 @@ static int recv_dless_read(struct drbd_peer_device *peer_device, struct drbd_req
 		data_size -= expect;
 	}
 
-	if (dgs) {
+	if (digest_size) {
 		drbd_csum_bio(peer_device->connection->peer_integrity_tfm, bio, dig_vv);
-		if (memcmp(dig_in, dig_vv, dgs)) {
+		if (memcmp(dig_in, dig_vv, digest_size)) {
 			drbd_err(peer_device, "Digest integrity check FAILED. Broken NICs?\n");
 			return -EINVAL;
 		}
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index c35c0f0..84b11f8 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -136,50 +136,50 @@ enum drbd_role conn_highest_peer(struct drbd_connection *connection)
 
 enum drbd_disk_state conn_highest_disk(struct drbd_connection *connection)
 {
-	enum drbd_disk_state ds = D_DISKLESS;
+	enum drbd_disk_state disk_state = D_DISKLESS;
 	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	rcu_read_lock();
 	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
 		struct drbd_device *device = peer_device->device;
-		ds = max_t(enum drbd_disk_state, ds, device->state.disk);
+		disk_state = max_t(enum drbd_disk_state, disk_state, device->state.disk);
 	}
 	rcu_read_unlock();
 
-	return ds;
+	return disk_state;
 }
 
 enum drbd_disk_state conn_lowest_disk(struct drbd_connection *connection)
 {
-	enum drbd_disk_state ds = D_MASK;
+	enum drbd_disk_state disk_state = D_MASK;
 	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	rcu_read_lock();
 	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
 		struct drbd_device *device = peer_device->device;
-		ds = min_t(enum drbd_disk_state, ds, device->state.disk);
+		disk_state = min_t(enum drbd_disk_state, disk_state, device->state.disk);
 	}
 	rcu_read_unlock();
 
-	return ds;
+	return disk_state;
 }
 
 enum drbd_disk_state conn_highest_pdsk(struct drbd_connection *connection)
 {
-	enum drbd_disk_state ds = D_DISKLESS;
+	enum drbd_disk_state disk_state = D_DISKLESS;
 	struct drbd_peer_device *peer_device;
 	int vnr;
 
 	rcu_read_lock();
 	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
 		struct drbd_device *device = peer_device->device;
-		ds = max_t(enum drbd_disk_state, ds, device->state.pdsk);
+		disk_state = max_t(enum drbd_disk_state, disk_state, device->state.pdsk);
 	}
 	rcu_read_unlock();
 
-	return ds;
+	return disk_state;
 }
 
 enum drbd_conns conn_lowest_conn(struct drbd_connection *connection)
-- 
1.9.1

