Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbaCDUC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:02:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbaCDUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 036/172] 6lowpan: fix lockdep splats
Date: Tue,  4 Mar 2014 12:02:00 -0800
Message-Id: <20140304200300.885600970@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 20e7c4e80dcd01dad5e6c8b32455228b8fe9c619 ]

When a device ndo_start_xmit() calls again dev_queue_xmit(),
lockdep can complain because dev_queue_xmit() is re-entered and the
spinlocks protecting tx queues share a common lockdep class.

Same issue was fixed for bonding/l2tp/ppp in commits

0daa2303028a6 ("[PATCH] bonding: lockdep annotation")
49ee49202b4ac ("bonding: set qdisc_tx_busylock to avoid LOCKDEP splat")
23d3b8bfb8eb2 ("net: qdisc busylock needs lockdep annotations ")
303c07db487be ("ppp: set qdisc_tx_busylock to avoid LOCKDEP splat ")

Reported-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/6lowpan.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -1249,7 +1249,27 @@ static struct header_ops lowpan_header_o
 	.create	= lowpan_header_create,
 };
 
+static struct lock_class_key lowpan_tx_busylock;
+static struct lock_class_key lowpan_netdev_xmit_lock_key;
+
+static void lowpan_set_lockdep_class_one(struct net_device *dev,
+					 struct netdev_queue *txq,
+					 void *_unused)
+{
+	lockdep_set_class(&txq->_xmit_lock,
+			  &lowpan_netdev_xmit_lock_key);
+}
+
+
+static int lowpan_dev_init(struct net_device *dev)
+{
+	netdev_for_each_tx_queue(dev, lowpan_set_lockdep_class_one, NULL);
+	dev->qdisc_tx_busylock = &lowpan_tx_busylock;
+	return 0;
+}
+
 static const struct net_device_ops lowpan_netdev_ops = {
+	.ndo_init		= lowpan_dev_init,
 	.ndo_start_xmit		= lowpan_xmit,
 	.ndo_set_mac_address	= lowpan_set_address,
 };


