Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbaJ1MA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:00:56 -0400
Received: from mail-bn1on0113.outbound.protection.outlook.com ([157.56.110.113]:44640
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752407AbaJ1L43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:56:29 -0400
X-WSS-ID: 0NE5L5Y-07-BGD-02
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
Subject: [PATCH v3 08/19] usb: dwc3: add request p1p2p3 quirk
Date: Tue, 28 Oct 2014 19:54:29 +0800
Message-ID: <1414497280-3126-9-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(53416004)(4396001)(105586002)(95666004)(106466001)(77096002)(48376002)(50466002)(36756003)(46102003)(80022003)(50226001)(97736003)(77156001)(107046002)(229853001)(31966008)(85306004)(120916001)(92566001)(44976005)(87286001)(88136002)(62966002)(19580405001)(104166001)(102836001)(86362001)(76482002)(93916002)(92726001)(33646002)(101416001)(68736004)(20776003)(50986999)(47776003)(76176999)(64706001)(84676001)(19580395003)(85852003)(89996001)(87936001)(2171001)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds request P1/P2/P3 quirk for U2/U2/U3, and some special
platforms can configure that if it is needed.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 6 ++++++
 drivers/usb/dwc3/core.h          | 3 +++
 drivers/usb/dwc3/platform_data.h | 1 +
 3 files changed, 10 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index ccc54df..021ebf3 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -377,6 +377,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	if (dwc->u2ss_inp3_quirk)
 		reg |= DWC3_GUSB3PIPECTL_U2SSINP3OK;
 
+	if (dwc->req_p1p2p3_quirk)
+		reg |= DWC3_GUSB3PIPECTL_REQP1P2P3;
+
 	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
 
 	mdelay(100);
@@ -751,6 +754,8 @@ static int dwc3_probe(struct platform_device *pdev)
 				"snps,u2exit_lfps_quirk");
 		dwc->u2ss_inp3_quirk = of_property_read_bool(node,
 				"snps,u2ss_inp3_quirk");
+		dwc->req_p1p2p3_quirk = of_property_read_bool(node,
+				"snps,req_p1p2p3_quirk");
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
 		dwc->has_lpm_erratum = pdata->has_lpm_erratum;
@@ -763,6 +768,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->disable_scramble_quirk = pdata->disable_scramble_quirk;
 		dwc->u2exit_lfps_quirk = pdata->u2exit_lfps_quirk;
 		dwc->u2ss_inp3_quirk = pdata->u2ss_inp3_quirk;
+		dwc->req_p1p2p3_quirk = pdata->req_p1p2p3_quirk;
 	}
 
 	/* default to superspeed if no maximum_speed passed */
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index f230668..e1aca71 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -177,6 +177,7 @@
 /* Global USB3 PIPE Control Register */
 #define DWC3_GUSB3PIPECTL_PHYSOFTRST	(1 << 31)
 #define DWC3_GUSB3PIPECTL_U2SSINP3OK	(1 << 29)
+#define DWC3_GUSB3PIPECTL_REQP1P2P3	(1 << 24)
 #define DWC3_GUSB3PIPECTL_SUSPHY	(1 << 17)
 
 /* Global TX Fifo Size Register */
@@ -683,6 +684,7 @@ struct dwc3_scratchpad_array {
  * @disable_scramble_quirk: set if we enable the disable scramble quirk
  * @u2exit_lfps_quirk: set if we enable u2exit lfps quirk
  * @u2ss_inp3_quirk: set if we enable P3 OK for U2/SS Inactive quirk
+ * @req_p1p2p3_quirk: set if we enable request p1p2p3 quirk
  */
 struct dwc3 {
 	struct usb_ctrlrequest	*ctrl_req;
@@ -793,6 +795,7 @@ struct dwc3 {
 	unsigned		disable_scramble_quirk:1;
 	unsigned		u2exit_lfps_quirk:1;
 	unsigned		u2ss_inp3_quirk:1;
+	unsigned		req_p1p2p3_quirk:1;
 };
 
 /* -------------------------------------------------------------------------- */
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index b5906a3..457ee9c 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -30,4 +30,5 @@ struct dwc3_platform_data {
 	unsigned lpm_nyet_thres:4;
 	unsigned u2exit_lfps_quirk:1;
 	unsigned u2ss_inp3_quirk:1;
+	unsigned req_p1p2p3_quirk:1;
 };
-- 
1.9.1

