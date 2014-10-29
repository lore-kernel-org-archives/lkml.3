Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670AbaJ2QjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:39:25 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:37126 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934559AbaJ2QiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:38:01 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 6/7] drbd: Fix state change in case of connection timeout
Date: Wed, 29 Oct 2014 17:37:55 +0100
Message-Id: <1414600676-11203-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414600676-11203-1-git-send-email-philipp.reisner@linbit.com>
References: <1414600676-11203-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A connection timeout affects all volumes of a resource!
Under the following conditions:

 A resource with multiple volumes
  AND
 ko-count >=1
  AND
 a write request triggers the timeout (ko-count * timeout)

DRBD's internal state gets confused. That in turn may
lead to very miss leading follow up failures. E.g.
"BUG: scheduling while atomic"

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 90319b1..3b797cd 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1629,7 +1629,7 @@ void request_timer_fn(unsigned long data)
 		 time_after(now, req_peer->pre_send_jif + ent) &&
 		!time_in_range(now, connection->last_reconnect_jif, connection->last_reconnect_jif + ent)) {
 		drbd_warn(device, "Remote failed to finish a request within ko-count * timeout\n");
-		_drbd_set_state(_NS(device, conn, C_TIMEOUT), CS_VERBOSE | CS_HARD, NULL);
+		_conn_request_state(connection, NS(conn, C_TIMEOUT), CS_VERBOSE | CS_HARD);
 	}
 	if (dt && oldest_submit_jif != now &&
 		 time_after(now, oldest_submit_jif + dt) &&
-- 
1.9.1

