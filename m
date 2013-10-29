Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3J2SJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:09:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59572 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab3J2SJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 36/81] netpoll: fix NULL pointer dereference in netpoll_cleanup
Date: Tue, 29 Oct 2013 11:03:57 -0700
Message-Id: <1383069882-11437-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@redhat.com>

[ Upstream commit d0fe8c888b1fd1a2f84b9962cabcb98a70988aec ]

I've been hitting a NULL ptr deref while using netconsole because the
np->dev check and the pointer manipulation in netpoll_cleanup are done
without rtnl and the following sequence happens when having a netconsole
over a vlan and we remove the vlan while disabling the netconsole:
	CPU 1					CPU2
					removes vlan and calls the notifier
enters store_enabled(), calls
netdev_cleanup which checks np->dev
and then waits for rtnl
					executes the netconsole netdev
					release notifier making np->dev
					== NULL and releases rtnl
continues to dereference a member of
np->dev which at this point is == NULL

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/netpoll.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 3151acf..40c1496 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -962,15 +962,14 @@ EXPORT_SYMBOL_GPL(__netpoll_free_rcu);
 
 void netpoll_cleanup(struct netpoll *np)
 {
-	if (!np->dev)
-		return;
-
 	rtnl_lock();
+	if (!np->dev)
+		goto out;
 	__netpoll_cleanup(np);
-	rtnl_unlock();
-
 	dev_put(np->dev);
 	np->dev = NULL;
+out:
+	rtnl_unlock();
 }
 EXPORT_SYMBOL(netpoll_cleanup);
 
-- 
1.8.1.2

