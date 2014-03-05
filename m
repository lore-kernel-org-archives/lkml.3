Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbaCEO0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:26:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41022 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaCEOZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 067/131] 6lowpan: fix lockdep splats
Date: Wed,  5 Mar 2014 14:23:11 +0000
Message-Id: <1394029455-23128-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 20e7c4e80dcd01dad5e6c8b32455228b8fe9c619 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ieee802154/6lowpan.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
index a47f582..e3eef6f 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -1173,7 +1173,27 @@ static struct header_ops lowpan_header_ops = {
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
1.9.0

