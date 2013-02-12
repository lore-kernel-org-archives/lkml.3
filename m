Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab3BLVE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:04:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3BLUfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Maciej=20=AFenczykowski?= <maze@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 27/61] tcp: fix incorrect LOCKDROPPEDICMPS counter
Date: Tue, 12 Feb 2013 12:34:47 -0800
Message-Id: <20130212203421.994548599@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b74aa930ef49a3c0d8e4c1987f89decac768fb2c ]

commit 563d34d057 (tcp: dont drop MTU reduction indications)
added an error leading to incorrect accounting of
LINUX_MIB_LOCKDROPPEDICMPS

If socket is owned by the user, we want to increment
this SNMP counter, unless the message is a
(ICMP_DEST_UNREACH,ICMP_FRAG_NEEDED) one.

Reported-by: Maciej ¯enczykowski <maze@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Maciej ¯enczykowski <maze@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -380,11 +380,10 @@ void tcp_v4_err(struct sk_buff *icmp_skb
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
 


