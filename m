Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3CZXtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:49:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab3CZWnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 07/98] bonding: dont call update_speed_duplex() under spinlocks
Date: Tue, 26 Mar 2013 15:41:56 -0700
Message-Id: <20130326224243.213793842@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1728,6 +1728,8 @@ int bond_enslave(struct net_device *bond
 
 	bond_compute_features(bond);
 
+	bond_update_speed_duplex(new_slave);
+
 	read_lock(&bond->lock);
 
 	new_slave->last_arp_rx = jiffies -
@@ -1780,8 +1782,6 @@ int bond_enslave(struct net_device *bond
 		new_slave->link == BOND_LINK_DOWN ? "DOWN" :
 			(new_slave->link == BOND_LINK_UP ? "UP" : "BACK"));
 
-	bond_update_speed_duplex(new_slave);
-
 	if (USES_PRIMARY(bond->params.mode) && bond->params.primary[0]) {
 		/* if there is a primary slave, remember it */
 		if (strcmp(bond->params.primary, new_slave->dev->name) == 0) {
@@ -2463,8 +2463,6 @@ static void bond_miimon_commit(struct bo
 				bond_set_backup_slave(slave);
 			}
 
-			bond_update_speed_duplex(slave);
-
 			pr_info("%s: link status definitely up for interface %s, %u Mbps %s duplex.\n",
 				bond->dev->name, slave->dev->name,
 				slave->speed, slave->duplex ? "full" : "half");


