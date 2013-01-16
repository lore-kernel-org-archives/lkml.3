Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab3APQHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:07:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36426 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623Ab3APQHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:07:14 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 152/222] bonding: Bonding driver does not consider the gso_max_size/gso_max_segs setting of slave devices.
Date: Wed, 16 Jan 2013 13:55:52 -0200
Message-Id: <1358351822-7675-153-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>

commit 0e376bd0b791ac6ac6bdb051492df0769c840848 upstream.

Patch sets the lowest gso_max_size and gso_max_segs values of the slave devices during enslave and detach.

Signed-off-by: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/bonding/bond_main.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2ee7699..2466847 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1383,6 +1383,8 @@ static void bond_compute_features(struct bonding *bond)
 	struct net_device *bond_dev = bond->dev;
 	netdev_features_t vlan_features = BOND_VLAN_FEATURES;
 	unsigned short max_hard_header_len = ETH_HLEN;
+	unsigned int gso_max_size = GSO_MAX_SIZE;
+	u16 gso_max_segs = GSO_MAX_SEGS;
 	int i;
 
 	read_lock(&bond->lock);
@@ -1396,11 +1398,16 @@ static void bond_compute_features(struct bonding *bond)
 
 		if (slave->dev->hard_header_len > max_hard_header_len)
 			max_hard_header_len = slave->dev->hard_header_len;
+
+		gso_max_size = min(gso_max_size, slave->dev->gso_max_size);
+		gso_max_segs = min(gso_max_segs, slave->dev->gso_max_segs);
 	}
 
 done:
 	bond_dev->vlan_features = vlan_features;
 	bond_dev->hard_header_len = max_hard_header_len;
+	bond_dev->gso_max_segs = gso_max_segs;
+	netif_set_gso_max_size(bond_dev, gso_max_size);
 
 	read_unlock(&bond->lock);
 
-- 
1.7.9.5

