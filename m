Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaAQSMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:12:07 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:44893 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaAQSMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:12:03 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/6] cgroup: make CONFIG_NET_CLS_CGROUP and CONFIG_NETPRIO_CGROUP bool instead of tristate
Date: Fri, 17 Jan 2014 13:11:52 -0500
Message-Id: <1389982317-22225-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389982317-22225-1-git-send-email-tj@kernel.org>
References: <1389982317-22225-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net_cls and net_prio are the only cgroups which are allowed to be
built as modules.  The savings from allowing the two controllers to be
built as modules are tiny especially given that cgroup module support
itself adds quite a bit of complexity.

The following are the sizes of vmlinux with both built as module and
both built as part of the kernel image with cgroup module support
removed.

	text		data		bss		dec
	20292207	2411496		10784768	33488471
	20293421	2412568		10784768	33490757

The total difference is 2286 bytes.  Given that none of other
controllers has much chance of being made a module and that we're
unlikely to add new modular controllers, the added complexity is
simply not justifiable.

As a first step to drop cgroup module support, this patch changes the
two config options to bool from tristate and drops module related code
from the two controllers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: "David S. Miller" <davem@davemloft.net>
---
 net/Kconfig               |  2 +-
 net/core/netprio_cgroup.c | 32 ++------------------------------
 net/sched/Kconfig         |  2 +-
 net/sched/cls_cgroup.c    | 23 ++---------------------
 4 files changed, 6 insertions(+), 53 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index d334678..fea7b88 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -239,7 +239,7 @@ config XPS
 	default y
 
 config NETPRIO_CGROUP
-	tristate "Network priority cgroup"
+	bool "Network priority cgroup"
 	depends on CGROUPS
 	---help---
 	  Cgroup subsystem for use in assigning processes to network priorities on
diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 56cbb69..8912da7 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -283,37 +283,9 @@ static struct notifier_block netprio_device_notifier = {
 
 static int __init init_cgroup_netprio(void)
 {
-	int ret;
-
-	ret = cgroup_load_subsys(&net_prio_subsys);
-	if (ret)
-		goto out;
-
 	register_netdevice_notifier(&netprio_device_notifier);
-
-out:
-	return ret;
-}
-
-static void __exit exit_cgroup_netprio(void)
-{
-	struct netprio_map *old;
-	struct net_device *dev;
-
-	unregister_netdevice_notifier(&netprio_device_notifier);
-
-	cgroup_unload_subsys(&net_prio_subsys);
-
-	rtnl_lock();
-	for_each_netdev(&init_net, dev) {
-		old = rtnl_dereference(dev->priomap);
-		RCU_INIT_POINTER(dev->priomap, NULL);
-		if (old)
-			kfree_rcu(old, rcu);
-	}
-	rtnl_unlock();
+	return 0;
 }
 
-module_init(init_cgroup_netprio);
-module_exit(exit_cgroup_netprio);
+subsys_initcall(init_cgroup_netprio);
 MODULE_LICENSE("GPL v2");
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index ad1f1d8..0a9e4d1 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -433,7 +433,7 @@ config NET_CLS_FLOW
 	  module will be called cls_flow.
 
 config NET_CLS_CGROUP
-	tristate "Control Group Classifier"
+	bool "Control Group Classifier"
 	select NET_CLS
 	depends on CGROUPS
 	---help---
diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index 16006c9..2f6a9b4 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -309,27 +309,8 @@ static struct tcf_proto_ops cls_cgroup_ops __read_mostly = {
 
 static int __init init_cgroup_cls(void)
 {
-	int ret;
-
-	ret = cgroup_load_subsys(&net_cls_subsys);
-	if (ret)
-		goto out;
-
-	ret = register_tcf_proto_ops(&cls_cgroup_ops);
-	if (ret)
-		cgroup_unload_subsys(&net_cls_subsys);
-
-out:
-	return ret;
-}
-
-static void __exit exit_cgroup_cls(void)
-{
-	unregister_tcf_proto_ops(&cls_cgroup_ops);
-
-	cgroup_unload_subsys(&net_cls_subsys);
+	return register_tcf_proto_ops(&cls_cgroup_ops);
 }
 
-module_init(init_cgroup_cls);
-module_exit(exit_cgroup_cls);
+subsys_initcall(init_cgroup_cls);
 MODULE_LICENSE("GPL");
-- 
1.8.4.2

