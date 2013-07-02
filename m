Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab3GBNKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 09:10:32 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:49381 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799Ab3GBNK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 09:10:26 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: netdev@vger.kernel.org
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH v1 1/3] dt:net:stmmac: Allocate platform data only if its NULL.
Date: Tue,  2 Jul 2013 14:04:23 +0100
Message-Id: <1372770263-1720-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1372770219-1643-1-git-send-email-srinivas.kandagatla@st.com>
References: <1372770219-1643-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

In some DT use-cases platform data might be already allocated and passed
via AUXDATA. These are the cases where machine level code populates few
callbacks in the platform data.

This patch adds check and reuses platform_data if its valid, before
allocating a new one.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 1d3780f..5907920 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -92,8 +92,10 @@ static int stmmac_pltfr_probe(struct platform_device *pdev)
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
 
+	plat_dat = pdev->dev.platform_data;
 	if (pdev->dev.of_node) {
-		plat_dat = devm_kzalloc(&pdev->dev,
+		if (!plat_dat)
+			plat_dat = devm_kzalloc(&pdev->dev,
 					sizeof(struct plat_stmmacenet_data),
 					GFP_KERNEL);
 		if (!plat_dat) {
@@ -106,8 +108,6 @@ static int stmmac_pltfr_probe(struct platform_device *pdev)
 			pr_err("%s: main dt probe failed", __func__);
 			return ret;
 		}
-	} else {
-		plat_dat = pdev->dev.platform_data;
 	}
 
 	/* Custom initialisation (if needed)*/
-- 
1.7.6.5

