Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaJVHQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:16:05 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:39022 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbaJVHP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:15:59 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Giuseppe Condorelli <giuseppe.condorelli@st.com>
Subject: [PATCH v4 7/8] phy: miphy28lp: Tune tx impedance across Soc cuts
Date: Wed, 22 Oct 2014 09:14:26 +0200
Message-Id: <1413962067-25557-8-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413962067-25557-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1413962067-25557-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-22_03:2014-10-21,2014-10-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch to compensate tx impedance (Sata, PCIe)
depending on Soc cuts the kernel is built for.

Signed-off-by: Giuseppe Condorelli <giuseppe.condorelli@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 Documentation/devicetree/bindings/phy/phy-miphy28lp.txt |  1 +
 drivers/phy/phy-miphy28lp.c                             | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt b/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
index daa8310..17f7eec 100644
--- a/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
+++ b/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
@@ -40,6 +40,7 @@ Optional properties (port (child) node):
 - st,px_rx_pol_inv	: to invert polarity of RXn/RXp (respectively negative line and positive
 			  line).
 - st,scc-on		: enable ssc to reduce effects of EMI (only for sata or PCIe).
+- st,tx-impedance-comp	: to compensate tx impedance avoiding out of range values.
 
 example:
 
diff --git a/drivers/phy/phy-miphy28lp.c b/drivers/phy/phy-miphy28lp.c
index ca0d9b4..a9128a8 100644
--- a/drivers/phy/phy-miphy28lp.c
+++ b/drivers/phy/phy-miphy28lp.c
@@ -204,6 +204,7 @@ struct miphy28lp_phy {
 	bool osc_rdy;
 	bool px_rx_pol_inv;
 	bool ssc;
+	bool tx_impedance;
 
 	struct reset_control *miphy_rst;
 
@@ -632,6 +633,12 @@ static void miphy_pcie_tune_ssc(struct miphy28lp_phy *miphy_phy)
 	}
 }
 
+static inline void miphy_tune_tx_impedance(struct miphy28lp_phy *miphy_phy)
+{
+	/* Compensate Tx impedance to avoid out of range values */
+	writeb_relaxed(0x02, miphy_phy->base + MIPHY_COMP_POSTP);
+}
+
 static inline int miphy28lp_configure_sata(struct miphy28lp_phy *miphy_phy)
 {
 	void __iomem *base = miphy_phy->base;
@@ -670,6 +677,9 @@ static inline int miphy28lp_configure_sata(struct miphy28lp_phy *miphy_phy)
 	if (miphy_phy->ssc)
 		miphy_sata_tune_ssc(miphy_phy);
 
+	if (miphy_phy->tx_impedance)
+		miphy_tune_tx_impedance(miphy_phy);
+
 	return 0;
 }
 
@@ -703,6 +713,9 @@ static inline int miphy28lp_configure_pcie(struct miphy28lp_phy *miphy_phy)
 	if (miphy_phy->ssc)
 		miphy_pcie_tune_ssc(miphy_phy);
 
+	if (miphy_phy->tx_impedance)
+		miphy_tune_tx_impedance(miphy_phy);
+
 	return 0;
 }
 
@@ -1151,6 +1164,9 @@ static int miphy28lp_of_probe(struct device_node *np,
 
 	miphy_phy->ssc = of_property_read_bool(np, "st,ssc-on");
 
+	miphy_phy->tx_impedance =
+		of_property_read_bool(np, "st,tx-impedance-comp");
+
 	of_property_read_u32(np, "st,sata-gen", &miphy_phy->sata_gen);
 	if (!miphy_phy->sata_gen)
 		miphy_phy->sata_gen = SATA_GEN1;
-- 
1.9.1

