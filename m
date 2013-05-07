Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809Ab3EGOJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:09:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42278 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907Ab3EGNlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 046/118] bonding: fix bonding_masters race condition in bond unloading
Date: Tue,  7 May 2013 14:38:12 +0100
Message-Id: <1367933964-1564-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "nikolay@redhat.com" <nikolay@redhat.com>

commit 69b0216ac255f523556fa3d4ff030d857eaaa37f upstream.

While the bonding module is unloading, it is considered that after
rtnl_link_unregister all bond devices are destroyed but since no
synchronization mechanism exists, a new bond device can be created
via bonding_masters before unregister_pernet_subsys which would
lead to multiple problems (e.g. NULL pointer dereference, wrong RIP,
list corruption).

This patch fixes the issue by removing any bond devices left in the
netns after bonding_masters is removed from sysfs.

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Acked-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/bonding/bond_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 1a6b118..5fc31a1 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4870,9 +4870,18 @@ static int __net_init bond_net_init(struct net *net)
 static void __net_exit bond_net_exit(struct net *net)
 {
 	struct bond_net *bn = net_generic(net, bond_net_id);
+	struct bonding *bond, *tmp_bond;
+	LIST_HEAD(list);
 
 	bond_destroy_sysfs(bn);
 	bond_destroy_proc_dir(bn);
+
+	/* Kill off any bonds created after unregistering bond rtnl ops */
+	rtnl_lock();
+	list_for_each_entry_safe(bond, tmp_bond, &bn->dev_list, bond_list)
+		unregister_netdevice_queue(bond->dev, &list);
+	unregister_netdevice_many(&list);
+	rtnl_unlock();
 }
 
 static struct pernet_operations bond_net_ops = {
-- 
1.8.1.2

