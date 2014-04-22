Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbaDVUPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:15:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36120 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763AbaDVUPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:15:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 002/133] bridge: multicast: add sanity check for query source addresses
Date: Tue, 22 Apr 2014 13:12:20 -0700
Message-Id: <1398197671-12786-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>

[ Upstream commit 6565b9eeef194afbb3beec80d6dd2447f4091f8c ]

MLD queries are supposed to have an IPv6 link-local source address
according to RFC2710, section 4 and RFC3810, section 5.1.14. This patch
adds a sanity check to ignore such broken MLD queries.

Without this check, such malformed MLD queries can result in a
denial of service: The queries are ignored by any MLD listener
therefore they will not respond with an MLD report. However,
without this patch these malformed MLD queries would enable the
snooping part in the bridge code, potentially shutting down the
according ports towards these hosts for multicast traffic as the
bridge did not learn about these listeners.

Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Linus Lüssing <linus.luessing@web.de>
Reviewed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bridge/br_multicast.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index fda703b..9861fff 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1158,6 +1158,12 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 
 	br_multicast_query_received(br, port, !ipv6_addr_any(&ip6h->saddr));
 
+	/* RFC2710+RFC3810 (MLDv1+MLDv2) require link-local source addresses */
+	if (!(ipv6_addr_type(&ip6h->saddr) & IPV6_ADDR_LINKLOCAL)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (skb->len == sizeof(*mld)) {
 		if (!pskb_may_pull(skb, sizeof(*mld))) {
 			err = -EINVAL;
-- 
1.9.1

