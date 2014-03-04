Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbaCDC5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:57:48 -0500
Received: from mout.web.de ([212.227.15.3]:54881 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929AbaCDC5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:57:46 -0500
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>,
        Florian Westphal <fwestpha@redhat.com>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCH] bridge: multicast: add sanity check for query source addresses
Date: Tue,  4 Mar 2014 03:57:35 +0100
Message-Id: <1393901855-18231-1-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:+iLylx3khIMy5UaaYok5M3rpxiCUNfSnfthvKabSV7h0zLfOKLZ
 aD6Zc/h1N9iUKlBdWEsi66lXYC48GITy6ZpgU5ughSkcBFmucg6cHfQE/frI7Iots9sqtvG
 nSM5F00U96lavRfHUatYhMav8CScejXbxu/mHOqUkeQatsVAW6qv11BVHlKO1SvKoSPDyED
 2CnSGMEe1i5nqgaN25uiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 net/bridge/br_multicast.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index ef66365..fb0e36f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1235,6 +1235,12 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 	    (port && port->state == BR_STATE_DISABLED))
 		goto out;
 
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
1.7.10.4

