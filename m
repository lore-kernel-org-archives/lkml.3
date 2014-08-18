Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaHRJdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:33:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42441 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaHRJdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maggie Mae Roxas <maggie.mae.roxas@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 011/137] net: mvneta: fix operation in 10 Mbit/s mode
Date: Mon, 18 Aug 2014 10:31:12 +0100
Message-Id: <1408354398-10226-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 4d12bc63ab5e48c1d78fa13883cf6fefcea3afb1 upstream.

As reported by Maggie Mae Roxas, the mvneta driver doesn't behave
properly in 10 Mbit/s mode. This is due to a misconfiguration of the
MVNETA_GMAC_AUTONEG_CONFIG register: bit MVNETA_GMAC_CONFIG_MII_SPEED
must be set for a 100 Mbit/s speed, but cleared for a 10 Mbit/s speed,
which the driver was not properly doing. This commit adjusts that by
setting the MVNETA_GMAC_CONFIG_MII_SPEED bit only in 100 Mbit/s mode,
and relying on the fact that all the speed related bits of this
register are cleared at the beginning of the mvneta_adjust_link()
function.

This problem exists since c5aff18204da0 ("net: mvneta: driver for
Marvell Armada 370/XP network unit") which is the commit that
introduced the mvneta driver in the kernel.

Fixes: c5aff18204da0 ("net: mvneta: driver for Marvell Armada 370/XP network unit")
Reported-by: Maggie Mae Roxas <maggie.mae.roxas@gmail.com>
Cc: Maggie Mae Roxas <maggie.mae.roxas@gmail.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index b8aea9aa3566..c762b805164c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2325,7 +2325,7 @@ static void mvneta_adjust_link(struct net_device *ndev)
 
 			if (phydev->speed == SPEED_1000)
 				val |= MVNETA_GMAC_CONFIG_GMII_SPEED;
-			else
+			else if (phydev->speed == SPEED_100)
 				val |= MVNETA_GMAC_CONFIG_MII_SPEED;
 
 			mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, val);
-- 
1.9.1

