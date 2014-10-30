Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbaJ3KKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:10:54 -0400
Received: from mail-bn1bon0137.outbound.protection.outlook.com ([157.56.111.137]:16304
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932936AbaJ3KKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:10:45 -0400
X-WSS-ID: 0NE95LO-08-I9W-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH v4 07/20] usb: dwc3: add P3 in U2 SS Inactive quirk
Date: Thu, 30 Oct 2014 18:08:32 +0800
Message-ID: <1414663725-2195-8-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(76176999)(50986999)(92726001)(92566001)(85852003)(89996001)(86362001)(88136002)(93916002)(19580395003)(87936001)(2171001)(77156001)(47776003)(64706001)(20776003)(4396001)(50226001)(36756003)(87286001)(68736004)(77096002)(120916001)(50466002)(84676001)(48376002)(229853001)(107046002)(76482002)(62966002)(21056001)(80022003)(104166001)(31966008)(46102003)(106466001)(19580405001)(97736003)(44976005)(102836001)(99396003)(33646002)(95666004)(105586002)(53416004)(85306004)(101416001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds P3 in U2 SS Inactive quirk, and some special platforms can
configure that if it is needed.

[ balbi@ti.com : added DeviceTree binding documentation ]

Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 Documentation/devicetree/bindings/usb/dwc3.txt |  1 +
 drivers/usb/dwc3/core.c                        | 23 +++++++++++++++++++++++
 drivers/usb/dwc3/core.h                        |  3 +++
 drivers/usb/dwc3/platform_data.h               |  1 +
 4 files changed, 28 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
index 79ed37c..f714357 100644
--- a/Documentation/devicetree/bindings/usb/dwc3.txt
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -19,6 +19,7 @@ Optional properties:
  - snps,has-lpm-erratum: true when DWC3 was configured with LPM Erratum enabled
  - snps,lpm-nyet-threshold: LPM NYET threshold
  - snps,u2exit_lfps_quirk: set if we want to enable U2Exit LFPS quirk
+ - snps,u2ss_inp3_quirk: set if we enable P3 OK for U2/SS Inactive quirk
 
 This is usually a subnode to DWC3 glue to which it is connected.
 
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 6d1f09f..0a935cb 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -365,6 +365,24 @@ static void dwc3_cache_hwparams(struct dwc3 *dwc)
 }
 
 /**
+ * dwc3_phy_setup - Configure USB PHY Interface of DWC3 Core
+ * @dwc: Pointer to our controller context structure
+ */
+static void dwc3_phy_setup(struct dwc3 *dwc)
+{
+	u32 reg;
+
+	reg = dwc3_readl(dwc->regs, DWC3_GUSB3PIPECTL(0));
+
+	if (dwc->u2ss_inp3_quirk)
+		reg |= DWC3_GUSB3PIPECTL_U2SSINP3OK;
+
+	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
+
+	mdelay(100);
+}
+
+/**
  * dwc3_core_init - Low-level initialization of DWC3 Core
  * @dwc: Pointer to our controller context structure
  *
@@ -486,6 +504,8 @@ static int dwc3_core_init(struct dwc3 *dwc)
 
 	dwc3_writel(dwc->regs, DWC3_GCTL, reg);
 
+	dwc3_phy_setup(dwc);
+
 	ret = dwc3_alloc_scratch_buffers(dwc);
 	if (ret)
 		goto err1;
@@ -731,6 +751,8 @@ static int dwc3_probe(struct platform_device *pdev)
 				"snps,disable_scramble_quirk");
 		dwc->u2exit_lfps_quirk = of_property_read_bool(node,
 				"snps,u2exit_lfps_quirk");
+		dwc->u2ss_inp3_quirk = of_property_read_bool(node,
+				"snps,u2ss_inp3_quirk");
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
 		dwc->has_lpm_erratum = pdata->has_lpm_erratum;
@@ -742,6 +764,7 @@ static int dwc3_probe(struct platform_device *pdev)
 
 		dwc->disable_scramble_quirk = pdata->disable_scramble_quirk;
 		dwc->u2exit_lfps_quirk = pdata->u2exit_lfps_quirk;
+		dwc->u2ss_inp3_quirk = pdata->u2ss_inp3_quirk;
 	}
 
 	/* default to superspeed if no maximum_speed passed */
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 45130a1..3843511 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -176,6 +176,7 @@
 
 /* Global USB3 PIPE Control Register */
 #define DWC3_GUSB3PIPECTL_PHYSOFTRST	(1 << 31)
+#define DWC3_GUSB3PIPECTL_U2SSINP3OK	(1 << 29)
 #define DWC3_GUSB3PIPECTL_SUSPHY	(1 << 17)
 
 /* Global TX Fifo Size Register */
@@ -681,6 +682,7 @@ struct dwc3_scratchpad_array {
  * @three_stage_setup: set if we perform a three phase setup
  * @disable_scramble_quirk: set if we enable the disable scramble quirk
  * @u2exit_lfps_quirk: set if we enable U2Exit LFPS quirk
+ * @u2ss_inp3_quirk: set if we enable P3 OK for U2/SS Inactive quirk
  */
 struct dwc3 {
 	struct usb_ctrlrequest	*ctrl_req;
@@ -790,6 +792,7 @@ struct dwc3 {
 
 	unsigned		disable_scramble_quirk:1;
 	unsigned		u2exit_lfps_quirk:1;
+	unsigned		u2ss_inp3_quirk:1;
 };
 
 /* -------------------------------------------------------------------------- */
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 3f21591..cf92c81 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -30,4 +30,5 @@ struct dwc3_platform_data {
 	unsigned disable_scramble_quirk:1;
 	unsigned has_lpm_erratum:1;
 	unsigned u2exit_lfps_quirk:1;
+	unsigned u2ss_inp3_quirk:1;
 };
-- 
1.9.1

