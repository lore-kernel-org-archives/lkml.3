Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965077Ab3CZP2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:28:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54186 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965440Ab3CZPYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 142/150] bonding: don't call update_speed_duplex() under spinlocks
Date: Tue, 26 Mar 2013 15:20:41 +0000
Message-Id: <1364311249-14454-143-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

commit 876254ae2758d50dcb08c7bd00caf6a806571178 upstream.

bond_update_speed_duplex() might sleep while calling underlying slave's
routines. Move it out of atomic context in bond_enslave() and remove it
from bond_miimon_commit() - it was introduced by commit 546add79, however
when the slave interfaces go up/change state it's their responsibility to
fire NETDEV_UP/NETDEV_CHANGE events so that bonding can properly update
their speed.

I've tested it on all combinations of ifup/ifdown, autoneg/speed/duplex
changes, remote-controlled and local, on (not) MII-based cards. All changes
are visible.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/bonding/bond_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2466847..a8406dc 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1737,6 +1737,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 
 	bond_compute_features(bond);
 
+	bond_update_speed_duplex(new_slave);
+
 	read_lock(&bond->lock);
 
 	new_slave->last_arp_rx = jiffies -
@@ -1789,8 +1791,6 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 		new_slave->link == BOND_LINK_DOWN ? "DOWN" :
 			(new_slave->link == BOND_LINK_UP ? "UP" : "BACK"));
 
-	bond_update_speed_duplex(new_slave);
-
 	if (USES_PRIMARY(bond->params.mode) && bond->params.primary[0]) {
 		/* if there is a primary slave, remember it */
 		if (strcmp(bond->params.primary, new_slave->dev->name) == 0) {
@@ -2471,8 +2471,6 @@ static void bond_miimon_commit(struct bonding *bond)
 				bond_set_backup_slave(slave);
 			}
 
-			bond_update_speed_duplex(slave);
-
 			pr_info("%s: link status definitely up for interface %s, %u Mbps %s duplex.\n",
 				bond->dev->name, slave->dev->name,
 				slave->speed, slave->duplex ? "full" : "half");
-- 
1.8.1.2

