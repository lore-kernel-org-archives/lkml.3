Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbbA0BhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:37:07 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:36703 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590AbbA0Bg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:36:57 -0500
From: David Decotigny <ddecotig@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>, Amir Vadai <amirv@mellanox.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        Eugenia Emantayev <eugenia@mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>, Ido Shamay <idos@mellanox.com>,
        Joe Perches <joe@perches.com>, Saeed Mahameed <saeedm@mellanox.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Venkata Duvvuru <VenkatKumar.Duvvuru@Emulex.Com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Eyal Perry <eyalpe@mellanox.com>, Pravin B Shelar <pshelar@nicira.com>,
        Ed Swierk <eswierk@skyportsystems.com>,
        David Decotigny <decot@googlers.com>
Subject: [PATCH net-next v1 07/18] net: bonding: use __ethtool_get_ksettings
Date: Mon, 26 Jan 2015 17:36:03 -0800
Message-Id: <1422322574-6188-8-git-send-email-ddecotig@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1422322574-6188-1-git-send-email-ddecotig@gmail.com>
References: <1422322574-6188-1-git-send-email-ddecotig@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>

Signed-off-by: David Decotigny <decot@googlers.com>
---
 drivers/net/bonding/bond_main.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index f47bc43..7710386 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -371,22 +371,20 @@ down:
 static void bond_update_speed_duplex(struct slave *slave)
 {
 	struct net_device *slave_dev = slave->dev;
-	struct ethtool_cmd ecmd;
-	u32 slave_speed;
+	struct ethtool_ksettings ecmd;
 	int res;
 
 	slave->speed = SPEED_UNKNOWN;
 	slave->duplex = DUPLEX_UNKNOWN;
 
-	res = __ethtool_get_settings(slave_dev, &ecmd);
+	res = __ethtool_get_ksettings(slave_dev, &ecmd);
 	if (res < 0)
 		return;
 
-	slave_speed = ethtool_cmd_speed(&ecmd);
-	if (slave_speed == 0 || slave_speed == ((__u32) -1))
+	if (ecmd.parent.speed == 0 || ecmd.parent.speed == ((__u32) -1))
 		return;
 
-	switch (ecmd.duplex) {
+	switch (ecmd.parent.duplex) {
 	case DUPLEX_FULL:
 	case DUPLEX_HALF:
 		break;
@@ -394,8 +392,8 @@ static void bond_update_speed_duplex(struct slave *slave)
 		return;
 	}
 
-	slave->speed = slave_speed;
-	slave->duplex = ecmd.duplex;
+	slave->speed = ecmd.parent.speed;
+	slave->duplex = ecmd.parent.duplex;
 
 	return;
 }
-- 
2.2.0.rc0.207.ga3a616c

