Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbaD3MHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:07:12 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:47921 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037AbaD3MHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:07:10 -0400
From: Alexey Charkov <alchark@gmail.com>
To: Roger Luethi <rl@hellgate.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>,
        Jan Moskyto Matejka <mq@suse.cz>
Cc: Alexey Charkov <alchark@gmail.com>
Subject: [PATCH] net: via-rhine: Fix compiler warning re: pointer casting on 64bit
Date: Wed, 30 Apr 2014 16:06:29 +0400
Message-Id: <1398859589-22346-1-git-send-email-alchark@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F702D00@AcuExch.aculab.com>
References: <063D6719AE5E284EB5DD2968C1650D6D0F702D00@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed different size cast warning:

        drivers/net/ethernet/via/via-rhine.c: In function ‘rhine_init_one_platform’:
        drivers/net/ethernet/via/via-rhine.c:1132:13: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
          revision = (u32)match->data;
                     ^

That code was added in commit 2d283862dc62daead9db0dc89cd0d0351e91f765
("net: via-rhine: add OF bus binding").

This patch removes the cast altogether, and instead stores an actual
pointer to u8 in match->data. All instances of 'revision' are also
unified to u8 instead of an assortment of different integer types,
in line with the definition of 'revision' in struct pci_dev.

Tested in platform configuration on a VIA WM8950 APC Rock board.

Reported-by: Jan Moskyto Matejka <mq@suse.cz>
Signed-off-by: Alexey Charkov <alchark@gmail.com>
---
 drivers/net/ethernet/via/via-rhine.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 4fa9201..80cdc91 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -287,8 +287,9 @@ MODULE_DEVICE_TABLE(pci, rhine_pci_tbl);
  * The .data field is currently only used to store chip revision
  * (for quirks etc.)
  */
+static u8 vt8500_revision = 0x84;
 static struct of_device_id rhine_of_tbl[] = {
-	{ .compatible = "via,vt8500-rhine", .data = (void *)0x84 },
+	{ .compatible = "via,vt8500-rhine", .data = &vt8500_revision },
 	{ }	/* terminate list */
 };
 MODULE_DEVICE_TABLE(of, rhine_of_tbl);
@@ -459,7 +460,7 @@ struct rhine_private {
 	unsigned char *tx_bufs;
 	dma_addr_t tx_bufs_dma;
 
-	int revision;
+	u8 revision;
 	int irq;
 	long pioaddr;
 	struct net_device *dev;
@@ -882,7 +883,7 @@ static const struct net_device_ops rhine_netdev_ops = {
 #endif
 };
 
-static int rhine_init_one_common(struct device *hwdev, int revision,
+static int rhine_init_one_common(struct device *hwdev, u8 revision,
 				 long pioaddr, void __iomem *ioaddr, int irq)
 {
 	struct net_device *dev;
@@ -1111,7 +1112,7 @@ err_out:
 static int rhine_init_one_platform(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
-	u32 revision;
+	const u8 *revision;
 	int irq;
 	struct resource *res;
 	void __iomem *ioaddr;
@@ -1129,11 +1130,11 @@ static int rhine_init_one_platform(struct platform_device *pdev)
 	if (!irq)
 		return -EINVAL;
 
-	revision = (u32)match->data;
+	revision = match->data;
 	if (!revision)
 		return -EINVAL;
 
-	return rhine_init_one_common(&pdev->dev, revision,
+	return rhine_init_one_common(&pdev->dev, *revision,
 				     (long)ioaddr, ioaddr, irq);
 }
 
-- 
1.9.1

