Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaCJV0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:26:24 -0400
Received: from mout.web.de ([212.227.15.3]:49988 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbaCJV0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:26:21 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>,
        Florian Westphal <fwestpha@redhat.com>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCHv2 2/2] bridge: multicast: enable snooping on general queries only
Date: Mon, 10 Mar 2014 22:25:25 +0100
Message-Id: <1394486725-4992-2-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394486725-4992-1-git-send-email-linus.luessing@web.de>
References: <1394486725-4992-1-git-send-email-linus.luessing@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:DYwpeG8zfrxme4jbwEYi/PAEYdWWHTV7IHOEdVLZTgFY3v2hdMw
 FTYfR8qn06n25SVP1k5h6G1kCoB30r3JRWbRxMHLOptEQRMz0+8oT+bhquCiGGVtDndAiv0
 sTTlWChEVpMzQU7vmTK6N18i3n+xE35DJns/eKF5gCPv8A8Jb0kEGsomhumB6ibYw7c4lE7
 ZeiJ1+N0LPDEzGuYbwQEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this check someone could easily create a denial of service
by injecting multicast-specific queries to enable the bridge
snooping part if no real querier issuing periodic general queries
is present on the link which would result in the bridge wrongly
shutting down ports for multicast traffic as the bridge did not learn
about these listeners.

With this patch the snooping code is enabled upon receiving valid,
general queries only.

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
v2: unchanged

 net/bridge/br_multicast.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index e56bae4..93067ec 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1127,9 +1127,10 @@ static void br_multicast_query_received(struct net_bridge *br,
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
@@ -1190,7 +1191,7 @@ static int br_ip4_multicast_query(struct net_bridge *br,
 	}
 
 	br_multicast_query_received(br, port, &br->ip4_querier, !!iph->saddr,
-				    max_delay);
+				    !group, max_delay);
 
 	if (!group)
 		goto out;
@@ -1282,7 +1283,8 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 	}
 
 	br_multicast_query_received(br, port, &br->ip6_querier,
-				    !ipv6_addr_any(&ip6h->saddr), max_delay);
+				    !ipv6_addr_any(&ip6h->saddr),
+				    is_general_query, max_delay);
 
 	if (!group)
 		goto out;
-- 
1.7.10.4

