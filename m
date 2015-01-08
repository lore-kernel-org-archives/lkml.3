Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbbAHHHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 02:07:15 -0500
Received: from mail-bl2on0082.outbound.protection.outlook.com ([65.55.169.82]:4704
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753017AbbAHHHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 02:07:13 -0500
From: Aaron Wu <Aaron.wu@analog.com>
To: <mkl@pengutronix.de>, <wg@grandegger.com>, <linux-can@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <adi-buildroot-devel@lists.sourceforge.net>,
        Aaron Wu <Aaron.wu@analog.com>
Subject: [PATCH V2 2/2] bfin_can: rewrite the driver to support the common
Date: Thu, 8 Jan 2015 14:57:34 +0800
Message-ID: <1420700254-22529-2-git-send-email-Aaron.wu@analog.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420700254-22529-1-git-send-email-Aaron.wu@analog.com>
References: <1420700254-22529-1-git-send-email-Aaron.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 137.71.25.57)
 smtp.mailfrom=Aaron.Wu@analog.com; 
X-Forefront-Antispam-Report: CIP:137.71.25.57;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(199003)(87936001)(6806004)(19580395003)(19580405001)(46102003)(120916001)(99396003)(89996001)(76176999)(50986999)(86362001)(50226001)(20776003)(48376002)(47776003)(64706001)(21056001)(50466002)(229853001)(77096005)(107046002)(2950100001)(4396001)(31966008)(106466001)(77156002)(2201001)(92566001)(36756003)(62966003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB0862;H:nwd2mta2.analog.com;FPR:;SPF:Pass;MLV:sfv;PTR:nwd2mail11.analog.com;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:DM2PR0301MB0862;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0862;
X-Forefront-PRVS: 0450A714CB
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0862;
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2015 07:07:09.0600
 (UTC)
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0862
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the driver to comply to common style with MMU 

Signed-off-by: Aaron Wu <Aaron.wu@analog.com>
---
 drivers/net/can/bfin_can.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/bfin_can.c b/drivers/net/can/bfin_can.c
index 0a5eff4..1d116a7 100644
--- a/drivers/net/can/bfin_can.c
+++ b/drivers/net/can/bfin_can.c
@@ -551,16 +551,10 @@ static int bfin_can_probe(struct platform_device *pdev)
 		goto exit;
 	}
 
-	if (!request_mem_region(res_mem->start, resource_size(res_mem),
-				dev_name(&pdev->dev))) {
-		err = -EBUSY;
-		goto exit;
-	}
-
 	/* request peripheral pins */
 	err = peripheral_request_list(pdata, dev_name(&pdev->dev));
 	if (err)
-		goto exit_mem_release;
+		goto exit;
 
 	dev = alloc_bfin_candev();
 	if (!dev) {
@@ -569,7 +563,13 @@ static int bfin_can_probe(struct platform_device *pdev)
 	}
 
 	priv = netdev_priv(dev);
-	priv->membase = (void __iomem *)res_mem->start;
+
+	priv->membase = devm_ioremap_resource(&pdev->dev, res_mem);
+	if (IS_ERR((void *)priv->membase)) {
+		dev_err(&pdev->dev, "Cannot map IO\n");
+		return PTR_ERR((void *)priv->membase);
+	}
+
 	priv->rx_irq = rx_irq->start;
 	priv->tx_irq = tx_irq->start;
 	priv->err_irq = err_irq->start;
@@ -601,8 +601,6 @@ exit_candev_free:
 	free_candev(dev);
 exit_peri_pin_free:
 	peripheral_free_list(pdata);
-exit_mem_release:
-	release_mem_region(res_mem->start, resource_size(res_mem));
 exit:
 	return err;
 }
@@ -617,9 +615,6 @@ static int bfin_can_remove(struct platform_device *pdev)
 
 	unregister_candev(dev);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
 	peripheral_free_list(priv->pin_list);
 
 	free_candev(dev);
-- 
1.7.9.5

