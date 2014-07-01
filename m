Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbaGAQRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:17:04 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53112 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119AbaGAQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:54 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/20] drbd: Limit the time we are waiting for the first packet on an accepted socket
Date: Tue,  1 Jul 2014 18:16:37 +0200
Message-Id: <1404231410-29852-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before the patch
'drbd: Keep the listening socket open while trying to connect to the peer'

the newly created socket inherited the receive timeout from the listen
socket. The listen socket had a receive timeout of connect-intervall
+- 30% random jitter.

The real issue is that after the mentioned patch we had no timeout at all.
Now use 4 times the ping-timeout.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index d326af6..7da83f3 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -791,8 +791,18 @@ static int receive_first_packet(struct drbd_connection *connection, struct socke
 {
 	unsigned int header_size = drbd_header_size(connection);
 	struct packet_info pi;
+	struct net_conf *nc;
 	int err;
 
+	rcu_read_lock();
+	nc = rcu_dereference(connection->net_conf);
+	if (!nc) {
+		rcu_read_unlock();
+		return -EIO;
+	}
+	sock->sk->sk_rcvtimeo = nc->ping_timeo * 4 * HZ / 10;
+	rcu_read_unlock();
+
 	err = drbd_recv_short(sock, connection->data.rbuf, header_size, 0);
 	if (err != header_size) {
 		if (err >= 0)
-- 
1.9.1

