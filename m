Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaJ1L4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:56:25 -0400
Received: from mail-bl2on0115.outbound.protection.outlook.com ([65.55.169.115]:3098
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751647AbaJ1L4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:56:20 -0400
X-WSS-ID: 0NE5L5N-08-OBM-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, "Vincent Wan" <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH v3 06/19] usb: dwc3: add u2exit lfps quirk
Date: Tue, 28 Oct 2014 19:54:27 +0800
Message-ID: <1414497280-3126-7-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(50986999)(84676001)(31966008)(104166001)(102836001)(77156001)(19580395003)(107046002)(62966002)(229853001)(95666004)(19580405001)(50226001)(85306004)(44976005)(92726001)(53416004)(77096002)(88136002)(86362001)(93916002)(92566001)(68736004)(36756003)(101416001)(21056001)(50466002)(106466001)(120916001)(97736003)(46102003)(80022003)(2171001)(48376002)(76482002)(87936001)(89996001)(76176999)(87286001)(85852003)(105586002)(33646002)(64706001)(47776003)(20776003)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds u2exit lfps quirk, and some special platforms can configure
that if it is needed.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 6 ++++++
 drivers/usb/dwc3/core.h          | 3 +++
 drivers/usb/dwc3/platform_data.h | 1 +
 3 files changed, 10 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 4f37a43..6abf4e9 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -468,6 +468,9 @@ static int dwc3_core_init(struct dwc3 *dwc)
 	else
 		reg &= ~DWC3_GCTL_DISSCRAMBLE;
 
+	if (dwc->u2exit_lfps_quirk)
+		reg |= DWC3_GCTL_U2EXIT_LFPS;
+
 	/*
 	 * WORKAROUND: DWC3 revisions <1.90a have a bug
 	 * where the device can fail to connect at SuperSpeed
@@ -724,6 +727,8 @@ static int dwc3_probe(struct platform_device *pdev)
 
 		dwc->disable_scramble_quirk = of_property_read_bool(node,
 				"snps,disable_scramble_quirk");
+		dwc->u2exit_lfps_quirk = of_property_read_bool(node,
+				"snps,u2exit_lfps_quirk");
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
 		dwc->has_lpm_erratum = pdata->has_lpm_erratum;
@@ -734,6 +739,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->dr_mode = pdata->dr_mode;
 
 		dwc->disable_scramble_quirk = pdata->disable_scramble_quirk;
+		dwc->u2exit_lfps_quirk = pdata->u2exit_lfps_quirk;
 	}
 
 	/* default to superspeed if no maximum_speed passed */
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 19d1ecb..03e0505 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -166,6 +166,7 @@
 #define DWC3_GCTL_SCALEDOWN(n)		((n) << 4)
 #define DWC3_GCTL_SCALEDOWN_MASK	DWC3_GCTL_SCALEDOWN(3)
 #define DWC3_GCTL_DISSCRAMBLE		(1 << 3)
+#define DWC3_GCTL_U2EXIT_LFPS		(1 << 2)
 #define DWC3_GCTL_GBLHIBERNATIONEN	(1 << 1)
 #define DWC3_GCTL_DSBLCLKGTNG		(1 << 0)
 
@@ -679,6 +680,7 @@ struct dwc3_scratchpad_array {
  * @start_config_issued: true when StartConfig command has been issued
  * @three_stage_setup: set if we perform a three phase setup
  * @disable_scramble_quirk: set if we enable the disable scramble quirk
+ * @u2exit_lfps_quirk: set if we enable u2exit lfps quirk
  */
 struct dwc3 {
 	struct usb_ctrlrequest	*ctrl_req;
@@ -787,6 +789,7 @@ struct dwc3 {
 	unsigned		three_stage_setup:1;
 
 	unsigned		disable_scramble_quirk:1;
+	unsigned		u2exit_lfps_quirk:1;
 };
 
 /* -------------------------------------------------------------------------- */
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 2e546ac..4e91e09 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -28,4 +28,5 @@ struct dwc3_platform_data {
 	unsigned disable_scramble_quirk:1;
 	unsigned has_lpm_erratum:1;
 	unsigned lpm_nyet_thres:4;
+	unsigned u2exit_lfps_quirk:1;
 };
-- 
1.9.1

