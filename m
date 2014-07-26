Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaGZTLy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:11:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbaGZTKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:10:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Loic Prylli <loicp@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 47/87] net: Fix NETDEV_CHANGE notifier usage causing spurious arp flush
Date: Sat, 26 Jul 2014 12:02:21 -0700
Message-Id: <20140726190216.058162642@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Prylli <loicp@google.com>

[ Upstream commit 54951194656e4853e441266fd095f880bc0398f3 ]

A bug was introduced in NETDEV_CHANGE notifier sequence causing the
arp table to be sometimes spuriously cleared (including manual arp
entries marked permanent), upon network link carrier changes.

The changed argument for the notifier was applied only to a single
caller of NETDEV_CHANGE, missing among others netdev_state_change().
So upon net_carrier events induced by the network, which are
triggering a call to netdev_state_change(), arp_netdev_event() would
decide whether to clear or not arp cache based on random/junk stack
values (a kind of read buffer overflow).

Fixes: be9efd365328 ("net: pass changed flags along with NETDEV_CHANGE event")
Fixes: 6c8b4e3ff81b ("arp: flush arp cache on IFF_NOARP change")
Signed-off-by: Loic Prylli <loicp@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -148,6 +148,9 @@ struct list_head ptype_all __read_mostly
 static struct list_head offload_base __read_mostly;
 
 static int netif_rx_internal(struct sk_buff *skb);
+static int call_netdevice_notifiers_info(unsigned long val,
+					 struct net_device *dev,
+					 struct netdev_notifier_info *info);
 
 /*
  * The @dev_base_head list is protected by @dev_base_lock and the rtnl
@@ -1207,7 +1210,11 @@ EXPORT_SYMBOL(netdev_features_change);
 void netdev_state_change(struct net_device *dev)
 {
 	if (dev->flags & IFF_UP) {
-		call_netdevice_notifiers(NETDEV_CHANGE, dev);
+		struct netdev_notifier_change_info change_info;
+
+		change_info.flags_changed = 0;
+		call_netdevice_notifiers_info(NETDEV_CHANGE, dev,
+					      &change_info.info);
 		rtmsg_ifinfo(RTM_NEWLINK, dev, 0, GFP_KERNEL);
 	}
 }


