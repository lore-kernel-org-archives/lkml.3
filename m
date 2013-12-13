Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3LMW4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:56:24 -0500
Received: from mail.ispras.ru ([83.149.199.45]:59213 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab3LMW4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:56:23 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [RXRPC]: do not unlock unheld spinlock in rxrpc_connect_exclusive()
Date: Sat, 14 Dec 2013 02:56:09 +0400
Message-Id: <1386975369-30837-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If rx->conn is not NULL, rxrpc_connect_exclusive() does not
acquire the transport's client lock, but it still releases it.

The patch adds locking of the spinlock to this path.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 net/rxrpc/ar-connection.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/rxrpc/ar-connection.c b/net/rxrpc/ar-connection.c
index 4106ca95ec86..4790140a1722 100644
--- a/net/rxrpc/ar-connection.c
+++ b/net/rxrpc/ar-connection.c
@@ -381,6 +381,11 @@ static int rxrpc_connect_exclusive(struct rxrpc_sock *rx,
 
 		rxrpc_assign_connection_id(conn);
 		rx->conn = conn;
+	} else {
+		spin_lock(&trans->client_lock);
+
+		_net("CONNECT EXCL old %d on TRANS %d",
+		     conn->debug_id, conn->trans->debug_id);
 	}
 
 	/* we've got a connection with a free channel and we can now attach the
-- 
1.8.3.2

