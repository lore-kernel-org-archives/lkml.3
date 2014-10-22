Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbaJVHRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:17:45 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34022 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754169AbaJVHQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:16:04 -0400
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
        Harsh Gupta <harsh.gupta@st.com>
Subject: [PATCH v4 6/8] phy: miphy28lp: Add SSC support for PCIE
Date: Wed, 22 Oct 2014 09:14:25 +0200
Message-Id: <1413962067-25557-7-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413962067-25557-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1413962067-25557-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-22_03:2014-10-21,2014-10-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SSC is the technique of modulating the operating frequency of a signal
slightly to spread its radiated emissions over a range of frequencies.
This reduction in the maximum emission for a given frequency helps meet
radiated emission requirements.
These settings are applicable for PCIE with Internal clock.

Signed-off-by: Harsh Gupta <harsh.gupta@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 drivers/phy/phy-miphy28lp.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/phy/phy-miphy28lp.c b/drivers/phy/phy-miphy28lp.c
index d4569af..ca0d9b4 100644
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
1.9.1

