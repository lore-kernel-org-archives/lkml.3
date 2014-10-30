Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbaJ3KL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:11:26 -0400
Received: from mail-bn1bn0105.outbound.protection.outlook.com ([157.56.110.105]:62496
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933546AbaJ3KLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:11:22 -0400
X-WSS-ID: 0NE95MR-07-XUP-02
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
Subject: [PATCH v4 14/20] usb: dwc3: add Tx de-emphasis quirk
Date: Thu, 30 Oct 2014 18:08:39 +0800
Message-ID: <1414663725-2195-15-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(53416004)(68736004)(46102003)(93916002)(50986999)(48376002)(77096002)(19580405001)(86362001)(31966008)(575784001)(80022003)(19580395003)(92726001)(44976005)(84676001)(4396001)(92566001)(2171001)(88136002)(77156001)(97736003)(33646002)(87936001)(87286001)(85306004)(85852003)(229853001)(102836001)(99396003)(36756003)(76482002)(107046002)(104166001)(76176999)(106466001)(64706001)(95666004)(20776003)(50466002)(89996001)(120916001)(50226001)(101416001)(105586002)(47776003)(62966002)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB202;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB202;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Tx de-emphasis quirk, and the Tx de-emphasis value is
configurable according to PIPE3 specification.

Value		Description
0		-6dB de-emphasis
1		-3.5dB de-emphasis
2		No de-emphasis
3		Reserved

It can be configured on DT or platform data.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 Documentation/devicetree/bindings/usb/dwc3.txt |  3 +++
 drivers/usb/dwc3/core.c                        | 17 +++++++++++++++++
 drivers/usb/dwc3/core.h                        | 11 +++++++++++
 drivers/usb/dwc3/platform_data.h               |  3 +++
 4 files changed, 34 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
index 38bac28..a9e54ae 100644
--- a/Documentation/devicetree/bindings/usb/dwc3.txt
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -29,6 +29,9 @@ Optional properties:
  - snps,lfps_filter_quirk: when set core will filter LFPS reception.
  - snps,rx_detect_poll_quirk: when set core will disable a 400us delay to start
 			Polling LFPS after RX.Detect.
+ - snps,tx_de_emphasis_quirk: when set core will set Tx de-emphasis value.
+ - snps,tx_de_emphasis: the value driven to the PHY is controlled by the
+			LTSSM during USB3 Compliance mode.
 
 This is usually a subnode to DWC3 glue to which it is connected.
 
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index e02c3b0..b55fa5b 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -401,6 +401,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	if (dwc->rx_detect_poll_quirk)
 		reg |= DWC3_GUSB3PIPECTL_RX_DETOPOLL;
 
+	if (dwc->tx_de_emphasis_quirk)
+		reg |= DWC3_GUSB3PIPECTL_TX_DEEPH(dwc->tx_de_emphasis);
+
 	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
 
 	mdelay(100);
@@ -717,6 +720,7 @@ static int dwc3_probe(struct platform_device *pdev)
 	struct resource		*res;
 	struct dwc3		*dwc;
 	u8			lpm_nyet_threshold;
+	u8			tx_de_emphasis;
 
 	int			ret;
 
@@ -775,6 +779,9 @@ static int dwc3_probe(struct platform_device *pdev)
 	/* default to highest possible threshold */
 	lpm_nyet_threshold = 0xff;
 
+	/* default to -3.5dB de-emphasis */
+	tx_de_emphasis = 1;
+
 	if (node) {
 		dwc->maximum_speed = of_usb_get_maximum_speed(node);
 		dwc->has_lpm_erratum = of_property_read_bool(node,
@@ -802,6 +809,11 @@ static int dwc3_probe(struct platform_device *pdev)
 				"snps,lfps_filter_quirk");
 		dwc->rx_detect_poll_quirk = of_property_read_bool(node,
 				"snps,rx_detect_poll_quirk");
+
+		dwc->tx_de_emphasis_quirk = of_property_read_bool(node,
+				"snps,tx_de_emphasis_quirk");
+		of_property_read_u8(node, "snps,tx_de_emphasis",
+				&tx_de_emphasis);
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
 		dwc->has_lpm_erratum = pdata->has_lpm_erratum;
@@ -819,6 +831,10 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->del_phy_power_chg_quirk = pdata->del_phy_power_chg_quirk;
 		dwc->lfps_filter_quirk = pdata->lfps_filter_quirk;
 		dwc->rx_detect_poll_quirk = pdata->rx_detect_poll_quirk;
+
+		dwc->tx_de_emphasis_quirk = pdata->tx_de_emphasis_quirk;
+		if (pdata->tx_de_emphasis)
+			tx_de_emphasis = pdata->tx_de_emphasis;
 	}
 
 	/* default to superspeed if no maximum_speed passed */
@@ -826,6 +842,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->maximum_speed = USB_SPEED_SUPER;
 
 	dwc->lpm_nyet_threshold = lpm_nyet_threshold;
+	dwc->tx_de_emphasis = tx_de_emphasis;
 
 	ret = dwc3_core_get_phy(dwc);
 	if (ret)
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index eeef976..469ee13 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -185,6 +185,8 @@
 #define DWC3_GUSB3PIPECTL_SUSPHY	(1 << 17)
 #define DWC3_GUSB3PIPECTL_LFPSFILT	(1 << 9)
 #define DWC3_GUSB3PIPECTL_RX_DETOPOLL	(1 << 8)
+#define DWC3_GUSB3PIPECTL_TX_DEEPH_MASK	DWC3_GUSB3PIPECTL_TX_DEEPH(3)
+#define DWC3_GUSB3PIPECTL_TX_DEEPH(n)	((n) << 1)
 
 /* Global TX Fifo Size Register */
 #define DWC3_GTXFIFOSIZ_TXFDEF(n)	((n) & 0xffff)
@@ -695,6 +697,12 @@ struct dwc3_scratchpad_array {
  * @del_phy_power_chg_quirk: set if we enable delay phy power change quirk
  * @lfps_filter_quirk: set if we enable LFPS filter quirk
  * @rx_detect_poll_quirk: set if we enable rx_detect to polling LFPS quirk
+ * @tx_de_emphasis_quirk: set if we enable Tx de-emphasis quirk
+ * @tx_de_emphasis: Tx de-emphasis value
+ * 	0       - -6dB de-emphasis
+ * 	1       - -3.5dB de-emphasis
+ * 	2       - No de-emphasis
+ * 	3       - Reserved
  */
 struct dwc3 {
 	struct usb_ctrlrequest	*ctrl_req;
@@ -810,6 +818,9 @@ struct dwc3 {
 	unsigned		del_phy_power_chg_quirk:1;
 	unsigned		lfps_filter_quirk:1;
 	unsigned		rx_detect_poll_quirk:1;
+
+	unsigned		tx_de_emphasis_quirk:1;
+	unsigned		tx_de_emphasis:2;
 };
 
 /* -------------------------------------------------------------------------- */
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 4a0f06b..e1ab900 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -36,4 +36,7 @@ struct dwc3_platform_data {
 	unsigned del_phy_power_chg_quirk:1;
 	unsigned lfps_filter_quirk:1;
 	unsigned rx_detect_poll_quirk:1;
+
+	unsigned tx_de_emphasis_quirk:1;
+	unsigned tx_de_emphasis:2;
 };
-- 
1.9.1

