Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3FRIHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:07:22 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:51799 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3FRIHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:07:16 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        Patrick McHardy <kaber@trash.net>, Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: [PATCH 2/9] amd8111e: use pdev->pm_cap instead of pci_find_capability(..,PCI_CAP_ID_PM)
Date: Tue, 18 Jun 2013 16:06:37 +0800
Message-ID: <1371542797-14964-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pci core has been saved pm cap register offset by pdev->pm_cap in pci_pm_init()
in init path. So we can use pdev->pm_cap instead of using
pci_find_capability(pdev, PCI_CAP_ID_PM) for better performance and simplified code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
---
 drivers/net/ethernet/amd/amd8111e.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 8e6b665..e947fd7 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1813,7 +1813,7 @@ static const struct net_device_ops amd8111e_netdev_ops = {
 static int amd8111e_probe_one(struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
 {
-	int err,i,pm_cap;
+	int err, i;
 	unsigned long reg_addr,reg_len;
 	struct amd8111e_priv* lp;
 	struct net_device* dev;
@@ -1842,7 +1842,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 	pci_set_master(pdev);
 
 	/* Find power-management capability. */
-	if((pm_cap = pci_find_capability(pdev, PCI_CAP_ID_PM))==0){
+	if (!pdev->pm_cap) {
 		printk(KERN_ERR "amd8111e: No Power Management capability, "
 		       "exiting.\n");
 		err = -ENODEV;
@@ -1875,7 +1875,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 	lp = netdev_priv(dev);
 	lp->pci_dev = pdev;
 	lp->amd8111e_net_dev = dev;
-	lp->pm_cap = pm_cap;
+	lp->pm_cap = pdev->pm_cap;
 
 	spin_lock_init(&lp->lock);
 
-- 
1.7.1


