Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942AbaE2FUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:20:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932534AbaE2Ef2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 082/140] net: Allow for more then a single subclass for netif_addr_lock
Date: Wed, 28 May 2014 21:33:41 -0700
Message-Id: <20140529043100.165494770@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit 25175ba5c9bff9aaf0229df34bb5d54c81633ec3 ]

Currently netif_addr_lock_nested assumes that there can be only
a single nesting level between 2 devices.  However, if we
have multiple devices of the same type stacked, this fails.
For example:
 eth0 <-- vlan0.10 <-- vlan0.10.20

A more complicated configuration may stack more then one type of
device in different order.
Ex:
  eth0 <-- vlan0.10 <-- macvlan0 <-- vlan1.10.20 <-- macvlan1

This patch adds an ndo_* function that allows each stackable
device to report its nesting level.  If the device doesn't
provide this function default subclass of 1 is used.

Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1145,6 +1145,7 @@ struct net_device_ops {
 	netdev_tx_t		(*ndo_dfwd_start_xmit) (struct sk_buff *skb,
 							struct net_device *dev,
 							void *priv);
+	int			(*ndo_get_lock_subclass)(struct net_device *dev);
 };
 
 /*
@@ -2861,7 +2862,12 @@ static inline void netif_addr_lock(struc
 
 static inline void netif_addr_lock_nested(struct net_device *dev)
 {
-	spin_lock_nested(&dev->addr_list_lock, SINGLE_DEPTH_NESTING);
+	int subclass = SINGLE_DEPTH_NESTING;
+
+	if (dev->netdev_ops->ndo_get_lock_subclass)
+		subclass = dev->netdev_ops->ndo_get_lock_subclass(dev);
+
+	spin_lock_nested(&dev->addr_list_lock, subclass);
 }
 
 static inline void netif_addr_lock_bh(struct net_device *dev)


