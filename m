Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3CYBWL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:22:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34110 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755381Ab3CYBQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:33 -0400
Message-Id: <20130325010527.925867168@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:01 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Eric Dumazet <edumazet@google.com>,
        Mukesh Agrawal <quiche@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 037/104] tcp: fix skb_availroom()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 16fad69cfe4adbbfa813de516757b87bcae36d93 ]

Chrome OS team reported a crash on a Pixel ChromeBook in TCP stack :

https://code.google.com/p/chromium/issues/detail?id=182056

commit a21d45726acac (tcp: avoid order-1 allocations on wifi and tx
path) did a poor choice adding an 'avail_size' field to skb, while
what we really needed was a 'reserved_tailroom' one.

It would have avoided commit 22b4a4f22da (tcp: fix retransmit of
partially acked frames) and this commit.

Crash occurs because skb_split() is not aware of the 'avail_size'
management (and should not be aware)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Mukesh Agrawal <quiche@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/skbuff.h | 7 +++++--
 net/ipv4/tcp.c         | 2 +-
 net/ipv4/tcp_output.c  | 1 -
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 53dc7e7..da65890 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -455,7 +455,7 @@ struct sk_buff {
 	union {
 		__u32		mark;
 		__u32		dropcount;
-		__u32		avail_size;
+		__u32		reserved_tailroom;
 	};
 
 	__u16			vlan_tci;
@@ -1332,7 +1332,10 @@ static inline int skb_tailroom(const struct sk_buff *skb)
  */
 static inline int skb_availroom(const struct sk_buff *skb)
 {
-	return skb_is_nonlinear(skb) ? 0 : skb->avail_size - skb->len;
+	if (skb_is_nonlinear(skb))
+		return 0;
+
+	return skb->end - skb->tail - skb->reserved_tailroom;
 }
 
 /**
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 52edbb8..fe381c2 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -704,7 +704,7 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp)
 			 * Make sure that we have exactly size bytes
 			 * available to the caller, no more, no less.
 			 */
-			skb->avail_size = size;
+			skb->reserved_tailroom = skb->end - skb->tail - size;
 			return skb;
 		}
 		__kfree_skb(skb);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 921cbac..9bb7400 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1096,7 +1096,6 @@ static void __pskb_trim_head(struct sk_buff *skb, int len)
 	eat = min_t(int, len, skb_headlen(skb));
 	if (eat) {
 		__skb_pull(skb, eat);
-		skb->avail_size -= eat;
 		len -= eat;
 		if (!len)
 			return;


