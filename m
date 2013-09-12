Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab3ILRsC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:48:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab3ILRpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:45:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Bohac <jbohac@suse.cz>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 15/23] ICMPv6: treat dest unreachable codes 5 and 6 as EACCES, not EPROTO
Date: Thu, 12 Sep 2013 10:45:11 -0700
Message-Id: <20130912174453.396621027@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912174451.748805761@linuxfoundation.org>
References: <20130912174451.748805761@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/icmpv6.h |    2 ++
 net/ipv6/icmp.c        |   10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -123,6 +123,8 @@ static inline struct icmp6hdr *icmp6_hdr
 #define ICMPV6_NOT_NEIGHBOUR		2
 #define ICMPV6_ADDR_UNREACH		3
 #define ICMPV6_PORT_UNREACH		4
+#define ICMPV6_POLICY_FAIL		5
+#define ICMPV6_REJECT_ROUTE		6
 
 /*
  *	Codes for Time Exceeded
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
@@ -928,7 +936,7 @@ int icmpv6_err_convert(u8 type, u8 code,
 	switch (type) {
 	case ICMPV6_DEST_UNREACH:
 		fatal = 1;
-		if (code <= ICMPV6_PORT_UNREACH) {
+		if (code < ARRAY_SIZE(tab_unreach)) {
 			*err  = tab_unreach[code].err;
 			fatal = tab_unreach[code].fatal;
 		}


