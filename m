Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161137AbaDKRAC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:00:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422729AbaDKQIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:08:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ying Xue <ying.xue@windriver.com>,
        Erik Hugne <erik.hugne@ericsson.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 06/65] tipc: fix connection refcount leak
Date: Fri, 11 Apr 2014 09:10:38 -0700
Message-Id: <20140411160958.613015282@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ying Xue <ying.xue@windriver.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/server.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/tipc/server.c
+++ b/net/tipc/server.c
@@ -427,10 +427,12 @@ int tipc_conn_sendmsg(struct tipc_server
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
 


