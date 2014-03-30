Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaC3XdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:33:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36518 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133AbaC3XZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Veaceslav Falico" <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, "Jiri Bohac" <jbohac@suse.cz>,
        "Jiri Bohac" <jiri@boha.cz>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.791276165@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 190/200] bonding: 802.3ad: make aggregator_identifier
 bond-private
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Bohac <jiri@boha.cz>

[ Upstream commit 163c8ff30dbe473abfbb24a7eac5536c87f3baa9 ]

aggregator_identifier is used to assign unique aggregator identifiers
to aggregators of a bond during device enslaving.

aggregator_identifier is currently a global variable that is zeroed in
bond_3ad_initialize().

This sequence will lead to duplicate aggregator identifiers for eth1 and eth3:

create bond0
change bond0 mode to 802.3ad
enslave eth0 to bond0 		//eth0 gets agg id 1
enslave eth1 to bond0 		//eth1 gets agg id 2
create bond1
change bond1 mode to 802.3ad
enslave eth2 to bond1		//aggregator_identifier is reset to 0
				//eth2 gets agg id 1
enslave eth3 to bond0 		//eth3 gets agg id 2

Fix this by making aggregator_identifier private to the bond.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Acked-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_3ad.c | 6 ++----
 drivers/net/bonding/bond_3ad.h | 1 +
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 0ae0d7c..aaa7999 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1854,8 +1854,6 @@ void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout)
 	BOND_AD_INFO(bond).agg_select_timer = timeout;
 }
 
-static u16 aggregator_identifier;
-
 /**
  * bond_3ad_initialize - initialize a bond's 802.3ad parameters and structures
  * @bond: bonding struct to work on
@@ -1869,7 +1867,7 @@ void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
 	if (MAC_ADDRESS_COMPARE(&(BOND_AD_INFO(bond).system.sys_mac_addr),
 				bond->dev->dev_addr)) {
 
-		aggregator_identifier = 0;
+		BOND_AD_INFO(bond).aggregator_identifier = 0;
 
 		BOND_AD_INFO(bond).system.sys_priority = 0xFFFF;
 		BOND_AD_INFO(bond).system.sys_mac_addr = *((struct mac_addr *)bond->dev->dev_addr);
@@ -1941,7 +1939,7 @@ int bond_3ad_bind_slave(struct slave *slave)
 		ad_initialize_agg(aggregator);
 
 		aggregator->aggregator_mac_address = *((struct mac_addr *)bond->dev->dev_addr);
-		aggregator->aggregator_identifier = (++aggregator_identifier);
+		aggregator->aggregator_identifier = ++BOND_AD_INFO(bond).aggregator_identifier;
 		aggregator->slave = slave;
 		aggregator->is_active = 0;
 		aggregator->num_of_ports = 0;
diff --git a/drivers/net/bonding/bond_3ad.h b/drivers/net/bonding/bond_3ad.h
index 235b2cc..20d9c78 100644
--- a/drivers/net/bonding/bond_3ad.h
+++ b/drivers/net/bonding/bond_3ad.h
@@ -253,6 +253,7 @@ struct ad_system {
 struct ad_bond_info {
 	struct ad_system system;	    /* 802.3ad system structure */
 	u32 agg_select_timer;	    // Timer to select aggregator after all adapter's hand shakes
+	u16 aggregator_identifier;
 };
 
 struct ad_slave_info {

