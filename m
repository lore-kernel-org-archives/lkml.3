Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161203AbaDKRAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:00:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422728AbaDKQIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:08:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ying Xue <ying.xue@windriver.com>,
        Erik Hugne <erik.hugne@ericsson.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 05/65] tipc: allow connection shutdown callback to be invoked in advance
Date: Fri, 11 Apr 2014 09:10:37 -0700
Message-Id: <20140411160958.473610122@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/config.c |    9 ++-------
 net/tipc/server.c |    8 +++-----
 net/tipc/subscr.c |    8 ++------
 3 files changed, 7 insertions(+), 18 deletions(-)

--- a/net/tipc/config.c
+++ b/net/tipc/config.c
@@ -376,7 +376,6 @@ static void cfg_conn_msg_event(int conid
 	struct tipc_cfg_msg_hdr *req_hdr;
 	struct tipc_cfg_msg_hdr *rep_hdr;
 	struct sk_buff *rep_buf;
-	int ret;
 
 	/* Validate configuration message header (ignore invalid message) */
 	req_hdr = (struct tipc_cfg_msg_hdr *)buf;
@@ -398,12 +397,8 @@ static void cfg_conn_msg_event(int conid
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
--- a/net/tipc/server.c
+++ b/net/tipc/server.c
@@ -87,7 +87,6 @@ static void tipc_clean_outqueues(struct
 static void tipc_conn_kref_release(struct kref *kref)
 {
 	struct tipc_conn *con = container_of(kref, struct tipc_conn, kref);
-	struct tipc_server *s = con->server;
 
 	if (con->sock) {
 		tipc_sock_release_local(con->sock);
@@ -95,10 +94,6 @@ static void tipc_conn_kref_release(struc
 	}
 
 	tipc_clean_outqueues(con);
-
-	if (con->conid)
-		s->tipc_conn_shutdown(con->conid, con->usr_data);
-
 	kfree(con);
 }
 
@@ -181,6 +176,9 @@ static void tipc_close_conn(struct tipc_
 	struct tipc_server *s = con->server;
 
 	if (test_and_clear_bit(CF_CONNECTED, &con->flags)) {
+		if (con->conid)
+			s->tipc_conn_shutdown(con->conid, con->usr_data);
+
 		spin_lock_bh(&s->idr_lock);
 		idr_remove(&s->conn_idr, con->conid);
 		s->idr_in_use--;
--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -96,20 +96,16 @@ static void subscr_send_event(struct tip
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


