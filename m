Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbaELBtE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:49:04 -0400
Received: from 1wt.eu ([62.212.114.60]:34783 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbaELBoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:44:12 -0400
Message-Id: <20140512003204.249648545@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 087/143] bridge: flush brs address entry in fdb when remove the bridge dev
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Ding Tianhong <dingtianhong@huawei.com>

[ Upstream commit f873042093c0b418d2351fe142222b625c740149 ]

When the following commands are executed:

brctl addbr br0
ifconfig br0 hw ether <addr>
rmmod bridge

The calltrace will occur:

[  563.312114] device eth1 left promiscuous mode
[  563.312188] br0: port 1(eth1) entered disabled state
[  563.468190] kmem_cache_destroy bridge_fdb_cache: Slab cache still has objects
[  563.468197] CPU: 6 PID: 6982 Comm: rmmod Tainted: G           O 3.12.0-0.7-default+ #9
[  563.468199] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  563.468200]  0000000000000880 ffff88010f111e98 ffffffff814d1c92 ffff88010f111eb8
[  563.468204]  ffffffff81148efd ffff88010f111eb8 0000000000000000 ffff88010f111ec8
[  563.468206]  ffffffffa062a270 ffff88010f111ed8 ffffffffa063ac76 ffff88010f111f78
[  563.468209] Call Trace:
[  563.468218]  [<ffffffff814d1c92>] dump_stack+0x6a/0x78
[  563.468234]  [<ffffffff81148efd>] kmem_cache_destroy+0xfd/0x100
[  563.468242]  [<ffffffffa062a270>] br_fdb_fini+0x10/0x20 [bridge]
[  563.468247]  [<ffffffffa063ac76>] br_deinit+0x4e/0x50 [bridge]
[  563.468254]  [<ffffffff810c7dc9>] SyS_delete_module+0x199/0x2b0
[  563.468259]  [<ffffffff814e0922>] system_call_fastpath+0x16/0x1b
[  570.377958] Bridge firewalling registered

--------------------------- cut here -------------------------------

The reason is that when the bridge dev's address is changed, the
br_fdb_change_mac_address() will add new address in fdb, but when
the bridge was removed, the address entry in the fdb did not free,
the bridge_fdb_cache still has objects when destroy the cache, Fix
this by flushing the bridge address entry when removing the bridge.

v2: according to the Toshiaki Makita and Vlad's suggestion, I only
    delete the vlan0 entry, it still have a leak here if the vlan id
    is other number, so I need to call fdb_delete_by_port(br, NULL, 1)
    to flush all entries whose dst is NULL for the bridge.

Suggested-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Suggested-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/bridge/br_if.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 4a9f527..c01e65d 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -162,6 +162,8 @@ static void del_br(struct net_bridge *br)
 		del_nbp(p);
 	}
 
+	br_fdb_delete_by_port(br, NULL, 1);
+
 	del_timer_sync(&br->gc_timer);
 
 	br_sysfs_delbr(br->dev);
-- 
1.7.12.2.21.g234cd45.dirty



