Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaLCLhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:37:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbaLCL1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:42 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 092/101] ieee802154: fix error handling in ieee802154fake_probe()
Date: Wed,  3 Dec 2014 12:26:54 +0100
Message-Id: <0d55bc1cf51599a78ae3bb5182fa2eda1e9c0c7c.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 8c2dd54485ccee7fc4086611e188478584758c8d ]

In case of any failure ieee802154fake_probe() just calls unregister_netdev().
But it does not look safe to unregister netdevice before it was registered.

The patch implements straightforward resource deallocation in case of
failure in ieee802154fake_probe().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ieee802154/fakehard.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ieee802154/fakehard.c b/drivers/net/ieee802154/fakehard.c
index bf0d55e2dd63..6adbef89c4b0 100644
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

