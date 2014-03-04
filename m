Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbaCDVbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:31:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757AbaCDUDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Bohac <jbohac@suse.cz>, Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 051/172] bonding: 802.3ad: make aggregator_identifier bond-private
Date: Tue,  4 Mar 2014 12:02:15 -0800
Message-Id: <20140304200301.363215487@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_3ad.c |    6 ++----
 drivers/net/bonding/bond_3ad.h |    1 +
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1806,8 +1806,6 @@ void bond_3ad_initiate_agg_selection(str
 	BOND_AD_INFO(bond).agg_select_timer = timeout;
 }
 
-static u16 aggregator_identifier;
-
 /**
  * bond_3ad_initialize - initialize a bond's 802.3ad parameters and structures
  * @bond: bonding struct to work on
@@ -1821,7 +1819,7 @@ void bond_3ad_initialize(struct bonding
 	if (MAC_ADDRESS_COMPARE(&(BOND_AD_INFO(bond).system.sys_mac_addr),
 				bond->dev->dev_addr)) {
 
-		aggregator_identifier = 0;
+		BOND_AD_INFO(bond).aggregator_identifier = 0;
 
 		BOND_AD_INFO(bond).system.sys_priority = 0xFFFF;
 		BOND_AD_INFO(bond).system.sys_mac_addr = *((struct mac_addr *)bond->dev->dev_addr);
@@ -1892,7 +1890,7 @@ int bond_3ad_bind_slave(struct slave *sl
 		ad_initialize_agg(aggregator);
 
 		aggregator->aggregator_mac_address = *((struct mac_addr *)bond->dev->dev_addr);
-		aggregator->aggregator_identifier = (++aggregator_identifier);
+		aggregator->aggregator_identifier = ++BOND_AD_INFO(bond).aggregator_identifier;
 		aggregator->slave = slave;
 		aggregator->is_active = 0;
 		aggregator->num_of_ports = 0;
--- a/drivers/net/bonding/bond_3ad.h
+++ b/drivers/net/bonding/bond_3ad.h
@@ -253,6 +253,7 @@ struct ad_system {
 struct ad_bond_info {
 	struct ad_system system;	    /* 802.3ad system structure */
 	u32 agg_select_timer;	    // Timer to select aggregator after all adapter's hand shakes
+	u16 aggregator_identifier;
 };
 
 struct ad_slave_info {


