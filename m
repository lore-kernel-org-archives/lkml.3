Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab3KAWIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:08:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab3KAWIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Dmitry Kravkov <dmitry@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 31/66] bnx2x: record rx queue for LRO packets
Date: Fri,  1 Nov 2013 15:07:07 -0700
Message-Id: <20131101220643.338036011@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -676,6 +676,7 @@ static void bnx2x_gro_receive(struct bnx
 		}
 	}
 #endif
+	skb_record_rx_queue(skb, fp->rx_queue);
 	napi_gro_receive(&fp->napi, skb);
 }
 


