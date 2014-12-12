Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967508AbaLLHBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 02:01:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51717 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758549AbaLLGQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:53 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "Jeffrey Knockel" <jeffk@cs.unm.edu>
Date: Fri, 12 Dec 2014 06:14:26 +0000
Message-ID: <lsq.1418364866.131629083@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 162/164] Patch for 3.2.x, 3.4.x IP identifier regression
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jeffrey Knockel <jeffk@cs.unm.edu>

With commits 73f156a6e8c1 ("inetpeer: get rid of ip_id_count") and
04ca6973f7c1 ("ip: make IP identifiers less predictable"), IP
identifiers are generated from a counter chosen from an array of
counters indexed by the hash of the outgoing packet header's source
address, destination address, and protocol number.  Thus, in
__ip_make_skb(), we must now call ip_select_ident() only after setting
these fields in the IP header to prevent IP identifiers from being
generated from bogus counters.

IP id sequence before fix: 18174, 5789, 5953, 59420, 59637, ...
After fix: 5967, 6185, 6374, 6600, 6795, 6892, 7051, 7288, ...

Signed-off-by: Jeffrey Knockel <jeffk@cs.unm.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Eric Dumazet <edumazet@google.com>
---
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1333,11 +1333,11 @@ struct sk_buff *__ip_make_skb(struct soc
 	iph->ihl = 5;
 	iph->tos = inet->tos;
 	iph->frag_off = df;
-	ip_select_ident(skb, sk);
 	iph->ttl = ttl;
 	iph->protocol = sk->sk_protocol;
 	iph->saddr = fl4->saddr;
 	iph->daddr = fl4->daddr;
+	ip_select_ident(skb, sk);
 
 	if (opt) {
 		iph->ihl += opt->optlen>>2;

