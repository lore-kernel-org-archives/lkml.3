Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3EJOUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:20:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57026 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753320Ab3EJOUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Veaceslav Falico" <vfalico@redhat.com>,
        "nikolay@redhat.com" <nikolay@redhat.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.165168986@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [089/118] bonding: fix bonding_masters race condition in bond 
 unloading
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "nikolay@redhat.com" <nikolay@redhat.com>

[ Upstream commit 69b0216ac255f523556fa3d4ff030d857eaaa37f ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4853,9 +4853,18 @@ static int __net_init bond_net_init(stru
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

