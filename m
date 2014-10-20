Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaJTS4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:56:51 -0400
Received: from mail-by2on0069.outbound.protection.outlook.com ([207.46.100.69]:32032
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751521AbaJTS4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:56:47 -0400
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <b.zolnierkie@samsung.com>,
        <matthijs@stdin.nl>, <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv5 3/7] usb: dwc2: Initialize the USB core for peripheral mode
Date: Mon, 20 Oct 2014 13:52:02 -0500
Message-ID: <1413831126-24193-4-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: SIXPR03CA014.apcprd03.prod.outlook.com (10.141.119.24) To
 BY1PR0301MB1189.namprd03.prod.outlook.com (25.160.195.148)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1189;
X-Forefront-PRVS: 03706074BC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(95666004)(20776003)(105586002)(88136002)(21056001)(102836001)(77096002)(97736003)(80022003)(99396003)(31966008)(107046002)(77156001)(106356001)(229853001)(81156004)(42186005)(76482002)(46102003)(66066001)(64706001)(120916001)(47776003)(53416004)(40100003)(33646002)(87976001)(93916002)(62966002)(86362001)(122386002)(19580405001)(19580395003)(50466002)(69596002)(87286001)(4396001)(104166001)(50226001)(86152002)(92726001)(92566001)(48376002)(50986999)(76176999)(85306004)(101416001)(85852003)(89996001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1189;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
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
index b21aace..de1f357 100644
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
index c407d33..6793ca8 100644
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

