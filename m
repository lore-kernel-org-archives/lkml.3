Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaCJDkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 23:40:23 -0400
Received: from mout.web.de ([212.227.15.3]:51659 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbaCJDkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 23:40:21 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>,
        Florian Westphal <fwestpha@redhat.com>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCH 1/2] bridge: multicast: add sanity check for general query destination
Date: Mon, 10 Mar 2014 04:39:45 +0100
Message-Id: <1394422786-1683-1-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:tukWoUL12tOS2Z+iKSXhDEae340XRPwHil2wfr5jhA2XVr/GG6o
 IDttcIY8gnx5HXGMRRRvje9mOr3+EwgpEb/ozAOnQpEvmh4ctHpeNVIq65z0+mi+kD68Bl/
 q6jywJIj0064sBFQYAvDuGPc62e7mNWlfoPY0q4iusTrTchy3hLiZg6YLgLpmlq8nvDU1sY
 6k04PgIktqY8EUqqjFCeA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

General IGMP and MLD queries are supposed to have the multicast
link-local all-nodes address as their destination according to RFC2236
section 9, RFC3376 section 4.1.12/9.1, RFC2710 section 8 and RFC3810
section 5.1.15.

Without this check, such malformed IGMP/MLD queries can result in a
denial of service: The queries are ignored by most IGMP/MLD listeners
therefore they will not respond with an IGMP/MLD report. However,
without this patch these malformed MLD queries would enable the
snooping part in the bridge code, potentially shutting down the
according ports towards these hosts for multicast traffic as the
bridge did not learn about these listeners.

Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
 net/bridge/br_multicast.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index fb0e36f..c77f073 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1181,6 +1181,14 @@ static int br_ip4_multicast_query(struct net_bridge *br,
 			    IGMPV3_MRC(ih3->code) * (HZ / IGMP_TIMER_SCALE) : 1;
 	}
 
+	/* RFC2236+RFC3376 (IGMPv2+IGMPv3) require the multicast link layer
+	 * all-systems destination addresses (224.0.0.1) for general queries
+	 */
+	if (!group && iph->daddr != htonl(INADDR_ALLHOSTS_GROUP)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	br_multicast_query_received(br, port, &br->ip4_querier, !!iph->saddr,
 				    max_delay);
 
@@ -1228,6 +1236,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 	unsigned long max_delay;
 	unsigned long now = jiffies;
 	const struct in6_addr *group = NULL;
+	bool is_general_query;
 	int err = 0;
 
 	spin_lock(&br->multicast_lock);
@@ -1262,6 +1271,16 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		max_delay = max(msecs_to_jiffies(mldv2_mrc(mld2q)), 1UL);
 	}
 
+	is_general_query = group && ipv6_addr_any(group) ? true : false;
+
+	/* RFC2710+RFC3810 (MLDv1+MLDv2) require the multicast link layer
+	 * all-nodes destination address (ff02::1) for general queries
+	 */
+	if (is_general_query && !ipv6_addr_is_ll_all_nodes(&ip6h->daddr)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	br_multicast_query_received(br, port, &br->ip6_querier,
 				    !ipv6_addr_any(&ip6h->saddr), max_delay);
 
-- 
1.7.10.4

