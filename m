Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaKKRUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:20:34 -0500
Received: from mail-by2on0083.outbound.protection.outlook.com ([207.46.100.83]:49862
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751926AbaKKRSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:18:06 -0500
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv7 4/8] usb: dwc2: Initialize the USB core for peripheral mode
Date: Tue, 11 Nov 2014 11:13:36 -0600
Message-ID: <1415726020-19238-5-git-send-email-dinguyen@opensource.altera.com>
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

Initialize the USB driver to peripheral mode when a B-Device connector
is attached.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
Acked-by: Paul Zimmerman <paulz@synopsys.com>
---
v7: s3c_hsotg_core_init became s3c_hsotg_core_init_disconnected
v5: move the export of s3c_hsotg_core_init into this patch
---
 drivers/usb/dwc2/core.h   | 4 ++++
 drivers/usb/dwc2/gadget.c | 4 ++--
 drivers/usb/dwc2/hcd.c    | 2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index 4905d88..4710935 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -966,6 +966,8 @@ extern int s3c_hsotg_remove(struct dwc2_hsotg *hsotg);
 extern int s3c_hsotg_suspend(struct dwc2_hsotg *dwc2);
 extern int s3c_hsotg_resume(struct dwc2_hsotg *dwc2);
 extern int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq);
+extern void s3c_hsotg_core_init_disconnected(struct dwc2_hsotg *dwc2);
+extern void s3c_hsotg_core_connect(struct dwc2_hsotg *hsotg);
 #else
 static inline int s3c_hsotg_remove(struct dwc2_hsotg *dwc2)
 { return 0; }
@@ -975,6 +977,8 @@ static inline int s3c_hsotg_resume(struct dwc2_hsotg *dwc2)
 { return 0; }
 static inline int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
 { return 0; }
+static inline void s3c_hsotg_core_init_disconnected(struct dwc2_hsotg *dwc2) {}
+static inline void s3c_hsotg_core_connect(struct dwc2_hsotg *hsotg) {}
 #endif
 
 #if IS_ENABLED(CONFIG_USB_DWC2_HOST) || IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 9caea51..ec85340 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2125,7 +2125,7 @@ static int s3c_hsotg_corereset(struct dwc2_hsotg *hsotg)
  *
  * Issue a soft reset to the core, and await the core finishing it.
  */
-static void s3c_hsotg_core_init_disconnected(struct dwc2_hsotg *hsotg)
+void s3c_hsotg_core_init_disconnected(struct dwc2_hsotg *hsotg)
 {
 	s3c_hsotg_corereset(hsotg);
 
@@ -2257,7 +2257,7 @@ static void s3c_hsotg_core_disconnect(struct dwc2_hsotg *hsotg)
 	__orr32(hsotg->regs + DCTL, DCTL_SFTDISCON);
 }
 
-static void s3c_hsotg_core_connect(struct dwc2_hsotg *hsotg)
+void s3c_hsotg_core_connect(struct dwc2_hsotg *hsotg)
 {
 	/* remove the soft-disconnect and let's go */
 	__bic32(hsotg->regs + DCTL, DCTL_SFTDISCON);
diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 4a3cce0..fa60f4a 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -1371,6 +1371,8 @@ static void dwc2_conn_id_status_change(struct work_struct *work)
 		hsotg->op_state = OTG_STATE_B_PERIPHERAL;
 		dwc2_core_init(hsotg, false, -1);
 		dwc2_enable_global_interrupts(hsotg);
+		s3c_hsotg_core_init_disconnected(hsotg);
+		s3c_hsotg_core_connect(hsotg);
 	} else {
 		/* A-Device connector (Host Mode) */
 		dev_dbg(hsotg->dev, "connId A\n");
-- 
2.0.3

