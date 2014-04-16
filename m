Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbaDPKce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:32:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51653 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbaDPKcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 12/46] bridge: multicast: add sanity check for query source addresses
Date: Wed, 16 Apr 2014 11:31:28 +0100
Message-Id: <1397644322-13905-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>

commit 6565b9eeef194afbb3beec80d6dd2447f4091f8c upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/bridge/br_multicast.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index b02fb47..29ff042 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1237,6 +1237,12 @@ static int br_ip6_multicast_query(struct net_bridge *br,
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
1.9.1

