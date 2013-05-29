Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965265Ab3E2JC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:02:26 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:41589 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039Ab3E2JCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:02:24 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <liuj97@gmail.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH] tg3: remove redundant pm init code
Date: Wed, 29 May 2013 17:00:32 +0800
Message-ID: <1369818032-36272-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pci_enable_device() will set device pm state to D0, so
it's no need to do it again in tg3_init_one().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/net/ethernet/broadcom/tg3.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 728d42a..1396ab3 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17042,25 +17042,10 @@ static int tg3_init_one(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	/* Find power-management capability. */
-	pm_cap = pci_find_capability(pdev, PCI_CAP_ID_PM);
-	if (pm_cap == 0) {
-		dev_err(&pdev->dev,
-			"Cannot find Power Management capability, aborting\n");
-		err = -EIO;
-		goto err_out_free_res;
-	}
-
-	err = pci_set_power_state(pdev, PCI_D0);
-	if (err) {
-		dev_err(&pdev->dev, "Transition to D0 failed, aborting\n");
-		goto err_out_free_res;
-	}
-
 	dev = alloc_etherdev_mq(sizeof(*tp), TG3_IRQ_MAX_VECS);
 	if (!dev) {
 		err = -ENOMEM;
-		goto err_out_power_down;
+		goto err_out_free_res;
 	}
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
@@ -17406,9 +17391,6 @@ err_out_iounmap:
 err_out_free_dev:
 	free_netdev(dev);
 
-err_out_power_down:
-	pci_set_power_state(pdev, PCI_D3hot);
-
 err_out_free_res:
 	pci_release_regions(pdev);
 
-- 
1.7.1


