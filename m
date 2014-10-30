Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192AbaJ3KSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:18:01 -0400
Received: from mail-bl2on0137.outbound.protection.outlook.com ([65.55.169.137]:27680
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758835AbaJ3KK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:10:28 -0400
X-WSS-ID: 0NE95L8-07-XT4-02
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
Subject: [PATCH v4 04/20] usb: dwc3: add disable scramble quirk
Date: Thu, 30 Oct 2014 18:08:29 +0800
Message-ID: <1414663725-2195-5-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(86362001)(93916002)(46102003)(80022003)(92566001)(92726001)(50466002)(48376002)(87286001)(62966002)(44976005)(19580405001)(84676001)(85852003)(21056001)(19580395003)(88136002)(87936001)(2171001)(89996001)(68736004)(76482002)(33646002)(76176999)(50986999)(85306004)(97736003)(101416001)(120916001)(31966008)(99396003)(102836001)(53416004)(105586002)(106466001)(77156001)(229853001)(95666004)(107046002)(104166001)(20776003)(4396001)(47776003)(50226001)(64706001)(36756003)(77096002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB198;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds disable scramble quirk, and it only needs to be enabled at
FPGA board on some vendor platforms.

[Note] In DesignWare databook, HW designer describes:
disscramble = disable scramble

Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 Documentation/devicetree/bindings/usb/dwc3.txt |  2 ++
 drivers/usb/dwc3/core.c                        | 11 ++++++++++-
 drivers/usb/dwc3/core.h                        |  3 +++
 drivers/usb/dwc3/platform_data.h               |  2 ++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
index 471366d..8ec2256 100644
--- a/Documentation/devicetree/bindings/usb/dwc3.txt
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -14,6 +14,8 @@ Optional properties:
  - phys: from the *Generic PHY* bindings
  - phy-names: from the *Generic PHY* bindings
  - tx-fifo-resize: determines if the FIFO *has* to be reallocated.
+ - snps,disable_scramble_quirk: true when SW should disable data scrambling.
+	Only really useful for FPGA builds.
 
 This is usually a subnode to DWC3 glue to which it is connected.
 
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index c8ae098..fae095f 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -422,7 +422,6 @@ static int dwc3_core_init(struct dwc3 *dwc)
 
 	reg = dwc3_readl(dwc->regs, DWC3_GCTL);
 	reg &= ~DWC3_GCTL_SCALEDOWN_MASK;
-	reg &= ~DWC3_GCTL_DISSCRAMBLE;
 
 	switch (DWC3_GHWPARAMS1_EN_PWROPT(dwc->hwparams.hwparams1)) {
 	case DWC3_GHWPARAMS1_EN_PWROPT_CLK:
@@ -466,6 +465,11 @@ static int dwc3_core_init(struct dwc3 *dwc)
 		dwc->is_fpga = true;
 	}
 
+	if (dwc->disable_scramble_quirk && dwc->is_fpga)
+		reg |= DWC3_GCTL_DISSCRAMBLE;
+	else
+		reg &= ~DWC3_GCTL_DISSCRAMBLE;
+
 	/*
 	 * WORKAROUND: DWC3 revisions <1.90a have a bug
 	 * where the device can fail to connect at SuperSpeed
@@ -710,11 +714,16 @@ static int dwc3_probe(struct platform_device *pdev)
 
 		dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
 		dwc->dr_mode = of_usb_get_dr_mode(node);
+
+		dwc->disable_scramble_quirk = of_property_read_bool(node,
+				"snps,disable_scramble_quirk");
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
 
 		dwc->needs_fifo_resize = pdata->tx_fifo_resize;
 		dwc->dr_mode = pdata->dr_mode;
+
+		dwc->disable_scramble_quirk = pdata->disable_scramble_quirk;
 	}
 
 	/* default to superspeed if no maximum_speed passed */
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index f6ee623..56bada6 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -672,6 +672,7 @@ struct dwc3_scratchpad_array {
  * @setup_packet_pending: true when there's a Setup Packet in FIFO. Workaround
  * @start_config_issued: true when StartConfig command has been issued
  * @three_stage_setup: set if we perform a three phase setup
+ * @disable_scramble_quirk: set if we enable the disable scramble quirk
  */
 struct dwc3 {
 	struct usb_ctrlrequest	*ctrl_req;
@@ -776,6 +777,8 @@ struct dwc3 {
 	unsigned		setup_packet_pending:1;
 	unsigned		start_config_issued:1;
 	unsigned		three_stage_setup:1;
+
+	unsigned		disable_scramble_quirk:1;
 };
 
 /* -------------------------------------------------------------------------- */
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 7db34f0..9209d02 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -24,4 +24,6 @@ struct dwc3_platform_data {
 	enum usb_device_speed maximum_speed;
 	enum usb_dr_mode dr_mode;
 	bool tx_fifo_resize;
+
+	unsigned disable_scramble_quirk:1;
 };
-- 
1.9.1

