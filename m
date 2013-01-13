Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3AMRvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:51:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35063 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491Ab3AMRpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:38 -0500
Message-Id: <20130113174304.558398551@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:37 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Vijay Subramanian <subramanian.vijay@gmail.com>,
        Kiran Kumar Kella <kkiran@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 42/49] tcp: refine SYN handling in tcp_validate_incoming
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e371589917011efe6ff8c7dfb4e9e81934ac5855 ]

Followup of commit 0c24604b68fc (tcp: implement RFC 5961 4.2)

As reported by Vijay Subramanian, we should send a challenge ACK
instead of a dup ack if a SYN flag is set on a packet received out of
window.

This permits the ratelimiting to work as intended, and to increase
correct SNMP counters.

Suggested-by: Vijay Subramanian <subramanian.vijay@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Vijay Subramanian <subramanian.vijay@gmail.com>
Cc: Kiran Kumar Kella <kkiran@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_input.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0b9d8d4..de434bc 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5289,8 +5289,11 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		 * an acknowledgment should be sent in reply (unless the RST
 		 * bit is set, if so drop the segment and return)".
 		 */
-		if (!th->rst)
+		if (!th->rst) {
+			if (th->syn)
+				goto syn_challenge;
 			tcp_send_dupack(sk, skb);
+		}
 		goto discard;
 	}
 
@@ -5320,6 +5323,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 	 * RFC 5691 4.2 : Send a challenge ack
 	 */
 	if (th->syn) {
+syn_challenge:
 		if (syn_inerr)
 			TCP_INC_STATS_BH(sock_net(sk), TCP_MIB_INERRS);
 		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);


