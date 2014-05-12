Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbaELCHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:07:10 -0400
Received: from 1wt.eu ([62.212.114.60]:34539 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbaELBmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:25 -0400
Message-Id: <20140512003204.835777473@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Bohac <jbohac@suse.cz>, Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 101/143] bonding: 802.3ad: make aggregator_identifier bond-private
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/bonding/bond_3ad.c | 6 ++----
 drivers/net/bonding/bond_3ad.h | 1 +
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 05308e6..ec2bf8c 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1846,8 +1846,6 @@ void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout)
 	BOND_AD_INFO(bond).agg_select_mode = bond->params.ad_select;
 }
 
-static u16 aggregator_identifier;
-
 /**
  * bond_3ad_initialize - initialize a bond's 802.3ad parameters and structures
  * @bond: bonding struct to work on
@@ -1862,7 +1860,7 @@ void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution, int lacp_fas
 	if (MAC_ADDRESS_COMPARE(&(BOND_AD_INFO(bond).system.sys_mac_addr),
 				bond->dev->dev_addr)) {
 
-		aggregator_identifier = 0;
+		BOND_AD_INFO(bond).aggregator_identifier = 0;
 
 		BOND_AD_INFO(bond).lacp_fast = lacp_fast;
 		BOND_AD_INFO(bond).system.sys_priority = 0xFFFF;
@@ -1937,7 +1935,7 @@ int bond_3ad_bind_slave(struct slave *slave)
 		ad_initialize_agg(aggregator);
 
 		aggregator->aggregator_mac_address = *((struct mac_addr *)bond->dev->dev_addr);
-		aggregator->aggregator_identifier = (++aggregator_identifier);
+		aggregator->aggregator_identifier = ++BOND_AD_INFO(bond).aggregator_identifier;
 		aggregator->slave = slave;
 		aggregator->is_active = 0;
 		aggregator->num_of_ports = 0;
diff --git a/drivers/net/bonding/bond_3ad.h b/drivers/net/bonding/bond_3ad.h
index 2c46a154..f04f465 100644
--- a/drivers/net/bonding/bond_3ad.h
+++ b/drivers/net/bonding/bond_3ad.h
@@ -253,6 +253,7 @@ struct ad_system {
 struct ad_bond_info {
 	struct ad_system system;	    /* 802.3ad system structure */
 	u32 agg_select_timer;	    // Timer to select aggregator after all adapter's hand shakes
+	u16 aggregator_identifier;
 	u32 agg_select_mode;	    // Mode of selection of active aggregator(bandwidth/count)
 	int lacp_fast;		/* whether fast periodic tx should be
 				 * requested
-- 
1.7.12.2.21.g234cd45.dirty



