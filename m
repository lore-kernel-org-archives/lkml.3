Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaBGLZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:25:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41246 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbaBGLZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:25:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrick McHardy <kaber@trash.net>, Thomas Graf <tgraf@suug.ch>,
        Julian Anastasov <ja@ssi.bg>, Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 82/88] net: avoid reference counter overflows on fib_rules in multicast forwarding
Date: Fri,  7 Feb 2014 11:23:19 +0000
Message-Id: <1391772205-22239-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 95f4a45de1a0f172b35451fc52283290adb21f6e upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ipmr.c  | 7 +++++--
 net/ipv6/ip6mr.c | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index f780fa3..7fa2594 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -154,9 +154,12 @@ static struct mr_table *ipmr_get_table(struct net *net, u32 id)
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
index 65dff8a..2df3e4a 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -138,9 +138,12 @@ static struct mr6_table *ip6mr_get_table(struct net *net, u32 id)
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
-- 
1.8.3.2

