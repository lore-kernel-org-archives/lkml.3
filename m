Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab3JKUPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:15:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab3JKTlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 018/135] netpoll: fix NULL pointer dereference in netpoll_cleanup
Date: Fri, 11 Oct 2013 12:38:19 -0700
Message-Id: <20131011193947.215071719@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -1284,15 +1284,14 @@ EXPORT_SYMBOL_GPL(__netpoll_free_async);
 
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
 


