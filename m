Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab3CDDnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:43:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32822 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756180Ab3CDDn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:28 -0500
Message-Id: <20130304033717.721719715@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:49 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Shawn Guo <shawn.guo@linaro.org>,
        Chris Ball <cjb@laptop.org>
Subject: [ 102/153] mmc: sdhci-esdhc-imx: fix host version read
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@linaro.org>

commit ef4d0888bb7e1b963880f086575081c3d39cad2d upstream.

When commit 95a2482 (mmc: sdhci-esdhc-imx: add basic imx6q usdhc
support) works around host version issue on imx6q, it gets the
register address fixup "reg ^= 2" lost for imx25/35/51/53 esdhc.
Thus, the controller version on these SoCs is wrongly identified
as v1 while it's actually v2.

Add the address fixup back and take a different approach to correct
imx6q host version, so that the host version read gets back to work
for all SoCs.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -232,15 +232,18 @@ static void esdhc_writel_le(struct sdhci
 
 static u16 esdhc_readw_le(struct sdhci_host *host, int reg)
 {
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct pltfm_imx_data *imx_data = pltfm_host->priv;
+
 	if (unlikely(reg == SDHCI_HOST_VERSION)) {
-		u16 val = readw(host->ioaddr + (reg ^ 2));
-		/*
-		 * uSDHC supports SDHCI v3.0, but it's encoded as value
-		 * 0x3 in host controller version register, which violates
-		 * SDHCI_SPEC_300 definition.  Work it around here.
-		 */
-		if ((val & SDHCI_SPEC_VER_MASK) == 3)
-			return --val;
+		reg ^= 2;
+		if (is_imx6q_usdhc(imx_data)) {
+			/*
+			 * The usdhc register returns a wrong host version.
+			 * Correct it here.
+			 */
+			return SDHCI_SPEC_300;
+		}
 	}
 
 	return readw(host->ioaddr + reg);


