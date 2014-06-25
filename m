Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaFYTvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:51:08 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:58361 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaFYTvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:51:06 -0400
Message-ID: <1403725861.3796.47.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: [PATCH] net: fix setting csum_start in skb_segment()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tom Herbert <therbert@google.com>
Cc: davem@davemloft.net, torvalds@linux-foundation.org, davej@redhat.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 12:51:01 -0700
In-Reply-To: <alpine.DEB.2.02.1406242056330.29780@tomh.mtv.corp.google.com>
References: <alpine.DEB.2.02.1406242056330.29780@tomh.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Herbert <therbert@google.com>

Dave Jones reported that a crash is occurring in

csum_partial
tcp_gso_segment
inet_gso_segment
? update_dl_migration
skb_mac_gso_segment
__skb_gso_segment
dev_hard_start_xmit
sch_direct_xmit
__dev_queue_xmit
? dev_hard_start_xmit
dev_queue_xmit
ip_finish_output
? ip_output
ip_output
ip_forward_finish
ip_forward
ip_rcv_finish
ip_rcv
__netif_receive_skb_core
? __netif_receive_skb_core
? trace_hardirqs_on
__netif_receive_skb
netif_receive_skb_internal
napi_gro_complete
? napi_gro_complete
dev_gro_receive
? dev_gro_receive
napi_gro_receive

It looks like a likely culprit is that SKB_GSO_CB()->csum_start is
not set correctly when doing non-scatter gather. We are using
offset as opposed to doffset.

Reported-by: Dave Jones <davej@redhat.com>
Tested-by: Dave Jones <davej@redhat.com>
Signed-off-by: Tom Herbert <therbert@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: 7e2b10c1e52ca ("net: Support for multiple checksums with gso")
---
 net/core/skbuff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9cd5344fad73..c1a33033cbe2 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2993,7 +2993,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 							    skb_put(nskb, len),
 							    len, 0);
 			SKB_GSO_CB(nskb)->csum_start =
-			    skb_headroom(nskb) + offset;
+			    skb_headroom(nskb) + doffset;
 			continue;
 		}
 


