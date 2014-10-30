Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbaJ3KLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:11:37 -0400
Received: from mail-bn1on0144.outbound.protection.outlook.com ([157.56.110.144]:50763
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933546AbaJ3KL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:11:28 -0400
X-WSS-ID: 0NE95MX-07-XUY-02
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
Subject: [PATCH v4 15/20] usb: dwc3: add disable usb3 suspend phy quirk
Date: Thu, 30 Oct 2014 18:08:40 +0800
Message-ID: <1414663725-2195-16-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(19580405001)(107046002)(105586002)(102836001)(87936001)(120916001)(77156001)(84676001)(85852003)(50466002)(106466001)(2171001)(46102003)(95666004)(21056001)(97736003)(68736004)(229853001)(36756003)(19580395003)(44976005)(48376002)(50986999)(33646002)(104166001)(47776003)(88136002)(99396003)(31966008)(89996001)(64706001)(86362001)(76176999)(92566001)(80022003)(85306004)(53416004)(87286001)(92726001)(4396001)(77096002)(93916002)(62966002)(20776003)(101416001)(50226001)(76482002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds disable usb3 suspend phy quirk, and some special platforms
can configure that if it is needed.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 Documentation/devicetree/bindings/usb/dwc3.txt | 1 +
 drivers/usb/dwc3/core.c                        | 7 +++++++
 drivers/usb/dwc3/core.h                        | 2 ++
 drivers/usb/dwc3/platform_data.h               | 1 +
 4 files changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
index a9e54ae..3720fca 100644
--- a/Documentation/devicetree/bindings/usb/dwc3.txt
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -32,6 +32,7 @@ Optional properties:
  - snps,tx_de_emphasis_quirk: when set core will set Tx de-emphasis value.
  - snps,tx_de_emphasis: the value driven to the PHY is controlled by the
 			LTSSM during USB3 Compliance mode.
+ - snps,dis_u3_susphy_quirk: when set core will disable USB3 suspend phy.
 
 This is usually a subnode to DWC3 glue to which it is connected.
 
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index b55fa5b..fdc715a 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -404,6 +404,10 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	if (dwc->tx_de_emphasis_quirk)
 		reg |= DWC3_GUSB3PIPECTL_TX_DEEPH(dwc->tx_de_emphasis);
 
+	/* FIXME will move FPGA flag when AMD NL taps out */
+	if (dwc->dis_u3_susphy_quirk && dwc->is_fpga)
+		reg &= ~DWC3_GUSB3PIPECTL_SUSPHY;
+
 	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
 
 	mdelay(100);
@@ -809,6 +813,8 @@ static int dwc3_probe(struct platform_device *pdev)
 				"snps,lfps_filter_quirk");
 		dwc->rx_detect_poll_quirk = of_property_read_bool(node,
 				"snps,rx_detect_poll_quirk");
+		dwc->dis_u3_susphy_quirk = of_property_read_bool(node,
+				"snps,dis_u3_susphy_quirk");
 
 		dwc->tx_de_emphasis_quirk = of_property_read_bool(node,
 				"snps,tx_de_emphasis_quirk");
@@ -831,6 +837,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->del_phy_power_chg_quirk = pdata->del_phy_power_chg_quirk;
 		dwc->lfps_filter_quirk = pdata->lfps_filter_quirk;
 		dwc->rx_detect_poll_quirk = pdata->rx_detect_poll_quirk;
+		dwc->dis_u3_susphy_quirk = pdata->dis_u3_susphy_quirk;
 
 		dwc->tx_de_emphasis_quirk = pdata->tx_de_emphasis_quirk;
 		if (pdata->tx_de_emphasis)
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 469ee13..be793f7 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -697,6 +697,7 @@ struct dwc3_scratchpad_array {
  * @del_phy_power_chg_quirk: set if we enable delay phy power change quirk
  * @lfps_filter_quirk: set if we enable LFPS filter quirk
  * @rx_detect_poll_quirk: set if we enable rx_detect to polling LFPS quirk
+ * @dis_u3_susphy_quirk: set if we disable usb3 suspend phy
  * @tx_de_emphasis_quirk: set if we enable Tx de-emphasis quirk
  * @tx_de_emphasis: Tx de-emphasis value
  * 	0       - -6dB de-emphasis
@@ -818,6 +819,7 @@ struct dwc3 {
 	unsigned		del_phy_power_chg_quirk:1;
 	unsigned		lfps_filter_quirk:1;
 	unsigned		rx_detect_poll_quirk:1;
+	unsigned		dis_u3_susphy_quirk:1;
 
 	unsigned		tx_de_emphasis_quirk:1;
 	unsigned		tx_de_emphasis:2;
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index e1ab900..0f1d5ad 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -36,6 +36,7 @@ struct dwc3_platform_data {
 	unsigned del_phy_power_chg_quirk:1;
 	unsigned lfps_filter_quirk:1;
 	unsigned rx_detect_poll_quirk:1;
+	unsigned dis_u3_susphy_quirk:1;
 
 	unsigned tx_de_emphasis_quirk:1;
 	unsigned tx_de_emphasis:2;
-- 
1.9.1

