Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaK3L5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 06:57:09 -0500
Received: from mout.gmx.net ([212.227.15.18]:54670 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbaK3L5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 06:57:07 -0500
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: stephen@networkplumber.org
Cc: mlindner@marvell.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH] sky2: avoid pci write posting after disabling irqs
Date: Sun, 30 Nov 2014 12:56:51 +0100
Message-Id: <1417348611-1752-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:8D81MfsZgFI2kqsPx7DTLsYxtc2wMc8XtdkOl0nLUURPuE5xmVA
 IA4FEyilpFZSQ2QWHeapUasGDTgdqkp8dDfpE3LG97dfct+Zcw8zMEfCp+qR0pEbhP7FdEb
 2Hm259KiTa20JR+K7+qJhr4sRPvZ2jglE0Uw1/JuVH6Auz3mJu2xzr1B817HKlWoStQS1aP
 etZbEm+cdGdsnbn9KPnQw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sky2_change_mtu setting B0_IMSK to 0 may be delayed due to PCI write posting
which could result in irqs being still active when synchronize_irq is called.
Since we are not prepared to handle any further irqs after synchronize_irq
(our resources are freed after that) force the write by a consecutive read from
the same register.
Similar situation in sky2_all_down: Here we disabled irqs by a write to B0_IMSK
but did not ensure that this write took place before synchronize_irq. Fix that
too.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 drivers/net/ethernet/marvell/sky2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index bd33662..f14544c 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -2419,6 +2419,7 @@ static int sky2_change_mtu(struct net_device *dev, int new_mtu)
 
 	imask = sky2_read32(hw, B0_IMSK);
 	sky2_write32(hw, B0_IMSK, 0);
+	sky2_read32(hw, B0_IMSK);
 
 	dev->trans_start = jiffies;	/* prevent tx timeout */
 	napi_disable(&hw->napi);
@@ -3487,8 +3488,8 @@ static void sky2_all_down(struct sky2_hw *hw)
 	int i;
 
 	if (hw->flags & SKY2_HW_IRQ_SETUP) {
-		sky2_read32(hw, B0_IMSK);
 		sky2_write32(hw, B0_IMSK, 0);
+		sky2_read32(hw, B0_IMSK);
 
 		synchronize_irq(hw->pdev->irq);
 		napi_disable(&hw->napi);
-- 
1.9.1

