Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbaGRJyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:54:10 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:58967
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761355AbaGRJyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:54:07 -0400
x-originating-ip: 72.167.245.219
From: Yue Zhang <yuezha@microsoft.com>
To: netdev@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        olaf@aepfle.de, jasowang@redhat.com, davem@davemloft.net
Cc: haiyangz@microsoft.com, kys@microsoft.com, huishao@microsoft.com,
        decui@microsoft.com
Subject: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Date: Fri, 18 Jul 2014 03:55:03 -0700
Message-Id: <1405680903-28176-1-git-send-email-yuezha@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yue Zhang <yuezha@microsoft.com>

This patch addresses the comment from Olaf Hering and Greg KH
for a previous commit 3a494e710367 ("hyperv: Add handler for
RNDIS_STATUS_NETWORK_CHANGE event")

In previous solution, the driver calls "network restart" to
force a DHCP renew when the host is back from hibernation.

In this fix, the driver will keep network carrier offline for
10 seconds and then bring it back. So that ifplugd daemon will
notice this change and refresh DHCP lease.

Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>

Signed-off-by: Yue Zhang <yuezha@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index a9c5eaa..559c97d 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -33,6 +33,7 @@
 #include <linux/if_vlan.h>
 #include <linux/in.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 #include <net/arp.h>
 #include <net/route.h>
 #include <net/sock.h>
@@ -792,8 +793,7 @@ static void netvsc_link_change(struct work_struct *w)
 	struct netvsc_device *net_device;
 	struct rndis_device *rdev;
 	bool notify, refresh = false;
-	char *argv[] = { "/etc/init.d/network", "restart", NULL };
-	char *envp[] = { "HOME=/", "PATH=/sbin:/usr/sbin:/bin:/usr/bin", NULL };
+	int delay;
 
 	rtnl_lock();
 
@@ -816,8 +816,21 @@ static void netvsc_link_change(struct work_struct *w)
 
 	rtnl_unlock();
 
-	if (refresh)
-		call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+	if (refresh) {
+		/*
+		 * Keep the carrier offline for 10 seconds
+		 * to notify ifplugd daemon network change
+		 */
+		for (delay = 0; delay < 10; delay++) {
+			rtnl_lock();
+			netif_carrier_off(net);
+			rtnl_unlock();
+			ssleep(1);
+		}
+		rtnl_lock();
+		netif_carrier_on(net);
+		rtnl_unlock();
+	}
 
 	if (notify)
 		netdev_notify_peers(net);
-- 
1.9.1

