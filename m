Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaF3P5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:57:03 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:50043 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbaF3PxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/18] drbd: trigger tcp_push_pending_frames() for PING and PING_ACK
Date: Mon, 30 Jun 2014 17:53:01 +0200
Message-Id: <1404143587-24344-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

This should reduce latency for such in-DRBD-protocol "pings",
and may help reduce spurious disconnect/reconnect cycles due to
 "PingAck did not arrive in time."

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 8e0813d..77d34a6 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -662,6 +662,11 @@ static int __send_command(struct drbd_connection *connection, int vnr,
 			    msg_flags);
 	if (data && !err)
 		err = drbd_send_all(connection, sock->socket, data, size, 0);
+	/* DRBD protocol "pings" are latency critical.
+	 * This is supposed to trigger tcp_push_pending_frames() */
+	if (!err && (cmd == P_PING || cmd == P_PING_ACK))
+		drbd_tcp_nodelay(sock->socket);
+
 	return err;
 }
 
-- 
1.9.1

