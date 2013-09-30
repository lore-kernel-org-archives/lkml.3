Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab3I3K2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:28:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43598 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab3I3KMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Bohac <jbohac@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 052/104] ICMPv6: treat dest unreachable codes 5 and 6 as EACCES, not EPROTO
Date: Mon, 30 Sep 2013 11:10:29 +0100
Message-Id: <1380535881-9239-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Bohac <jbohac@suse.cz>

commit 61e76b178dbe7145e8d6afa84bb4ccea71918994 upstream.

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
[ luis: backported to 3.5:
  - adjusted context
  - include/uapi/linux/icmpv6.h -> include/linux/icmpv6.h ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/icmpv6.h |  2 ++
 net/ipv6/icmp.c        | 10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index ba45e6b..f5a21d0 100644
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
index 091a297..2da16f0 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -917,6 +917,14 @@ static const struct icmp6_err {
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
@@ -928,7 +936,7 @@ int icmpv6_err_convert(u8 type, u8 code, int *err)
 	switch (type) {
 	case ICMPV6_DEST_UNREACH:
 		fatal = 1;
-		if (code <= ICMPV6_PORT_UNREACH) {
+		if (code < ARRAY_SIZE(tab_unreach)) {
 			*err  = tab_unreach[code].err;
 			fatal = tab_unreach[code].fatal;
 		}
-- 
1.8.3.2

