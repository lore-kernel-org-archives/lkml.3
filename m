Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643AbaJ3KLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:11:15 -0400
Received: from mail-bn1bn0106.outbound.protection.outlook.com ([157.56.110.106]:2848
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933546AbaJ3KLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:11:09 -0400
X-WSS-ID: 0NE95MD-08-IAM-02
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
Subject: [PATCH v4 12/20] usb: dwc3: add rx_detect to polling LFPS quirk
Date: Thu, 30 Oct 2014 18:08:37 +0800
Message-ID: <1414663725-2195-13-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(20776003)(36756003)(64706001)(48376002)(92566001)(120916001)(99396003)(102836001)(101416001)(104166001)(76482002)(31966008)(92726001)(47776003)(62966002)(50986999)(77156001)(21056001)(84676001)(76176999)(88136002)(87286001)(87936001)(68736004)(2171001)(44976005)(19580405001)(89996001)(85852003)(50466002)(19580395003)(229853001)(86362001)(95666004)(105586002)(80022003)(97736003)(106466001)(575784001)(33646002)(4396001)(85306004)(107046002)(46102003)(77096002)(93916002)(50226001)(53416004);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds RX_DETECT to Polling.LFPS control quirk, and some special
platforms can configure that if it is needed.

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
index 0647100..38bac28 100644
--- a/Documentation/devicetree/bindings/usb/dwc3.txt
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -27,6 +27,8 @@ Optional properties:
  - snps,del_phy_power_chg_quirk: when set core will delay PHY power change
 			from P0 to P1/P2/P3.
  - snps,lfps_filter_quirk: when set core will filter LFPS reception.
+ - snps,rx_detect_poll_quirk: when set core will disable a 400us delay to start
+			Polling LFPS after RX.Detect.
 
 This is usually a subnode to DWC3 glue to which it is connected.
 
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index ae7ff8f..11b0ab08 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -389,6 +389,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	if (dwc->lfps_filter_quirk)
 		reg |= DWC3_GUSB3PIPECTL_LFPSFILT;
 
+	if (dwc->rx_detect_poll_quirk)
+		reg |= DWC3_GUSB3PIPECTL_RX_DETOPOLL;
+
 	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
 
 	mdelay(100);
@@ -773,6 +776,8 @@ static int dwc3_probe(struct platform_device *pdev)
 				"snps,del_phy_power_chg_quirk");
 		dwc->lfps_filter_quirk = of_property_read_bool(node,
 				"snps,lfps_filter_quirk");
+		dwc->rx_detect_poll_quirk = of_property_read_bool(node,
+				"snps,rx_detect_poll_quirk");
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
 		dwc->has_lpm_erratum = pdata->has_lpm_erratum;
@@ -789,6 +794,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->del_p1p2p3_quirk = pdata->del_p1p2p3_quirk;
 		dwc->del_phy_power_chg_quirk = pdata->del_phy_power_chg_quirk;
 		dwc->lfps_filter_quirk = pdata->lfps_filter_quirk;
+		dwc->rx_detect_poll_quirk = pdata->rx_detect_poll_quirk;
 	}
 
 	/* default to superspeed if no maximum_speed passed */
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index cf9dd73..eeef976 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -184,6 +184,7 @@
 #define DWC3_GUSB3PIPECTL_DEPOCHANGE	(1 << 18)
 #define DWC3_GUSB3PIPECTL_SUSPHY	(1 << 17)
 #define DWC3_GUSB3PIPECTL_LFPSFILT	(1 << 9)
+#define DWC3_GUSB3PIPECTL_RX_DETOPOLL	(1 << 8)
 
 /* Global TX Fifo Size Register */
 #define DWC3_GTXFIFOSIZ_TXFDEF(n)	((n) & 0xffff)
@@ -693,6 +694,7 @@ struct dwc3_scratchpad_array {
  * @del_p1p2p3_quirk: set if we enable delay P1/P2/P3 quirk
  * @del_phy_power_chg_quirk: set if we enable delay phy power change quirk
  * @lfps_filter_quirk: set if we enable LFPS filter quirk
+ * @rx_detect_poll_quirk: set if we enable rx_detect to polling LFPS quirk
  */
 struct dwc3 {
 	struct usb_ctrlrequest	*ctrl_req;
@@ -807,6 +809,7 @@ struct dwc3 {
 	unsigned                del_p1p2p3_quirk:1;
 	unsigned		del_phy_power_chg_quirk:1;
 	unsigned		lfps_filter_quirk:1;
+	unsigned		rx_detect_poll_quirk:1;
 };
 
 /* -------------------------------------------------------------------------- */
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index dad0211..4a0f06b 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -35,4 +35,5 @@ struct dwc3_platform_data {
 	unsigned del_p1p2p3_quirk:1;
 	unsigned del_phy_power_chg_quirk:1;
 	unsigned lfps_filter_quirk:1;
+	unsigned rx_detect_poll_quirk:1;
 };
-- 
1.9.1

