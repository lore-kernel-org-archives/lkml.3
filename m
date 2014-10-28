Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbaJ1XaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 19:30:13 -0400
Received: from mail-bn1bon0091.outbound.protection.outlook.com ([157.56.111.91]:26835
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755130AbaJ1X35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 19:29:57 -0400
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv6 8/8] usb: dwc2: move usb_disabled() call to host driver only
Date: Tue, 28 Oct 2014 18:25:49 -0500
Message-ID: <1414538749-14735-9-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CY1PR12CA0019.namprd12.prod.outlook.com (25.160.137.29) To
 DM2PR0301MB1198.namprd03.prod.outlook.com (25.160.217.148)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1198;
X-Forefront-PRVS: 0378F1E47A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(122386002)(105586002)(33646002)(95666004)(102836001)(101416001)(53416004)(77156001)(77096002)(50226001)(120916001)(106356001)(229853001)(104166001)(107046002)(80022003)(50986999)(81156004)(69596002)(76176999)(46102003)(92566001)(85852003)(99396003)(4396001)(50466002)(19580405001)(19580395003)(76482002)(62966002)(85306004)(66066001)(97736003)(86362001)(89996001)(48376002)(86152002)(87286001)(20776003)(87976001)(21056001)(88136002)(40100003)(93916002)(92726001)(47776003)(42186005)(64706001)(31966008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1198;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Now that platform.c will get built for both Host and Gadget, if we leave the
usb_disabled() call in platform.c, it results in the following build error
when (!USB && USB_GADGET) condition is met.

ERROR: "usb_disabled" [drivers/usb/dwc2/dwc2_platform.ko] undefined!

Since usb_disabled() is mostly used to disable USB host functionality, move
the call the host portion for the DWC2 driver.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
 drivers/usb/dwc2/hcd.c      | 3 +++
 drivers/usb/dwc2/platform.c | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index fa49c72..b741997 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -2780,6 +2780,9 @@ int dwc2_hcd_init(struct dwc2_hsotg *hsotg, int irq,
 	int i, num_channels;
 	int retval;
 
+	if (usb_disabled())
+		return -ENODEV;
+
 	dev_dbg(hsotg->dev, "DWC OTG HCD INIT\n");
 
 	/* Detect config values from hardware */
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 77c8417..123cf54 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -157,9 +157,6 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	int retval;
 	int irq;
 
-	if (usb_disabled())
-		return -ENODEV;
-
 	match = of_match_device(dwc2_of_match_table, &dev->dev);
 	if (match && match->data) {
 		params = match->data;
-- 
2.0.3

