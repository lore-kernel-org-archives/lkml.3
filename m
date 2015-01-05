Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbbAEHHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 02:07:23 -0500
Received: from mail-by2on0137.outbound.protection.outlook.com ([207.46.100.137]:54592
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751068AbbAEHHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 02:07:21 -0500
X-Greylist: delayed 1140 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2015 02:07:21 EST
From: Anson Huang <b20788@freescale.com>
To: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <rui.zhang@intel.com>, <edubezval@gmail.com>
Subject: [PATCH] Thermal: imx: add clk disable/enable for suspend/resume
Date: Mon, 5 Jan 2015 22:29:13 +0800
Message-ID: <1420468153-19142-1-git-send-email-b20788@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Anson.Huang@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(21056001)(89996001)(229853001)(87936001)(85426001)(106466001)(81156004)(48376002)(99396003)(107046002)(62966003)(120916001)(77156002)(50466002)(46102003)(97736003)(36756003)(84676001)(64706001)(50986999)(47776003)(20776003)(6806004)(105606002)(50226001)(19580405001)(68736005)(104016003)(33646002)(77096005)(69596002)(4396001)(19580395003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0626;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN1PR0301MB0626;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0626;
X-Forefront-PRVS: 0447DB1C71
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0626;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2015 06:33:51.0853
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0626
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
 drivers/thermal/imx_thermal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index 461bf3d..03894da 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -600,6 +600,8 @@ static int imx_thermal_suspend(struct device *dev)
 	regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_MEASURE_TEMP);
 	regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_POWER_DOWN);
 	data->mode = THERMAL_DEVICE_DISABLED;
+	if (!IS_ERR(data->thermal_clk))
+		clk_disable_unprepare(data->thermal_clk);
 
 	return 0;
 }
@@ -609,6 +611,8 @@ static int imx_thermal_resume(struct device *dev)
 	struct imx_thermal_data *data = dev_get_drvdata(dev);
 	struct regmap *map = data->tempmon;
 
+	if (!IS_ERR(data->thermal_clk))
+		clk_prepare_enable(data->thermal_clk);
 	/* Enabled thermal sensor after resume */
 	regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_POWER_DOWN);
 	regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_MEASURE_TEMP);
-- 
1.9.1

