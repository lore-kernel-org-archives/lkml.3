Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab3APQJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:09:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36804 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782Ab3APQJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:09:37 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        Kiran Kumar Kella <kkiran@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 188/222] tcp: refine SYN handling in tcp_validate_incoming
Date: Wed, 16 Jan 2013 13:56:28 -0200
Message-Id: <1358351822-7675-189-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit e371589917011efe6ff8c7dfb4e9e81934ac5855 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/tcp_input.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e859775..afb436d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5477,8 +5477,11 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
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
 
@@ -5508,6 +5511,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 	 * RFC 5691 4.2 : Send a challenge ack
 	 */
 	if (th->syn) {
+syn_challenge:
 		if (syn_inerr)
 			TCP_INC_STATS_BH(sock_net(sk), TCP_MIB_INERRS);
 		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
-- 
1.7.9.5

