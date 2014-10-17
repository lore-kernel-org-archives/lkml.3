Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaJQJO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:14:29 -0400
Received: from mail-bn1bbn0105.outbound.protection.outlook.com ([157.56.111.105]:32800
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752031AbaJQJOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:14:25 -0400
X-Greylist: delayed 879 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2014 05:14:25 EDT
X-WSS-ID: 0NDKZNG-07-HNK-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH v2 06/16] usb: dwc3: add disscramble quirk
Date: Fri, 17 Oct 2014 16:53:31 +0800
Message-ID: <1413536021-4886-7-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(428002)(199003)(189002)(85852003)(87936001)(89996001)(2171001)(87286001)(93916002)(86362001)(575784001)(92566001)(92726001)(53416004)(88136002)(50986999)(76176999)(77156001)(62966002)(36756003)(31966008)(95666004)(64706001)(77096002)(48376002)(105586002)(85306004)(107046002)(20776003)(21056001)(47776003)(97736003)(229853001)(99396003)(68736004)(19580405001)(19580395003)(101416001)(44976005)(106466001)(84676001)(102836001)(4396001)(104166001)(76482002)(120916001)(50226001)(46102003)(50466002)(80022003)(33646002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp01.amd.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0367A50BB1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD NL fpga needs to enable disscramble quirk. And this quirk doesn't need on
the true soc.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 8 +++++++-
 drivers/usb/dwc3/dwc3-pci.c      | 5 +++++
 drivers/usb/dwc3/platform_data.h | 4 ++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 50c0eae..819e501 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -422,7 +422,6 @@ static int dwc3_core_init(struct dwc3 *dwc)
 
 	reg = dwc3_readl(dwc->regs, DWC3_GCTL);
 	reg &= ~DWC3_GCTL_SCALEDOWN_MASK;
-	reg &= ~DWC3_GCTL_DISSCRAMBLE;
 
 	switch (DWC3_GHWPARAMS1_EN_PWROPT(dwc->hwparams.hwparams1)) {
 	case DWC3_GHWPARAMS1_EN_PWROPT_CLK:
@@ -461,6 +460,13 @@ static int dwc3_core_init(struct dwc3 *dwc)
 		dwc->is_fpga = true;
 	}
 
+	if ((dwc->quirks & DWC3_QUIRK_AMD_NL) && dwc->is_fpga)
+		dwc->quirks |= DWC3_QUIRK_DISSCRAMBLE;
+
+	if (dwc->quirks & DWC3_QUIRK_DISSCRAMBLE)
+		reg |= DWC3_GCTL_DISSCRAMBLE;
+	else
+		reg &= ~DWC3_GCTL_DISSCRAMBLE;
 	/*
 	 * WORKAROUND: DWC3 revisions <1.90a have a bug
 	 * where the device can fail to connect at SuperSpeed
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 18569a4..a89db6c 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -146,6 +146,11 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 	res[1].name	= "dwc_usb3";
 	res[1].flags	= IORESOURCE_IRQ;
 
+	if (pci->vendor == PCI_VENDOR_ID_AMD && pci->device ==
+			PCI_DEVICE_ID_AMD_NL) {
+		dwc3_pdata.quirks |= DWC3_QUIRK_AMD_NL;
+	}
+
 	ret = platform_device_add_resources(dwc3, res, ARRAY_SIZE(res));
 	if (ret) {
 		dev_err(dev, "couldn't add resources to dwc3 device\n");
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 1d3d65f..9c5f074 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -26,4 +26,8 @@ struct dwc3_platform_data {
 	bool tx_fifo_resize;
 
 	u32     quirks;
+
+#define DWC3_QUIRK_AMD_NL		(1 << 0)
+#define DWC3_QUIRK_DISSCRAMBLE		(1 << 1)
+
 };
-- 
1.9.1

