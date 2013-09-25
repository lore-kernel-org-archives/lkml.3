Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3IYJ0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 05:26:46 -0400
Received: from mx0.eldamar.org.uk ([78.47.157.133]:36892 "EHLO
	mx0.eldamar.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3IYJ0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 05:26:44 -0400
Date: Wed, 25 Sep 2013 10:26:38 +0100
From: Alexander Frolkin <avf@eldamar.org.uk>
To: Simon Horman <horms@verge.net.au>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Julian Anastasov <ja@ssi.bg>, lvs-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: improved SH fallback strategy
Message-ID: <20130925092638.GD19768@eldamar.org.uk>
References: <20130923115139.GA15034@eldamar.org.uk>
 <524099BA.5020303@cogentembedded.com>
 <20130924093238.GD18494@eldamar.org.uk>
 <20130925003033.GG26081@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925003033.GG26081@verge.net.au>
X-GPG-Key-Fingerprint: 7820 960F C361 C9CE 401F  D07D 993A 2951 D970 4FA4
X-Operating-System: Linux 3.2.0-41-generic
X-Editor: Vi
X-Uptime: 10:32:43 up 134 days, 19:57, 11 users,  load average: 0.31, 0.43,
 0.45
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the SH fallback realserver selection strategy.

With sh and sh-fallback, if a realserver is down, this attempts to
distribute the traffic that would have gone to that server evenly
among the remaining servers.
 
Signed-off-by: Alexander Frolkin <avf@eldamar.org.uk>

--
diff --git a/net/netfilter/ipvs/ip_vs_sh.c b/net/netfilter/ipvs/ip_vs_sh.c
index 3588fae..3d5ab7c 100644
--- a/net/netfilter/ipvs/ip_vs_sh.c
+++ b/net/netfilter/ipvs/ip_vs_sh.c
@@ -115,27 +115,47 @@ ip_vs_sh_get(struct ip_vs_service *svc, struct ip_vs_sh_state *s,
 }
 
 
-/* As ip_vs_sh_get, but with fallback if selected server is unavailable */
+/* As ip_vs_sh_get, but with fallback if selected server is unavailable
+ *
+ * The fallback strategy loops around the table starting from a "random"
+ * point (in fact, it is chosen to be the original hash value to make the
+ * algorithm deterministic) to find a new server.
+ */
 static inline struct ip_vs_dest *
 ip_vs_sh_get_fallback(struct ip_vs_service *svc, struct ip_vs_sh_state *s,
 		      const union nf_inet_addr *addr, __be16 port)
 {
-	unsigned int offset;
-	unsigned int hash;
+	unsigned int offset, roffset;
+	unsigned int hash, ihash;
 	struct ip_vs_dest *dest;
 
-	for (offset = 0; offset < IP_VS_SH_TAB_SIZE; offset++) {
-		hash = ip_vs_sh_hashkey(svc->af, addr, port, offset);
-		dest = rcu_dereference(s->buckets[hash].dest);
-		if (!dest)
-			break;
-		if (is_unavailable(dest))
-			IP_VS_DBG_BUF(6, "SH: selected unavailable server "
-				      "%s:%d (offset %d)",
+	/* first try the dest it's supposed to go to */
+	ihash = ip_vs_sh_hashkey(svc->af, addr, port, 0);
+	dest = rcu_dereference(s->buckets[ihash].dest);
+	if (!dest)
+		return NULL;
+	if (is_unavailable(dest)) {
+		IP_VS_DBG_BUF(6, "SH: selected unavailable server "
+		      "%s:%d, reselecting",
+		      IP_VS_DBG_ADDR(svc->af, &dest->addr),
+		      ntohs(dest->port));
+		/* if the original dest is unavailable, loop around the table
+		 * starting from ihash to find a new dest
+		 */
+		for (offset = 0; offset < IP_VS_SH_TAB_SIZE; offset++) {
+			roffset = (offset + ihash) % IP_VS_SH_TAB_SIZE;
+			hash = ip_vs_sh_hashkey(svc->af, addr, port, roffset);
+			dest = rcu_dereference(s->buckets[hash].dest);
+			if (is_unavailable(dest))
+				IP_VS_DBG_BUF(6, "SH: selected unavailable "
+				      "server %s:%d (offset %d), reselecting",
 				      IP_VS_DBG_ADDR(svc->af, &dest->addr),
-				      ntohs(dest->port), offset);
-		else
-			return dest;
+				      ntohs(dest->port), roffset);
+			else
+				return dest;
+		}
+	} else {
+		return dest;
 	}
 
 	return NULL;

