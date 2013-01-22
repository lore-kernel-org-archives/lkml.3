Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab3AVOaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:30:12 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:51253 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3AVOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:30:07 -0500
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/3] staging: et131x: Fix endian bugs in et131x_get_regs()
Date: Tue, 22 Jan 2013 14:29:47 +0000
Message-Id: <1358864989-4859-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

et131x_get_regs() calls et131x_mii_read(), passing the address of a u32
which is cast to a (u16 *). This works fine for little endian systems,
but not for big endian. Change so that the types are cast, not pointers
to the types.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   97 ++++++++++++++++++++++++---------------
 1 file changed, 61 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index f0bc7ba..2b2f315 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3456,6 +3456,7 @@ static void et131x_get_regs(struct net_device *netdev,
 	struct address_map __iomem *aregs = adapter->regs;
 	u32 *regs_buff = regs_data;
 	u32 num = 0;
+	u16 tmp;
 
 	memset(regs_data, 0, et131x_get_regs_len(netdev));
 
@@ -3463,44 +3464,68 @@ static void et131x_get_regs(struct net_device *netdev,
 			adapter->pdev->device;
 
 	/* PHY regs */
-	et131x_mii_read(adapter, MII_BMCR, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, MII_BMSR, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, MII_PHYSID1, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, MII_PHYSID2, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, MII_ADVERTISE, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, MII_LPA, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, MII_EXPANSION, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, MII_BMCR, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, MII_BMSR, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, MII_PHYSID1, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, MII_PHYSID2, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, MII_ADVERTISE, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, MII_LPA, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, MII_EXPANSION, &tmp);
+	regs_buff[num++] = tmp;
 	/* Autoneg next page transmit reg */
-	et131x_mii_read(adapter, 0x07, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, 0x07, &tmp);
+	regs_buff[num++] = tmp;
 	/* Link partner next page reg */
-	et131x_mii_read(adapter, 0x08, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, MII_CTRL1000, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, MII_STAT1000, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, 0x0b, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, 0x0c, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, MII_MMD_CTRL, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, MII_MMD_DATA, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, MII_ESTATUS, (u16 *)&regs_buff[num++]);
-
-	et131x_mii_read(adapter, PHY_INDEX_REG, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, PHY_DATA_REG, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG,
-			(u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, PHY_LOOPBACK_CONTROL,
-			(u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, PHY_LOOPBACK_CONTROL+1,
-			(u16 *)&regs_buff[num++]);
-
-	et131x_mii_read(adapter, PHY_REGISTER_MGMT_CONTROL,
-			(u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, PHY_CONFIG, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, PHY_PHY_CONTROL, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, PHY_INTERRUPT_MASK, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, PHY_INTERRUPT_STATUS,
-			(u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, PHY_PHY_STATUS, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, PHY_LED_1, (u16 *)&regs_buff[num++]);
-	et131x_mii_read(adapter, PHY_LED_2, (u16 *)&regs_buff[num++]);
+	et131x_mii_read(adapter, 0x08, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, MII_CTRL1000, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, MII_STAT1000, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, 0x0b, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, 0x0c, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, MII_MMD_CTRL, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, MII_MMD_DATA, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, MII_ESTATUS, &tmp);
+	regs_buff[num++] = tmp;
+
+	et131x_mii_read(adapter, PHY_INDEX_REG, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, PHY_DATA_REG, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, PHY_LOOPBACK_CONTROL, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, PHY_LOOPBACK_CONTROL + 1, &tmp);
+	regs_buff[num++] = tmp;
+
+	et131x_mii_read(adapter, PHY_REGISTER_MGMT_CONTROL, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, PHY_CONFIG, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, PHY_PHY_CONTROL, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, PHY_INTERRUPT_MASK, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, PHY_INTERRUPT_STATUS, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, PHY_PHY_STATUS, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, PHY_LED_1, &tmp);
+	regs_buff[num++] = tmp;
+	et131x_mii_read(adapter, PHY_LED_2, &tmp);
+	regs_buff[num++] = tmp;
 
 	/* Global regs */
 	regs_buff[num++] = readl(&aregs->global.txq_start_addr);
-- 
1.7.10.4

