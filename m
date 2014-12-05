Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbaLEXwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:52:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaLEWpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 022/122] ieee802154: fix error handling in ieee802154fake_probe()
Date: Fri,  5 Dec 2014 14:43:16 -0800
Message-Id: <20141205223308.785091428@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ieee802154/fakehard.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/ieee802154/fakehard.c
+++ b/drivers/net/ieee802154/fakehard.c
@@ -377,17 +377,20 @@ static int ieee802154fake_probe(struct p
 
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
 


