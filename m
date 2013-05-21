Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3EUOYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:24:48 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:25128
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872Ab3EUOYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:24:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <kernel@pengutronix.de>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 1/3] imx-drm: imx-tve: Check the return value of 'regulator_enable()'
Date: Tue, 21 May 2013 11:24:44 -0300
Message-ID: <1369146286-24434-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit c8801a8 (regulator: core: Mark all get and enable calls as 
__must_check) we need to check the value returned by 'regulator_enable()'.

Do this check to get rid of the following build warning:

drivers/staging/imx-drm/imx-tve.c: In function 'imx_tve_probe':
drivers/staging/imx-drm/imx-tve.c:671:19: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
---
Changes since v1:
- Use 'build warning' instead of 'build error' in commit log
- Also mention the commit that requires the checking
- Added Ack's

 drivers/staging/imx-drm/imx-tve.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index a6efa8f6..ce65ad3 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -668,7 +668,9 @@ static int imx_tve_probe(struct platform_device *pdev)
 	tve->dac_reg = devm_regulator_get(&pdev->dev, "dac");
 	if (!IS_ERR(tve->dac_reg)) {
 		regulator_set_voltage(tve->dac_reg, 2750000, 2750000);
-		regulator_enable(tve->dac_reg);
+		ret = regulator_enable(tve->dac_reg);
+		if (ret)
+			return ret;
 	}
 
 	tve->clk = devm_clk_get(&pdev->dev, "tve");
-- 
1.8.1.2


