Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162322Ab3LFWdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:33:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759120Ab3LFVwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 43/83] bridge: flush brs address entry in fdb when remove the bridge dev
Date: Fri,  6 Dec 2013 13:51:33 -0800
Message-Id: <20131206214644.064283149@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_if.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -172,6 +172,8 @@ void br_dev_delete(struct net_device *de
 		del_nbp(p);
 	}
 
+	br_fdb_delete_by_port(br, NULL, 1);
+
 	del_timer_sync(&br->gc_timer);
 
 	br_sysfs_delbr(br->dev);


