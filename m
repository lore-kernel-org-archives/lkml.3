Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaKFX2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:28:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58421 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaKFWh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 008/162] packet: handle too big packets for PACKET_V3
Date: Thu,  6 Nov 2014 14:34:32 -0800
Message-Id: <1415313426-9622-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit dc808110bb62b64a448696ecac3938902c92e1ab ]

af_packet can currently overwrite kernel memory by out of bound
accesses, because it assumed a [new] block can always hold one frame.

This is not generally the case, even if most existing tools do it right.

This patch clamps too long frames as API permits, and issue a one time
error on syslog.

[  394.357639] tpacket_rcv: packet too big, clamped from 5042 to 3966. macoff=82

In this example, packet header tp_snaplen was set to 3966,
and tp_len was set to 5042 (skb->len)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: f6fb8f100b80 ("af-packet: TPACKET_V3 flexible buffer implementation.")
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/packet/af_packet.c | 17 +++++++++++++++++
 net/packet/internal.h  |  1 +
 2 files changed, 18 insertions(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 88cfbc1..a846125 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -565,6 +565,7 @@ static void init_prb_bdqc(struct packet_sock *po,
 	p1->tov_in_jiffies = msecs_to_jiffies(p1->retire_blk_tov);
 	p1->blk_sizeof_priv = req_u->req3.tp_sizeof_priv;
 
+	p1->max_frame_len = p1->kblk_size - BLK_PLUS_PRIV(p1->blk_sizeof_priv);
 	prb_init_ft_ops(p1, req_u);
 	prb_setup_retire_blk_timer(po, tx_ring);
 	prb_open_block(p1, pbd);
@@ -1814,6 +1815,18 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 			if ((int)snaplen < 0)
 				snaplen = 0;
 		}
+	} else if (unlikely(macoff + snaplen >
+			    GET_PBDQC_FROM_RB(&po->rx_ring)->max_frame_len)) {
+		u32 nval;
+
+		nval = GET_PBDQC_FROM_RB(&po->rx_ring)->max_frame_len - macoff;
+		pr_err_once("tpacket_rcv: packet too big, clamped from %u to %u. macoff=%u\n",
+			    snaplen, nval, macoff);
+		snaplen = nval;
+		if (unlikely((int)snaplen < 0)) {
+			snaplen = 0;
+			macoff = GET_PBDQC_FROM_RB(&po->rx_ring)->max_frame_len;
+		}
 	}
 	spin_lock(&sk->sk_receive_queue.lock);
 	h.raw = packet_current_rx_frame(po, skb,
@@ -3610,6 +3623,10 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 			goto out;
 		if (unlikely(req->tp_block_size & (PAGE_SIZE - 1)))
 			goto out;
+		if (po->tp_version >= TPACKET_V3 &&
+		    (int)(req->tp_block_size -
+			  BLK_PLUS_PRIV(req_u->req3.tp_sizeof_priv)) <= 0)
+			goto out;
 		if (unlikely(req->tp_frame_size < po->tp_hdrlen +
 					po->tp_reserve))
 			goto out;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 1035fa2..ca086c0 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -29,6 +29,7 @@ struct tpacket_kbdq_core {
 	char		*pkblk_start;
 	char		*pkblk_end;
 	int		kblk_size;
+	unsigned int	max_frame_len;
 	unsigned int	knum_blocks;
 	uint64_t	knxt_seq_num;
 	char		*prev;
-- 
1.9.1

