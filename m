Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaABBOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 20:14:33 -0500
Received: from [119.145.14.64] ([119.145.14.64]:60168 "EHLO
	szxga01-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaABBOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 20:14:32 -0500
Message-ID: <52C4BD28.2070809@huawei.com>
Date: Thu, 2 Jan 2014 09:13:12 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jay Vosburgh <fubar@us.ibm.com>, Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH RESEND net-next 6/7] bonding: remove the return value for
 bond_3ad_bind_slave()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sure the operand slave and bond for the function will not
be NULL, so the check for the bond will not make any sense, so
remove the judgement, and the return value was useless here,
remove the unwanted return value.

The comments for the bond 3ad is too old, cleanup some errors
and warming.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/bonding/bond_3ad.c | 36 +++++++++++++++---------------------
 drivers/net/bonding/bond_3ad.h |  2 +-
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 8d7483d..81559b2 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1855,22 +1855,16 @@ void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
  * Returns:   0 on success
  *          < 0 on error
  */
-int bond_3ad_bind_slave(struct slave *slave)
+void bond_3ad_bind_slave(struct slave *slave)
 {
 	struct bonding *bond = bond_get_bond_by_slave(slave);
 	struct port *port;
 	struct aggregator *aggregator;
 
-	if (bond == NULL) {
-		pr_err("%s: The slave %s is not attached to its bond\n",
-		       slave->bond->dev->name, slave->dev->name);
-		return -1;
-	}
-
-	//check that the slave has not been initialized yet.
+	/* check that the slave has not been initialized yet. */
 	if (SLAVE_AD_INFO(slave).port.slave != slave) {
 
-		// port initialization
+		/* port initialization */
 		port = &(SLAVE_AD_INFO(slave).port);
 
 		ad_initialize_port(port, bond->params.lacp_fast);
@@ -1878,28 +1872,30 @@ int bond_3ad_bind_slave(struct slave *slave)
 		__initialize_port_locks(slave);
 		port->slave = slave;
 		port->actor_port_number = SLAVE_AD_INFO(slave).id;
-		// key is determined according to the link speed, duplex and user key(which is yet not supported)
-		//              ------------------------------------------------------------
-		// Port key :   | User key                       |      Speed       |Duplex|
-		//              ------------------------------------------------------------
-		//              16                               6               1 0
-		port->actor_admin_port_key = 0;	// initialize this parameter
+		/* key is determined according to the link speed, duplex and user key(which
+		 * is yet not supported)
+		 *              ------------------------------------------------------------
+		 * Port key :   | User key                       |      Speed       |Duplex|
+		 *              ------------------------------------------------------------
+		 *              16                               6               1 0
+		 */
+		port->actor_admin_port_key = 0;	/* initialize this parameter */
 		port->actor_admin_port_key |= __get_duplex(port);
 		port->actor_admin_port_key |= (__get_link_speed(port) << 1);
 		port->actor_oper_port_key = port->actor_admin_port_key;
-		// if the port is not full duplex, then the port should be not lacp Enabled
+		/* if the port is not full duplex, then the port should be not lacp Enabled */
 		if (!(port->actor_oper_port_key & AD_DUPLEX_KEY_BITS))
 			port->sm_vars &= ~AD_PORT_LACP_ENABLED;
-		// actor system is the bond's system
+		/* actor system is the bond's system */
 		port->actor_system = BOND_AD_INFO(bond).system.sys_mac_addr;
-		// tx timer(to verify that no more than MAX_TX_IN_SECOND lacpdu's are sent in one second)
+		/* tx timer(to verify that no more than MAX_TX_IN_SECOND lacpdu's are sent in one second) */
 		port->sm_tx_timer_counter = ad_ticks_per_sec/AD_MAX_TX_IN_SECOND;
 		port->aggregator = NULL;
 		port->next_port_in_aggregator = NULL;
 
 		__disable_port(port);
 
-		// aggregator initialization
+		/* aggregator initialization */
 		aggregator = &(SLAVE_AD_INFO(slave).aggregator);
 
 		ad_initialize_agg(aggregator);
@@ -1910,8 +1906,6 @@ int bond_3ad_bind_slave(struct slave *slave)
 		aggregator->is_active = 0;
 		aggregator->num_of_ports = 0;
 	}
-
-	return 0;
 }
 
 /**
diff --git a/drivers/net/bonding/bond_3ad.h b/drivers/net/bonding/bond_3ad.h
index 5d91ad0..13dc9d3 100644
--- a/drivers/net/bonding/bond_3ad.h
+++ b/drivers/net/bonding/bond_3ad.h
@@ -265,7 +265,7 @@ struct ad_slave_info {
 
 // ================= AD Exported functions to the main bonding code ==================
 void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution);
-int  bond_3ad_bind_slave(struct slave *slave);
+void  bond_3ad_bind_slave(struct slave *slave);
 void bond_3ad_unbind_slave(struct slave *slave);
 void bond_3ad_state_machine_handler(struct work_struct *);
 void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout);
-- 
1.8.0


