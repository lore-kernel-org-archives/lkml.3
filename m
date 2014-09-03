Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbaICPji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:39:38 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:42152 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756459AbaICPjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:39:36 -0400
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
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Giuseppe Condorelli <giuseppe.condorelli@st.com>
Subject: [PATCH v2 8/8] phy: miphy28lp: Tune tx impedance across Soc cuts
Date: Wed,  3 Sep 2014 17:37:17 +0200
Message-Id: <1409758637-28654-9-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409758637-28654-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1409758637-28654-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-09-03_07:2014-09-03,2014-09-03,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch to compensate tx impedance (Sata, PCIe)
depending on Soc cuts the kernel is built for.

Signed-off-by: Giuseppe Condorelli <giuseppe.condorelli@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 .../devicetree/bindings/phy/phy-miphy28lp.txt      |  1 +
 drivers/phy/phy-miphy28lp.c                        | 24 ++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt b/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
index 49bb7bb..de25e8f 100644
--- a/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
+++ b/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
@@ -40,6 +40,7 @@ Optional properties (port (child) node):
 - st,px_rx_pol_inv	: to invert polarity of RXn/RXp (respectively negative line and positive
 			  line).
 - st,scc-on		: enable ssc to reduce effects of EMI (only for sata or PCIe).
+- st,tx-impedance-comp	: to compensate tx impedance avoiding out of range values.
 
 example:
 
diff --git a/drivers/phy/phy-miphy28lp.c b/drivers/phy/phy-miphy28lp.c
index 976fdda..148dd9c 100644
--- a/drivers/phy/phy-miphy28lp.c
+++ b/drivers/phy/phy-miphy28lp.c
@@ -141,6 +141,7 @@ struct miphy28lp_phy {
 	bool osc_rdy;
 	bool px_rx_pol_inv;
 	bool ssc;
+	bool tx_impedance;
 
 	struct reset_control *miphy_rst;
 
@@ -296,6 +297,10 @@ static inline void miphy28lp_configure_sata(struct miphy28lp_phy *miphy_phy)
 	writeb_relaxed(0x40, base + MIPHY_COMP_FSM_1);
 	writeb_relaxed(0x00, base + MIPHY_RESET);
 	writeb_relaxed(0x40, base + MIPHY_PLL_COMMON_MISC_2);
+
+	/* TX compensation offset to re-center TX impedance */
+	writeb_relaxed(0x00, base + MIPHY_COMP_POSTP);
+
 }
 
 static inline void miphy28lp_configure_pcie(struct miphy28lp_phy *miphy_phy)
@@ -385,6 +390,10 @@ static inline void miphy28lp_configure_pcie(struct miphy28lp_phy *miphy_phy)
 	writeb_relaxed(0x00, base + MIPHY_RESET);
 	writeb_relaxed(0x40, base + MIPHY_PLL_COMMON_MISC_2);
 	writeb_relaxed(0x02, base + MIPHY_PLL_SBR_1);
+
+	/* TX compensation offset to re-center TX impedance */
+	writeb_relaxed(0x00, base + MIPHY_COMP_POSTP);
+
 }
 
 static inline void miphy28lp_configure_usb3(struct miphy28lp_phy *miphy_phy)
@@ -605,6 +614,14 @@ static int miphy28lp_setup(struct miphy28lp_phy *miphy_phy, u32 miphy_val)
 	return miphy_osc_is_ready(miphy_phy);
 }
 
+static void miphy_tune_tx_impedance(struct miphy28lp_phy *miphy_phy)
+{
+	/* Compensate Tx impedance to avoid out of range values */
+	if (miphy_phy->tx_impedance)
+		writeb_relaxed(0x02, miphy_phy->base + 0x42);
+
+}
+
 static void miphy_sata_tune_ssc(struct miphy28lp_phy *miphy_phy)
 {
 	u8 val;
@@ -676,6 +693,8 @@ static int miphy28lp_init_sata(struct miphy28lp_phy *miphy_phy)
 
 	miphy_sata_tune_ssc(miphy_phy);
 
+	miphy_tune_tx_impedance(miphy_phy);
+
 	return miphy_is_ready(miphy_phy);
 }
 
@@ -750,6 +769,8 @@ static int miphy28lp_init_pcie(struct miphy28lp_phy *miphy_phy)
 		cpu_relax();
 	} while (!(val & MIPHY_COMP_DONE));
 
+	miphy_tune_tx_impedance(miphy_phy);
+
 	/* PIPE Wrapper Configuration */
 	writeb_relaxed(0x68, miphy_phy->pipebase + 0x104); /* Rise_0 */
 	writeb_relaxed(0x61, miphy_phy->pipebase + 0x105); /* Rise_1 */
@@ -939,6 +960,9 @@ static int miphy28lp_of_probe(struct device_node *np,
 
 	miphy_phy->ssc = of_property_read_bool(np, "st,ssc-on");
 
+	miphy_phy->tx_impedance =
+		of_property_read_bool(np, "st,tx-impedance-comp");
+
 	of_property_read_u32(np, "st,sata-gen", &miphy_phy->sata_gen);
 	if (!miphy_phy->sata_gen)
 		miphy_phy->sata_gen = SATA_GEN1;
-- 
1.9.1

