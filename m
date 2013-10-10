Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab3JJQKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:10:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52583 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3JJPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 005/104] neighbour: populate neigh_parms on alloc before calling ndo_neigh_setup
Date: Thu, 10 Oct 2013 08:40:53 -0700
Message-Id: <1381419752-29733-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 63134803a6369dcf7dddf7f0d5e37b9566b308d2 ]

dev->ndo_neigh_setup() might need some of the values of neigh_parms, so
populate them before calling it.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/neighbour.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 8f9a6c6..e7f5bff 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1458,16 +1458,18 @@ struct neigh_parms *neigh_parms_alloc(struct net_device *dev,
 		atomic_set(&p->refcnt, 1);
 		p->reachable_time =
 				neigh_rand_reach_time(p->base_reachable_time);
+		dev_hold(dev);
+		p->dev = dev;
+		write_pnet(&p->net, hold_net(net));
+		p->sysctl_table = NULL;
 
 		if (ops->ndo_neigh_setup && ops->ndo_neigh_setup(dev, p)) {
+			release_net(net);
+			dev_put(dev);
 			kfree(p);
 			return NULL;
 		}
 
-		dev_hold(dev);
-		p->dev = dev;
-		write_pnet(&p->net, hold_net(net));
-		p->sysctl_table = NULL;
 		write_lock_bh(&tbl->lock);
 		p->next		= tbl->parms.next;
 		tbl->parms.next = p;
-- 
1.8.1.2

