Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab3G3JwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:52:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53102 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730Ab3G3Jc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 041/106] bridge: fix switched interval for MLD Query types
Date: Tue, 30 Jul 2013 10:31:00 +0100
Message-Id: <1375176725-5825-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>

commit 32de868cbc6bee010d2cee95b5071b25ecbec8c3 upstream.

General Queries (the one with the Multicast Address field
set to zero / '::') are supposed to have a Maximum Response Delay
of [Query Response Interval], while for Multicast-Address-Specific
Queries it is [Last Listener Query Interval] - not the other way
round. (see RFC2710, section 7.3+7.8)

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/bridge/br_multicast.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index b665812..4c1954b 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -469,8 +469,9 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 	skb_set_transport_header(skb, skb->len);
 	mldq = (struct mld_msg *) icmp6_hdr(skb);
 
-	interval = ipv6_addr_any(group) ? br->multicast_last_member_interval :
-					  br->multicast_query_response_interval;
+	interval = ipv6_addr_any(group) ?
+			br->multicast_query_response_interval :
+			br->multicast_last_member_interval;
 
 	mldq->mld_type = ICMPV6_MGM_QUERY;
 	mldq->mld_code = 0;
-- 
1.8.3.2

