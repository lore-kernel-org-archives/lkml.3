Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3BLUfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:35:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab3BLUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 19/61] net, wireless: overwrite default_ethtool_ops
Date: Tue, 12 Feb 2013 12:34:39 -0800
Message-Id: <20130212203420.957757920@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Stanislaw Gruszka <sgruszka@redhat.com>

[ Upstream commit d07d7507bfb4e23735c9b83e397c43e1e8a173e8 ]

Since:

commit 2c60db037034d27f8c636403355d52872da92f81
Author: Eric Dumazet <edumazet@google.com>
Date:   Sun Sep 16 09:17:26 2012 +0000

    net: provide a default dev->ethtool_ops

wireless core does not correctly assign ethtool_ops.

After alloc_netdev*() call, some cfg80211 drivers provide they own
ethtool_ops, but some do not. For them, wireless core provide generic
cfg80211_ethtool_ops, which is assigned in NETDEV_REGISTER notify call:

        if (!dev->ethtool_ops)
                dev->ethtool_ops = &cfg80211_ethtool_ops;

But after Eric's commit, dev->ethtool_ops is no longer NULL (on cfg80211
drivers without custom ethtool_ops), but points to &default_ethtool_ops.

In order to fix the problem, provide function which will overwrite
default_ethtool_ops and use it by wireless core.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    3 +++
 net/core/dev.c            |    8 ++++++++
 net/wireless/core.c       |    3 +--
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -60,6 +60,9 @@ struct wireless_dev;
 #define SET_ETHTOOL_OPS(netdev,ops) \
 	( (netdev)->ethtool_ops = (ops) )
 
+extern void netdev_set_default_ethtool_ops(struct net_device *dev,
+					   const struct ethtool_ops *ops);
+
 /* hardware address assignment types */
 #define NET_ADDR_PERM		0	/* address is permanent (default) */
 #define NET_ADDR_RANDOM		1	/* address is generated randomly */
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6012,6 +6012,14 @@ struct netdev_queue *dev_ingress_queue_c
 
 static const struct ethtool_ops default_ethtool_ops;
 
+void netdev_set_default_ethtool_ops(struct net_device *dev,
+				    const struct ethtool_ops *ops)
+{
+	if (dev->ethtool_ops == &default_ethtool_ops)
+		dev->ethtool_ops = ops;
+}
+EXPORT_SYMBOL_GPL(netdev_set_default_ethtool_ops);
+
 /**
  *	alloc_netdev_mqs - allocate network device
  *	@sizeof_priv:	size of private data to allocate space for
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -856,8 +856,7 @@ static int cfg80211_netdev_notifier_call
 		/* allow mac80211 to determine the timeout */
 		wdev->ps_timeout = -1;
 
-		if (!dev->ethtool_ops)
-			dev->ethtool_ops = &cfg80211_ethtool_ops;
+		netdev_set_default_ethtool_ops(dev, &cfg80211_ethtool_ops);
 
 		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
 		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT ||


