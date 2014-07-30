Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaG3Mge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:36:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36682 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbaG3MPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>, Yuchung Cheng <ycheng@google.com>,
        Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 34/94] tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb
Date: Wed, 30 Jul 2014 14:14:23 +0200
Message-Id: <5f8c661beedfe757e0c56b415cbe6e2781892718.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 2cd0d743b05e87445c54ca124a9916f22f16742e ]

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0e8af08a98fc..3c6ee41ba419 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1120,7 +1120,7 @@ static int tcp_match_skb_to_sack(struct sock *sk, struct sk_buff *skb,
 			unsigned int new_len = (pkt_len / mss) * mss;
 			if (!in_sack && new_len < pkt_len) {
 				new_len += mss;
-				if (new_len > skb->len)
+				if (new_len >= skb->len)
 					return 0;
 			}
 			pkt_len = new_len;
-- 
2.0.1

