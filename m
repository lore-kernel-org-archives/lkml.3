Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaG3M0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:26:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36759 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969AbaG3MPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Maggie Mae Roxas <maggie.mae.roxas@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 49/94] net: mvneta: fix operation in 10 Mbit/s mode
Date: Wed, 30 Jul 2014 14:14:38 +0200
Message-Id: <477e05a67bb496ecbecceafa502e4f1af31a360a.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 4d12bc63ab5e48c1d78fa13883cf6fefcea3afb1 ]

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

Cc: <stable@vger.kernel.org> # v3.8+
Fixes: c5aff18204da0 ("net: mvneta: driver for Marvell Armada 370/XP network unit")
Reported-by: Maggie Mae Roxas <maggie.mae.roxas@gmail.com>
Cc: Maggie Mae Roxas <maggie.mae.roxas@gmail.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 5cdd2b2f18c5..fabdda91fd0e 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2358,7 +2358,7 @@ static void mvneta_adjust_link(struct net_device *ndev)
 
 			if (phydev->speed == SPEED_1000)
 				val |= MVNETA_GMAC_CONFIG_GMII_SPEED;
-			else
+			else if (phydev->speed == SPEED_100)
 				val |= MVNETA_GMAC_CONFIG_MII_SPEED;
 
 			mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, val);
-- 
2.0.1

