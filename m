Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaA0Hbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 02:31:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaA0Hbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 02:31:38 -0500
From: Jason Wang <jasowang@redhat.com>
To: kys@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH net] net: hyperv: initialize link status correctly
Date: Mon, 27 Jan 2014 15:30:54 +0800
Message-Id: <1390807854-4469-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call netif_carrier_on() after register_device(). Otherwise it won't work since
the device was still in NETREG_UNINITIALIZED state.

Fixes a68f9614614749727286f675d15f1e09d13cb54a
(hyperv: Fix race between probe and open calls)

Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Reported-by: Di Nie <dnie@redhat.com>
Tested-by: Di Nie <dnie@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/hyperv/netvsc_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 71baeb3..dc11601 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -444,13 +444,13 @@ static int netvsc_probe(struct hv_device *dev,
 	}
 	memcpy(net->dev_addr, device_info.mac_adr, ETH_ALEN);
 
-	netif_carrier_on(net);
-
 	ret = register_netdev(net);
 	if (ret != 0) {
 		pr_err("Unable to register netdev.\n");
 		rndis_filter_device_remove(dev);
 		free_netdev(net);
+	} else {
+		netif_carrier_on(net);
 	}
 
 	return ret;
-- 
1.8.3.2

