Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaJ1L4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:56:55 -0400
Received: from mail-bn1bon0114.outbound.protection.outlook.com ([157.56.111.114]:44592
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755346AbaJ1L4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:56:52 -0400
X-WSS-ID: 0NE5L6E-08-OCK-02
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
Subject: [PATCH v3 12/19] usb: dwc3: add rx_detect to polling lfps quirk
Date: Tue, 28 Oct 2014 19:54:33 +0800
Message-ID: <1414497280-3126-13-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(46102003)(80022003)(92726001)(85306004)(31966008)(92566001)(87936001)(48376002)(2171001)(88136002)(85852003)(89996001)(102836001)(229853001)(106466001)(76176999)(50986999)(101416001)(107046002)(97736003)(93916002)(86362001)(104166001)(95666004)(19580405001)(105586002)(19580395003)(76482002)(77156001)(68736004)(4396001)(50226001)(33646002)(21056001)(36756003)(77096002)(120916001)(62966002)(87286001)(44976005)(50466002)(53416004)(84676001)(47776003)(20776003)(64706001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB199;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds RX_DETECT to Polling.LFPS control quirk, and some special
platforms can configure that if it is needed.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 6 ++++++
 drivers/usb/dwc3/core.h          | 3 +++
 drivers/usb/dwc3/platform_data.h | 1 +
 3 files changed, 10 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 86ed064..19019dc 100644
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
@@ -771,6 +774,8 @@ static int dwc3_probe(struct platform_device *pdev)
 				"snps,del_phy_power_chg_quirk");
 		dwc->lfps_filter_quirk = of_property_read_bool(node,
 				"snps,lfps_filter_quirk");
+		dwc->rx_detect_poll_quirk = of_property_read_bool(node,
+				"snps,rx_detect_poll_quirk");
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
 		dwc->has_lpm_erratum = pdata->has_lpm_erratum;
@@ -787,6 +792,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->del_p1p2p3_quirk = pdata->del_p1p2p3_quirk;
 		dwc->del_phy_power_chg_quirk = pdata->del_phy_power_chg_quirk;
 		dwc->lfps_filter_quirk = pdata->lfps_filter_quirk;
+		dwc->rx_detect_poll_quirk = pdata->rx_detect_poll_quirk;
 	}
 
 	/* default to superspeed if no maximum_speed passed */
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 23b48a0..57a203a 100644
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
  * @del_p1p2p3_quirk: set if we enable delay p1p2p3 quirk
  * @del_phy_power_chg_quirk: set if we enable delay phy power change quirk
  * @lfps_filter_quirk: set if we enable LFPS filter quirk
+ * @rx_detect_poll_quirk: set if we enable rx_detect to polling lfps quirk
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
index 89918e5..9776764 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -34,4 +34,5 @@ struct dwc3_platform_data {
 	unsigned del_p1p2p3_quirk:1;
 	unsigned del_phy_power_chg_quirk:1;
 	unsigned lfps_filter_quirk:1;
+	unsigned rx_detect_poll_quirk:1;
 };
-- 
1.9.1

