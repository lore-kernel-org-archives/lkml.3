Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaK0Gcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:32:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34488 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaK0G02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:28 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/25] phy: miphy28lp: Add SSC support for PCIE
Date: Thu, 27 Nov 2014 11:55:57 +0530
Message-ID: <1417069577-1169-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417069577-1169-1-git-send-email-kishon@ti.com>
References: <1417069577-1169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>

SSC is the technique of modulating the operating frequency of a signal
slightly to spread its radiated emissions over a range of frequencies.
This reduction in the maximum emission for a given frequency helps meet
radiated emission requirements.
These settings are applicable for PCIE with Internal clock.

Signed-off-by: Harsh Gupta <harsh.gupta@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-miphy28lp.c |   44 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/phy/phy-miphy28lp.c b/drivers/phy/phy-miphy28lp.c
index d2f797c..d8ff895 100644
--- a/drivers/phy/phy-miphy28lp.c
+++ b/drivers/phy/phy-miphy28lp.c
@@ -192,6 +192,7 @@
 #define SATA_SPDMODE		1
 
 #define MIPHY_SATA_BANK_NB	3
+#define MIPHY_PCIE_BANK_NB	2
 
 struct miphy28lp_phy {
 	struct phy *phy;
@@ -591,6 +592,46 @@ static void miphy_sata_tune_ssc(struct miphy28lp_phy *miphy_phy)
 	}
 }
 
+static void miphy_pcie_tune_ssc(struct miphy28lp_phy *miphy_phy)
+{
+	void __iomem *base = miphy_phy->base;
+	u8 val;
+
+	/* Compensate Tx impedance to avoid out of range values */
+	/*
+	 * Enable the SSC on PLL for all banks
+	 * SSC Modulation @ 31 KHz and 4000 ppm modulation amp
+	 */
+	val = readb_relaxed(base + MIPHY_BOUNDARY_2);
+	val |= SSC_EN_SW;
+	writeb_relaxed(val, base + MIPHY_BOUNDARY_2);
+
+	val = readb_relaxed(base + MIPHY_BOUNDARY_SEL);
+	val |= SSC_SEL;
+	writeb_relaxed(val, base + MIPHY_BOUNDARY_SEL);
+
+	for (val = 0; val < MIPHY_PCIE_BANK_NB; val++) {
+		writeb_relaxed(val, base + MIPHY_CONF);
+
+		/* Validate Step component */
+		writeb_relaxed(0x69, base + MIPHY_PLL_SBR_3);
+		writeb_relaxed(0x21, base + MIPHY_PLL_SBR_4);
+
+		/* Validate Period component */
+		writeb_relaxed(0x3c, base + MIPHY_PLL_SBR_2);
+		writeb_relaxed(0x21, base + MIPHY_PLL_SBR_4);
+
+		/* Clear any previous request */
+		writeb_relaxed(0x00, base + MIPHY_PLL_SBR_1);
+
+		/* requests the PLL to take in account new parameters */
+		writeb_relaxed(SET_NEW_CHANGE, base + MIPHY_PLL_SBR_1);
+
+		/* To be sure there is no other pending requests */
+		writeb_relaxed(0x00, base + MIPHY_PLL_SBR_1);
+	}
+}
+
 static inline int miphy28lp_configure_sata(struct miphy28lp_phy *miphy_phy)
 {
 	void __iomem *base = miphy_phy->base;
@@ -659,6 +700,9 @@ static inline int miphy28lp_configure_pcie(struct miphy28lp_phy *miphy_phy)
 	if (err)
 		return err;
 
+	if (miphy_phy->ssc)
+		miphy_pcie_tune_ssc(miphy_phy);
+
 	return 0;
 }
 
-- 
1.7.9.5

