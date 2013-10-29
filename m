Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3J2SIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:08:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59418 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab3J2SIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:08:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        Mark Wu <wudxw@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 51/81] bonding: Fix broken promiscuity reference counting issue
Date: Tue, 29 Oct 2013 11:04:12 -0700
Message-Id: <1383069882-11437-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit 5a0068deb611109c5ba77358be533f763f395ee4 ]

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/bonding/bond_main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index fe48472..490f5f5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1933,6 +1933,7 @@ int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave, *oldcurrent;
 	struct sockaddr addr;
+	int old_flags = bond_dev->flags;
 	netdev_features_t old_features = bond_dev->features;
 
 	/* slave is not a slave or master is not master of this slave */
@@ -2067,12 +2068,18 @@ int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
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
1.8.1.2

