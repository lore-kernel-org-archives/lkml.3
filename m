Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934281AbaJ3KNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:13:39 -0400
Received: from mail-bn1on0142.outbound.protection.outlook.com ([157.56.110.142]:45524
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933784AbaJ3KLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:11:33 -0400
X-WSS-ID: 0NE95N2-07-XV2-02
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
Subject: [PATCH v4 16/20] usb: dwc3: add disable usb2 suspend phy quirk
Date: Thu, 30 Oct 2014 18:08:41 +0800
Message-ID: <1414663725-2195-17-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(50986999)(86362001)(62966002)(36756003)(48376002)(97736003)(21056001)(19580405001)(44976005)(46102003)(80022003)(19580395003)(92566001)(50466002)(68736004)(76176999)(64706001)(47776003)(85852003)(20776003)(89996001)(104166001)(50226001)(87286001)(88136002)(87936001)(4396001)(77156001)(2171001)(84676001)(93916002)(92726001)(31966008)(106466001)(95666004)(101416001)(107046002)(33646002)(229853001)(85306004)(76482002)(99396003)(120916001)(53416004)(105586002)(77096002)(102836001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB199;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds disable usb2 suspend phy quirk, and some special platforms
can configure that if it is needed.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 Documentation/devicetree/bindings/usb/dwc3.txt | 1 +
 drivers/usb/dwc3/core.c                        | 7 +++++++
 drivers/usb/dwc3/core.h                        | 2 ++
 drivers/usb/dwc3/platform_data.h               | 1 +
 4 files changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
index 3720fca..feaf2c8 100644
--- a/Documentation/devicetree/bindings/usb/dwc3.txt
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -33,6 +33,7 @@ Optional properties:
  - snps,tx_de_emphasis: the value driven to the PHY is controlled by the
 			LTSSM during USB3 Compliance mode.
  - snps,dis_u3_susphy_quirk: when set core will disable USB3 suspend phy.
+ - snps,dis_u2_susphy_quirk: when set core will disable USB2 suspend phy.
 
 This is usually a subnode to DWC3 glue to which it is connected.
 
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index fdc715a..a28ed1c 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -423,6 +423,10 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	if (dwc->revision > DWC3_REVISION_194A)
 		reg |= DWC3_GUSB2PHYCFG_SUSPHY;
 
+	/* FIXME will move FPGA flag when AMD NL taps out */
+	if (dwc->dis_u2_susphy_quirk && dwc->is_fpga)
+		reg &= ~DWC3_GUSB2PHYCFG_SUSPHY;
+
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
 
 	mdelay(100);
@@ -815,6 +819,8 @@ static int dwc3_probe(struct platform_device *pdev)
 				"snps,rx_detect_poll_quirk");
 		dwc->dis_u3_susphy_quirk = of_property_read_bool(node,
 				"snps,dis_u3_susphy_quirk");
+		dwc->dis_u2_susphy_quirk = of_property_read_bool(node,
+				"snps,dis_u2_susphy_quirk");
 
 		dwc->tx_de_emphasis_quirk = of_property_read_bool(node,
 				"snps,tx_de_emphasis_quirk");
@@ -838,6 +844,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->lfps_filter_quirk = pdata->lfps_filter_quirk;
 		dwc->rx_detect_poll_quirk = pdata->rx_detect_poll_quirk;
 		dwc->dis_u3_susphy_quirk = pdata->dis_u3_susphy_quirk;
+		dwc->dis_u2_susphy_quirk = pdata->dis_u2_susphy_quirk;
 
 		dwc->tx_de_emphasis_quirk = pdata->tx_de_emphasis_quirk;
 		if (pdata->tx_de_emphasis)
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index be793f7..8b6c308 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -698,6 +698,7 @@ struct dwc3_scratchpad_array {
  * @lfps_filter_quirk: set if we enable LFPS filter quirk
  * @rx_detect_poll_quirk: set if we enable rx_detect to polling LFPS quirk
  * @dis_u3_susphy_quirk: set if we disable usb3 suspend phy
+ * @dis_u2_susphy_quirk: set if we disable usb2 suspend phy
  * @tx_de_emphasis_quirk: set if we enable Tx de-emphasis quirk
  * @tx_de_emphasis: Tx de-emphasis value
  * 	0       - -6dB de-emphasis
@@ -820,6 +821,7 @@ struct dwc3 {
 	unsigned		lfps_filter_quirk:1;
 	unsigned		rx_detect_poll_quirk:1;
 	unsigned		dis_u3_susphy_quirk:1;
+	unsigned		dis_u2_susphy_quirk:1;
 
 	unsigned		tx_de_emphasis_quirk:1;
 	unsigned		tx_de_emphasis:2;
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 0f1d5ad..245300b 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -37,6 +37,7 @@ struct dwc3_platform_data {
 	unsigned lfps_filter_quirk:1;
 	unsigned rx_detect_poll_quirk:1;
 	unsigned dis_u3_susphy_quirk:1;
+	unsigned dis_u2_susphy_quirk:1;
 
 	unsigned tx_de_emphasis_quirk:1;
 	unsigned tx_de_emphasis:2;
-- 
1.9.1

