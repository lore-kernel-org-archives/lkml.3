Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3JUJJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:09:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39720 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754092Ab3JUIwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:11 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Nikolay Aleksandrov" <nikolay@redhat.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.899725233@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 103/149] netpoll: fix NULL pointer dereference in 
 netpoll_cleanup
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/netpoll.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index db4bb7a..9649cea 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -923,15 +923,14 @@ EXPORT_SYMBOL_GPL(__netpoll_cleanup);
 
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
 

