Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934577Ab3DGW42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 18:56:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46346 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934539Ab3DGW4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 18:56:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Hong Zhiguo" <honkiko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 07 Apr 2013 23:45:43 +0100
Message-ID: <lsq.1365374743.145534820@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [67/74] ipv6: fix bad free of addrconf_init_net
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hong Zhiguo <honkiko@gmail.com>

[ Upstream commit a79ca223e029aa4f09abb337accf1812c900a800 ]

Signed-off-by: Hong Zhiguo <honkiko@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/addrconf.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b27baed..8589c2d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4658,26 +4658,20 @@ static void addrconf_sysctl_unregister(struct inet6_dev *idev)
 
 static int __net_init addrconf_init_net(struct net *net)
 {
-	int err;
+	int err = -ENOMEM;
 	struct ipv6_devconf *all, *dflt;
 
-	err = -ENOMEM;
-	all = &ipv6_devconf;
-	dflt = &ipv6_devconf_dflt;
+	all = kmemdup(&ipv6_devconf, sizeof(ipv6_devconf), GFP_KERNEL);
+	if (all == NULL)
+		goto err_alloc_all;
 
-	if (!net_eq(net, &init_net)) {
-		all = kmemdup(all, sizeof(ipv6_devconf), GFP_KERNEL);
-		if (all == NULL)
-			goto err_alloc_all;
+	dflt = kmemdup(&ipv6_devconf_dflt, sizeof(ipv6_devconf_dflt), GFP_KERNEL);
+	if (dflt == NULL)
+		goto err_alloc_dflt;
 
-		dflt = kmemdup(dflt, sizeof(ipv6_devconf_dflt), GFP_KERNEL);
-		if (dflt == NULL)
-			goto err_alloc_dflt;
-	} else {
-		/* these will be inherited by all namespaces */
-		dflt->autoconf = ipv6_defaults.autoconf;
-		dflt->disable_ipv6 = ipv6_defaults.disable_ipv6;
-	}
+	/* these will be inherited by all namespaces */
+	dflt->autoconf = ipv6_defaults.autoconf;
+	dflt->disable_ipv6 = ipv6_defaults.disable_ipv6;
 
 	net->ipv6.devconf_all = all;
 	net->ipv6.devconf_dflt = dflt;

