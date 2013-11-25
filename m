Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab3KYOLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:11:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58867 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142Ab3KYNxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:45 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Willem de Bruijn" <willemb@google.com>,
        "Dmitry Kravkov" <dmitry@broadcom.com>,
        "Eilon Greenstein" <eilong@broadcom.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.213751350@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 13/87] bnx2x: record rx queue for LRO packets
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 60e66fee56b2256dcb1dc2ea1b2ddcb6e273857d ]

RPS support is kind of broken on bnx2x, because only non LRO packets
get proper rx queue information. This triggers reorders, as it seems
bnx2x like to generate a non LRO packet for segment including TCP PUSH
flag : (this might be pure coincidence, but all the reorders I've
seen involve segments with a PUSH)

11:13:34.335847 IP A > B: . 415808:447136(31328) ack 1 win 457 <nop,nop,timestamp 3789336 3985797>
11:13:34.335992 IP A > B: . 447136:448560(1424) ack 1 win 457 <nop,nop,timestamp 3789336 3985797>
11:13:34.336391 IP A > B: . 448560:479888(31328) ack 1 win 457 <nop,nop,timestamp 3789337 3985797>
11:13:34.336425 IP A > B: P 511216:512640(1424) ack 1 win 457 <nop,nop,timestamp 3789337 3985798>
11:13:34.336423 IP A > B: . 479888:511216(31328) ack 1 win 457 <nop,nop,timestamp 3789337 3985798>
11:13:34.336924 IP A > B: . 512640:543968(31328) ack 1 win 457 <nop,nop,timestamp 3789337 3985798>
11:13:34.336963 IP A > B: . 543968:575296(31328) ack 1 win 457 <nop,nop,timestamp 3789337 3985798>

We must call skb_record_rx_queue() to properly give to RPS (and more
generally for TX queue selection on forward path) the receive queue
information.

Similar fix is needed for skb_mark_napi_id(), but will be handled
in a separate patch to ease stable backports.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Eilon Greenstein <eilong@broadcom.com>
Acked-by: Dmitry Kravkov <dmitry@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 4c50ac0..bbb6692 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -516,6 +516,7 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 		if (!bnx2x_fill_frag_skb(bp, fp, queue, skb, cqe, cqe_idx)) {
 			if (tpa_info->parsing_flags & PARSING_FLAGS_VLAN)
 				__vlan_hwaccel_put_tag(skb, tpa_info->vlan_tag);
+			skb_record_rx_queue(skb, fp->index);
 			napi_gro_receive(&fp->napi, skb);
 		} else {
 			DP(NETIF_MSG_RX_STATUS, "Failed to allocate new pages"

