Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaDAQJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:09:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44345 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaDAQJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 01/86] 6lowpan: fix lockdep splats
Date: Tue,  1 Apr 2014 09:07:14 -0700
Message-Id: <1396368519-12728-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ieee802154/6lowpan.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
index f227061..d08949e 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -1086,7 +1086,27 @@ static struct header_ops lowpan_header_ops = {
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
-- 
1.8.3.2

