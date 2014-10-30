Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbaJ3KKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:10:39 -0400
Received: from mail-bn1bon0115.outbound.protection.outlook.com ([157.56.111.115]:46208
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758262AbaJ3KKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:10:34 -0400
X-WSS-ID: 0NE95LD-08-I9I-02
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
Subject: [PATCH v4 05/20] usb: dwc3: add lpm erratum support
Date: Thu, 30 Oct 2014 18:08:30 +0800
Message-ID: <1414663725-2195-6-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(479174003)(199003)(4396001)(85306004)(86362001)(46102003)(80022003)(575784001)(50226001)(102836001)(93916002)(229853001)(107046002)(31966008)(33646002)(62966002)(77096002)(53416004)(92726001)(48376002)(101416001)(64706001)(47776003)(20776003)(50466002)(104166001)(92566001)(105586002)(87936001)(50986999)(2171001)(36756003)(77156001)(76482002)(106466001)(99396003)(120916001)(21056001)(68736004)(76176999)(89996001)(85852003)(97736003)(95666004)(88136002)(84676001)(87286001)(44976005)(19580395003)(19580405001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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

When parameter DWC_USB3_LPM_ERRATA_ENABLE is enabled in Advanced
Configuration of coreConsultant, support of xHCI BESL Errata Dated
10/19/2011 is enabled in host mode. In device mode it adds the capability
to send NYET response threshold based on the BESL value received in the LPM
token, and the threshold is configurable for each SoC platform.

This patch adds an entry that soc platform is able to define the lpm
capacity with their own device tree or bus glue layer.

[ balbi@ti.com : added devicetree documentation, spelled threshold
		completely, made sure threshold is only applied to
		proper core revisions. ]

Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 Documentation/devicetree/bindings/usb/dwc3.txt |  2 ++
 drivers/usb/dwc3/core.c                        | 16 +++++++++++++++-
 drivers/usb/dwc3/core.h                        | 26 +++++++++++++++++---------
 drivers/usb/dwc3/gadget.c                      | 13 +++++++++++++
 drivers/usb/dwc3/platform_data.h               |  3 +++
 5 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
index 8ec2256..2b0c1f2 100644
--- a/Documentation/devicetree/bindings/usb/dwc3.txt
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -16,6 +16,8 @@ Optional properties:
  - tx-fifo-resize: determines if the FIFO *has* to be reallocated.
  - snps,disable_scramble_quirk: true when SW should disable data scrambling.
 	Only really useful for FPGA builds.
+ - snps,has-lpm-erratum: true when DWC3 was configured with LPM Erratum enabled
+ - snps,lpm-nyet-threshold: LPM NYET threshold
 
 This is usually a subnode to DWC3 glue to which it is connected.
 
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index fae095f..2ac96e4 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -654,6 +654,7 @@ static int dwc3_probe(struct platform_device *pdev)
 	struct device_node	*node = dev->of_node;
 	struct resource		*res;
 	struct dwc3		*dwc;
+	u8			lpm_nyet_threshold;
 
 	int			ret;
 
@@ -709,16 +710,27 @@ static int dwc3_probe(struct platform_device *pdev)
 	 */
 	res->start -= DWC3_GLOBALS_REGS_START;
 
+	/* default to highest possible threshold */
+	lpm_nyet_threshold = 0xff;
+
 	if (node) {
 		dwc->maximum_speed = of_usb_get_maximum_speed(node);
+		dwc->has_lpm_erratum = of_property_read_bool(node,
+				"snps,has-lpm-erratum");
+		of_property_read_u8(node, "snps,lpm-nyet-threshold",
+				&lpm_nyet_threshold);
 
-		dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
+		dwc->needs_fifo_resize = of_property_read_bool(node,
+				"tx-fifo-resize");
 		dwc->dr_mode = of_usb_get_dr_mode(node);
 
 		dwc->disable_scramble_quirk = of_property_read_bool(node,
 				"snps,disable_scramble_quirk");
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
+		dwc->has_lpm_erratum = pdata->has_lpm_erratum;
+		if (pdata->lpm_nyet_threshold)
+			lpm_nyet_threshold = pdata->lpm_nyet_threshold;
 
 		dwc->needs_fifo_resize = pdata->tx_fifo_resize;
 		dwc->dr_mode = pdata->dr_mode;
@@ -730,6 +742,8 @@ static int dwc3_probe(struct platform_device *pdev)
 	if (dwc->maximum_speed == USB_SPEED_UNKNOWN)
 		dwc->maximum_speed = USB_SPEED_SUPER;
 
+	dwc->lpm_nyet_threshold = lpm_nyet_threshold;
+
 	ret = dwc3_core_get_phy(dwc);
 	if (ret)
 		return ret;
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 56bada6..34f1e08 100644
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
@@ -660,10 +663,13 @@ struct dwc3_scratchpad_array {
  * @regset: debugfs pointer to regdump file
  * @test_mode: true when we're entering a USB test mode
  * @test_mode_nr: test feature selector
+ * @lpm_nyet_threshold: LPM NYET response threshold
  * @delayed_status: true when gadget driver asks for delayed status
  * @ep0_bounced: true when we used bounce buffer
  * @ep0_expect_in: true when we expect a DATA IN transfer
  * @has_hibernation: true when dwc3 was configured with Hibernation
+ * @has_lpm_erratum: true when core was configured with LPM Erratum. Note that
+ *			there's now way for software to detect this in runtime.
  * @is_selfpowered: true when we are selfpowered
  * @is_fpga: true when we are using the FPGA board
  * @needs_fifo_resize: not all users might want fifo resizing, flag it
@@ -764,11 +770,13 @@ struct dwc3 {
 
 	u8			test_mode;
 	u8			test_mode_nr;
+	u8			lpm_nyet_threshold;
 
 	unsigned		delayed_status:1;
 	unsigned		ep0_bounced:1;
 	unsigned		ep0_expect_in:1;
 	unsigned		has_hibernation:1;
+	unsigned		has_lpm_erratum:1;
 	unsigned		is_selfpowered:1;
 	unsigned		is_fpga:1;
 	unsigned		needs_fifo_resize:1;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 7a64c2f..2c0d19a4 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2297,6 +2297,19 @@ static void dwc3_gadget_conndone_interrupt(struct dwc3 *dwc)
 		 */
 		reg |= DWC3_DCTL_HIRD_THRES(12);
 
+		/*
+		 * When dwc3 revisions >= 2.40a, LPM Erratum is enabled and
+		 * DCFG.LPMCap is set, core responses with an ACK and the
+		 * BESL value in the LPM token is less than or equal to LPM
+		 * NYET threshold.
+		 */
+		WARN_ONCE(dwc->revision < DWC3_REVISION_240A
+				&& dwc->has_lpm_erratum,
+				"LPM Erratum not available on dwc3 revisisions < 2.40a\n");
+
+		if (dwc->has_lpm_erratum && dwc->revision >= DWC3_REVISION_240A)
+			reg |= DWC3_DCTL_LPM_ERRATA(dwc->lpm_nyet_threshold);
+
 		dwc3_writel(dwc->regs, DWC3_DCTL, reg);
 	} else {
 		reg = dwc3_readl(dwc->regs, DWC3_DCTL);
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 9209d02..e128308 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -25,5 +25,8 @@ struct dwc3_platform_data {
 	enum usb_dr_mode dr_mode;
 	bool tx_fifo_resize;
 
+	u8 lpm_nyet_threshold;
+
 	unsigned disable_scramble_quirk:1;
+	unsigned has_lpm_erratum:1;
 };
-- 
1.9.1

