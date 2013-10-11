Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab3JKK5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:57:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58627 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab3JKKne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 057/100] netpoll: fix NULL pointer dereference in netpoll_cleanup
Date: Fri, 11 Oct 2013 11:41:27 +0100
Message-Id: <1381488130-30235-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@redhat.com>

commit d0fe8c888b1fd1a2f84b9962cabcb98a70988aec upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/netpoll.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index f9f40b9..5e81c49 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -920,15 +920,14 @@ EXPORT_SYMBOL_GPL(__netpoll_cleanup);
 
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
1.8.3.2

