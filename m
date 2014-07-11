Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaGKHgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:36:45 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:52712 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaGKHgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:36:40 -0400
From: varkabhadram@gmail.com
To: netdev@vger.kernel.org
Cc: Thomas.Lendacky@amd.com, geert+renesas@linux-m68k.org,
        ebiederm@xmission.com, macro@linux-mips.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH net-next 2/8] ethernet: amd: use devm_ioremap()
Date: Fri, 11 Jul 2014 13:05:04 +0530
Message-Id: <1405064110-22579-3-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405064110-22579-1-git-send-email-varkabhadram@gmail.com>
References: <1405064110-22579-1-git-send-email-varkabhadram@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkab@cdac.in>

This patch replace ioremap() with the devm_ioremap() so that
the resource will be freed automatically with the probe failed.

Signed-off-by: Varka Bhadram <varkab@cdac.in>
---
 drivers/net/ethernet/amd/amd8111e.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index ddd09e8..433107c 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1866,7 +1866,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 
 	spin_lock_init(&lp->lock);
 
-	lp->mmio = ioremap(reg_addr, reg_len);
+	lp->mmio = devm_ioremap(&pdev->dev, reg_addr, reg_len);
 	if (!lp->mmio) {
 		printk(KERN_ERR "amd8111e: Cannot map device registers, "
 		       "exiting\n");
@@ -1913,7 +1913,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 	if (err) {
 		printk(KERN_ERR "amd8111e: Cannot register net device, "
 		       "exiting.\n");
-		goto err_iounmap;
+		goto err_free_dev;
 	}
 
 	pci_set_drvdata(pdev, dev);
@@ -1943,8 +1943,6 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 		printk(KERN_INFO "%s: Couldn't detect MII PHY, assuming address 0x01\n",
 		       dev->name);
     	return 0;
-err_iounmap:
-	iounmap(lp->mmio);
 
 err_free_dev:
 	free_netdev(dev);
@@ -1964,7 +1962,6 @@ static void amd8111e_remove_one(struct pci_dev *pdev)
 
 	if (dev) {
 		unregister_netdev(dev);
-		iounmap(((struct amd8111e_priv *)netdev_priv(dev))->mmio);
 		free_netdev(dev);
 		pci_release_regions(pdev);
 		pci_disable_device(pdev);
-- 
1.7.9.5

