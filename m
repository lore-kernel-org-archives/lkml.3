Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaIAL5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:57:22 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:19888 "EHLO
	mail.work-microwave.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbaIAL5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:57:20 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Sep 2014 07:57:19 EDT
From: stigge@antcom.de
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] net: lpc_eth: Fix crash on ip link up
Date: Mon,  1 Sep 2014 13:46:46 +0200
Message-Id: <1409572006-26876-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 2.1.0
X-FEAS-SYSTEM-WL: stigge@antcom.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Stigge <stigge@antcom.de>

When a link is already up, the following sequence makes the kernel
block completely:

  ip link set dev eth0 down
  ip link set dev eth0 up

This is because on suspended phy, the following lines

  __lpc_eth_reset(pldat);
  __lpc_eth_init(pldat);

make the LPC ethernet core block (see LPC32x0 manual). The PHY needs to be
(re-)activated low-level first.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 Applies to v3.17-rc3

 drivers/net/ethernet/nxp/lpc_eth.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 8706c0d..a44a03c 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1220,6 +1220,9 @@ static int lpc_eth_open(struct net_device *ndev)
 
 	__lpc_eth_clock_enable(pldat, true);
 
+	/* Suspended PHY makes LPC ethernet core block, so resume now */
+	phy_resume(pldat->phy_dev);
+
 	/* Reset and initialize */
 	__lpc_eth_reset(pldat);
 	__lpc_eth_init(pldat);
-- 
2.1.0

