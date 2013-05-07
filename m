Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491Ab3EGElQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:41:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759469Ab3EGEZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:41 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=yo305fgBZycA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=cjm-ESw5PtgA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035859.858503308@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:59:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nikolay Aleksandrov <nikolay@redhat.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [113/126] bonding: fix bonding_masters race condition in bond unloading
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0113-bonding-fix-bonding_masters-race-condition-in-bond-u.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/bonding/bond_main.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 83ae683..bbd3ac1 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4876,9 +4876,18 @@ static int __net_init bond_net_init(struct net *net)
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
1.7.10.4


