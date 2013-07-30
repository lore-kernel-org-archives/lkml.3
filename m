Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab3G3S5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:57:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56522 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3G3Spd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:45:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 46/75] bridge: fix switched interval for MLD Query types
Date: Tue, 30 Jul 2013 11:44:50 -0700
Message-Id: <1375209919-1768-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>

[ Upstream commit 32de868cbc6bee010d2cee95b5071b25ecbec8c3 ]

General Queries (the one with the Multicast Address field
set to zero / '::') are supposed to have a Maximum Response Delay
of [Query Response Interval], while for Multicast-Address-Specific
Queries it is [Last Listener Query Interval] - not the other way
round. (see RFC2710, section 7.3+7.8)

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bridge/br_multicast.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 6d6f265..155bc05 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -458,8 +458,9 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
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
1.8.1.2

