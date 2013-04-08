Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936154Ab3DHKC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:02:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42960 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935845Ab3DHJwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hong Zhiguo <honkiko@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 076/102] ipv6: fix bad free of addrconf_init_net
Date: Mon,  8 Apr 2013 10:50:31 +0100
Message-Id: <1365414657-29191-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hong Zhiguo <honkiko@gmail.com>

commit a79ca223e029aa4f09abb337accf1812c900a800 upstream.

Signed-off-by: Hong Zhiguo <honkiko@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/addrconf.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index fc9ac78..00188b3 100644
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
-- 
1.8.1.2

