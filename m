Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaCFMq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 07:46:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaCFMqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 07:46:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/8] af_rxrpc: Prevent RxRPC peers from ABORT-storming one
 another [ver #2]
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: dhowells@redhat.com, tim@electronghost.co.uk,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Mar 2014 12:46:29 +0000
Message-ID: <20140306124629.16645.63784.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140306124614.16645.50744.stgit@warthog.procyon.org.uk>
References: <20140306124614.16645.50744.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Smith <tim@electronghost.co.uk>

When an ABORT is sent, aborting a connection, the sender quite reasonably
forgets about the connection.  If another frame is received, another ABORT
will be sent.  When the receiver gets it, it no longer applies to an extant
connection, so an ABORT is sent, and so on...

Prevent this by never sending a rejection for an ABORT packet.

Signed-off-by: Tim Smith <tim@electronghost.co.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-input.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/ar-input.c b/net/rxrpc/ar-input.c
index 529572f18d1f..eb7e16276cc1 100644
--- a/net/rxrpc/ar-input.c
+++ b/net/rxrpc/ar-input.c
@@ -606,8 +606,10 @@ dead_call:
 	}
 
 	_debug("dead call");
-	skb->priority = RX_CALL_DEAD;
-	rxrpc_reject_packet(conn->trans->local, skb);
+	if (sp->hdr.type != RXRPC_PACKET_TYPE_ABORT) {
+		skb->priority = RX_CALL_DEAD;
+		rxrpc_reject_packet(conn->trans->local, skb);
+	}
 	goto done;
 
 	/* resend last packet of a completed call
@@ -790,8 +792,10 @@ cant_route_call:
 		skb->priority = RX_CALL_DEAD;
 	}
 
-	_debug("reject");
-	rxrpc_reject_packet(local, skb);
+	if (sp->hdr.type != RXRPC_PACKET_TYPE_ABORT) {
+		_debug("reject type %d",sp->hdr.type);
+		rxrpc_reject_packet(local, skb);
+	}
 	rxrpc_put_local(local);
 	_leave(" [no call]");
 	return;

