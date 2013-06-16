Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3FPVVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 17:21:06 -0400
Received: from mout.web.de ([212.227.15.4]:50969 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab3FPVVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 17:21:04 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: bridge@lists.linux-foundation.org
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCH] bridge: fix switched interval for MLD Query types
Date: Sun, 16 Jun 2013 23:20:34 +0200
Message-Id: <1371417634-29803-1-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:zmC5WoLViz8MQv+GOOHzBjKAYZmsKLZL+w4DzJW0DPo/ogljygU
 l7QreXDgDwVh1+kXAxNSuq3P/34oZWmpdeDhqXXw4wF7lNE9eKEZerme7kD2oPHQSCsBCsi
 G4OxixJ9kvotoJ/wVgcDnByA00hUqTBnuJUoSo8Bcnin8sJjIbVP+TImqXVagqQEgethVxq
 9aq4Fy6DBlpRgT156kxhA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

General Queries (the one with the Multicast Address field
set to zero / '::') are supposed to have a Maximum Response Delay
of [Query Response Interval], while for Multicast-Address-Specific
Queries it is [Last Listener Query Interval] - not the other way
round. (see RFC2710, section 7.3+7.8)

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
 net/bridge/br_multicast.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 81f2389..d6448e3 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -465,8 +465,9 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
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
1.7.10.4

