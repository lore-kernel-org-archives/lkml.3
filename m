Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab3GBLIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:08:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36352 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3GBLIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 42/50] dlci: acquire rtnl_lock before calling __dev_get_by_name()
Date: Tue,  2 Jul 2013 12:07:30 +0100
Message-Id: <1372763258-20664-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zefan Li <lizefan@huawei.com>

commit 11eb2645cbf38a08ae491bf6c602eea900ec0bb5 upstream.

Otherwise the net device returned can be freed at anytime.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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

