Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaD1Bbr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42840 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "Jan Stancek" <jstancek@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "=?UTF-8?q?Linus=20L=C3=BCssing?=" <linus.luessing@web.de>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.203367043@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 02/94] bridge: multicast: add sanity check for query
 source  addresses
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Lüssing <linus.luessing@web.de>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bridge/br_multicast.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1138,6 +1138,12 @@ static int br_ip6_multicast_query(struct
 
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

