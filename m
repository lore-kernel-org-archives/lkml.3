Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaLOT2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:28:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40695 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaLOT2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:28:41 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 31/96] ieee802154: fix error handling in ieee802154fake_probe()
Date: Mon, 15 Dec 2014 11:25:51 -0800
Message-Id: <1418671616-25482-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit 8c2dd54485ccee7fc4086611e188478584758c8d ]

In case of any failure ieee802154fake_probe() just calls unregister_netdev().
But it does not look safe to unregister netdevice before it was registered.

The patch implements straightforward resource deallocation in case of
failure in ieee802154fake_probe().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ieee802154/fakehard.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ieee802154/fakehard.c b/drivers/net/ieee802154/fakehard.c
index bf0d55e..6adbef8 100644
--- a/drivers/net/ieee802154/fakehard.c
+++ b/drivers/net/ieee802154/fakehard.c
@@ -376,17 +376,20 @@ static int ieee802154fake_probe(struct platform_device *pdev)
 
 	err = wpan_phy_register(phy);
 	if (err)
-		goto out;
+		goto err_phy_reg;
 
 	err = register_netdev(dev);
-	if (err < 0)
-		goto out;
+	if (err)
+		goto err_netdev_reg;
 
 	dev_info(&pdev->dev, "Added ieee802154 HardMAC hardware\n");
 	return 0;
 
-out:
-	unregister_netdev(dev);
+err_netdev_reg:
+	wpan_phy_unregister(phy);
+err_phy_reg:
+	free_netdev(dev);
+	wpan_phy_free(phy);
 	return err;
 }
 
-- 
1.9.1

