Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbaJ3KKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:10:45 -0400
Received: from mail-bl2on0101.outbound.protection.outlook.com ([65.55.169.101]:47470
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932923AbaJ3KKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:10:39 -0400
X-WSS-ID: 0NE95LK-07-XTM-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH v4 06/20] usb: dwc3: add U2Exit LFPS quirk
Date: Thu, 30 Oct 2014 18:08:31 +0800
Message-ID: <1414663725-2195-7-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(428002)(199003)(189002)(87286001)(50986999)(19580405001)(120916001)(44976005)(85852003)(92726001)(19580395003)(102836001)(36756003)(76482002)(48376002)(93916002)(104166001)(575784001)(53416004)(77096002)(50466002)(84676001)(21056001)(33646002)(77156001)(62966002)(31966008)(89996001)(76176999)(68736004)(2171001)(101416001)(50226001)(4396001)(95666004)(106466001)(99396003)(105586002)(47776003)(20776003)(107046002)(87936001)(92566001)(97736003)(88136002)(46102003)(80022003)(86362001)(85306004)(64706001)(229853001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0201MB1075;H:atltwp01.amd.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0201MB1075;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0201MB0948;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds U2Exit LFPS quirk, and some special platforms can configure
that if it is needed.

[ balbi@ti.com : added DeviceTree binding documentation ]

Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 Documentation/devicetree/bindings/usb/dwc3.txt | 1 +
 drivers/usb/dwc3/core.c                        | 6 ++++++
 drivers/usb/dwc3/core.h                        | 3 +++
 drivers/usb/dwc3/platform_data.h               | 1 +
 4 files changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
index 2b0c1f2..79ed37c 100644
--- a/Documentation/devicetree/bindings/usb/dwc3.txt
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -18,6 +18,7 @@ Optional properties:
 	Only really useful for FPGA builds.
  - snps,has-lpm-erratum: true when DWC3 was configured with LPM Erratum enabled
  - snps,lpm-nyet-threshold: LPM NYET threshold
+ - snps,u2exit_lfps_quirk: set if we want to enable U2Exit LFPS quirk
 
 This is usually a subnode to DWC3 glue to which it is connected.
 
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 2ac96e4..6d1f09f 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -470,6 +470,9 @@ static int dwc3_core_init(struct dwc3 *dwc)
 	else
 		reg &= ~DWC3_GCTL_DISSCRAMBLE;
 
+	if (dwc->u2exit_lfps_quirk)
+		reg |= DWC3_GCTL_U2EXIT_LFPS;
+
 	/*
 	 * WORKAROUND: DWC3 revisions <1.90a have a bug
 	 * where the device can fail to connect at SuperSpeed
@@ -726,6 +729,8 @@ static int dwc3_probe(struct platform_device *pdev)
 
 		dwc->disable_scramble_quirk = of_property_read_bool(node,
 				"snps,disable_scramble_quirk");
+		dwc->u2exit_lfps_quirk = of_property_read_bool(node,
+				"snps,u2exit_lfps_quirk");
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
 		dwc->has_lpm_erratum = pdata->has_lpm_erratum;
@@ -736,6 +741,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->dr_mode = pdata->dr_mode;
 
 		dwc->disable_scramble_quirk = pdata->disable_scramble_quirk;
+		dwc->u2exit_lfps_quirk = pdata->u2exit_lfps_quirk;
 	}
 
 	/* default to superspeed if no maximum_speed passed */
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 34f1e08..45130a1 100644
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
+ * @u2exit_lfps_quirk: set if we enable U2Exit LFPS quirk
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
index e128308..3f21591 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -29,4 +29,5 @@ struct dwc3_platform_data {
 
 	unsigned disable_scramble_quirk:1;
 	unsigned has_lpm_erratum:1;
+	unsigned u2exit_lfps_quirk:1;
 };
-- 
1.9.1

