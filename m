Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab3APQHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:07:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36410 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541Ab3APQHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:07:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 149/222] inet_diag: avoid unsafe and nonsensical prefix matches in inet_diag_bc_run()
Date: Wed, 16 Jan 2013 13:55:49 -0200
Message-Id: <1358351822-7675-150-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

commit f67caec9068cee426ec23cf9005a1dee2ecad187 upstream.

Add logic to check the address family of the user-supplied conditional
and the address family of the connection entry. We now do not do
prefix matching of addresses from different address families (AF_INET
vs AF_INET6), except for the previously existing support for having an
IPv4 prefix match an IPv4-mapped IPv6 address (which this commit
maintains as-is).

This change is needed for two reasons:

(1) The addresses are different lengths, so comparing a 128-bit IPv6
prefix match condition to a 32-bit IPv4 connection address can cause
us to unwittingly walk off the end of the IPv4 address and read
garbage or oops.

(2) The IPv4 and IPv6 address spaces are semantically distinct, so a
simple bit-wise comparison of the prefixes is not meaningful, and
would lead to bogus results (except for the IPv4-mapped IPv6 case,
which this commit maintains).

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/inet_diag.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index efeca3b..5d57af1 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -423,25 +423,31 @@ static int inet_diag_bc_run(const struct nlattr *_bc,
 				break;
 			}
 
-			if (cond->prefix_len == 0)
-				break;
-
 			if (op->code == INET_DIAG_BC_S_COND)
 				addr = entry->saddr;
 			else
 				addr = entry->daddr;
 
+			if (cond->family != AF_UNSPEC &&
+			    cond->family != entry->family) {
+				if (entry->family == AF_INET6 &&
+				    cond->family == AF_INET) {
+					if (addr[0] == 0 && addr[1] == 0 &&
+					    addr[2] == htonl(0xffff) &&
+					    bitstring_match(addr + 3,
+							    cond->addr,
+							    cond->prefix_len))
+						break;
+				}
+				yes = 0;
+				break;
+			}
+
+			if (cond->prefix_len == 0)
+				break;
 			if (bitstring_match(addr, cond->addr,
 					    cond->prefix_len))
 				break;
-			if (entry->family == AF_INET6 &&
-			    cond->family == AF_INET) {
-				if (addr[0] == 0 && addr[1] == 0 &&
-				    addr[2] == htonl(0xffff) &&
-				    bitstring_match(addr + 3, cond->addr,
-						    cond->prefix_len))
-					break;
-			}
 			yes = 0;
 			break;
 		}
-- 
1.7.9.5

