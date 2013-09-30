Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab3I3KbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:31:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43529 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab3I3KMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 040/104] neighbour: populate neigh_parms on alloc before calling ndo_neigh_setup
Date: Mon, 30 Sep 2013 11:10:17 +0100
Message-Id: <1380535881-9239-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

commit 63134803a6369dcf7dddf7f0d5e37b9566b308d2 upstream.

dev->ndo_neigh_setup() might need some of the values of neigh_parms, so
populate them before calling it.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/neighbour.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index c09f82b..38d5188 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1443,16 +1443,18 @@ struct neigh_parms *neigh_parms_alloc(struct net_device *dev,
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
1.8.3.2

