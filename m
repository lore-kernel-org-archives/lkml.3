Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaKKRSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:18:10 -0500
Received: from mail-by2on0083.outbound.protection.outlook.com ([207.46.100.83]:49862
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751573AbaKKRSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:18:05 -0500
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv7 3/8] usb: dwc2: convert to use dev_pm_ops API
Date: Tue, 11 Nov 2014 11:13:35 -0600
Message-ID: <1415726020-19238-4-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1415726020-19238-1-git-send-email-dinguyen@opensource.altera.com>
References: <1415726020-19238-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR07CA079.namprd07.prod.outlook.com (25.160.24.34) To
 CY1PR0301MB1196.namprd03.prod.outlook.com (25.160.165.27)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-Forefront-PRVS: 0392679D18
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(64706001)(20776003)(47776003)(66066001)(53416004)(33646002)(40100003)(101416001)(50466002)(48376002)(122386002)(97736003)(42186005)(102836001)(50226001)(4396001)(105586002)(107046002)(19580395003)(19580405001)(95666004)(21056001)(229853001)(106356001)(86152002)(88136002)(92726001)(104166001)(31966008)(62966003)(87976001)(92566001)(77096003)(87286001)(77156002)(99396003)(89996001)(46102003)(69596002)(120916001)(81156004)(93916002)(86362001)(50986999)(76176999);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1196;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Update suspend/resume to use dev_pm_ops API.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
 drivers/usb/dwc2/platform.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index eeba8a4..b94867b 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -219,9 +219,9 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	return retval;
 }
 
-static int dwc2_suspend(struct platform_device *dev, pm_message_t state)
+static int dwc2_suspend(struct device *dev)
 {
-	struct dwc2_hsotg *dwc2 = platform_get_drvdata(dev);
+	struct dwc2_hsotg *dwc2 = dev_get_drvdata(dev);
 	int ret = 0;
 
 	if (dwc2_is_device_mode(dwc2))
@@ -229,9 +229,9 @@ static int dwc2_suspend(struct platform_device *dev, pm_message_t state)
 	return ret;
 }
 
-static int dwc2_resume(struct platform_device *dev)
+static int dwc2_resume(struct device *dev)
 {
-	struct dwc2_hsotg *dwc2 = platform_get_drvdata(dev);
+	struct dwc2_hsotg *dwc2 = dev_get_drvdata(dev);
 	int ret = 0;
 
 	if (dwc2_is_device_mode(dwc2))
@@ -239,15 +239,18 @@ static int dwc2_resume(struct platform_device *dev)
 	return ret;
 }
 
+static const struct dev_pm_ops dwc2_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(dwc2_suspend, dwc2_resume)
+};
+
 static struct platform_driver dwc2_platform_driver = {
 	.driver = {
 		.name = dwc2_driver_name,
 		.of_match_table = dwc2_of_match_table,
+		.pm = &dwc2_dev_pm_ops,
 	},
 	.probe = dwc2_driver_probe,
 	.remove = dwc2_driver_remove,
-	.suspend = dwc2_suspend,
-	.resume = dwc2_resume,
 };
 
 module_platform_driver(dwc2_platform_driver);
-- 
2.0.3

