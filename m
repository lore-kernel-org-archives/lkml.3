Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbbA0KxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:53:01 -0500
Received: from mail-am1on0142.outbound.protection.outlook.com ([157.56.112.142]:9952
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758148AbbA0Kw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:52:56 -0500
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <mark.rutland@arm.com>
CC: <stefan@agner.ch>, <shawn.guo@linaro.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>, <broonie@kernel.org>,
        <B44548@freescale.com>, <Li.Xiubo@freescale.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH 4/7] spi: spi-fsl-dspi: avoid preparing the clock two times
Date: Tue, 27 Jan 2015 16:27:21 +0530
Message-ID: <1422356244-15629-5-git-send-email-bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422356244-15629-1-git-send-email-bhuvanchandra.dv@toradex.com>
References: <1422356244-15629-1-git-send-email-bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: HKXPR03CA001.apcprd03.prod.outlook.com (10.242.96.21) To
 AMSPR05MB262.eurprd05.prod.outlook.com (10.242.95.19)
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=toradex.com;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:AMSPR05MB262;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:AMSPR05MB262;
X-Forefront-PRVS: 046985391D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(92566002)(229853001)(48376002)(19580395003)(230783001)(122386002)(40100003)(19580405001)(50986999)(50466002)(87976001)(50226001)(53416004)(86362001)(47776003)(42186005)(36756003)(33646002)(77156002)(76176999)(62966003)(2950100001)(110136001)(46102003)(77096005)(2351001)(66066001)(7059030);DIR:OUT;SFP:1102;SCL:1;SRVR:AMSPR05MB262;H:dvb.toradex.int;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:AMSPR05MB262;
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2015 10:52:46.7911 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMSPR05MB262
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regmap_read/regmap_write will expect the peripheral clock
to be enabled before accessing the registers of the peripheral.
Since the peripheral clock is enabled separatly, avoid redundant clock
prepare (with devm_regmap_init_mmio_clk) and use devm_regmap_init_mmio instead.

Acked-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
---
 drivers/spi/spi-fsl-dspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 9b80d54..5378148 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -502,7 +502,7 @@ static int dspi_probe(struct platform_device *pdev)
 		goto out_master_put;
 	}
 
-	dspi->regmap = devm_regmap_init_mmio_clk(&pdev->dev, "dspi", base,
+	dspi->regmap = devm_regmap_init_mmio(&pdev->dev, base,
 						&dspi_regmap_config);
 	if (IS_ERR(dspi->regmap)) {
 		dev_err(&pdev->dev, "failed to init regmap: %ld\n",
-- 
2.2.2

