Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaLEXw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:52:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaLEWpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ding Tianhong <dingtianhong@huawei.com>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        Andy Gospodarek <gospo@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 024/122] bonding: fix curr_active_slave/carrier with loadbalance arp monitoring
Date: Fri,  5 Dec 2014 14:43:18 -0800
Message-Id: <20141205223309.062639724@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@redhat.com>

[ Upstream commit b8e4500f42fe4464a33a887579147050bed8fcef ]

Since commit 6fde8f037e60 ("bonding: fix locking in
bond_loadbalance_arp_mon()") we can have a stale bond carrier state and
stale curr_active_slave when using arp monitoring in loadbalance modes. The
reason is that in bond_loadbalance_arp_mon() we can't have
do_failover == true but slave_state_changed == false, whenever do_failover
is true then slave_state_changed is also true. Then the following piece
from bond_loadbalance_arp_mon():
                if (slave_state_changed) {
                        bond_slave_state_change(bond);
                        if (BOND_MODE(bond) == BOND_MODE_XOR)
                                bond_update_slave_arr(bond, NULL);
                } else if (do_failover) {
                        block_netpoll_tx();
                        bond_select_active_slave(bond);
                        unblock_netpoll_tx();
                }

will execute only the first branch, always and regardless of do_failover.
Since these two events aren't related in such way, we need to decouple and
consider them separately.

For example this issue could lead to the following result:
Bonding Mode: load balancing (round-robin)
*MII Status: down*
MII Polling Interval (ms): 0
Up Delay (ms): 0
Down Delay (ms): 0
ARP Polling Interval (ms): 100
ARP IP target/s (n.n.n.n form): 192.168.9.2

Slave Interface: ens12
*MII Status: up*
Speed: 10000 Mbps
Duplex: full
Link Failure Count: 2
Permanent HW addr: 00:0f:53:01:42:2c
Slave queue ID: 0

Slave Interface: eth1
*MII Status: up*
Speed: Unknown
Duplex: Unknown
Link Failure Count: 70
Permanent HW addr: 52:54:00:2f:0f:8e
Slave queue ID: 0

Since some interfaces are up, then the status of the bond should also be
up, but it will never change unless something invokes bond_set_carrier()
(i.e. enslave, bond_select_active_slave etc). Now, if I force the
calling of bond_select_active_slave via for example changing
primary_reselect (it can change in any mode), then the MII status goes to
"up" because it calls bond_select_active_slave() which should've been done
from bond_loadbalance_arp_mon() itself.

CC: Veaceslav Falico <vfalico@gmail.com>
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: Ding Tianhong <dingtianhong@huawei.com>

Fixes: 6fde8f037e60 ("bonding: fix locking in bond_loadbalance_arp_mon()")
Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Acked-by: Veaceslav Falico <vfalico@gmail.com>
Acked-by: Andy Gospodarek <gospo@cumulusnetworks.com>
Acked-by: Ding Tianhong <dingtianhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2498,9 +2498,9 @@ static void bond_loadbalance_arp_mon(str
 		if (!rtnl_trylock())
 			goto re_arm;
 
-		if (slave_state_changed) {
+		if (slave_state_changed)
 			bond_slave_state_change(bond);
-		} else if (do_failover) {
+		if (do_failover) {
 			/* the bond_select_active_slave must hold RTNL
 			 * and curr_slave_lock for write.
 			 */


