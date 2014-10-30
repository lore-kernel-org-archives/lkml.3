Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128AbaJ3KLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:11:53 -0400
Received: from mail-by2on0140.outbound.protection.outlook.com ([207.46.100.140]:12778
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934002AbaJ3KLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:11:49 -0400
X-WSS-ID: 0NE95NK-07-XVO-02
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
Subject: [PATCH v4 20/20] usb: dwc3: make HIRD threshold configurable
Date: Thu, 30 Oct 2014 18:08:45 +0800
Message-ID: <1414663725-2195-21-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(21056001)(80022003)(46102003)(76176999)(50986999)(84676001)(19580405001)(19580395003)(68736004)(44976005)(50226001)(97736003)(95666004)(105586002)(4396001)(106466001)(33646002)(107046002)(229853001)(77096002)(87286001)(76482002)(2171001)(48376002)(87936001)(85852003)(89996001)(88136002)(85306004)(77156001)(31966008)(62966002)(120916001)(36756003)(50466002)(99396003)(53416004)(101416001)(102836001)(104166001)(47776003)(20776003)(93916002)(86362001)(575784001)(92566001)(92726001)(64706001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB206;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HIRD threshold should be configurable by different platforms.

>From DesignWare databook:
When HIRD_Threshold[4] is set to 1b1 and HIRD value is greater than or
equal to the value in HIRD_Threshold[3:0], dwc3 asserts output signals
utmi_l1_suspend_n to put PHY into Deep Low-Power mode in L1.

When HIRD_Threshold[4] is set to 1b0 or the HIRD value is less than
HIRD_Threshold[3:0], dwc3 asserts output signals utmi_sleep_n on L1.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 Documentation/devicetree/bindings/usb/dwc3.txt |  3 +++
 drivers/usb/dwc3/core.c                        | 17 +++++++++++++++++
 drivers/usb/dwc3/core.h                        |  6 ++++++
 drivers/usb/dwc3/gadget.c                      |  6 +-----
 drivers/usb/dwc3/platform_data.h               |  3 +++
 5 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
index feaf2c8..5b99755 100644
--- a/Documentation/devicetree/bindings/usb/dwc3.txt
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -34,6 +34,9 @@ Optional properties:
 			LTSSM during USB3 Compliance mode.
  - snps,dis_u3_susphy_quirk: when set core will disable USB3 suspend phy.
  - snps,dis_u2_susphy_quirk: when set core will disable USB2 suspend phy.
+ - snps,is-utmi-l1-suspend: true when DWC3 asserts output signal
+			utmi_l1_suspend_n, false when asserts utmi_sleep_n
+ - snps,hird-threshold: HIRD threshold
 
 This is usually a subnode to DWC3 glue to which it is connected.
 
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index a28ed1c..f4172ab 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -729,6 +729,7 @@ static int dwc3_probe(struct platform_device *pdev)
 	struct dwc3		*dwc;
 	u8			lpm_nyet_threshold;
 	u8			tx_de_emphasis;
+	u8			hird_threshold;
 
 	int			ret;
 
@@ -790,12 +791,22 @@ static int dwc3_probe(struct platform_device *pdev)
 	/* default to -3.5dB de-emphasis */
 	tx_de_emphasis = 1;
 
+	/*
+	 * defalut to assert utmi_sleep_n and use maximum allowed HIRD
+	 * threshold value of 0b1100
+	 */
+	hird_threshold = 12;
+
 	if (node) {
 		dwc->maximum_speed = of_usb_get_maximum_speed(node);
 		dwc->has_lpm_erratum = of_property_read_bool(node,
 				"snps,has-lpm-erratum");
 		of_property_read_u8(node, "snps,lpm-nyet-threshold",
 				&lpm_nyet_threshold);
+		dwc->is_utmi_l1_suspend = of_property_read_bool(node,
+				"snps,is-utmi-l1-suspend");
+		of_property_read_u8(node, "snps,hird-threshold",
+				&hird_threshold);
 
 		dwc->needs_fifo_resize = of_property_read_bool(node,
 				"tx-fifo-resize");
@@ -831,6 +842,9 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->has_lpm_erratum = pdata->has_lpm_erratum;
 		if (pdata->lpm_nyet_threshold)
 			lpm_nyet_threshold = pdata->lpm_nyet_threshold;
+		dwc->is_utmi_l1_suspend = pdata->is_utmi_l1_suspend;
+		if (pdata->hird_threshold)
+			hird_threshold = pdata->hird_threshold;
 
 		dwc->needs_fifo_resize = pdata->tx_fifo_resize;
 		dwc->dr_mode = pdata->dr_mode;
@@ -858,6 +872,9 @@ static int dwc3_probe(struct platform_device *pdev)
 	dwc->lpm_nyet_threshold = lpm_nyet_threshold;
 	dwc->tx_de_emphasis = tx_de_emphasis;
 
+	dwc->hird_threshold = hird_threshold
+		| (dwc->is_utmi_l1_suspend << 4);
+
 	ret = dwc3_core_get_phy(dwc);
 	if (ret)
 		return ret;
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 8b6c308..2c90139 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -675,12 +675,16 @@ struct dwc3_scratchpad_array {
  * @test_mode: true when we're entering a USB test mode
  * @test_mode_nr: test feature selector
  * @lpm_nyet_threshold: LPM NYET response threshold
+ * @hird_threshold: HIRD threshold
  * @delayed_status: true when gadget driver asks for delayed status
  * @ep0_bounced: true when we used bounce buffer
  * @ep0_expect_in: true when we expect a DATA IN transfer
  * @has_hibernation: true when dwc3 was configured with Hibernation
  * @has_lpm_erratum: true when core was configured with LPM Erratum. Note that
  *			there's now way for software to detect this in runtime.
+ * @is_utmi_l1_suspend: the core asserts output signal
+ * 	0	- utmi_sleep_n
+ * 	1	- utmi_l1_suspend_n
  * @is_selfpowered: true when we are selfpowered
  * @is_fpga: true when we are using the FPGA board
  * @needs_fifo_resize: not all users might want fifo resizing, flag it
@@ -797,12 +801,14 @@ struct dwc3 {
 	u8			test_mode;
 	u8			test_mode_nr;
 	u8			lpm_nyet_threshold;
+	u8			hird_threshold;
 
 	unsigned		delayed_status:1;
 	unsigned		ep0_bounced:1;
 	unsigned		ep0_expect_in:1;
 	unsigned		has_hibernation:1;
 	unsigned		has_lpm_erratum:1;
+	unsigned		is_utmi_l1_suspend:1;
 	unsigned		is_selfpowered:1;
 	unsigned		is_fpga:1;
 	unsigned		needs_fifo_resize:1;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 2c0d19a4..303bb67 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2291,11 +2291,7 @@ static void dwc3_gadget_conndone_interrupt(struct dwc3 *dwc)
 		reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 		reg &= ~(DWC3_DCTL_HIRD_THRES_MASK | DWC3_DCTL_L1_HIBER_EN);
 
-		/*
-		 * TODO: This should be configurable. For now using
-		 * maximum allowed HIRD threshold value of 0b1100
-		 */
-		reg |= DWC3_DCTL_HIRD_THRES(12);
+		reg |= DWC3_DCTL_HIRD_THRES(dwc->hird_threshold);
 
 		/*
 		 * When dwc3 revisions >= 2.40a, LPM Erratum is enabled and
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 245300b..a3a3b6d 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -25,6 +25,9 @@ struct dwc3_platform_data {
 	enum usb_dr_mode dr_mode;
 	bool tx_fifo_resize;
 
+	unsigned is_utmi_l1_suspend:1;
+	u8 hird_threshold;
+
 	u8 lpm_nyet_threshold;
 
 	unsigned disable_scramble_quirk:1;
-- 
1.9.1

