Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaHDDjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 23:39:22 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:31577 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaHDDjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 23:39:21 -0400
From: <lichunhe@huawei.com>
To: <vyasevic@redhat.com>, <xiyou.wangcong@gmail.com>,
        <makita.toshiaki@lab.ntt.co.jp>, <mst@redhat.com>,
        <stephen@networkplumber.org>, <ebiederm@xmission.com>,
        <f.fainelli@gmail.com>, <linux-kernel@vger.kernel.org>
CC: <wuyunfei@huawei.com>, <qianhuibin@huawei.com>,
        Chunhe Li <lichunhe@huawei.com>
Subject: [PATCH net/next] bridge:Add rcu read lock when delete br port
Date: Mon, 4 Aug 2014 11:37:56 +0800
Message-ID: <1407123476-9720-1-git-send-email-lichunhe@huawei.com>
X-Mailer: git-send-email 1.9.2.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.26.106]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chunhe Li <lichunhe@huawei.com>

In the br_hanle_frame function has a bug, when the bridge receive packets
which go througth the br_handle_frame, get the net_bridge_port pointer "p",
but don't check NULL pointer to use it. If somebody delete the bridge port
at the same time, will call a NULL pointer, trigger kernel panic. I see the
del_nbp comments, call del_nbp should via RCU, but the caller don't do this.

following steps will make bug happened
1.start vm and add the vm interface to a bridge br0,for example,
brctl addbr br0 tap0

2.configuer vm interface and br0 same ip subnet, vm ping br0.

3.add and delete the vm interface port for endless loop.

Signed-off-by: Chunhe Li <lichunhe@huawei.com>
---
 net/bridge/br_if.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 3eca3fd..91c611d 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -274,9 +274,11 @@ void br_dev_delete(struct net_device *dev, struct list_head *head)
 	struct net_bridge *br = netdev_priv(dev);
 	struct net_bridge_port *p, *n;
 
+	rcu_read_lock();
 	list_for_each_entry_safe(p, n, &br->port_list, list) {
 		del_nbp(p);
 	}
+	rcu_read_unlock();
 
 	br_fdb_delete_by_port(br, NULL, 1);
 
@@ -550,7 +552,9 @@ int br_del_if(struct net_bridge *br, struct net_device *dev)
 	 * there still maybe an alternate path for netconsole to use;
 	 * therefore there is no reason for a NETDEV_RELEASE event.
 	 */
+	rcu_read_lock();
 	del_nbp(p);
+	rcu_read_unlock();
 
 	spin_lock_bh(&br->lock);
 	changed_addr = br_stp_recalculate_bridge_id(br);
-- 
1.9.2.0


