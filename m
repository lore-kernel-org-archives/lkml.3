Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbaGZUNQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:13:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaGZTCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:02:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 17/56] tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb
Date: Sat, 26 Jul 2014 12:02:10 -0700
Message-Id: <20140726190200.608064667@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190200.061512159@linuxfoundation.org>
References: <20140726190200.061512159@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1130,7 +1130,7 @@ static int tcp_match_skb_to_sack(struct
 			unsigned int new_len = (pkt_len / mss) * mss;
 			if (!in_sack && new_len < pkt_len) {
 				new_len += mss;
-				if (new_len > skb->len)
+				if (new_len >= skb->len)
 					return 0;
 			}
 			pkt_len = new_len;


