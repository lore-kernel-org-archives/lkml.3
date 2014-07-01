Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbaGAQRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:17:01 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53109 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082AbaGAQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:54 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/20] drbd: don't implicitly resize Diskless node beyond end of device
Date: Tue,  1 Jul 2014 18:16:35 +0200
Message-Id: <1404231410-29852-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

During handshake, we compare backend sizes, and user set limits,
and agree on what device size we are going to expose.

We remember that last-agreed-size in our meta data.

But if we come up diskless, we have to accept what the peer
presents us with. We used to accept the peers maximum potential
capacity (backend size), which is wrong, and could lead to IO errors
due to access beyond end of device.

Instead, we need to accept the peer's current size.
Unless that is communicated as 0, in which case we
accept the backend size, or the user set limit, if set.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 2fcc3af..5626c5b 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3657,7 +3657,7 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 	struct drbd_device *device;
 	struct p_sizes *p = pi->data;
 	enum determine_dev_size dd = DS_UNCHANGED;
-	sector_t p_size, p_usize, my_usize;
+	sector_t p_size, p_usize, p_csize, my_usize;
 	int ldsc = 0; /* local disk size changed */
 	enum dds_flags ddsf;
 
@@ -3668,6 +3668,7 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 
 	p_size = be64_to_cpu(p->d_size);
 	p_usize = be64_to_cpu(p->u_size);
+	p_csize = be64_to_cpu(p->c_size);
 
 	/* just store the peer's disk size for now.
 	 * we still need to figure out whether we accept that. */
@@ -3742,9 +3743,21 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 			return -EIO;
 		drbd_md_sync(device);
 	} else {
-		/* I am diskless, need to accept the peer's size. */
+		/*
+		 * I am diskless, need to accept the peer's *current* size.
+		 * I must NOT accept the peers backing disk size,
+		 * it may have been larger than mine all along...
+		 *
+		 * At this point, the peer knows more about my disk, or at
+		 * least about what we last agreed upon, than myself.
+		 * So if his c_size is less than his d_size, the most likely
+		 * reason is that *my* d_size was smaller last time we checked.
+		 *
+		 * However, if he sends a zero current size,
+		 * take his (user-capped or) backing disk size anyways.
+		 */
 		drbd_reconsider_max_bio_size(device, NULL);
-		drbd_set_my_capacity(device, p_size);
+		drbd_set_my_capacity(device, p_csize ?: p_usize ?: p_size);
 	}
 
 	if (get_ldev(device)) {
-- 
1.9.1

