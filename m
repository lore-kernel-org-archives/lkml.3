Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaELBn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:43:29 -0400
Received: from 1wt.eu ([62.212.114.60]:34728 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbaELBn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:26 -0400
Message-Id: <20140512003205.294915191@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 112/143] sctp: unbalanced rcu lock in ip_queue_xmit()
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

The bug was introduced in 2.6.32.61 by commit b8710128e201 ("inet: add RCU
protection to inet->opt") (it's a backport of upstream commit f6d8bd051c39).

In SCTP case, packet is already routed, hence we jump to the label
'packet_routed', but without rcu_read_lock(). After this label,
rcu_read_unlock() is called unconditionally.

Spotted-by: Guo Fengtian <fengtian.guo@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/ip_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 7dde039..2cd69e3 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -320,13 +320,13 @@ int ip_queue_xmit(struct sk_buff *skb, int ipfragok)
 	/* Skip all of this if the packet is already routed,
 	 * f.e. by something like SCTP.
 	 */
+	rcu_read_lock();
 	rt = skb_rtable(skb);
 	if (rt != NULL)
 		goto packet_routed;
 
 	/* Make sure we can route this packet. */
 	rt = (struct rtable *)__sk_dst_check(sk, 0);
-	rcu_read_lock();
 	inet_opt = rcu_dereference(inet->inet_opt);
 	if (rt == NULL) {
 		__be32 daddr;
-- 
1.7.12.2.21.g234cd45.dirty



