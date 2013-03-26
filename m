Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab3CZWnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:43:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3CZWng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Mukesh Agrawal <quiche@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 13/98] tcp: fix skb_availroom()
Date: Tue, 26 Mar 2013 15:42:02 -0700
Message-Id: <20130326224243.832727318@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    7 +++++--
 net/ipv4/tcp.c         |    2 +-
 net/ipv4/tcp_output.c  |    1 -
 3 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -491,7 +491,7 @@ struct sk_buff {
 	union {
 		__u32		mark;
 		__u32		dropcount;
-		__u32		avail_size;
+		__u32		reserved_tailroom;
 	};
 
 	sk_buff_data_t		inner_transport_header;
@@ -1428,7 +1428,10 @@ static inline int skb_tailroom(const str
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
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -773,7 +773,7 @@ struct sk_buff *sk_stream_alloc_skb(stru
 			 * Make sure that we have exactly size bytes
 			 * available to the caller, no more, no less.
 			 */
-			skb->avail_size = size;
+			skb->reserved_tailroom = skb->end - skb->tail - size;
 			return skb;
 		}
 		__kfree_skb(skb);
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1298,7 +1298,6 @@ static void __pskb_trim_head(struct sk_b
 	eat = min_t(int, len, skb_headlen(skb));
 	if (eat) {
 		__skb_pull(skb, eat);
-		skb->avail_size -= eat;
 		len -= eat;
 		if (!len)
 			return;


