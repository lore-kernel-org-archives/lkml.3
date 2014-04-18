Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaDRJns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:43:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45923 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 26/72] bridge: multicast: add sanity check for query source addresses
Date: Fri, 18 Apr 2014 11:21:59 +0200
Message-Id: <f8adfb6467c0b6385cd3855520d3b6afa2bfc9ee.1397812482.git.jslaby@suse.cz>
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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bridge/br_multicast.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 1b148a3affa7..b98627e902e7 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1238,6 +1238,12 @@ static int br_ip6_multicast_query(struct net_bridge *br,
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
1.9.2

