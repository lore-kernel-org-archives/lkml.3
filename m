Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab3CZR5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:57:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30328 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3CZRgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:09 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=2m7I2ORB-N4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=-JyVteMtZIgA:10 a=Na2XfeO0AAAA:8 a=SOtbYguYAAAA:8 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=tduqqSyvDTFb0OIsw9kA:9 a=QeDTVy5pXycA:10 a=S4w2x5khEiUA:10 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173603.419233321@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Phil Sutter <phil.sutter@viprinet.com>,
        Johann Baudy <johann.baudy@gnu-log.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 22/86] packet: fix leakage of tx_ring memory
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0022-packet-fix-leakage-of-tx_ring-memory.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

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
---
 net/packet/af_packet.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index c5c9e2a..70f7e18 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2443,13 +2443,15 @@ static int packet_release(struct socket *sock)
 
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
 
-- 
1.7.10.4


