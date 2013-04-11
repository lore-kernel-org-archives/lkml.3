Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935098Ab3DKUln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:41:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5269 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab3DKUZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:25:56 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3BC1IQqTNZgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mDhElfJnBgoA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=mSCOiLAyvqR8YHzN6XsA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202547.575070610@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 008/171 ] bonding: dont call update_speed_duplex() under spinlocks
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0008-bonding-don-t-call-update_speed_duplex-under-spinloc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 876254ae2758d50dcb08c7bd00caf6a806571178 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/bonding/bond_main.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index acc0718..704d0ad 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1733,6 +1733,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 
 	bond_compute_features(bond);
 
+	bond_update_speed_duplex(new_slave);
+
 	read_lock(&bond->lock);
 
 	new_slave->last_arp_rx = jiffies -
@@ -1785,8 +1787,6 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 		new_slave->link == BOND_LINK_DOWN ? "DOWN" :
 			(new_slave->link == BOND_LINK_UP ? "UP" : "BACK"));
 
-	bond_update_speed_duplex(new_slave);
-
 	if (USES_PRIMARY(bond->params.mode) && bond->params.primary[0]) {
 		/* if there is a primary slave, remember it */
 		if (strcmp(bond->params.primary, new_slave->dev->name) == 0) {
@@ -2467,8 +2467,6 @@ static void bond_miimon_commit(struct bonding *bond)
 				bond_set_backup_slave(slave);
 			}
 
-			bond_update_speed_duplex(slave);
-
 			pr_info("%s: link status definitely up for interface %s, %u Mbps %s duplex.\n",
 				bond->dev->name, slave->dev->name,
 				slave->speed, slave->duplex ? "full" : "half");
-- 
1.7.10.4


