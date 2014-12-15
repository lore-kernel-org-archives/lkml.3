Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaLOO1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:27:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38160 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaLOO1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 005/168] ieee802154: fix error handling in ieee802154fake_probe()
Date: Mon, 15 Dec 2014 14:24:19 +0000
Message-Id: <1418653622-21105-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit 8c2dd54485ccee7fc4086611e188478584758c8d upstream.

In case of any failure ieee802154fake_probe() just calls unregister_netdev().
But it does not look safe to unregister netdevice before it was registered.

The patch implements straightforward resource deallocation in case of
failure in ieee802154fake_probe().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ieee802154/fakehard.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ieee802154/fakehard.c b/drivers/net/ieee802154/fakehard.c
index 78f18be3bbf2..c6aaa3d9de63 100644
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
2.1.3

