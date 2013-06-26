Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab3FZHaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:30:08 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:4734 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3FZHaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:30:06 -0400
Message-ID: <51CA9872.5050700@huawei.com>
Date: Wed, 26 Jun 2013 15:29:54 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: LKML <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 1/2] dlci: acquire rtnl_lock before calling __dev_get_by_name()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise the net device returned can be freed at anytime.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: stable@vger.kernel.org
---
 drivers/net/wan/dlci.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wan/dlci.c b/drivers/net/wan/dlci.c
index 147614e..1f6e053 100644
--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -385,20 +385,24 @@ static int dlci_del(struct dlci_add *dlci)
 	struct net_device	*master, *slave;
 	int			err;
 
+	rtnl_lock();
+
 	/* validate slave device */
 	master = __dev_get_by_name(&init_net, dlci->devname);
-	if (!master)
-		return -ENODEV;
+	if (!master) {
+		err = -ENODEV;
+		goto out;
+	}
 
 	if (netif_running(master)) {
-		return -EBUSY;
+		err = -EBUSY;
+		goto out;
 	}
 
 	dlp = netdev_priv(master);
 	slave = dlp->slave;
 	flp = netdev_priv(slave);
 
-	rtnl_lock();
 	err = (*flp->deassoc)(slave, master);
 	if (!err) {
 		list_del(&dlp->list);
@@ -407,8 +411,8 @@ static int dlci_del(struct dlci_add *dlci)
 
 		dev_put(slave);
 	}
+out:
 	rtnl_unlock();
-
 	return err;
 }
 
-- 
1.8.0.2
