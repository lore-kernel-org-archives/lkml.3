Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaKLBTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:19:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaKLBTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:19:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 010/319] tipc: fix bug in bundled buffer reception
Date: Wed, 12 Nov 2014 10:12:28 +0900
Message-Id: <20141112010954.346840586@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Paul Maloy <jon.maloy@ericsson.com>

[ Upstream commit 643566d4b47e2956110e79c0e6f65db9b9ea42c6 ]

In commit ec8a2e5621db2da24badb3969eda7fd359e1869f ("tipc: same receive
code path for connection protocol and data messages") we omitted the
the possiblilty that an arriving message extracted from a bundle buffer
may be a multicast message. Such messages need to be to be delivered to
the socket via a separate function, tipc_sk_mcast_rcv(). As a result,
small multicast messages arriving as members of a bundle buffer will be
silently dropped.

This commit corrects the error by considering this case in the function
tipc_link_bundle_rcv().

Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/link.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1936,7 +1936,12 @@ void tipc_link_bundle_rcv(struct sk_buff
 		}
 		omsg = buf_msg(obuf);
 		pos += align(msg_size(omsg));
-		if (msg_isdata(omsg) || (msg_user(omsg) == CONN_MANAGER)) {
+		if (msg_isdata(omsg)) {
+			if (unlikely(msg_type(omsg) == TIPC_MCAST_MSG))
+				tipc_sk_mcast_rcv(obuf);
+			else
+				tipc_sk_rcv(obuf);
+		} else if (msg_user(omsg) == CONN_MANAGER) {
 			tipc_sk_rcv(obuf);
 		} else if (msg_user(omsg) == NAME_DISTRIBUTOR) {
 			tipc_named_rcv(obuf);


