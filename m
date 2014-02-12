Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbaBLIRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:17:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50352 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbaBLION (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Thomas Graf" <tgraf@suug.ch>,
        "Patrick McHardy" <kaber@trash.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Bob Falken" <NetFestivalHaveFun@gmx.com>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Julian Anastasov" <ja@ssi.bg>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.947931583@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 17/79] net: avoid reference counter overflows on
 fib_rules in  multicast forwarding
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 95f4a45de1a0f172b35451fc52283290adb21f6e ]

Bob Falken reported that after 4G packets, multicast forwarding stopped
working. This was because of a rule reference counter overflow which
freed the rule as soon as the overflow happend.

This patch solves this by adding the FIB_LOOKUP_NOREF flag to
fib_rules_lookup calls. This is safe even from non-rcu locked sections
as in this case the flag only implies not taking a reference to the rule,
which we don't need at all.

Rules only hold references to the namespace, which are guaranteed to be
available during the call of the non-rcu protected function reg_vif_xmit
because of the interface reference which itself holds a reference to
the net namespace.

Fixes: f0ad0860d01e47 ("ipv4: ipmr: support multiple tables")
Fixes: d1db275dd3f6e4 ("ipv6: ip6mr: support multiple tables")
Reported-by: Bob Falken <NetFestivalHaveFun@gmx.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/ipmr.c  | 7 +++++--
 net/ipv6/ip6mr.c | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index b5e64e4..140d377 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -155,9 +155,12 @@ static struct mr_table *ipmr_get_table(struct net *net, u32 id)
 static int ipmr_fib_lookup(struct net *net, struct flowi4 *flp4,
 			   struct mr_table **mrt)
 {
-	struct ipmr_result res;
-	struct fib_lookup_arg arg = { .result = &res, };
 	int err;
+	struct ipmr_result res;
+	struct fib_lookup_arg arg = {
+		.result = &res,
+		.flags = FIB_LOOKUP_NOREF,
+	};
 
 	err = fib_rules_lookup(net->ipv4.mr_rules_ops,
 			       flowi4_to_flowi(flp4), 0, &arg);
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index f5af259..f96c96f 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -139,9 +139,12 @@ static struct mr6_table *ip6mr_get_table(struct net *net, u32 id)
 static int ip6mr_fib_lookup(struct net *net, struct flowi6 *flp6,
 			    struct mr6_table **mrt)
 {
-	struct ip6mr_result res;
-	struct fib_lookup_arg arg = { .result = &res, };
 	int err;
+	struct ip6mr_result res;
+	struct fib_lookup_arg arg = {
+		.result = &res,
+		.flags = FIB_LOOKUP_NOREF,
+	};
 
 	err = fib_rules_lookup(net->ipv6.mr6_rules_ops,
 			       flowi6_to_flowi(flp6), 0, &arg);

