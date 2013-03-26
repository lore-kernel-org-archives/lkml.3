Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965473Ab3CZPYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:24:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54173 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965438Ab3CZPYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 140/150] netconsole: don't call __netpoll_cleanup() while atomic
Date: Tue, 26 Mar 2013 15:20:39 +0000
Message-Id: <1364311249-14454-141-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

commit 3f315bef23075ea8a98a6fe4221a83b83456d970 upstream.

__netpoll_cleanup() is called in netconsole_netdev_event() while holding a
spinlock. Release/acquire the spinlock before/after it and restart the
loop. Also, disable the netconsole completely, because we won't have chance
after the restart of the loop, and might end up in a situation where
nt->enabled == 1 and nt->np.dev == NULL.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/netconsole.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 63ffbdf..2524a69 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -626,6 +626,7 @@ static int netconsole_netdev_event(struct notifier_block *this,
 		goto done;
 
 	spin_lock_irqsave(&target_list_lock, flags);
+restart:
 	list_for_each_entry(nt, &target_list, list) {
 		netconsole_target_get(nt);
 		if (nt->np.dev == dev) {
@@ -638,20 +639,17 @@ static int netconsole_netdev_event(struct notifier_block *this,
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
-- 
1.8.1.2

