Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaJQJPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:15:45 -0400
Received: from mail-bn1bon0117.outbound.protection.outlook.com ([157.56.111.117]:1484
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752972AbaJQJPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:15:41 -0400
X-WSS-ID: 0NDKZNW-07-HNT-02
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
Subject: [PATCH v2 09/16] usb: dwc3: add P3 in U2 SS inactive quirk
Date: Fri, 17 Oct 2014 16:53:34 +0800
Message-ID: <1413536021-4886-10-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(68736004)(105586002)(575784001)(93916002)(229853001)(106466001)(36756003)(4396001)(77096002)(50226001)(87286001)(84676001)(89996001)(87936001)(95666004)(107046002)(102836001)(19580405001)(77156001)(92726001)(64706001)(88136002)(76482002)(2171001)(31966008)(85852003)(20776003)(47776003)(53416004)(19580395003)(104166001)(33646002)(48376002)(50466002)(46102003)(80022003)(120916001)(76176999)(50986999)(99396003)(44976005)(92566001)(62966002)(21056001)(97736003)(85306004)(86362001)(101416001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0367A50BB1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD NL needs to enable P3 OK for U2/SSInactive on USB3PIPE register.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 20 ++++++++++++++++++++
 drivers/usb/dwc3/core.h          |  1 +
 drivers/usb/dwc3/dwc3-pci.c      |  3 ++-
 drivers/usb/dwc3/platform_data.h |  1 +
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 7322d85..9d0a249 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -365,6 +365,24 @@ static void dwc3_cache_hwparams(struct dwc3 *dwc)
 }
 
 /**
+ * dwc3_phy_setup - Configure USB3 PHY Interface of DWC3 Core
+ * @dwc: Pointer to our controller context structure
+ */
+static void dwc3_phy_setup(struct dwc3 *dwc)
+{
+	u32 reg;
+
+	reg = dwc3_readl(dwc->regs, DWC3_GUSB3PIPECTL(0));
+
+	if (dwc->quirks & DWC3_QUIRK_U2SSINP3OK)
+		reg |= DWC3_GUSB3PIPECTL_U2SSINP3OK;
+
+	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
+
+	mdelay(100);
+}
+
+/**
  * dwc3_core_init - Low-level initialization of DWC3 Core
  * @dwc: Pointer to our controller context structure
  *
@@ -484,6 +502,8 @@ static int dwc3_core_init(struct dwc3 *dwc)
 
 	dwc3_writel(dwc->regs, DWC3_GCTL, reg);
 
+	dwc3_phy_setup(dwc);
+
 	ret = dwc3_alloc_scratch_buffers(dwc);
 	if (ret)
 		goto err1;
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 3d27f10..71cb255 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -176,6 +176,7 @@
 
 /* Global USB3 PIPE Control Register */
 #define DWC3_GUSB3PIPECTL_PHYSOFTRST	(1 << 31)
+#define DWC3_GUSB3PIPECTL_U2SSINP3OK	(1 << 29)
 #define DWC3_GUSB3PIPECTL_SUSPHY	(1 << 17)
 
 /* Global TX Fifo Size Register */
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index cdb9b04..1235eb3 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -150,7 +150,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 			PCI_DEVICE_ID_AMD_NL) {
 		dwc3_pdata.has_lpm_erratum = true;
 		dwc3_pdata.quirks |= DWC3_QUIRK_AMD_NL
-			| DWC3_QUIRK_U2EXIT_LFPS;
+			| DWC3_QUIRK_U2EXIT_LFPS
+			| DWC3_QUIRK_U2SSINP3OK;
 	}
 
 	ret = platform_device_add_resources(dwc3, res, ARRAY_SIZE(res));
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index a6463c0..ad03563 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -31,5 +31,6 @@ struct dwc3_platform_data {
 #define DWC3_QUIRK_AMD_NL		(1 << 0)
 #define DWC3_QUIRK_DISSCRAMBLE		(1 << 1)
 #define DWC3_QUIRK_U2EXIT_LFPS		(1 << 2)
+#define DWC3_QUIRK_U2SSINP3OK		(1 << 3)
 
 };
-- 
1.9.1

