Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbaICPjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:39:48 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:42163 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756323AbaICPjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:39:46 -0400
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
        Harsh Gupta <harsh.gupta@st.com>,
        Gabriel Fernandez <gabriel.fernandez@linaro.orgm>
Subject: [PATCH v2 7/8] phy: miphy28lp: Add SSC support for PCIE
Date: Wed,  3 Sep 2014 17:37:16 +0200
Message-Id: <1409758637-28654-8-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409758637-28654-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1409758637-28654-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-09-03_07:2014-09-03,2014-09-03,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SSC is the technique of modulating the operating frequency of a signal
slightly to spread its radiated emissions over a range of frequencies.
This reduction in the maximum emission for a given frequency helps meet
radiated emission requirements.
These settings are applicable for PCIE with Internal clock.

Signed-off-by: Harsh Gupta <harsh.gupta@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.orgm>
---
 drivers/phy/phy-miphy28lp.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/phy/phy-miphy28lp.c b/drivers/phy/phy-miphy28lp.c
index b36e737..976fdda 100644
--- a/drivers/phy/phy-miphy28lp.c
+++ b/drivers/phy/phy-miphy28lp.c
@@ -679,6 +679,36 @@ static int miphy28lp_init_sata(struct miphy28lp_phy *miphy_phy)
 	return miphy_is_ready(miphy_phy);
 }
 
+static void miphy_pcie_tune_ssc(struct miphy28lp_phy *miphy_phy)
+{
+	u8 val;
+
+	/* Compensate Tx impedance to avoid out of range values */
+	if (miphy_phy->ssc) {
+		/*
+		 * Enable the SSC on PLL for all banks
+		 * SSC Modulation @ 31 KHz and 4000 ppm modulation amp
+		 */
+		val = readb_relaxed(miphy_phy->base + 0x0c);
+		val |= 0x04;
+		writeb_relaxed(val, miphy_phy->base + 0x0c);
+		val = readb_relaxed(miphy_phy->base + 0x0a);
+		val |= 0x10;
+		writeb_relaxed(val, miphy_phy->base + 0x0a);
+
+		for (val = 0; val < 2; val++) {
+			writeb_relaxed(val, miphy_phy->base + 0x0f);
+			writeb_relaxed(0x69, miphy_phy->base + 0xe5);
+			writeb_relaxed(0x21, miphy_phy->base + 0xe6);
+			writeb_relaxed(0x3c, miphy_phy->base + 0xe4);
+			writeb_relaxed(0x21, miphy_phy->base + 0xe6);
+			writeb_relaxed(0x00, miphy_phy->base + 0xe3);
+			writeb_relaxed(0x02, miphy_phy->base + 0xe3);
+			writeb_relaxed(0x00, miphy_phy->base + 0xe3);
+		}
+	}
+}
+
 static int miphy28lp_init_pcie(struct miphy28lp_phy *miphy_phy)
 {
 	struct miphy28lp_dev *miphy_dev = miphy_phy->phydev;
@@ -710,6 +740,8 @@ static int miphy28lp_init_pcie(struct miphy28lp_phy *miphy_phy)
 	/* initialize miphy */
 	miphy28lp_configure_pcie(miphy_phy);
 
+	miphy_pcie_tune_ssc(miphy_phy);
+
 	/* Waiting for Compensation to complete */
 	do {
 		val = readb_relaxed(miphy_phy->base + MIPHY_COMP_FSM_6);
-- 
1.9.1

