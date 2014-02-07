Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaBGLu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:50:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbaBGLux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lior Amsalem <alior@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Simon Guinot <simon.guinot@sequanux.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 136/233] ata: sata_mv: fix disk hotplug for Armada 370/XP SoCs
Date: Fri,  7 Feb 2014 11:45:55 +0000
Message-Id: <1391773652-25214-137-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lior Amsalem <alior@marvell.com>

commit 9013d64e661fc2a37a1742670202171c27fef4b5 upstream.

On Armada 370/XP SoCs, once a disk is removed from a SATA port, then the
re-plug events are not detected by the sata_mv driver. This patch fixes
the issue by updating the PHY speed in the LP_PHY_CTL register (0x58)
according to the SControl speed.

Note that this fix is only applied if the compatible string
"marvell,armada-370-sata" is found in the SATA DT node.

Fixes: 9ae6f740b49f ("arm: mach-mvebu: add support for Armada 370 and Armada XP with DT")
Signed-off-by: Lior Amsalem <alior@marvell.com>
Signed-off-by: Nadav Haklai <nadavh@marvell.com>
Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/sata_mv.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 9258775..b256ff5 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -304,6 +304,7 @@ enum {
 	MV5_LTMODE		= 0x30,
 	MV5_PHY_CTL		= 0x0C,
 	SATA_IFCFG		= 0x050,
+	LP_PHY_CTL		= 0x058,
 
 	MV_M2_PREAMP_MASK	= 0x7e0,
 
@@ -431,6 +432,7 @@ enum {
 	MV_HP_CUT_THROUGH	= (1 << 10),	/* can use EDMA cut-through */
 	MV_HP_FLAG_SOC		= (1 << 11),	/* SystemOnChip, no PCI */
 	MV_HP_QUIRK_LED_BLINK_EN = (1 << 12),	/* is led blinking enabled? */
+	MV_HP_FIX_LP_PHY_CTL	= (1 << 13),	/* fix speed in LP_PHY_CTL ? */
 
 	/* Port private flags (pp_flags) */
 	MV_PP_FLAG_EDMA_EN	= (1 << 0),	/* is EDMA engine enabled? */
@@ -1353,6 +1355,7 @@ static int mv_scr_write(struct ata_link *link, unsigned int sc_reg_in, u32 val)
 
 	if (ofs != 0xffffffffU) {
 		void __iomem *addr = mv_ap_base(link->ap) + ofs;
+		struct mv_host_priv *hpriv = link->ap->host->private_data;
 		if (sc_reg_in == SCR_CONTROL) {
 			/*
 			 * Workaround for 88SX60x1 FEr SATA#26:
@@ -1369,6 +1372,18 @@ static int mv_scr_write(struct ata_link *link, unsigned int sc_reg_in, u32 val)
 			 */
 			if ((val & 0xf) == 1 || (readl(addr) & 0xf) == 1)
 				val |= 0xf000;
+
+			if (hpriv->hp_flags & MV_HP_FIX_LP_PHY_CTL) {
+				void __iomem *lp_phy_addr =
+					mv_ap_base(link->ap) + LP_PHY_CTL;
+				/*
+				 * Set PHY speed according to SControl speed.
+				 */
+				if ((val & 0xf0) == 0x10)
+					writelfl(0x7, lp_phy_addr);
+				else
+					writelfl(0x227, lp_phy_addr);
+			}
 		}
 		writelfl(val, addr);
 		return 0;
@@ -4111,6 +4126,15 @@ static int mv_platform_probe(struct platform_device *pdev)
 	if (rc)
 		goto err;
 
+	/*
+	 * To allow disk hotplug on Armada 370/XP SoCs, the PHY speed must be
+	 * updated in the LP_PHY_CTL register.
+	 */
+	if (pdev->dev.of_node &&
+		of_device_is_compatible(pdev->dev.of_node,
+					"marvell,armada-370-sata"))
+		hpriv->hp_flags |= MV_HP_FIX_LP_PHY_CTL;
+
 	/* initialize adapter */
 	rc = mv_init_host(host);
 	if (rc)
-- 
1.8.3.2

