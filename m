Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab3DBWNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:13:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933533Ab3DBWNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:13:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hong Zhiguo <honkiko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 115/124] ipv6: fix bad free of addrconf_init_net
Date: Tue,  2 Apr 2013 15:11:37 -0700
Message-Id: <20130402221117.508630337@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Hong Zhiguo <honkiko@gmail.com>

[ Upstream commit a79ca223e029aa4f09abb337accf1812c900a800 ]

Signed-off-by: Hong Zhiguo <honkiko@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4787,26 +4787,20 @@ static void addrconf_sysctl_unregister(s
 
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


