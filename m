Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbbAFCzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:55:31 -0500
Received: from mail-bl2on0124.outbound.protection.outlook.com ([65.55.169.124]:28456
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932298AbbAFCzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:55:06 -0500
From: Anson Huang <b20788@freescale.com>
To: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <edubezval@gmail.com>, <rui.zhang@intel.com>, <jangra.pankaj9@gmail.com>
Subject: [PATCH V2] Thermal: imx: add clk disable/enable for suspend/resume
Date: Tue, 6 Jan 2015 18:50:22 +0800
Message-ID: <1420541422-27602-1-git-send-email-b20788@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Anson.Huang@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(31966008)(85426001)(36756003)(104016003)(62966003)(87936001)(4396001)(50226001)(89996001)(68736005)(77096005)(77156002)(21056001)(92566001)(50986999)(97736003)(106466001)(229853001)(107046002)(99396003)(120916001)(46102003)(84676001)(6806004)(19580405001)(33646002)(48376002)(19580395003)(50466002)(105606002)(47776003)(20776003)(64706001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0625;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN1PR0301MB0625;
X-Forefront-PRVS: 0448A97BF2
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2015 02:55:03.4753
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0625
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thermal sensor's clk is from pll3_usb_otg, per hardware
design requirement, need to make sure pll3_usb_otg is disabled
before STOP mode is entered, otherwise, all PFDs under it may
enter incorrect state, this patch disables pll3_usb_otg before
suspend and enables it after resume.

Signed-off-by: Anson Huang <b20788@freescale.com>
---
 drivers/thermal/imx_thermal.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index 461bf3d..dc8bcd8 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -600,6 +600,7 @@ static int imx_thermal_suspend(struct device *dev)
 	regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_MEASURE_TEMP);
 	regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_POWER_DOWN);
 	data->mode = THERMAL_DEVICE_DISABLED;
+	clk_disable_unprepare(data->thermal_clk);
 
 	return 0;
 }
@@ -609,6 +610,7 @@ static int imx_thermal_resume(struct device *dev)
 	struct imx_thermal_data *data = dev_get_drvdata(dev);
 	struct regmap *map = data->tempmon;
 
+	clk_prepare_enable(data->thermal_clk);
 	/* Enabled thermal sensor after resume */
 	regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_POWER_DOWN);
 	regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_MEASURE_TEMP);
-- 
1.9.1

