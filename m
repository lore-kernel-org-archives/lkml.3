Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035Ab3DKUkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:40:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30019 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab3DKUZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:25:57 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ZqPafjS3ZUoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=prNJ2qesBMQA:10 a=1XWaLZrsAAAA:8 a=cm27Pg_UAAAA:8 a=J1Y8HTJGAAAA:8 a=fxJ97_ir6-UvnoTxVDUA:9 a=UTB_XpHje0EA:10 a=zv9_9hqRWm8A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202548.399884015@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Mukesh Agrawal <quiche@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 013/171 ] tcp: fix skb_availroom()
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0013-tcp-fix-skb_availroom.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/skbuff.h |    7 +++++--
 net/ipv4/tcp.c         |    2 +-
 net/ipv4/tcp_output.c  |    1 -
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f3165d2..9a21379 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -481,7 +481,7 @@ struct sk_buff {
 	union {
 		__u32		mark;
 		__u32		dropcount;
-		__u32		avail_size;
+		__u32		reserved_tailroom;
 	};
 
 	sk_buff_data_t		transport_header;
@@ -1412,7 +1412,10 @@ static inline int skb_tailroom(const struct sk_buff *skb)
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
index a07e91c..094a01f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -771,7 +771,7 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp)
 			 * Make sure that we have exactly size bytes
 			 * available to the caller, no more, no less.
 			 */
-			skb->avail_size = size;
+			skb->reserved_tailroom = skb->end - skb->tail - size;
 			return skb;
 		}
 		__kfree_skb(skb);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6a1cdc8..745fc20 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1289,7 +1289,6 @@ static void __pskb_trim_head(struct sk_buff *skb, int len)
 	eat = min_t(int, len, skb_headlen(skb));
 	if (eat) {
 		__skb_pull(skb, eat);
-		skb->avail_size -= eat;
 		len -= eat;
 		if (!len)
 			return;
-- 
1.7.10.4


