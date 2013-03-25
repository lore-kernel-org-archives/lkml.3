Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab3CYBUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:20:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34137 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756349Ab3CYBQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:36 -0400
Message-Id: <20130325010527.444644366@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:56 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Veaceslav Falico <vfalico@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 032/104] netconsole: dont call __netpoll_cleanup() while  atomic
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 3f315bef23075ea8a98a6fe4221a83b83456d970 ]

__netpoll_cleanup() is called in netconsole_netdev_event() while holding a
spinlock. Release/acquire the spinlock before/after it and restart the
loop. Also, disable the netconsole completely, because we won't have chance
after the restart of the loop, and might end up in a situation where
nt->enabled == 1 and nt->np.dev == NULL.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/netconsole.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 01b104e..bff6908 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -630,6 +630,7 @@ static int netconsole_netdev_event(struct notifier_block *this,
 		goto done;
 
 	spin_lock_irqsave(&target_list_lock, flags);
+restart:
 	list_for_each_entry(nt, &target_list, list) {
 		netconsole_target_get(nt);
 		if (nt->np.dev == dev) {
@@ -642,20 +643,17 @@ static int netconsole_netdev_event(struct notifier_block *this,
 			case NETDEV_UNREGISTER:
 				/*
 				 * rtnl_lock already held
+				 * we might sleep in __netpoll_cleanup()
 				 */
-				if (nt->np.dev) {
-					spin_unlock_irqrestore(
-							      &target_list_lock,
-							      flags);
-					__netpoll_cleanup(&nt->np);
-					spin_lock_irqsave(&target_list_lock,
-							  flags);
-					dev_put(nt->np.dev);
-					nt->np.dev = NULL;
-				}
+				spin_unlock_irqrestore(&target_list_lock, flags);
+				__netpoll_cleanup(&nt->np);
+				spin_lock_irqsave(&target_list_lock, flags);
+				dev_put(nt->np.dev);
+				nt->np.dev = NULL;
 				nt->enabled = 0;
 				stopped = true;
-				break;
+				netconsole_target_put(nt);
+				goto restart;
 			}
 		}
 		netconsole_target_put(nt);


