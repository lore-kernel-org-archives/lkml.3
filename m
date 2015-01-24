Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbbAXOHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:07:54 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48984 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbbAXOEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:20 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 20/32] net: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:26 -0500
Message-Id: <1422108218-25398-21-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
---
 net/core/net-sysfs.c       | 28 +++++++---------------------
 net/core/sysctl_net_core.c |  2 +-
 2 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 9993412..f2aa73b 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -614,8 +614,7 @@ static ssize_t show_rps_map(struct netdev_rx_queue *queue,
 {
 	struct rps_map *map;
 	cpumask_var_t mask;
-	size_t len = 0;
-	int i;
+	int i, len;
 
 	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
@@ -626,17 +625,11 @@ static ssize_t show_rps_map(struct netdev_rx_queue *queue,
 		for (i = 0; i < map->len; i++)
 			cpumask_set_cpu(map->cpus[i], mask);
 
-	len += cpumask_scnprintf(buf + len, PAGE_SIZE, mask);
-	if (PAGE_SIZE - len < 3) {
-		rcu_read_unlock();
-		free_cpumask_var(mask);
-		return -EINVAL;
-	}
+	len = snprintf(buf, PAGE_SIZE, "%*pb\n", cpumask_pr_args(mask));
 	rcu_read_unlock();
-
 	free_cpumask_var(mask);
-	len += sprintf(buf + len, "\n");
-	return len;
+
+	return len < PAGE_SIZE ? len : -EINVAL;
 }
 
 static ssize_t store_rps_map(struct netdev_rx_queue *queue,
@@ -1090,8 +1083,7 @@ static ssize_t show_xps_map(struct netdev_queue *queue,
 	struct xps_dev_maps *dev_maps;
 	cpumask_var_t mask;
 	unsigned long index;
-	size_t len = 0;
-	int i;
+	int i, len;
 
 	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
@@ -1117,15 +1109,9 @@ static ssize_t show_xps_map(struct netdev_queue *queue,
 	}
 	rcu_read_unlock();
 
-	len += cpumask_scnprintf(buf + len, PAGE_SIZE, mask);
-	if (PAGE_SIZE - len < 3) {
-		free_cpumask_var(mask);
-		return -EINVAL;
-	}
-
+	len = snprintf(buf, PAGE_SIZE, "%*pb\n", cpumask_pr_args(mask));
 	free_cpumask_var(mask);
-	len += sprintf(buf + len, "\n");
-	return len;
+	return len < PAGE_SIZE ? len : -EINVAL;
 }
 
 static ssize_t store_xps_map(struct netdev_queue *queue,
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 31baba2..453ada1 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -155,7 +155,7 @@ write_unlock:
 		rcu_read_unlock();
 
 		len = min(sizeof(kbuf) - 1, *lenp);
-		len = cpumask_scnprintf(kbuf, len, mask);
+		len = scnprintf(kbuf, len, "%*pb", cpumask_pr_args(mask));
 		if (!len) {
 			*lenp = 0;
 			goto done;
-- 
2.1.0

