Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaJQJSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:18:35 -0400
Received: from mail-bl2on0104.outbound.protection.outlook.com ([65.55.169.104]:18464
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752148AbaJQJO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:14:27 -0400
X-WSS-ID: 0NDKZNZ-08-TN9-02
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
Subject: [PATCH v2 10/16] usb: dwc3: add request p1p2p3 quirk
Date: Fri, 17 Oct 2014 16:53:35 +0800
Message-ID: <1413536021-4886-11-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(104166001)(101416001)(89996001)(102836001)(64706001)(77096002)(92726001)(85852003)(105586002)(19580395003)(19580405001)(2171001)(84676001)(48376002)(87286001)(88136002)(68736004)(87936001)(44976005)(50466002)(31966008)(93916002)(85306004)(99396003)(47776003)(86362001)(92566001)(575784001)(95666004)(33646002)(21056001)(107046002)(229853001)(77156001)(62966002)(120916001)(76176999)(20776003)(76482002)(106466001)(36756003)(97736003)(4396001)(80022003)(46102003)(50226001)(53416004)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0367A50BB1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD NL needs to enable always request P1/P2/P3 for U1/U2/U3 for AMD own phy.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 3 +++
 drivers/usb/dwc3/core.h          | 1 +
 drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
 drivers/usb/dwc3/platform_data.h | 1 +
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 9d0a249..ec8b667 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -377,6 +377,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	if (dwc->quirks & DWC3_QUIRK_U2SSINP3OK)
 		reg |= DWC3_GUSB3PIPECTL_U2SSINP3OK;
 
+	if (dwc->quirks & DWC3_QUIRK_REQP1P2P3)
+		reg |= DWC3_GUSB3PIPECTL_REQP1P2P3;
+
 	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
 
 	mdelay(100);
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 71cb255..8f47ade18 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -177,6 +177,7 @@
 /* Global USB3 PIPE Control Register */
 #define DWC3_GUSB3PIPECTL_PHYSOFTRST	(1 << 31)
 #define DWC3_GUSB3PIPECTL_U2SSINP3OK	(1 << 29)
+#define DWC3_GUSB3PIPECTL_REQP1P2P3	(1 << 24)
 #define DWC3_GUSB3PIPECTL_SUSPHY	(1 << 17)
 
 /* Global TX Fifo Size Register */
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 1235eb3..7154d18 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -151,7 +151,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 		dwc3_pdata.has_lpm_erratum = true;
 		dwc3_pdata.quirks |= DWC3_QUIRK_AMD_NL
 			| DWC3_QUIRK_U2EXIT_LFPS
-			| DWC3_QUIRK_U2SSINP3OK;
+			| DWC3_QUIRK_U2SSINP3OK
+			| DWC3_QUIRK_REQP1P2P3;
 	}
 
 	ret = platform_device_add_resources(dwc3, res, ARRAY_SIZE(res));
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index ad03563..850883f 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -32,5 +32,6 @@ struct dwc3_platform_data {
 #define DWC3_QUIRK_DISSCRAMBLE		(1 << 1)
 #define DWC3_QUIRK_U2EXIT_LFPS		(1 << 2)
 #define DWC3_QUIRK_U2SSINP3OK		(1 << 3)
+#define DWC3_QUIRK_REQP1P2P3		(1 << 4)
 
 };
-- 
1.9.1

