Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935669AbaBDWqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:46:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933388AbaBDVCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lior Amsalem <alior@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Simon Guinot <simon.guinot@sequanux.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.10 068/104] ata: sata_mv: fix disk hotplug for Armada 370/XP SoCs
Date: Tue,  4 Feb 2014 13:02:11 -0800
Message-Id: <20140204210224.636638555@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/sata_mv.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

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
@@ -1353,6 +1355,7 @@ static int mv_scr_write(struct ata_link
 
 	if (ofs != 0xffffffffU) {
 		void __iomem *addr = mv_ap_base(link->ap) + ofs;
+		struct mv_host_priv *hpriv = link->ap->host->private_data;
 		if (sc_reg_in == SCR_CONTROL) {
 			/*
 			 * Workaround for 88SX60x1 FEr SATA#26:
@@ -1369,6 +1372,18 @@ static int mv_scr_write(struct ata_link
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
@@ -4111,6 +4126,15 @@ static int mv_platform_probe(struct plat
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


