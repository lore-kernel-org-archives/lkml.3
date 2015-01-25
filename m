Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbbAYTC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:02:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbbAYSJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Zhou <azhou@nicira.com>, Jesse Gross <jesse@nicira.com>,
        Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 006/183] geneve: Fix races between socket add and release.
Date: Sun, 25 Jan 2015 10:05:28 -0800
Message-Id: <20150125180810.467308724@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Gross <jesse@nicira.com>

[ Upstream commit 12069401d895ff84076a50189ca842c0696b84b2 ]

Currently, searching for a socket to add a reference to is not
synchronized with deletion of sockets. This can result in use
after free if there is another operation that is removing a
socket at the same time. Solving this requires both holding the
appropriate lock and checking the refcount to ensure that it
has not already hit zero.

Inspired by a related (but not exactly the same) issue in the
VXLAN driver.

Fixes: 0b5e8b8e ("net: Add Geneve tunneling protocol driver")
CC: Andy Zhou <azhou@nicira.com>
Signed-off-by: Jesse Gross <jesse@nicira.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/geneve.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/ipv4/geneve.c
+++ b/net/ipv4/geneve.c
@@ -302,6 +302,7 @@ struct geneve_sock *geneve_sock_add(stru
 				    geneve_rcv_t *rcv, void *data,
 				    bool no_share, bool ipv6)
 {
+	struct geneve_net *gn = net_generic(net, geneve_net_id);
 	struct geneve_sock *gs;
 
 	gs = geneve_socket_create(net, port, rcv, data, ipv6);
@@ -311,15 +312,15 @@ struct geneve_sock *geneve_sock_add(stru
 	if (no_share)	/* Return error if sharing is not allowed. */
 		return ERR_PTR(-EINVAL);
 
+	spin_lock(&gn->sock_lock);
 	gs = geneve_find_sock(net, port);
-	if (gs) {
-		if (gs->rcv == rcv)
-			atomic_inc(&gs->refcnt);
-		else
+	if (gs && ((gs->rcv != rcv) ||
+		   !atomic_add_unless(&gs->refcnt, 1, 0)))
 			gs = ERR_PTR(-EBUSY);
-	} else {
+	spin_unlock(&gn->sock_lock);
+
+	if (!gs)
 		gs = ERR_PTR(-EINVAL);
-	}
 
 	return gs;
 }


