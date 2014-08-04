Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaHDREc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:04:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56533 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Yuchung Cheng" <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Ilpo Jarvinen" <ilpo.jarvinen@helsinki.fi>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.200263161@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 55/94] tcp: fix tcp_match_skb_to_sack() for unaligned
 SACK at  end of an skb
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c1ed01e..afe6886 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1305,7 +1305,7 @@ static int tcp_match_skb_to_sack(struct sock *sk, struct sk_buff *skb,
 			unsigned int new_len = (pkt_len / mss) * mss;
 			if (!in_sack && new_len < pkt_len) {
 				new_len += mss;
-				if (new_len > skb->len)
+				if (new_len >= skb->len)
 					return 0;
 			}
 			pkt_len = new_len;

