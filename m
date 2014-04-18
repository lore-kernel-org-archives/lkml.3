Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaDRJkC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:40:02 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45951 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 40/72] bridge: multicast: add sanity check for general query destination
Date: Fri, 18 Apr 2014 11:22:13 +0200
Message-Id: <b8d3ded97fc1d1765a352f8315ad65d6ef302e9c.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 9ed973cc40c588abeaa58aea0683ea665132d11d ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bridge/br_multicast.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index b98627e902e7..4af88e2a33c4 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1183,6 +1183,14 @@ static int br_ip4_multicast_query(struct net_bridge *br,
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
 
@@ -1230,6 +1238,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 	unsigned long max_delay;
 	unsigned long now = jiffies;
 	const struct in6_addr *group = NULL;
+	bool is_general_query;
 	int err = 0;
 	u16 vid = 0;
 
@@ -1265,6 +1274,16 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		max_delay = max(msecs_to_jiffies(mldv2_mrc(mld2q)), 1UL);
 	}
 
+	is_general_query = group && ipv6_addr_any(group);
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
1.9.2

