Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab3LWWBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:01:18 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60687 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab3LWV7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:59:00 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 24/27] drbd: Get rid of first_peer_device() in handle_write_conflicts()
Date: Mon, 23 Dec 2013 22:50:53 +0100
Message-Id: <1387835456-29695-25-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_receiver.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index e2e01b4..5c0239e 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2065,7 +2065,7 @@ static void fail_postponed_requests(struct drbd_device *device, sector_t sector,
 static int handle_write_conflicts(struct drbd_device *device,
 				  struct drbd_peer_request *peer_req)
 {
-	struct drbd_connection *connection = first_peer_device(device)->connection;
+	struct drbd_connection *connection = peer_req->peer_device->connection;
 	bool resolve_conflicts = test_bit(RESOLVE_CONFLICTS, &connection->flags);
 	sector_t sector = peer_req->i.sector;
 	const unsigned int size = peer_req->i.size;
@@ -2119,7 +2119,7 @@ static int handle_write_conflicts(struct drbd_device *device,
 			peer_req->w.cb = superseded ? e_send_superseded :
 						   e_send_retry_write;
 			list_add_tail(&peer_req->w.list, &device->done_ee);
-			wake_asender(first_peer_device(device)->connection);
+			wake_asender(connection);
 
 			err = -ENOENT;
 			goto out;
@@ -2148,9 +2148,7 @@ static int handle_write_conflicts(struct drbd_device *device,
 				 */
 				err = drbd_wait_misc(device, &req->i);
 				if (err) {
-					_conn_request_state(first_peer_device(device)->connection,
-							    NS(conn, C_TIMEOUT),
-							    CS_HARD);
+					_conn_request_state(connection, NS(conn, C_TIMEOUT), CS_HARD);
 					fail_postponed_requests(device, sector, size);
 					goto out;
 				}
-- 
1.7.9.5

