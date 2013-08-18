Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3HRJyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 05:54:45 -0400
Received: from jesper.alarsen.net ([144.76.18.233]:46703 "EHLO
	mail.alarsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3HRJyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 05:54:44 -0400
From: Anders Larsen <al@alarsen.net>
To: "David S. Miller" <davem@davemloft.net>
Cc: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] pch_gbe: ethtool cannot change parameters when link is down
Date: Sun, 18 Aug 2013 11:54:40 +0200
Message-Id: <1376819680-15359-1-git-send-email-al@alarsen.net>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When attempting to change e.g. the advertising mask when the link is down
ecmd->speed is -1 causing mii_ethtool_sset() to bail out.

This bug bit when connecting to a gigabit switch through a 4-pin (industrial)
cable, since link negotiation would not complete (both endpoints claimed to
be gigabit-capable, but this is not possible with only 4 pins).
Any attempt to fix this by setting autonegation to not offer 1000Mbps
failed as the setting would not be accepted while the link was still down...

Set ecmd->speed to SPEED_1000 to satisfy mii_ethtool_sset()
(the actual value of ecmd->speed doesn't matter as long as it is valid,
since a re-negotation is forced afterwards).

Signed-off-by: Anders Larsen <al@alarsen.net>
---
 .../ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c    |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
index 1129db0..f0ceb89 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
@@ -118,6 +118,7 @@ static int pch_gbe_set_settings(struct net_device *netdev,
 	 * filled by get_settings() on a down link, speed is -1: */
 	if (speed == UINT_MAX) {
 		speed = SPEED_1000;
+		ethtool_cmd_speed_set(ecmd, speed);
 		ecmd->duplex = DUPLEX_FULL;
 	}
 	ret = mii_ethtool_sset(&adapter->mii, ecmd);
-- 
1.7.0.4

