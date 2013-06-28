Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3F1S4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:56:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41776 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3F1S4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:56:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 103/105] dlci: acquire rtnl_lock before calling __dev_get_by_name()
Date: Fri, 28 Jun 2013 11:52:05 -0700
Message-Id: <1372445527-24414-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zefan Li <lizefan@huawei.com>

commit 11eb2645cbf38a08ae491bf6c602eea900ec0bb5 upstream.

Otherwise the net device returned can be freed at anytime.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.1.2

