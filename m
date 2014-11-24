Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaKXRHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:07:04 -0500
Received: from mail-by2on0058.outbound.protection.outlook.com ([207.46.100.58]:64832
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750966AbaKXRHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:07:01 -0500
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <dan.carpenter@oracle.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCH] usb: dwc2: remove early return on clock query
Date: Mon, 24 Nov 2014 11:02:11 -0600
Message-ID: <1416848531-673-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0023.namprd02.prod.outlook.com (10.141.56.23) To
 BY1PR0301MB1190.namprd03.prod.outlook.com (25.160.195.149)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1190;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1190;
X-Forefront-PRVS: 040513D301
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(20776003)(47776003)(92726001)(92566001)(64706001)(122386002)(86152002)(86362001)(93916002)(42186005)(53416004)(19580395003)(19580405001)(69596002)(21056001)(33646002)(62966003)(77096003)(77156002)(40100003)(87976001)(87286001)(88136002)(89996001)(101416001)(31966008)(104166001)(97736003)(120916001)(66066001)(99396003)(46102003)(102836001)(50986999)(106356001)(95666004)(81156004)(50466002)(107046002)(4396001)(50226001)(48376002)(105586002)(229853001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1190;H:linux-builds1.altera.com;FPR:;PTR:InfoNoRecords;MX:3;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1190;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB0870;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Since we have assigned clk=NULL, which is a valid clk, we should not
be returning when a clock node is not provide. Instead, we should return
only when we cannot enable the clock.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
 drivers/usb/dwc2/gadget.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 05b0522..407f55c 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3451,8 +3451,7 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
 	hsotg->clk = devm_clk_get(dev, "otg");
 	if (IS_ERR(hsotg->clk)) {
 		hsotg->clk = NULL;
-		dev_err(dev, "cannot get otg clock\n");
-		return PTR_ERR(hsotg->clk);
+		dev_dbg(dev, "cannot get otg clock\n");
 	}
 
 	hsotg->gadget.max_speed = USB_SPEED_HIGH;
@@ -3461,7 +3460,12 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
 
 	/* reset the system */
 
-	clk_prepare_enable(hsotg->clk);
+	ret = clk_prepare_enable(hsotg->clk);
+	if (ret) {
+		dev_err(dev, "failed to enable otg clk\n");
+		goto err_clk;
+	}
+
 
 	/* regulators */
 
-- 
2.0.3

