Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaELBm5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:42:57 -0400
Received: from 1wt.eu ([62.212.114.60]:34654 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbaELBm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:56 -0400
Message-Id: <20140512003205.874319880@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Neal Cardwell <ncardwell@google.com>,
        Nandita Dukkipati <nanditad@google.com>,
        =?ISO-8859-15?q?Ilpo=20J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 125/143] tcp: fix tcp_trim_head() to adjust segment count with skb MSS
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

This commit fixes tcp_trim_head() to recalculate the number of
segments in the skb with the skb's existing MSS, so trimming the head
causes the skb segment count to be monotonically non-increasing - it
should stay the same or go down, but not increase.

Previously tcp_trim_head() used the current MSS of the connection. But
if there was a decrease in MSS between original transmission and ACK
(e.g. due to PMTUD), this could cause tcp_trim_head() to
counter-intuitively increase the segment count when trimming bytes off
the head of an skb. This violated assumptions in tcp_tso_acked() that
tcp_trim_head() only decreases the packet count, so that packets_acked
in tcp_tso_acked() could underflow, leading tcp_clean_rtx_queue() to
pass u32 pkts_acked values as large as 0xffffffff to
ca_ops->pkts_acked().

As an aside, if tcp_trim_head() had really wanted the skb to reflect
the current MSS, it should have called tcp_set_skb_tso_segs()
unconditionally, since a decrease in MSS would mean that a
single-packet skb should now be sliced into multiple segments.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Nandita Dukkipati <nanditad@google.com>
Acked-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit 5b35e1e6e9ca651e6b291c96d1106043c9af314a)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/tcp_output.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 49da29e..0fc0a73 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -949,11 +949,9 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
 	sk_mem_uncharge(sk, len);
 	sock_set_flag(sk, SOCK_QUEUE_SHRUNK);
 
-	/* Any change of skb->len requires recalculation of tso
-	 * factor and mss.
-	 */
+	/* Any change of skb->len requires recalculation of tso factor. */
 	if (tcp_skb_pcount(skb) > 1)
-		tcp_set_skb_tso_segs(sk, skb, tcp_current_mss(sk));
+		tcp_set_skb_tso_segs(sk, skb, tcp_skb_mss(skb));
 
 	return 0;
 }
-- 
1.7.12.2.21.g234cd45.dirty



