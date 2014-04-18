Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbaDRJcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:32:08 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45974 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ying Xue <ying.xue@windriver.com>,
        Erik Hugne <erik.hugne@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 27/72] tipc: allow connection shutdown callback to be invoked in advance
Date: Fri, 18 Apr 2014 11:22:00 +0200
Message-Id: <1f92d32f63aef244e48d96b6d1abab64133b0d0c.1397812482.git.jslaby@suse.cz>
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

[ Upstream commit 6d4ebeb4df0176b1973875840a9f7e91394c0685 ]

Currently connection shutdown callback function is called when
connection instance is released in tipc_conn_kref_release(), and
receiving packets and sending packets are running in different
threads. Even if connection is closed by the thread of receiving
packets, its shutdown callback may not be called immediately as
the connection reference count is non-zero at that moment. So,
although the connection is shut down by the thread of receiving
packets, the thread of sending packets doesn't know it. Before
its shutdown callback is invoked to tell the sending thread its
connection has been closed, the sending thread may deliver
messages by tipc_conn_sendmsg(), this is why the following error
information appears:

"Sending subscription event failed, no memory"

To eliminate it, allow connection shutdown callback function to
be called before connection id is removed in tipc_close_conn(),
which makes the sending thread know the truth in time that its
socket is closed so that it doesn't send message to it. We also
remove the "Sending XXX failed..." error reporting for topology
and config services.

Signed-off-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Erik Hugne <erik.hugne@ericsson.com>
Reviewed-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/tipc/config.c | 9 ++-------
 net/tipc/server.c | 8 +++-----
 net/tipc/subscr.c | 8 ++------
 3 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/net/tipc/config.c b/net/tipc/config.c
index c301a9a592d8..5afe633114e0 100644
--- a/net/tipc/config.c
+++ b/net/tipc/config.c
@@ -376,7 +376,6 @@ static void cfg_conn_msg_event(int conid, struct sockaddr_tipc *addr,
 	struct tipc_cfg_msg_hdr *req_hdr;
 	struct tipc_cfg_msg_hdr *rep_hdr;
 	struct sk_buff *rep_buf;
-	int ret;
 
 	/* Validate configuration message header (ignore invalid message) */
 	req_hdr = (struct tipc_cfg_msg_hdr *)buf;
@@ -398,12 +397,8 @@ static void cfg_conn_msg_event(int conid, struct sockaddr_tipc *addr,
 		memcpy(rep_hdr, req_hdr, sizeof(*rep_hdr));
 		rep_hdr->tcm_len = htonl(rep_buf->len);
 		rep_hdr->tcm_flags &= htons(~TCM_F_REQUEST);
-
-		ret = tipc_conn_sendmsg(&cfgsrv, conid, addr, rep_buf->data,
-					rep_buf->len);
-		if (ret < 0)
-			pr_err("Sending cfg reply message failed, no memory\n");
-
+		tipc_conn_sendmsg(&cfgsrv, conid, addr, rep_buf->data,
+				  rep_buf->len);
 		kfree_skb(rep_buf);
 	}
 }
diff --git a/net/tipc/server.c b/net/tipc/server.c
index fd3fa57a410e..ae474479f12e 100644
--- a/net/tipc/server.c
+++ b/net/tipc/server.c
@@ -87,7 +87,6 @@ static void tipc_clean_outqueues(struct tipc_conn *con);
 static void tipc_conn_kref_release(struct kref *kref)
 {
 	struct tipc_conn *con = container_of(kref, struct tipc_conn, kref);
-	struct tipc_server *s = con->server;
 
 	if (con->sock) {
 		tipc_sock_release_local(con->sock);
@@ -95,10 +94,6 @@ static void tipc_conn_kref_release(struct kref *kref)
 	}
 
 	tipc_clean_outqueues(con);
-
-	if (con->conid)
-		s->tipc_conn_shutdown(con->conid, con->usr_data);
-
 	kfree(con);
 }
 
@@ -181,6 +176,9 @@ static void tipc_close_conn(struct tipc_conn *con)
 	struct tipc_server *s = con->server;
 
 	if (test_and_clear_bit(CF_CONNECTED, &con->flags)) {
+		if (con->conid)
+			s->tipc_conn_shutdown(con->conid, con->usr_data);
+
 		spin_lock_bh(&s->idr_lock);
 		idr_remove(&s->conn_idr, con->conid);
 		s->idr_in_use--;
diff --git a/net/tipc/subscr.c b/net/tipc/subscr.c
index d38bb45d82e9..13f48bb5e540 100644
--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -96,20 +96,16 @@ static void subscr_send_event(struct tipc_subscription *sub, u32 found_lower,
 {
 	struct tipc_subscriber *subscriber = sub->subscriber;
 	struct kvec msg_sect;
-	int ret;
 
 	msg_sect.iov_base = (void *)&sub->evt;
 	msg_sect.iov_len = sizeof(struct tipc_event);
-
 	sub->evt.event = htohl(event, sub->swap);
 	sub->evt.found_lower = htohl(found_lower, sub->swap);
 	sub->evt.found_upper = htohl(found_upper, sub->swap);
 	sub->evt.port.ref = htohl(port_ref, sub->swap);
 	sub->evt.port.node = htohl(node, sub->swap);
-	ret = tipc_conn_sendmsg(&topsrv, subscriber->conid, NULL,
-				msg_sect.iov_base, msg_sect.iov_len);
-	if (ret < 0)
-		pr_err("Sending subscription event failed, no memory\n");
+	tipc_conn_sendmsg(&topsrv, subscriber->conid, NULL, msg_sect.iov_base,
+			  msg_sect.iov_len);
 }
 
 /**
-- 
1.9.2

