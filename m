Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab3AYU4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:56:17 -0500
Received: from mail.ispras.ru ([83.149.199.43]:58471 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab3AYU4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:56:15 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Bing Zhao <bzhao@marvell.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] mwifiex: don't return zero on failure paths in mwifiex_pcie_init()
Date: Sat, 26 Jan 2013 00:56:03 +0400
Message-Id: <1359147363-9587-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pci_iomap() fails in mwifiex_pcie_init(), it breaks off initialization,
deallocates all resources, but returns zero.
The patch adds -EIO as return value in this case.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/mwifiex/pcie.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 13fbc4e..9d9349c 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1739,6 +1739,7 @@ static int mwifiex_pcie_init(struct mwifiex_adapter *adapter)
 	card->pci_mmap = pci_iomap(pdev, 0, 0);
 	if (!card->pci_mmap) {
 		dev_err(adapter->dev, "iomap(0) error\n");
+		ret = -EIO;
 		goto err_iomap0;
 	}
 	ret = pci_request_region(pdev, 2, DRV_NAME);
@@ -1749,6 +1750,7 @@ static int mwifiex_pcie_init(struct mwifiex_adapter *adapter)
 	card->pci_mmap1 = pci_iomap(pdev, 2, 0);
 	if (!card->pci_mmap1) {
 		dev_err(adapter->dev, "iomap(2) error\n");
+		ret = -EIO;
 		goto err_iomap2;
 	}
 
-- 
1.7.9.5

