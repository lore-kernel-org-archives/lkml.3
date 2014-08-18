Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaHRKBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:01:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42603 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaHRJeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neal Cardwell <ncardwell@google.com>, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 036/137] tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb
Date: Mon, 18 Aug 2014 10:31:37 +0100
Message-Id: <1408354398-10226-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

commit 2cd0d743b05e87445c54ca124a9916f22f16742e upstream.

If there is an MSS change (or misbehaving receiver) that causes a SACK
to arrive that covers the end of an skb but is less than one MSS, then
tcp_match_skb_to_sack() was rounding up pkt_len to the full length of
the skb ("Round if necessary..."), then chopping all bytes off the skb
and creating a zero-byte skb in the write queue.

This was visible now because the recently simplified TLP logic in
bef1909ee3ed1c ("tcp: fixing TLP's FIN recovery") could find that 0-byte
skb at the end of the write queue, and now that we do not check that
skb's length we could send it as a TLP probe.

Consider the following example scenario:

 mss: 1000
 skb: seq: 0 end_seq: 4000  len: 4000
 SACK: start_seq: 3999 end_seq: 4000

The tcp_match_skb_to_sack() code will compute:

 in_sack = false
 pkt_len = start_seq - TCP_SKB_CB(skb)->seq = 3999 - 0 = 3999
 new_len = (pkt_len / mss) * mss = (3999/1000)*1000 = 3000
 new_len += mss = 4000

Previously we would find the new_len > skb->len check failing, so we
would fall through and set pkt_len = new_len = 4000 and chop off
pkt_len of 4000 from the 4000-byte skb, leaving a 0-byte segment
afterward in the write queue.

With this new commit, we notice that the new new_len >= skb->len check
succeeds, so that we return without trying to fragment.

Fixes: adb92db857ee ("tcp: Make SACK code to split only at mss boundaries")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d8e4c81bc114..ebafc8703c7a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1119,7 +1119,7 @@ static int tcp_match_skb_to_sack(struct sock *sk, struct sk_buff *skb,
 			unsigned int new_len = (pkt_len / mss) * mss;
 			if (!in_sack && new_len < pkt_len) {
 				new_len += mss;
-				if (new_len > skb->len)
+				if (new_len >= skb->len)
 					return 0;
 			}
 			pkt_len = new_len;
-- 
1.9.1

