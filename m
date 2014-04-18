Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaDRJj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:39:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45952 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 41/72] bridge: multicast: enable snooping on general queries only
Date: Fri, 18 Apr 2014 11:22:14 +0200
Message-Id: <9ee68ddbab843386afdcc369acf8a96c28b6cdf2.1397812482.git.jslaby@suse.cz>
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

[ Upstream commit 20a599bec95a52fa72432b2376a2ce47c5bb68fb ]

Without this check someone could easily create a denial of service
by injecting multicast-specific queries to enable the bridge
snooping part if no real querier issuing periodic general queries
is present on the link which would result in the bridge wrongly
shutting down ports for multicast traffic as the bridge did not learn
about these listeners.

With this patch the snooping code is enabled upon receiving valid,
general queries only.

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bridge/br_multicast.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 4af88e2a33c4..162d6c78ad05 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1129,9 +1129,10 @@ static void br_multicast_query_received(struct net_bridge *br,
 					struct net_bridge_port *port,
 					struct bridge_mcast_querier *querier,
 					int saddr,
+					bool is_general_query,
 					unsigned long max_delay)
 {
-	if (saddr)
+	if (saddr && is_general_query)
 		br_multicast_update_querier_timer(br, querier, max_delay);
 	else if (timer_pending(&querier->timer))
 		return;
@@ -1192,7 +1193,7 @@ static int br_ip4_multicast_query(struct net_bridge *br,
 	}
 
 	br_multicast_query_received(br, port, &br->ip4_querier, !!iph->saddr,
-				    max_delay);
+				    !group, max_delay);
 
 	if (!group)
 		goto out;
@@ -1285,7 +1286,8 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 	}
 
 	br_multicast_query_received(br, port, &br->ip6_querier,
-				    !ipv6_addr_any(&ip6h->saddr), max_delay);
+				    !ipv6_addr_any(&ip6h->saddr),
+				    is_general_query, max_delay);
 
 	if (!group)
 		goto out;
-- 
1.9.2

