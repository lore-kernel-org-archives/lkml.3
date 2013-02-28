Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736Ab3B1O5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:57:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42482 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab3B1Ouj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shawn Guo <shawn.guo@linaro.org>, Chris Ball <cjb@laptop.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 116/139] mmc: sdhci-esdhc-imx: fix host version read
Date: Thu, 28 Feb 2013 14:44:26 +0000
Message-Id: <1362062689-2567-117-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index ebbe984..1dc06a6 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -237,15 +237,18 @@ static void esdhc_writel_le(struct sdhci_host *host, u32 val, int reg)
 
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
-- 
1.8.1.2

