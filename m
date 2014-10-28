Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaJ1XcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 19:32:21 -0400
Received: from mail-bn1bon0055.outbound.protection.outlook.com ([157.56.111.55]:21570
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754795AbaJ1X3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 19:29:50 -0400
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv6 3/8] usb: dwc2: Initialize the USB core for peripheral mode
Date: Tue, 28 Oct 2014 18:25:44 -0500
Message-ID: <1414538749-14735-4-git-send-email-dinguyen@opensource.altera.com>
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

Initialize the USB driver to peripheral mode when a B-Device connector
is attached.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
Acked-by: Paul Zimmerman <paulz@synopsys.com>
---
v5: move the export of s3c_hsotg_core_init into this patch
---
 drivers/usb/dwc2/core.h   | 2 ++
 drivers/usb/dwc2/gadget.c | 2 +-
 drivers/usb/dwc2/hcd.c    | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index de2b194..80d29c7 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -966,6 +966,7 @@ extern int s3c_hsotg_remove(struct dwc2_hsotg *hsotg);
 extern int s3c_hsotg_suspend(struct dwc2_hsotg *dwc2);
 extern int s3c_hsotg_resume(struct dwc2_hsotg *dwc2);
 extern int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq);
+extern void s3c_hsotg_core_init(struct dwc2_hsotg *dwc2);
 #else
 static inline int s3c_hsotg_remove(struct dwc2_hsotg *dwc2)
 { return 0; }
@@ -975,6 +976,7 @@ static inline int s3c_hsotg_resume(struct dwc2_hsotg *dwc2)
 { return 0; }
 static inline int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
 { return 0; }
+static inline void s3c_hsotg_core_init(struct dwc2_hsotg *dwc2) {}
 #endif
 
 #if IS_ENABLED(CONFIG_USB_DWC2_HOST) || IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 38ec1cc..19d1b03 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2125,7 +2125,7 @@ static int s3c_hsotg_corereset(struct dwc2_hsotg *hsotg)
  *
  * Issue a soft reset to the core, and await the core finishing it.
  */
-static void s3c_hsotg_core_init(struct dwc2_hsotg *hsotg)
+void s3c_hsotg_core_init(struct dwc2_hsotg *hsotg)
 {
 	s3c_hsotg_corereset(hsotg);
 
diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 4a3cce0..44c609f 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -1371,6 +1371,7 @@ static void dwc2_conn_id_status_change(struct work_struct *work)
 		hsotg->op_state = OTG_STATE_B_PERIPHERAL;
 		dwc2_core_init(hsotg, false, -1);
 		dwc2_enable_global_interrupts(hsotg);
+		s3c_hsotg_core_init(hsotg);
 	} else {
 		/* A-Device connector (Host Mode) */
 		dev_dbg(hsotg->dev, "connId A\n");
-- 
2.0.3

