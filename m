Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaLEGBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:01:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51303 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaLEF6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:58:55 -0500
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] switch l2cap ->memcpy_fromiovec() to msghdr
Date: Fri,  5 Dec 2014 05:58:46 +0000
Message-Id: <1417759133-18370-5-git-send-email-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <20141205055623.GQ29748@ZenIV.linux.org.uk>
References: <20141205055623.GQ29748@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

it'll die soon enough - now that kvec-backed iov_iter works regardless
of set_fs(), both instances will become copy_from_iter() as soon as
we introduce ->msg_iter...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/net/bluetooth/l2cap.h | 6 +++---
 net/bluetooth/l2cap_core.c    | 4 ++--
 net/bluetooth/l2cap_sock.c    | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 061e648..4e23674 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -608,7 +608,7 @@ struct l2cap_ops {
 					       unsigned long len, int nb);
 	int			(*memcpy_fromiovec) (struct l2cap_chan *chan,
 						     unsigned char *kdata,
-						     struct iovec *iov,
+						     struct msghdr *msg,
 						     int len);
 };
 
@@ -905,13 +905,13 @@ static inline long l2cap_chan_no_get_sndtimeo(struct l2cap_chan *chan)
 
 static inline int l2cap_chan_no_memcpy_fromiovec(struct l2cap_chan *chan,
 						 unsigned char *kdata,
-						 struct iovec *iov,
+						 struct msghdr *msg,
 						 int len)
 {
 	/* Following is safe since for compiler definitions of kvec and
 	 * iovec are identical, yielding the same in-core layout and alignment
 	 */
-	struct kvec *vec = (struct kvec *)iov;
+	struct kvec *vec = (struct kvec *)msg->msg_iov;
 
 	while (len > 0) {
 		if (vec->iov_len) {
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 8e12731..5201d61 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2097,7 +2097,7 @@ static inline int l2cap_skbuff_fromiovec(struct l2cap_chan *chan,
 	int sent = 0;
 
 	if (chan->ops->memcpy_fromiovec(chan, skb_put(skb, count),
-					msg->msg_iov, count))
+					msg, count))
 		return -EFAULT;
 
 	sent += count;
@@ -2118,7 +2118,7 @@ static inline int l2cap_skbuff_fromiovec(struct l2cap_chan *chan,
 		*frag = tmp;
 
 		if (chan->ops->memcpy_fromiovec(chan, skb_put(*frag, count),
-						msg->msg_iov, count))
+						msg, count))
 			return -EFAULT;
 
 		sent += count;
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index b0efb72..205b298 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1338,9 +1338,9 @@ static struct sk_buff *l2cap_sock_alloc_skb_cb(struct l2cap_chan *chan,
 
 static int l2cap_sock_memcpy_fromiovec_cb(struct l2cap_chan *chan,
 					  unsigned char *kdata,
-					  struct iovec *iov, int len)
+					  struct msghdr *msg, int len)
 {
-	return memcpy_fromiovec(kdata, iov, len);
+	return memcpy_from_msg(kdata, msg, len);
 }
 
 static void l2cap_sock_ready_cb(struct l2cap_chan *chan)
-- 
2.1.3

