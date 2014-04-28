Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbaD1BcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42865 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Larry Finger" <Larry.Finger@lwfinger.net>,
        "=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?=" <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.519086654@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 85/94] b43: Fix machine check error due to improper
 access of B43_MMIO_PSM_PHY_HDR
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <zajec5@gmail.com>

commit 12cd43c6ed6da7bf7c5afbd74da6959cda6d056b upstream.

Register B43_MMIO_PSM_PHY_HDR is 16 bit one, so accessing it with 32b
functions isn't safe. On my machine it causes delayed (!) CPU exception:

Disabling lock debugging due to kernel taint
mce: [Hardware Error]: CPU 0: Machine Check Exception: 4 Bank 4: b200000000070f0f
mce: [Hardware Error]: TSC 164083803dc
mce: [Hardware Error]: PROCESSOR 2:20fc2 TIME 1396650505 SOCKET 0 APIC 0 microcode 0
mce: [Hardware Error]: Run the above through 'mcelog --ascii'
mce: [Hardware Error]: Machine check: Processor context corrupt
Kernel panic - not syncing: Fatal machine check on current CPU
Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/b43/phy_n.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3937,22 +3937,22 @@ static void b43_nphy_channel_setup(struc
 	struct b43_phy_n *nphy = dev->phy.n;
 
 	u16 old_band_5ghz;
-	u32 tmp32;
+	u16 tmp16;
 
 	old_band_5ghz =
 		b43_phy_read(dev, B43_NPHY_BANDCTL) & B43_NPHY_BANDCTL_5GHZ;
 	if (new_channel->band == IEEE80211_BAND_5GHZ && !old_band_5ghz) {
-		tmp32 = b43_read32(dev, B43_MMIO_PSM_PHY_HDR);
-		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32 | 4);
+		tmp16 = b43_read16(dev, B43_MMIO_PSM_PHY_HDR);
+		b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp16 | 4);
 		b43_phy_set(dev, B43_PHY_B_BBCFG, 0xC000);
-		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32);
+		b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp16);
 		b43_phy_set(dev, B43_NPHY_BANDCTL, B43_NPHY_BANDCTL_5GHZ);
 	} else if (new_channel->band == IEEE80211_BAND_2GHZ && old_band_5ghz) {
 		b43_phy_mask(dev, B43_NPHY_BANDCTL, ~B43_NPHY_BANDCTL_5GHZ);
-		tmp32 = b43_read32(dev, B43_MMIO_PSM_PHY_HDR);
-		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32 | 4);
+		tmp16 = b43_read16(dev, B43_MMIO_PSM_PHY_HDR);
+		b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp16 | 4);
 		b43_phy_mask(dev, B43_PHY_B_BBCFG, 0x3FFF);
-		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32);
+		b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp16);
 	}
 
 	b43_chantab_phy_upload(dev, e);

