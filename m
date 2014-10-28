Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaJ1L4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:56:46 -0400
Received: from mail-by2on0102.outbound.protection.outlook.com ([207.46.100.102]:19968
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755390AbaJ1L4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:56:43 -0400
X-WSS-ID: 0NE5L6C-07-BGY-02
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
Subject: [PATCH v3 11/19] usb: dwc3: add lfps filter quirk
Date: Tue, 28 Oct 2014 19:54:32 +0800
Message-ID: <1414497280-3126-12-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(87936001)(87286001)(33646002)(229853001)(102836001)(85852003)(85306004)(50226001)(97736003)(4396001)(88136002)(2171001)(62966002)(120916001)(64706001)(106466001)(107046002)(95666004)(20776003)(47776003)(21056001)(101416001)(104166001)(105586002)(77156001)(36756003)(76176999)(76482002)(89996001)(50466002)(48376002)(77096002)(53416004)(50986999)(19580405001)(19580395003)(44976005)(80022003)(46102003)(84676001)(93916002)(92726001)(92566001)(86362001)(575784001)(31966008)(68736004);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB202;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB202;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds LFPS filter quirk, and some special platforms can configure
that if it is needed.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 6 ++++++
 drivers/usb/dwc3/core.h          | 3 +++
 drivers/usb/dwc3/platform_data.h | 1 +
 3 files changed, 10 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 97796d7..86ed064 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -386,6 +386,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	if (dwc->del_phy_power_chg_quirk)
 		reg |= DWC3_GUSB3PIPECTL_DEPOCHANGE;
 
+	if (dwc->lfps_filter_quirk)
+		reg |= DWC3_GUSB3PIPECTL_LFPSFILT;
+
 	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
 
 	mdelay(100);
@@ -766,6 +769,8 @@ static int dwc3_probe(struct platform_device *pdev)
 				"snps,del_p1p2p3_quirk");
 		dwc->del_phy_power_chg_quirk = of_property_read_bool(node,
 				"snps,del_phy_power_chg_quirk");
+		dwc->lfps_filter_quirk = of_property_read_bool(node,
+				"snps,lfps_filter_quirk");
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
 		dwc->has_lpm_erratum = pdata->has_lpm_erratum;
@@ -781,6 +786,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->req_p1p2p3_quirk = pdata->req_p1p2p3_quirk;
 		dwc->del_p1p2p3_quirk = pdata->del_p1p2p3_quirk;
 		dwc->del_phy_power_chg_quirk = pdata->del_phy_power_chg_quirk;
+		dwc->lfps_filter_quirk = pdata->lfps_filter_quirk;
 	}
 
 	/* default to superspeed if no maximum_speed passed */
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 13bc46b..23b48a0 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -183,6 +183,7 @@
 #define DWC3_GUSB3PIPECTL_DEP1P2P3_EN	DWC3_GUSB3PIPECTL_DEP1P2P3(1)
 #define DWC3_GUSB3PIPECTL_DEPOCHANGE	(1 << 18)
 #define DWC3_GUSB3PIPECTL_SUSPHY	(1 << 17)
+#define DWC3_GUSB3PIPECTL_LFPSFILT	(1 << 9)
 
 /* Global TX Fifo Size Register */
 #define DWC3_GTXFIFOSIZ_TXFDEF(n)	((n) & 0xffff)
@@ -691,6 +692,7 @@ struct dwc3_scratchpad_array {
  * @req_p1p2p3_quirk: set if we enable request p1p2p3 quirk
  * @del_p1p2p3_quirk: set if we enable delay p1p2p3 quirk
  * @del_phy_power_chg_quirk: set if we enable delay phy power change quirk
+ * @lfps_filter_quirk: set if we enable LFPS filter quirk
  */
 struct dwc3 {
 	struct usb_ctrlrequest	*ctrl_req;
@@ -804,6 +806,7 @@ struct dwc3 {
 	unsigned		req_p1p2p3_quirk:1;
 	unsigned                del_p1p2p3_quirk:1;
 	unsigned		del_phy_power_chg_quirk:1;
+	unsigned		lfps_filter_quirk:1;
 };
 
 /* -------------------------------------------------------------------------- */
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 1dea0c0..89918e5 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -33,4 +33,5 @@ struct dwc3_platform_data {
 	unsigned req_p1p2p3_quirk:1;
 	unsigned del_p1p2p3_quirk:1;
 	unsigned del_phy_power_chg_quirk:1;
+	unsigned lfps_filter_quirk:1;
 };
-- 
1.9.1

