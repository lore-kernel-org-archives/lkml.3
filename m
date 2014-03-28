Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbaC1JIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 05:08:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49262 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaC1JIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 05:08:45 -0400
From: Zheng Li <zheng.x.li@oracle.com>
To: netdev@vger.kernel.org, fubar@us.ibm.com, andy@greyhouse.net
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, joe.jin@oracle.com,
        zheng.x.li@oracle.com
Subject: [PATCH] bonding: Inactive slaves should keep inactive flag's value to 1
Date: Fri, 28 Mar 2014 17:22:09 +0800
Message-Id: <1395998529-5937-1-git-send-email-zheng.x.li@oracle.com>
X-Mailer: git-send-email 1.7.6.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In bond mode tlb and alb, inactive slaves should keep inactive flag to 1 to
refuse to receive broadcast packets. Now, active slave send broadcast packets
(for example ARP requests) which will arrive inactive slaves on same host from
switch, but inactive slave's inactive flag is zero that cause bridge receive the
broadcast packets to produce a wrong entry in forward table. Typical situation
is domu send some ARP request which go out from dom0 bond's active slave, then
the ARP broadcast request packets go back to inactive slave from switch, because
the inactive slave's inactive flag is zero, kernel will receive the packets and
pass them to bridge that cause dom0's bridge map domu's MAC address to port of
bond, bridge should map domu's MAC to port of vif.

Signed-off-by: Zheng Li <zheng.x.li@oracle.com>
---
 drivers/net/bonding/bond_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e5628fc..f97d72e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3058,7 +3058,7 @@ static int bond_open(struct net_device *bond_dev)
 	if (bond_has_slaves(bond)) {
 		read_lock(&bond->curr_slave_lock);
 		bond_for_each_slave(bond, slave, iter) {
-			if ((bond->params.mode == BOND_MODE_ACTIVEBACKUP)
+			if ((bond->params.mode == BOND_MODE_ACTIVEBACKUP || bond_is_lb(bond))
 				&& (slave != bond->curr_active_slave)) {
 				bond_set_slave_inactive_flags(slave,
 							      BOND_SLAVE_NOTIFY_NOW);
-- 
1.7.6.5

