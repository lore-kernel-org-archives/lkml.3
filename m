Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbaJ1MBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:01:32 -0400
Received: from mail-by2on0126.outbound.protection.outlook.com ([207.46.100.126]:21968
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755107AbaJ1L4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:56:14 -0400
X-WSS-ID: 0NE5L5K-07-BG5-02
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
Subject: [PATCH v3 05/19] usb: dwc3: add lpm erratum support
Date: Tue, 28 Oct 2014 19:54:26 +0800
Message-ID: <1414497280-3126-6-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(479174003)(189002)(199003)(97736003)(77156001)(36756003)(229853001)(87286001)(88136002)(2171001)(89996001)(46102003)(87936001)(80022003)(76176999)(21056001)(104166001)(85852003)(76482002)(120916001)(95666004)(106466001)(62966002)(53416004)(50986999)(77096002)(107046002)(105586002)(68736004)(44976005)(19580405001)(50226001)(19580395003)(4396001)(93916002)(86362001)(575784001)(102836001)(33646002)(20776003)(101416001)(50466002)(92566001)(47776003)(64706001)(92726001)(48376002)(84676001)(85306004)(31966008);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When parameter DWC_USB3_LPM_ERRATA_ENABLE is enabled in Andvanced
Configuration of coreConsultant, it supports of xHCI BESL Errata Dated
10/19/2011 is enabled in host mode. In device mode it adds the capability
to send NYET response threshold based on the BESL value received in the LPM
token, and the threhold is configurable for each soc platform.

This patch adds an entry that soc platform is able to define the lpm
capacity with their own device tree or bus glue layer.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 16 +++++++++++++++-
 drivers/usb/dwc3/core.h          | 26 +++++++++++++++++---------
 drivers/usb/dwc3/gadget.c        | 13 +++++++++++++
 drivers/usb/dwc3/platform_data.h |  2 ++
 4 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index c320835..4f37a43 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -652,6 +652,7 @@ static int dwc3_probe(struct platform_device *pdev)
 	struct device_node	*node = dev->of_node;
 	struct resource		*res;
 	struct dwc3		*dwc;
+	u8			lpm_nyet_thres;
 
 	int			ret;
 
@@ -707,16 +708,27 @@ static int dwc3_probe(struct platform_device *pdev)
 	 */
 	res->start -= DWC3_GLOBALS_REGS_START;
 
+	/* default to highest possible threshold */
+	lpm_nyet_thres = 0xff;
+
 	if (node) {
 		dwc->maximum_speed = of_usb_get_maximum_speed(node);
+		dwc->has_lpm_erratum = of_property_read_bool(node,
+				"snps,has-lpm-erratum");
+		of_property_read_u8(node, "snps,lpm-nyet-thres",
+				&lpm_nyet_thres);
 
-		dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
+		dwc->needs_fifo_resize = of_property_read_bool(node,
+				"tx-fifo-resize");
 		dwc->dr_mode = of_usb_get_dr_mode(node);
 
 		dwc->disable_scramble_quirk = of_property_read_bool(node,
 				"snps,disable_scramble_quirk");
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
+		dwc->has_lpm_erratum = pdata->has_lpm_erratum;
+		if (pdata->lpm_nyet_thres)
+			lpm_nyet_thres = pdata->lpm_nyet_thres;
 
 		dwc->needs_fifo_resize = pdata->tx_fifo_resize;
 		dwc->dr_mode = pdata->dr_mode;
@@ -728,6 +740,8 @@ static int dwc3_probe(struct platform_device *pdev)
 	if (dwc->maximum_speed == USB_SPEED_UNKNOWN)
 		dwc->maximum_speed = USB_SPEED_SUPER;
 
+	dwc->lpm_nyet_thres = lpm_nyet_thres;
+
 	ret = dwc3_core_get_phy(dwc);
 	if (ret)
 		return ret;
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 56bada6..19d1ecb 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -246,16 +246,19 @@
 #define DWC3_DCTL_TRGTULST_SS_INACT	(DWC3_DCTL_TRGTULST(6))
 
 /* These apply for core versions 1.94a and later */
-#define DWC3_DCTL_KEEP_CONNECT	(1 << 19)
-#define DWC3_DCTL_L1_HIBER_EN	(1 << 18)
-#define DWC3_DCTL_CRS		(1 << 17)
-#define DWC3_DCTL_CSS		(1 << 16)
+#define DWC3_DCTL_LPM_ERRATA_MASK	DWC3_DCTL_LPM_ERRATA(0xf)
+#define DWC3_DCTL_LPM_ERRATA(n)		((n) << 20)
 
-#define DWC3_DCTL_INITU2ENA	(1 << 12)
-#define DWC3_DCTL_ACCEPTU2ENA	(1 << 11)
-#define DWC3_DCTL_INITU1ENA	(1 << 10)
-#define DWC3_DCTL_ACCEPTU1ENA	(1 << 9)
-#define DWC3_DCTL_TSTCTRL_MASK	(0xf << 1)
+#define DWC3_DCTL_KEEP_CONNECT		(1 << 19)
+#define DWC3_DCTL_L1_HIBER_EN		(1 << 18)
+#define DWC3_DCTL_CRS			(1 << 17)
+#define DWC3_DCTL_CSS			(1 << 16)
+
+#define DWC3_DCTL_INITU2ENA		(1 << 12)
+#define DWC3_DCTL_ACCEPTU2ENA		(1 << 11)
+#define DWC3_DCTL_INITU1ENA		(1 << 10)
+#define DWC3_DCTL_ACCEPTU1ENA		(1 << 9)
+#define DWC3_DCTL_TSTCTRL_MASK		(0xf << 1)
 
 #define DWC3_DCTL_ULSTCHNGREQ_MASK	(0x0f << 5)
 #define DWC3_DCTL_ULSTCHNGREQ(n) (((n) << 5) & DWC3_DCTL_ULSTCHNGREQ_MASK)
@@ -664,6 +667,9 @@ struct dwc3_scratchpad_array {
  * @ep0_bounced: true when we used bounce buffer
  * @ep0_expect_in: true when we expect a DATA IN transfer
  * @has_hibernation: true when dwc3 was configured with Hibernation
+ * @has_lpm_erratum: true when core was configured with LPM Erratum. Note that
+ *			there's now way for software to detect this in runtime.
+ * @lpm_nyet_thres: LPM NYET response threshold
  * @is_selfpowered: true when we are selfpowered
  * @is_fpga: true when we are using the FPGA board
  * @needs_fifo_resize: not all users might want fifo resizing, flag it
@@ -769,6 +775,8 @@ struct dwc3 {
 	unsigned		ep0_bounced:1;
 	unsigned		ep0_expect_in:1;
 	unsigned		has_hibernation:1;
+	unsigned		has_lpm_erratum:1;
+	unsigned		lpm_nyet_thres:4;
 	unsigned		is_selfpowered:1;
 	unsigned		is_fpga:1;
 	unsigned		needs_fifo_resize:1;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 7a64c2f..b918a65 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2297,6 +2297,19 @@ static void dwc3_gadget_conndone_interrupt(struct dwc3 *dwc)
 		 */
 		reg |= DWC3_DCTL_HIRD_THRES(12);
 
+		/*
+		 * When dwc3 revisions >= 2.40a, LPM Erratum is enabled and
+		 * DCFG.LPMCap is set, core responses with an ACK and the
+		 * BESL value in the LPM token is less than or equal to lPM
+		 * NYET threshold.
+		 */
+		WARN(dwc->revision < DWC3_REVISION_240A
+				&& dwc->has_lpm_erratum,
+				"LPM Erratum not available on dwc3 revisisions < 2.40a\n");
+
+		if (dwc->has_lpm_erratum)
+			reg |= DWC3_DCTL_LPM_ERRATA(dwc->lpm_nyet_thres);
+
 		dwc3_writel(dwc->regs, DWC3_DCTL, reg);
 	} else {
 		reg = dwc3_readl(dwc->regs, DWC3_DCTL);
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 9209d02..2e546ac 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -26,4 +26,6 @@ struct dwc3_platform_data {
 	bool tx_fifo_resize;
 
 	unsigned disable_scramble_quirk:1;
+	unsigned has_lpm_erratum:1;
+	unsigned lpm_nyet_thres:4;
 };
-- 
1.9.1

