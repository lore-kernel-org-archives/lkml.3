Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaJQJPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:15:30 -0400
Received: from [157.56.110.143] ([157.56.110.143]:46112 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751360AbaJQJP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:15:27 -0400
X-Greylist: delayed 962 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2014 05:15:26 EDT
X-WSS-ID: 0NDKZP0-08-TOJ-02
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
Subject: [PATCH v2 16/16] usb: dwc3: enable usb suspend phy
Date: Fri, 17 Oct 2014 16:53:41 +0800
Message-ID: <1413536021-4886-17-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(44976005)(48376002)(68736004)(77156001)(50986999)(19580405001)(80022003)(102836001)(84676001)(36756003)(101416001)(19580395003)(46102003)(76176999)(31966008)(85306004)(99396003)(33646002)(87936001)(87286001)(2171001)(62966002)(229853001)(50226001)(105586002)(107046002)(4396001)(104166001)(106466001)(95666004)(21056001)(77096002)(53416004)(76482002)(120916001)(97736003)(93916002)(575784001)(92566001)(50466002)(47776003)(88136002)(85852003)(20776003)(92726001)(89996001)(86362001)(64706001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0367A50BB1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD NL needs to suspend usb3 ss phy, but this doesn't enable on simulation
board.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 7 ++++++-
 drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
 drivers/usb/dwc3/platform_data.h | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 3ccfe41..4a98696 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -395,6 +395,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	if (dwc->quirks & DWC3_QUIRK_TX_DEEPH)
 		reg |= DWC3_GUSB3PIPECTL_TX_DEEPH(1);
 
+	if (dwc->quirks & DWC3_QUIRK_SUSPHY)
+		reg |= DWC3_GUSB3PIPECTL_SUSPHY;
+
 	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
 
 	mdelay(100);
@@ -496,8 +499,10 @@ static int dwc3_core_init(struct dwc3 *dwc)
 		dwc->is_fpga = true;
 	}
 
-	if ((dwc->quirks & DWC3_QUIRK_AMD_NL) && dwc->is_fpga)
+	if ((dwc->quirks & DWC3_QUIRK_AMD_NL) && dwc->is_fpga) {
 		dwc->quirks |= DWC3_QUIRK_DISSCRAMBLE;
+		dwc->quirks &= ~DWC3_QUIRK_SUSPHY;
+	}
 
 	if (dwc->quirks & DWC3_QUIRK_DISSCRAMBLE)
 		reg |= DWC3_GCTL_DISSCRAMBLE;
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 146eb2f..71401a3 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -157,7 +157,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 			| DWC3_QUIRK_DEPOCHANGE
 			| DWC3_QUIRK_LFPSFILT
 			| DWC3_QUIRK_RX_DETOPOLL
-			| DWC3_QUIRK_TX_DEEPH;
+			| DWC3_QUIRK_TX_DEEPH
+			| DWC3_QUIRK_SUSPHY;
 	}
 
 	ret = platform_device_add_resources(dwc3, res, ARRAY_SIZE(res));
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 54f0e45..f68cd97 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -38,5 +38,6 @@ struct dwc3_platform_data {
 #define DWC3_QUIRK_LFPSFILT		(1 << 7)
 #define DWC3_QUIRK_RX_DETOPOLL		(1 << 8)
 #define DWC3_QUIRK_TX_DEEPH		(1 << 9)
+#define DWC3_QUIRK_SUSPHY		(1 << 10)
 
 };
-- 
1.9.1

