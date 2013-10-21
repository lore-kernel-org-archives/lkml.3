Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3JUJFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:05:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39778 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754242Ab3JUIwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:33 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andy Gospodarek" <andy@greyhouse.net>,
        "Mark Wu" <wudxw@linux.vnet.ibm.com>,
        "Neil Horman" <nhorman@tuxdriver.com>,
        "Jay Vosburgh" <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.280765896@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 110/149] bonding: Fix broken promiscuity reference
 counting  issue
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b436b84..1bf36ac 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1911,6 +1911,7 @@ int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave, *oldcurrent;
 	struct sockaddr addr;
+	int old_flags = bond_dev->flags;
 	u32 old_features = bond_dev->features;
 
 	/* slave is not a slave or master is not master of this slave */
@@ -2041,12 +2042,18 @@ int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
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

