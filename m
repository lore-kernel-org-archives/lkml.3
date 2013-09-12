Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3ILR7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:59:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3ILR7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 05/46] neighbour: populate neigh_parms on alloc before calling ndo_neigh_setup
Date: Thu, 12 Sep 2013 10:58:16 -0700
Message-Id: <20130912175721.641931326@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 63134803a6369dcf7dddf7f0d5e37b9566b308d2 ]

dev->ndo_neigh_setup() might need some of the values of neigh_parms, so
populate them before calling it.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/neighbour.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1445,16 +1445,18 @@ struct neigh_parms *neigh_parms_alloc(st
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


