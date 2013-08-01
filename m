Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab3HAVuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:50:16 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:40396 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425Ab3HAVuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:50:12 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 03/23] netprio_cgroup: pass around @css instead of @cgroup and kill struct cgroup_netprio_state
Date: Thu,  1 Aug 2013 17:49:41 -0400
Message-Id: <1375393801-4817-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375393801-4817-1-git-send-email-tj@kernel.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup controller API will be converted to primarily use struct
cgroup_subsys_state instead of struct cgroup.  In preparation, make
the internal functions of netprio_cgroup pass around @css instead of
@cgrp.

While at it, kill struct cgroup_netprio_state which only contained
struct cgroup_subsys_state without serving any purpose.  All functions
are converted to deal with @css directly.

This patch shouldn't cause any behavior differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: David S. Miller <davem@davemloft.net>
---
 include/net/netprio_cgroup.h |  4 ----
 net/core/netprio_cgroup.c    | 56 ++++++++++++++++++++++----------------------
 2 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/include/net/netprio_cgroup.h b/include/net/netprio_cgroup.h
index 8110fa7..a24f8bb 100644
--- a/include/net/netprio_cgroup.h
+++ b/include/net/netprio_cgroup.h
@@ -25,10 +25,6 @@ struct netprio_map {
 	u32 priomap[];
 };
 
-struct cgroup_netprio_state {
-	struct cgroup_subsys_state css;
-};
-
 extern void sock_update_netprioidx(struct sock *sk);
 
 #if IS_BUILTIN(CONFIG_NETPRIO_CGROUP)
diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index ccf8523..5dfac88 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -29,12 +29,6 @@
 
 #define PRIOMAP_MIN_SZ		128
 
-static inline struct cgroup_netprio_state *cgrp_netprio_state(struct cgroup *cgrp)
-{
-	return container_of(cgroup_css(cgrp, net_prio_subsys_id),
-			    struct cgroup_netprio_state, css);
-}
-
 /*
  * Extend @dev->priomap so that it's large enough to accomodate
  * @target_idx.  @dev->priomap.priomap_len > @target_idx after successful
@@ -87,68 +81,72 @@ static int extend_netdev_table(struct net_device *dev, u32 target_idx)
 
 /**
  * netprio_prio - return the effective netprio of a cgroup-net_device pair
- * @cgrp: cgroup part of the target pair
+ * @css: css part of the target pair
  * @dev: net_device part of the target pair
  *
  * Should be called under RCU read or rtnl lock.
  */
-static u32 netprio_prio(struct cgroup *cgrp, struct net_device *dev)
+static u32 netprio_prio(struct cgroup_subsys_state *css, struct net_device *dev)
 {
 	struct netprio_map *map = rcu_dereference_rtnl(dev->priomap);
+	int id = css->cgroup->id;
 
-	if (map && cgrp->id < map->priomap_len)
-		return map->priomap[cgrp->id];
+	if (map && id < map->priomap_len)
+		return map->priomap[id];
 	return 0;
 }
 
 /**
  * netprio_set_prio - set netprio on a cgroup-net_device pair
- * @cgrp: cgroup part of the target pair
+ * @css: css part of the target pair
  * @dev: net_device part of the target pair
  * @prio: prio to set
  *
- * Set netprio to @prio on @cgrp-@dev pair.  Should be called under rtnl
+ * Set netprio to @prio on @css-@dev pair.  Should be called under rtnl
  * lock and may fail under memory pressure for non-zero @prio.
  */
