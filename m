Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934781Ab3CZP0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:26:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54207 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965463Ab3CZPYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 146/150] tcp: fix skb_availroom()
Date: Tue, 26 Mar 2013 15:20:45 +0000
Message-Id: <1364311249-14454-147-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 16fad69cfe4adbbfa813de516757b87bcae36d93 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/skbuff.h | 7 +++++--
 net/ipv4/tcp.c         | 2 +-
 net/ipv4/tcp_output.c  | 1 -
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ce73657..5af4bef 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -480,7 +480,7 @@ struct sk_buff {
 	union {
 		__u32		mark;
 		__u32		dropcount;
-		__u32		avail_size;
+		__u32		reserved_tailroom;
 	};
 
 	sk_buff_data_t		transport_header;
@@ -1391,7 +1391,10 @@ static inline int skb_tailroom(const struct sk_buff *skb)
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
index 34b23da..1a763b7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -769,7 +769,7 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp)
 			 * Make sure that we have exactly size bytes
 			 * available to the caller, no more, no less.
 			 */
-			skb->avail_size = size;
+			skb->reserved_tailroom = skb->end - skb->tail - size;
 			return skb;
 		}
 		__kfree_skb(skb);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 305aafe..1195760 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1097,7 +1097,6 @@ static void __pskb_trim_head(struct sk_buff *skb, int len)
 	eat = min_t(int, len, skb_headlen(skb));
 	if (eat) {
 		__skb_pull(skb, eat);
-		skb->avail_size -= eat;
 		len -= eat;
 		if (!len)
 			return;
-- 
1.8.1.2

