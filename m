Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaLSDuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 22:50:04 -0500
Received: from sender1.zohomail.com ([74.201.84.155]:30836 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaLSDuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 22:50:02 -0500
From: Dan Collins <dan@dcollins.co.nz>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Collins <dan@dcollins.co.nz>
Subject: [PATCH] Fixed TPACKET V3 to signal poll when block is closed rather than every packet
Date: Fri, 19 Dec 2014 16:49:25 +1300
Message-Id: <1418960965-29522-1-git-send-email-dan@dcollins.co.nz>
X-Mailer: git-send-email 2.1.3
X-ZohoMail: Ss  SS_10 UW UB CHF_INT_SMD_EXT  SGR4_3_09124_1
X-ZohoMail-Owner: <1418960965-29522-1-git-send-email-dan@dcollins.co.nz>+zmo_0_<dan@dcollins.co.nz>
X-ZohoMail-Sender: 130.217.250.111
X-Zoho-Virus-Status: 2
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make TPACKET_V3 signal poll when block is closed rather than for every
packet. Side effect is that poll will be signaled when block retire
timer expires which didn't previously happen. Issue was visible when
sending packets at a very low frequency such that all blocks are retired
before packets are received by TPACKET_V3. This caused avoidable packet
loss. The fix ensures that the signal is sent when blocks are closed
which covers the normal path where the block is filled as well as the
path where the timer expires. The case where a block is filled without
moving to the next block (ie. all blocks are full) will still cause poll
to be signaled.

Signed-off-by: Dan Collins <dan@dcollins.co.nz>
---
 net/packet/af_packet.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index e52a447..6880f34 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -785,6 +785,7 @@ static void prb_close_block(struct tpacket_kbdq_core *pkc1,
 
 	struct tpacket3_hdr *last_pkt;
 	struct tpacket_hdr_v1 *h1 = &pbd1->hdr.bh1;
+	struct sock *sk = &po->sk;
 
 	if (po->stats.stats3.tp_drops)
 		status |= TP_STATUS_LOSING;
@@ -809,6 +810,8 @@ static void prb_close_block(struct tpacket_kbdq_core *pkc1,
 	/* Flush the block */
 	prb_flush_block(pkc1, pbd1, status);
 
+	sk->sk_data_ready(sk);
+
 	pkc1->kactive_blk_num = GET_NEXT_PRB_BLK_NUM(pkc1);
 }
 
@@ -2052,12 +2055,12 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	smp_wmb();
 #endif
 
-	if (po->tp_version <= TPACKET_V2)
+	if (po->tp_version <= TPACKET_V2) {
 		__packet_set_status(po, h.raw, status);
-	else
+		sk->sk_data_ready(sk);
+	} else {
 		prb_clear_blk_fill_status(&po->rx_ring);
-
-	sk->sk_data_ready(sk);
+	}
 
 drop_n_restore:
 	if (skb_head != skb->data && skb_shared(skb)) {
-- 
2.1.3


