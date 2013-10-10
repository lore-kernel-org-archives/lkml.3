Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab3JJPss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:48:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52872 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab3JJPsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:48:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Bohac <jbohac@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 024/104] ICMPv6: treat dest unreachable codes 5 and 6 as EACCES, not EPROTO
Date: Thu, 10 Oct 2013 08:41:12 -0700
Message-Id: <1381419752-29733-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/uapi/linux/icmpv6.h |  2 ++
 net/ipv6/icmp.c             | 10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/icmpv6.h b/include/uapi/linux/icmpv6.h
index e0133c7..590beda 100644
--- a/include/uapi/linux/icmpv6.h
+++ b/include/uapi/linux/icmpv6.h
@@ -115,6 +115,8 @@ struct icmp6hdr {
 #define ICMPV6_NOT_NEIGHBOUR		2
 #define ICMPV6_ADDR_UNREACH		3
 #define ICMPV6_PORT_UNREACH		4
+#define ICMPV6_POLICY_FAIL		5
+#define ICMPV6_REJECT_ROUTE		6
 
 /*
  *	Codes for Time Exceeded
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index fff5bdd..7463f05 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -924,6 +924,14 @@ static const struct icmp6_err {
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
@@ -935,7 +943,7 @@ int icmpv6_err_convert(u8 type, u8 code, int *err)
 	switch (type) {
 	case ICMPV6_DEST_UNREACH:
 		fatal = 1;
-		if (code <= ICMPV6_PORT_UNREACH) {
+		if (code < ARRAY_SIZE(tab_unreach)) {
 			*err  = tab_unreach[code].err;
 			fatal = tab_unreach[code].fatal;
 		}
-- 
1.8.1.2

