Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbaELCEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:04:49 -0400
Received: from 1wt.eu ([62.212.114.60]:34573 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbaELBme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:34 -0400
Message-Id: <20140512003203.586050048@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Bohac <jbohac@suse.cz>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 071/143] ICMPv6: treat dest unreachable codes 5 and 6 as EACCES, not EPROTO
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Bohac <jbohac@suse.cz>

[ Upstream commit 61e76b178dbe7145e8d6afa84bb4ccea71918994 ]

RFC 4443 has defined two additional codes for ICMPv6 type 1 (destination
unreachable) messages:
        5 - Source address failed ingress/egress policy
	6 - Reject route to destination

Now they are treated as protocol error and icmpv6_err_convert() converts them
to EPROTO.

RFC 4443 says:
	"Codes 5 and 6 are more informative subsets of code 1."

Treat codes 5 and 6 as code 1 (EACCES)

Btw, connect() returning -EPROTO confuses firefox, so that fallback to
other/IPv4 addresses does not work:
https://bugzilla.mozilla.org/show_bug.cgi?id=910773

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/linux/icmpv6.h |  2 ++
 net/ipv6/icmp.c        | 10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index c0d8357..2e3d33c 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -123,6 +123,8 @@ static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)
 #define ICMPV6_NOT_NEIGHBOUR		2
 #define ICMPV6_ADDR_UNREACH		3
 #define ICMPV6_PORT_UNREACH		4
+#define ICMPV6_POLICY_FAIL		5
+#define ICMPV6_REJECT_ROUTE		6
 
 /*
  *	Codes for Time Exceeded
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index f23ebbe..376a4b6 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -903,6 +903,14 @@ static const struct icmp6_err {
 		.err	= ECONNREFUSED,
 		.fatal	= 1,
 	},
+	{	/* POLICY_FAIL */
+		.err	= EACCES,
+		.fatal	= 1,
+	},
+	{	/* REJECT_ROUTE	*/
+		.err	= EACCES,
+		.fatal	= 1,
+	},
 };
 
 int icmpv6_err_convert(u8 type, u8 code, int *err)
@@ -914,7 +922,7 @@ int icmpv6_err_convert(u8 type, u8 code, int *err)
 	switch (type) {
 	case ICMPV6_DEST_UNREACH:
 		fatal = 1;
-		if (code <= ICMPV6_PORT_UNREACH) {
+		if (code < ARRAY_SIZE(tab_unreach)) {
 			*err  = tab_unreach[code].err;
 			fatal = tab_unreach[code].fatal;
 		}
-- 
1.7.12.2.21.g234cd45.dirty



