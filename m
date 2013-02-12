Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab3BLUhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:37:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029Ab3BLUhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:37:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Phil Sutter <phil.sutter@viprinet.com>,
        Johann Baudy <johann.baudy@gnu-log.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 12/22] packet: fix leakage of tx_ring memory
Date: Tue, 12 Feb 2013 12:36:55 -0800
Message-Id: <20130212203415.810414121@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203413.459836020@linuxfoundation.org>
References: <20130212203413.459836020@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1349,13 +1349,15 @@ static int packet_release(struct socket
 
 	packet_flush_mclist(sk);
 
-	memset(&req, 0, sizeof(req));
-
-	if (po->rx_ring.pg_vec)
+	if (po->rx_ring.pg_vec) {
+		memset(&req, 0, sizeof(req));
 		packet_set_ring(sk, &req, 1, 0);
+	}
 
-	if (po->tx_ring.pg_vec)
+	if (po->tx_ring.pg_vec) {
+		memset(&req, 0, sizeof(req));
 		packet_set_ring(sk, &req, 1, 1);
+	}
 
 	synchronize_net();
 	/*


