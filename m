Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab3CZX1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:27:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab3CZWwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Veaceslav Falico <vfalico@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 04/72] netconsole: dont call __netpoll_cleanup() while atomic
Date: Tue, 26 Mar 2013 15:50:47 -0700
Message-Id: <20130326224920.155448260@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netconsole.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -626,6 +626,7 @@ static int netconsole_netdev_event(struc
 		goto done;
 
 	spin_lock_irqsave(&target_list_lock, flags);
+restart:
 	list_for_each_entry(nt, &target_list, list) {
 		netconsole_target_get(nt);
 		if (nt->np.dev == dev) {
@@ -637,21 +638,18 @@ static int netconsole_netdev_event(struc
 			case NETDEV_JOIN:
 			case NETDEV_UNREGISTER:
 				/*
+				 * we might sleep in __netpoll_cleanup()
 				 * rtnl_lock already held
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


