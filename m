Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaJQJOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:14:00 -0400
Received: from mail-bl2on0134.outbound.protection.outlook.com ([65.55.169.134]:29568
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751815AbaJQJN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:13:57 -0400
X-WSS-ID: 0NDKZN6-07-HN4-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH v2 04/16] usb: dwc3: add a flag to check if it is fpga board
Date: Fri, 17 Oct 2014 16:53:29 +0800
Message-ID: <1413536021-4886-5-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(31966008)(15975445006)(89996001)(97736003)(50986999)(99396003)(80022003)(21056001)(15202345003)(20776003)(47776003)(64706001)(53416004)(88136002)(102836001)(68736004)(87286001)(84676001)(46102003)(87936001)(15395725005)(50466002)(44976005)(85306004)(19580395003)(19580405001)(85852003)(575784001)(93916002)(86362001)(229853001)(77156001)(106466001)(92566001)(36756003)(120916001)(76482002)(95666004)(2171001)(33646002)(62966002)(101416001)(50226001)(4396001)(92726001)(76176999)(104166001)(77096002)(48376002)(105586002)(107046002)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0367A50BB1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some chip vendor is on pre-silicon phase, which needs to use the simulation
board. It should have the same product and vendor id with the true soc, but
might have some minor different configurations.

Below thread discussion proposes to find a method to distinguish between
simulation board and soc.

http://marc.info/?l=linux-usb&m=141194772206369&w=2

In Andvanced Configuration of coreConsultant, there is the parameter of
DWC_USB_EN_FPGA. This bit has the function we need. And it would response as 7
bit of GHWPARAMS6 register. So it's able to check this functional bit to confirm
if works on FPGA board.

Reported-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c | 6 ++++++
 drivers/usb/dwc3/core.h | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index bf77509..ddac372 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -455,6 +455,12 @@ static int dwc3_core_init(struct dwc3 *dwc)
 		dev_dbg(dwc->dev, "No power optimization available\n");
 	}
 
+	/* check if current dwc3 is on simulation board */
+	if (dwc->hwparams.hwparams6 & DWC3_GHWPARAMS6_EN_FPGA) {
+		dev_dbg(dwc->dev, "it is on FPGA board\n");
+		dwc->is_fpga = true;
+	}
+
 	/*
 	 * WORKAROUND: DWC3 revisions <1.90a have a bug
 	 * where the device can fail to connect at SuperSpeed
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index a715ee1..f6ee623 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -210,6 +210,9 @@
 #define DWC3_GHWPARAMS4_HIBER_SCRATCHBUFS(n)	(((n) & (0x0f << 13)) >> 13)
 #define DWC3_MAX_HIBER_SCRATCHBUFS		15
 
+/* Global HWPARAMS6 Register */
+#define DWC3_GHWPARAMS6_EN_FPGA			(1 << 7)
+
 /* Device Configuration Register */
 #define DWC3_DCFG_DEVADDR(addr)	((addr) << 3)
 #define DWC3_DCFG_DEVADDR_MASK	DWC3_DCFG_DEVADDR(0x7f)
@@ -662,6 +665,7 @@ struct dwc3_scratchpad_array {
  * @ep0_expect_in: true when we expect a DATA IN transfer
  * @has_hibernation: true when dwc3 was configured with Hibernation
  * @is_selfpowered: true when we are selfpowered
+ * @is_fpga: true when we are using the FPGA board
  * @needs_fifo_resize: not all users might want fifo resizing, flag it
  * @pullups_connected: true when Run/Stop bit is set
  * @resize_fifos: tells us it's ok to reconfigure our TxFIFO sizes.
@@ -765,6 +769,7 @@ struct dwc3 {
 	unsigned		ep0_expect_in:1;
 	unsigned		has_hibernation:1;
 	unsigned		is_selfpowered:1;
+	unsigned		is_fpga:1;
 	unsigned		needs_fifo_resize:1;
 	unsigned		pullups_connected:1;
 	unsigned		resize_fifos:1;
-- 
1.9.1

