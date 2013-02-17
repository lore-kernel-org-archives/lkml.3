Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab3BQXGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:06:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45713 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755329Ab3BQWzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:25 -0500
Message-Id: <20130217225007.567352657@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:52 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Phil Sutter <phil.sutter@viprinet.com>,
        Johann Baudy <johann.baudy@gnu-log.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 51/66] packet: fix leakage of tx_ring memory
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil.sutter@viprinet.com>

[ Upstream commit 9665d5d62487e8e7b1f546c00e11107155384b9a ]

When releasing a packet socket, the routine packet_set_ring() is reused
to free rings instead of allocating them. But when calling it for the
first time, it fills req->tp_block_nr with the value of rb->pg_vec_len
which in the second invocation makes it bail out since req->tp_block_nr
is greater zero but req->tp_block_size is zero.

This patch solves the problem by passing a zeroed auto-variable to
packet_set_ring() upon each invocation from packet_release().

As far as I can tell, this issue exists even since 69e3c75 (net: TX_RING
and packet mmap), i.e. the original inclusion of TX ring support into
af_packet, but applies only to sockets with both RX and TX ring
allocated, which is probably why this was unnoticed all the time.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
Cc: Johann Baudy <johann.baudy@gnu-log.net>
Cc: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/packet/af_packet.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 85afc13..835fcea 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2422,13 +2422,15 @@ static int packet_release(struct socket *sock)
 
 	packet_flush_mclist(sk);
 
-	memset(&req_u, 0, sizeof(req_u));
-
-	if (po->rx_ring.pg_vec)
+	if (po->rx_ring.pg_vec) {
+		memset(&req_u, 0, sizeof(req_u));
 		packet_set_ring(sk, &req_u, 1, 0);
+	}
 
-	if (po->tx_ring.pg_vec)
+	if (po->tx_ring.pg_vec) {
+		memset(&req_u, 0, sizeof(req_u));
 		packet_set_ring(sk, &req_u, 1, 1);
+	}
 
 	fanout_release(sk);
 


