Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaELBm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:42:27 -0400
Received: from 1wt.eu ([62.212.114.60]:34530 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbaELBmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:22 -0400
Message-Id: <20140512003205.648149434@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Zhu Yanjun <Yanjun.Zhu@windriver.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 120/143] gianfar: disable TX vlan based on kernel 2.6.x
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <Yanjun.Zhu@windriver.com>

2.6.x kernels require a similar logic change as commit e1653c3e
[gianfar: do vlan cleanup] and commit 51b8cbfc
[gianfar: fix bug caused by e1653c3e] introduces for newer kernels.

Since there is something wrong with tx vlan of gianfar nic driver,
in kernel(3.1+), tx vlan is disabled. But in kernel 2.6.x, tx vlan
is still enabled. Thus,gianfar nic driver can not support vlan
packets and non-vlan packets at the same time.

Signed-off-by: Zhu Yanjun <Yanjun.Zhu@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/gianfar.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 934a28f..8aa2cf6 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -365,7 +365,7 @@ static int gfar_probe(struct of_device *ofdev,
 	priv->vlgrp = NULL;
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN)
-		dev->features |= NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
+		dev->features |= NETIF_F_HW_VLAN_RX;
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_EXTENDED_HASH) {
 		priv->extended_hash = 1;
@@ -1451,12 +1451,6 @@ static void gfar_vlan_rx_register(struct net_device *dev,
 	priv->vlgrp = grp;
 
 	if (grp) {
-		/* Enable VLAN tag insertion */
-		tempval = gfar_read(&priv->regs->tctrl);
-		tempval |= TCTRL_VLINS;
-
-		gfar_write(&priv->regs->tctrl, tempval);
-
 		/* Enable VLAN tag extraction */
 		tempval = gfar_read(&priv->regs->rctrl);
 		tempval |= (RCTRL_VLEX | RCTRL_PRSDEP_INIT);
-- 
1.7.12.2.21.g234cd45.dirty



