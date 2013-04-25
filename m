Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab3DYNrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:47:32 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:41339 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab3DYNra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:47:30 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/3] unix/dgram: peek beyond 0-sized skbs
Date: Thu, 25 Apr 2013 09:47:16 -0400
Message-Id: <1366897638-21882-1-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"77c1090 net: fix infinite loop in __skb_recv_datagram()" (v3.8) introduced a
regression:
After that commit, recv can no longer peek beyond a 0-sized skb in the queue.
__skb_recv_datagram() instead stops at the first skb with len == 0 and results
in the system call failing with -EFAULT via skb_copy_datagram_iovec().

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---
 net/core/datagram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 368f9c3..02398ae 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -187,7 +187,7 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned int flags,
 		skb_queue_walk(queue, skb) {
 			*peeked = skb->peeked;
 			if (flags & MSG_PEEK) {
-				if (*off >= skb->len && skb->len) {
+				if (*off >= skb->len && (skb->len || *off)) {
 					*off -= skb->len;
 					continue;
 				}
-- 
1.7.10.4

