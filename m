Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaDRJcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:32:12 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45972 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 28/72] tipc: fix connection refcount leak
Date: Fri, 18 Apr 2014 11:22:01 +0200
Message-Id: <a9d796583feb5cfa2e2282e69a4963aa3492dfe6.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ying Xue <ying.xue@windriver.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 4652edb70e8a7eebbe47fa931940f65522c36e8f ]

When tipc_conn_sendmsg() calls tipc_conn_lookup() to query a
connection instance, its reference count value is increased if
it's found. But subsequently if it's found that the connection is
closed, the work of sending message is not queued into its server
send workqueue, and the connection reference count is not decreased.
This will cause a reference count leak. To reproduce this problem,
an application would need to open and closes topology server
connections with high intensity.

We fix this by immediately decrementing the connection reference
count if a send fails due to the connection being closed.

Signed-off-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Erik Hugne <erik.hugne@ericsson.com>
Reviewed-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/tipc/server.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/tipc/server.c b/net/tipc/server.c
index ae474479f12e..bd2336aad0e4 100644
--- a/net/tipc/server.c
+++ b/net/tipc/server.c
@@ -427,10 +427,12 @@ int tipc_conn_sendmsg(struct tipc_server *s, int conid,
 	list_add_tail(&e->list, &con->outqueue);
 	spin_unlock_bh(&con->outqueue_lock);
 
-	if (test_bit(CF_CONNECTED, &con->flags))
+	if (test_bit(CF_CONNECTED, &con->flags)) {
 		if (!queue_work(s->send_wq, &con->swork))
 			conn_put(con);
-
+	} else {
+		conn_put(con);
+	}
 	return 0;
 }
 
-- 
1.9.2