-static int netprio_set_prio(struct cgroup *cgrp, struct net_device *dev,
-			    u32 prio)
+static int netprio_set_prio(struct cgroup_subsys_state *css,
+			    struct net_device *dev, u32 prio)
 {
 	struct netprio_map *map;
+	int id = css->cgroup->id;
 	int ret;
 
 	/* avoid extending priomap for zero writes */
 	map = rtnl_dereference(dev->priomap);
-	if (!prio && (!map || map->priomap_len <= cgrp->id))
+	if (!prio && (!map || map->priomap_len <= id))
 		return 0;
 
-	ret = extend_netdev_table(dev, cgrp->id);
+	ret = extend_netdev_table(dev, id);
 	if (ret)
 		return ret;
 
 	map = rtnl_dereference(dev->priomap);
-	map->priomap[cgrp->id] = prio;
+	map->priomap[id] = prio;
 	return 0;
 }
 
 static struct cgroup_subsys_state *cgrp_css_alloc(struct cgroup *cgrp)
 {
-	struct cgroup_netprio_state *cs;
+	struct cgroup_subsys_state *css;
 
-	cs = kzalloc(sizeof(*cs), GFP_KERNEL);
-	if (!cs)
+	css = kzalloc(sizeof(*css), GFP_KERNEL);
+	if (!css)
 		return ERR_PTR(-ENOMEM);
 
-	return &cs->css;
+	return css;
 }
 
 static int cgrp_css_online(struct cgroup *cgrp)
 {
-	struct cgroup *parent = cgrp->parent;
+	struct cgroup_subsys_state *css = cgroup_css(cgrp, net_prio_subsys_id);
+	struct cgroup_subsys_state *parent_css;
 	struct net_device *dev;
 	int ret = 0;
 
-	if (!parent)
+	if (!cgrp->parent)
 		return 0;
+	parent_css = cgroup_css(cgrp->parent, net_prio_subsys_id);
 
 	rtnl_lock();
 	/*
@@ -156,9 +154,9 @@ static int cgrp_css_online(struct cgroup *cgrp)
 	 * onlining, there is no need to clear them on offline.
 	 */
 	for_each_netdev(&init_net, dev) {
-		u32 prio = netprio_prio(parent, dev);
+		u32 prio = netprio_prio(parent_css, dev);
 
-		ret = netprio_set_prio(cgrp, dev, prio);
+		ret = netprio_set_prio(css, dev, prio);
 		if (ret)
 			break;
 	}
@@ -168,7 +166,7 @@ static int cgrp_css_online(struct cgroup *cgrp)
 
 static void cgrp_css_free(struct cgroup *cgrp)
 {
-	kfree(cgrp_netprio_state(cgrp));
+	kfree(cgroup_css(cgrp, net_prio_subsys_id));
 }
 
 static u64 read_prioidx(struct cgroup *cgrp, struct cftype *cft)
@@ -179,11 +177,12 @@ static u64 read_prioidx(struct cgroup *cgrp, struct cftype *cft)
 static int read_priomap(struct cgroup *cont, struct cftype *cft,
 			struct cgroup_map_cb *cb)
 {
+	struct cgroup_subsys_state *css = cgroup_css(cont, net_prio_subsys_id);
 	struct net_device *dev;
 
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, dev)
-		cb->fill(cb, dev->name, netprio_prio(cont, dev));
+		cb->fill(cb, dev->name, netprio_prio(css, dev));
 	rcu_read_unlock();
 	return 0;
 }
@@ -191,6 +190,7 @@ static int read_priomap(struct cgroup *cont, struct cftype *cft,
 static int write_priomap(struct cgroup *cgrp, struct cftype *cft,
 			 const char *buffer)
 {
+	struct cgroup_subsys_state *css = cgroup_css(cgrp, net_prio_subsys_id);
 	char devname[IFNAMSIZ + 1];
 	struct net_device *dev;
 	u32 prio;
@@ -205,7 +205,7 @@ static int write_priomap(struct cgroup *cgrp, struct cftype *cft,
 
 	rtnl_lock();
 
-	ret = netprio_set_prio(cgrp, dev, prio);
+	ret = netprio_set_prio(css, dev, prio);
 
 	rtnl_unlock();
 	dev_put(dev);
-- 
1.8.3.1

