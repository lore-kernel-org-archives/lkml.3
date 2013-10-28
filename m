Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab3J1OxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:53:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51283 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab3J1Ott (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 53/64] bnx2x: record rx queue for LRO packets
Date: Mon, 28 Oct 2013 14:48:12 +0000
Message-Id: <1382971703-17393-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 60e66fee56b2256dcb1dc2ea1b2ddcb6e273857d upstream.

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
[ luis: backported to 3.5, using davem's port to 3.4:
  - adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 2364f66..27c2843 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -566,6 +566,7 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 					 skb, cqe, cqe_idx)) {
 			if (tpa_info->parsing_flags & PARSING_FLAGS_VLAN)
 				__vlan_hwaccel_put_tag(skb, tpa_info->vlan_tag);
+			skb_record_rx_queue(skb, fp->rx_queue);
 			napi_gro_receive(&fp->napi, skb);
 		} else {
 			DP(NETIF_MSG_RX_STATUS,
-- 
1.8.3.2

