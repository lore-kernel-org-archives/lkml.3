Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbaJaDM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 23:12:59 -0400
Received: from mail-bn1on0113.outbound.protection.outlook.com ([157.56.110.113]:26559
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757694AbaJaDMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 23:12:55 -0400
X-WSS-ID: 0NEAGXC-07-7X6-02
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
Subject: [PATCH v5 3/8] usb: dwc3: add disable usb2 suspend phy quirk
Date: Fri, 31 Oct 2014 11:11:14 +0800
Message-ID: <1414725079-11490-4-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414725079-11490-1-git-send-email-ray.huang@amd.com>
References: <1414725079-11490-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(93916002)(50986999)(53416004)(2171001)(4396001)(46102003)(68736004)(44976005)(77096002)(48376002)(86362001)(19580395003)(80022003)(31966008)(84676001)(19580405001)(92726001)(92566001)(88136002)(77156001)(97736003)(33646002)(87936001)(87286001)(85306004)(85852003)(102836001)(229853001)(99396003)(36756003)(20776003)(95666004)(104166001)(76482002)(76176999)(106466001)(107046002)(64706001)(50466002)(62966002)(50226001)(101416001)(120916001)(89996001)(105586002)(47776003)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB202;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB202;
X-Forefront-PRVS: 03818C953D
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
 drivers/usb/dwc3/core.c                        | 6 ++++++
 drivers/usb/dwc3/core.h                        | 2 ++
 drivers/usb/dwc3/platform_data.h               | 1 +
 4 files changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
index 08b394e..f200ecc 100644
--- a/Documentation/devicetree/bindings/usb/dwc3.txt
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -33,6 +33,7 @@ Optional properties:
  - snps,tx_de_emphasis: the value driven to the PHY is controlled by the
 			LTSSM during USB3 Compliance mode.
  - snps,dis_u3_susphy_quirk: when set core will disable USB3 suspend phy.
+ - snps,dis_u2_susphy_quirk: when set core will disable USB2 suspend phy.
 
 This is usually a subnode to DWC3 glue to which it is connected.
 
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 6ec4176..25f1446 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -422,6 +422,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	if (dwc->revision > DWC3_REVISION_194A)
 		reg |= DWC3_GUSB2PHYCFG_SUSPHY;
 
+	if (dwc->dis_u2_susphy_quirk && dwc->is_fpga)
+		reg &= ~DWC3_GUSB2PHYCFG_SUSPHY;
+
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
 
 	mdelay(100);
@@ -812,6 +815,8 @@ static int dwc3_probe(struct platform_device *pdev)
 				"snps,rx_detect_poll_quirk");
 		dwc->dis_u3_susphy_quirk = of_property_read_bool(node,
 				"snps,dis_u3_susphy_quirk");
+		dwc->dis_u2_susphy_quirk = of_property_read_bool(node,
+				"snps,dis_u2_susphy_quirk");
 
 		dwc->tx_de_emphasis_quirk = of_property_read_bool(node,
 				"snps,tx_de_emphasis_quirk");
@@ -835,6 +840,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->lfps_filter_quirk = pdata->lfps_filter_quirk;
 		dwc->rx_detect_poll_quirk = pdata->rx_detect_poll_quirk;
 		dwc->dis_u3_susphy_quirk = pdata->dis_u3_susphy_quirk;
+		dwc->dis_u2_susphy_quirk = pdata->dis_u2_susphy_quirk;
 
 		dwc->tx_de_emphasis_quirk = pdata->tx_de_emphasis_quirk;
 		if (pdata->tx_de_emphasis)
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index fa778b0..cf86d30 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -698,6 +698,7 @@ struct dwc3_scratchpad_array {
  * @lfps_filter_quirk: set if we enable LFPS filter quirk
  * @rx_detect_poll_quirk: set if we enable rx_detect to polling lfps quirk
  * @dis_u3_susphy_quirk: set if we disable usb3 suspend phy
+ * @dis_u2_susphy_quirk: set if we disable usb2 suspend phy
  * @tx_de_emphasis_quirk: set if we enable Tx de-emphasis quirk
  * @tx_de_emphasis: Tx de-emphasis value
  * 	0	- -6dB de-emphasis
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

