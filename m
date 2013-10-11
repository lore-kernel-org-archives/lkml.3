Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab3JKK4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:56:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757963Ab3JKKnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        Mark Wu <wudxw@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 061/100] bonding: Fix broken promiscuity reference counting issue
Date: Fri, 11 Oct 2013 11:41:31 +0100
Message-Id: <1381488130-30235-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit 5a0068deb611109c5ba77358be533f763f395ee4 upstream.

Recently grabbed this report:
https://bugzilla.redhat.com/show_bug.cgi?id=1005567

Of an issue in which the bonding driver, with an attached vlan encountered the
following errors when bond0 was taken down and back up:

dummy1: promiscuity touches roof, set promiscuity failed. promiscuity feature of
device might be broken.

The error occurs because, during __bond_release_one, if we release our last
slave, we take on a random mac address and issue a NETDEV_CHANGEADDR
notification.  With an attached vlan, the vlan may see that the vlan and bond
mac address were in sync, but no longer are.  This triggers a call to dev_uc_add
and dev_set_rx_mode, which enables IFF_PROMISC on the bond device.  Then, when
we complete __bond_release_one, we use the current state of the bond flags to
determine if we should decrement the promiscuity of the releasing slave.  But
since the bond changed promiscuity state during the release operation, we
incorrectly decrement the slave promisc count when it wasn't in promiscuous mode
to begin with, causing the above error

Fix is pretty simple, just cache the bonding flags at the start of the function
and use those when determining the need to set promiscuity.

This is also needed for the ALLMULTI flag

CC: Jay Vosburgh <fubar@us.ibm.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: Mark Wu <wudxw@linux.vnet.ibm.com>
CC: "David S. Miller" <davem@davemloft.net>
Reported-by: Mark Wu <wudxw@linux.vnet.ibm.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/bonding/bond_main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c7fd229c..5edf072 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1942,6 +1942,7 @@ int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave, *oldcurrent;
 	struct sockaddr addr;
+	int old_flags = bond_dev->flags;
 	netdev_features_t old_features = bond_dev->features;
 
 	/* slave is not a slave or master is not master of this slave */
@@ -2075,12 +2076,18 @@ int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
 	 * already taken care of above when we detached the slave
 	 */
 	if (!USES_PRIMARY(bond->params.mode)) {
-		/* unset promiscuity level from slave */
-		if (bond_dev->flags & IFF_PROMISC)
+		/* unset promiscuity level from slave
+		 * NOTE: The NETDEV_CHANGEADDR call above may change the value
+		 * of the IFF_PROMISC flag in the bond_dev, but we need the
+		 * value of that flag before that change, as that was the value
+		 * when this slave was attached, so we cache at the start of the
+		 * function and use it here. Same goes for ALLMULTI below
+		 */
+		if (old_flags & IFF_PROMISC)
 			dev_set_promiscuity(slave_dev, -1);
 
 		/* unset allmulti level from slave */
-		if (bond_dev->flags & IFF_ALLMULTI)
+		if (old_flags & IFF_ALLMULTI)
 			dev_set_allmulti(slave_dev, -1);
 
 		/* flush master's mc_list from slave */
-- 
1.8.3.2

