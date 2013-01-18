Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3ARVYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:24:32 -0500
Received: from mail.ispras.ru ([83.149.199.43]:35128 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab3ARVYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:24:31 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Lennert Buytenhek <buytenh@wantstofly.org>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] mwl8k: don't return zero on failure paths in mwl8k_probe[_hw]()
Date: Sat, 19 Jan 2013 01:24:01 +0400
Message-Id: <1358544241-13032-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pci_iomap() fails in mwl8k_probe(), it breaks off initialization,
deallocates all resources, but returns zero.
There is a similar issue when priv->rxd_ops is NULL in mwl8k_probe_hw().

The patch adds proper error code return values.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/mwl8k.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f221b95..018f442 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5462,6 +5462,7 @@ static int mwl8k_probe_hw(struct ieee80211_hw *hw)
 		if (priv->rxd_ops == NULL) {
 			wiphy_err(hw->wiphy,
 				  "Driver does not have AP firmware image support for this hardware\n");
+			rc = -ENOENT;
 			goto err_stop_firmware;
 		}
 	} else {
@@ -5807,6 +5808,7 @@ static int mwl8k_probe(struct pci_dev *pdev,
 	priv->sram = pci_iomap(pdev, 0, 0x10000);
 	if (priv->sram == NULL) {
 		wiphy_err(hw->wiphy, "Cannot map device SRAM\n");
+		rc = -EIO;
 		goto err_iounmap;
 	}
 
@@ -5819,6 +5821,7 @@ static int mwl8k_probe(struct pci_dev *pdev,
 		priv->regs = pci_iomap(pdev, 2, 0x10000);
 		if (priv->regs == NULL) {
 			wiphy_err(hw->wiphy, "Cannot map device registers\n");
+			rc = -EIO;
 			goto err_iounmap;
 		}
 	}
-- 
1.7.9.5

