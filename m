Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3LUAFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 19:05:07 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:34914
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab3LUAFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 19:05:05 -0500
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net] hyperv: Fix race between probe and open calls
Date: Fri, 20 Dec 2013 16:52:31 -0800
Message-Id: <1387587151-1508-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving the register_netdev to the end of probe to prevent
possible open call happens before NetVSP is connected.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index f813572..71baeb3 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -261,9 +261,7 @@ int netvsc_recv_callback(struct hv_device *device_obj,
 	struct sk_buff *skb;
 
 	net = ((struct netvsc_device *)hv_get_drvdata(device_obj))->ndev;
-	if (!net) {
-		netdev_err(net, "got receive callback but net device"
-			" not initialized yet\n");
+	if (!net || net->reg_state != NETREG_REGISTERED) {
 		packet->status = NVSP_STAT_FAIL;
 		return 0;
 	}
@@ -435,19 +433,11 @@ static int netvsc_probe(struct hv_device *dev,
 	SET_ETHTOOL_OPS(net, &ethtool_ops);
 	SET_NETDEV_DEV(net, &dev->device);
 
-	ret = register_netdev(net);
-	if (ret != 0) {
-		pr_err("Unable to register netdev.\n");
-		free_netdev(net);
-		goto out;
-	}
-
 	/* Notify the netvsc driver of the new device */
 	device_info.ring_size = ring_size;
 	ret = rndis_filter_device_add(dev, &device_info);
 	if (ret != 0) {
 		netdev_err(net, "unable to add netvsc device (ret %d)\n", ret);
-		unregister_netdev(net);
 		free_netdev(net);
 		hv_set_drvdata(dev, NULL);
 		return ret;
@@ -456,7 +446,13 @@ static int netvsc_probe(struct hv_device *dev,
 
 	netif_carrier_on(net);
 
-out:
+	ret = register_netdev(net);
+	if (ret != 0) {
+		pr_err("Unable to register netdev.\n");
+		rndis_filter_device_remove(dev);
+		free_netdev(net);
+	}
+
 	return ret;
 }
 
-- 
1.7.4.1

