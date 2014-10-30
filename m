Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423AbaJ3KLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:11:03 -0400
Received: from mail-bn1bon0116.outbound.protection.outlook.com ([157.56.111.116]:2304
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932936AbaJ3KK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:10:58 -0400
X-WSS-ID: 0NE95M3-08-IAF-02
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
Subject: [PATCH v4 10/20] usb: dwc3: add delay phy power change quirk
Date: Thu, 30 Oct 2014 18:08:35 +0800
Message-ID: <1414663725-2195-11-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(4396001)(85306004)(86362001)(46102003)(80022003)(50226001)(102836001)(93916002)(229853001)(107046002)(31966008)(33646002)(62966002)(77096002)(53416004)(92726001)(48376002)(101416001)(64706001)(47776003)(20776003)(50466002)(104166001)(92566001)(105586002)(87936001)(50986999)(2171001)(36756003)(77156001)(76482002)(106466001)(99396003)(120916001)(21056001)(68736004)(76176999)(89996001)(85852003)(97736003)(95666004)(88136002)(84676001)(87286001)(44976005)(19580395003)(19580405001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds delay PHY power change from P0 to P1/P2/P3 when link state
changing from U0 to U1/U2/U3 respectively, and some special platforms can
configure that if it is needed.

[ balbi@ti.com : added DeviceTree binding documentation ]

Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 Documentation/devicetree/bindings/usb/dwc3.txt | 2 ++
 drivers/usb/dwc3/core.c                        | 6 ++++++
 drivers/usb/dwc3/core.h                        | 3 +++
 drivers/usb/dwc3/platform_data.h               | 1 +
 4 files changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
index a406bb5..216cc35 100644
--- a/Documentation/devicetree/bindings/usb/dwc3.txt
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -24,6 +24,8 @@ Optional properties:
 			P1/P2/P3 transition sequence.
  - snps,del_p1p2p3_quirk: when set core will delay P1/P2/P3 until a certain
 			amount of 8B10B errors occur.
+ - snps,del_phy_power_chg_quirk: when set core will delay PHY power change
+			from P0 to P1/P2/P3.
 
 This is usually a subnode to DWC3 glue to which it is connected.
 
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 4429de7..deceb7c 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -383,6 +383,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	if (dwc->del_p1p2p3_quirk)
 		reg |= DWC3_GUSB3PIPECTL_DEP1P2P3_EN;
 
+	if (dwc->del_phy_power_chg_quirk)
+		reg |= DWC3_GUSB3PIPECTL_DEPOCHANGE;
+
 	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
 
 	mdelay(100);
@@ -763,6 +766,8 @@ static int dwc3_probe(struct platform_device *pdev)
 				"snps,req_p1p2p3_quirk");
 		dwc->del_p1p2p3_quirk = of_property_read_bool(node,
 				"snps,del_p1p2p3_quirk");
+		dwc->del_phy_power_chg_quirk = of_property_read_bool(node,
+				"snps,del_phy_power_chg_quirk");
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
 		dwc->has_lpm_erratum = pdata->has_lpm_erratum;
@@ -777,6 +782,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->u2ss_inp3_quirk = pdata->u2ss_inp3_quirk;
 		dwc->req_p1p2p3_quirk = pdata->req_p1p2p3_quirk;
 		dwc->del_p1p2p3_quirk = pdata->del_p1p2p3_quirk;
+		dwc->del_phy_power_chg_quirk = pdata->del_phy_power_chg_quirk;
 	}
 
 	/* default to superspeed if no maximum_speed passed */
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 750e473..176f3f1 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -181,6 +181,7 @@
 #define DWC3_GUSB3PIPECTL_DEP1P2P3(n)	((n) << 19)
 #define DWC3_GUSB3PIPECTL_DEP1P2P3_MASK	DWC3_GUSB3PIPECTL_DEP1P2P3(7)
 #define DWC3_GUSB3PIPECTL_DEP1P2P3_EN	DWC3_GUSB3PIPECTL_DEP1P2P3(1)
+#define DWC3_GUSB3PIPECTL_DEPOCHANGE	(1 << 18)
 #define DWC3_GUSB3PIPECTL_SUSPHY	(1 << 17)
 
 /* Global TX Fifo Size Register */
@@ -689,6 +690,7 @@ struct dwc3_scratchpad_array {
  * @u2ss_inp3_quirk: set if we enable P3 OK for U2/SS Inactive quirk
  * @req_p1p2p3_quirk: set if we enable request P1/P2/P3 quirk
  * @del_p1p2p3_quirk: set if we enable delay P1/P2/P3 quirk
+ * @del_phy_power_chg_quirk: set if we enable delay phy power change quirk
  */
 struct dwc3 {
 	struct usb_ctrlrequest	*ctrl_req;
@@ -801,6 +803,7 @@ struct dwc3 {
 	unsigned		u2ss_inp3_quirk:1;
 	unsigned		req_p1p2p3_quirk:1;
 	unsigned                del_p1p2p3_quirk:1;
+	unsigned		del_phy_power_chg_quirk:1;
 };
 
 /* -------------------------------------------------------------------------- */
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index a421cec..ae67151 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -33,4 +33,5 @@ struct dwc3_platform_data {
 	unsigned u2ss_inp3_quirk:1;
 	unsigned req_p1p2p3_quirk:1;
 	unsigned del_p1p2p3_quirk:1;
+	unsigned del_phy_power_chg_quirk:1;
 };
-- 
1.9.1

