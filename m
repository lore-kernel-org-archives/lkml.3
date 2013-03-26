Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3CZRj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:39:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27419 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3CZRgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:33 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=HMXTXvYb6IcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=CIneEAQuiPsA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173609.952397441@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 63/86] tcp: fix incorrect LOCKDROPPEDICMPS counter
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0063-tcp-fix-incorrect-LOCKDROPPEDICMPS-counter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 55ef74760190fb39eacaaee1816dfaeeadd5b92d ]

commit 563d34d057 (tcp: dont drop MTU reduction indications)
added an error leading to incorrect accounting of
LINUX_MIB_LOCKDROPPEDICMPS

If socket is owned by the user, we want to increment
this SNMP counter, unless the message is a
(ICMP_DEST_UNREACH,ICMP_FRAG_NEEDED) one.

Reported-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp_ipv4.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 4705caf..c883f4f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -379,11 +379,10 @@ void tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 	 * We do take care of PMTU discovery (RFC1191) special case :
 	 * we can receive locally generated ICMP messages while socket is held.
 	 */
-	if (sock_owned_by_user(sk) &&
-	    type != ICMP_DEST_UNREACH &&
-	    code != ICMP_FRAG_NEEDED)
-		NET_INC_STATS_BH(net, LINUX_MIB_LOCKDROPPEDICMPS);
-
+	if (sock_owned_by_user(sk)) {
+		if (!(type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED))
+			NET_INC_STATS_BH(net, LINUX_MIB_LOCKDROPPEDICMPS);
+	}
 	if (sk->sk_state == TCP_CLOSE)
 		goto out;
 
-- 
1.7.10.4


