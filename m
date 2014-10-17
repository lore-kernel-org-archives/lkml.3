Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaJQJPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:15:38 -0400
Received: from [65.55.169.139] ([65.55.169.139]:51385 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751289AbaJQJPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:15:33 -0400
X-WSS-ID: 0NDKZO8-07-HO1-02
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
Subject: [PATCH v2 11/16] usb: dwc3: add delay p1p2p3 quirk
Date: Fri, 17 Oct 2014 16:53:36 +0800
Message-ID: <1413536021-4886-12-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(97736003)(50226001)(76176999)(102836001)(53416004)(92726001)(86362001)(44976005)(62966002)(31966008)(20776003)(68736004)(101416001)(19580405001)(19580395003)(47776003)(92566001)(105586002)(77096002)(93916002)(84676001)(64706001)(36756003)(229853001)(87286001)(87936001)(88136002)(85306004)(85852003)(4396001)(120916001)(104166001)(77156001)(89996001)(80022003)(46102003)(95666004)(76482002)(48376002)(107046002)(50466002)(99396003)(21056001)(50986999)(33646002)(106466001)(2171001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0367A50BB1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD NL needs to delay P0 to P1/P2/P3 request when entering U1/U2/U3.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 3 +++
 drivers/usb/dwc3/core.h          | 2 ++
 drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
 drivers/usb/dwc3/platform_data.h | 1 +
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index ec8b667..a9f1d4c 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -380,6 +380,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	if (dwc->quirks & DWC3_QUIRK_REQP1P2P3)
 		reg |= DWC3_GUSB3PIPECTL_REQP1P2P3;
 
+	if (dwc->quirks & DWC3_QUIRK_DEPP1P2P3)
+		reg |= DWC3_GUSB3PIPECTL_DEP1P2P3(1);
+
 	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
 
 	mdelay(100);
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 8f47ade18..cf70fa6 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -178,6 +178,8 @@
 #define DWC3_GUSB3PIPECTL_PHYSOFTRST	(1 << 31)
 #define DWC3_GUSB3PIPECTL_U2SSINP3OK	(1 << 29)
 #define DWC3_GUSB3PIPECTL_REQP1P2P3	(1 << 24)
+#define DWC3_GUSB3PIPECTL_DEP1P2P3_MASK	DWC3_GUSB3PIPECTL_DEP1P2P3(7)
+#define DWC3_GUSB3PIPECTL_DEP1P2P3(n)	((n) << 19)
 #define DWC3_GUSB3PIPECTL_SUSPHY	(1 << 17)
 
 /* Global TX Fifo Size Register */
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 7154d18..23ae6a7 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -152,7 +152,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 		dwc3_pdata.quirks |= DWC3_QUIRK_AMD_NL
 			| DWC3_QUIRK_U2EXIT_LFPS
 			| DWC3_QUIRK_U2SSINP3OK
-			| DWC3_QUIRK_REQP1P2P3;
+			| DWC3_QUIRK_REQP1P2P3
+			| DWC3_QUIRK_DEPP1P2P3;
 	}
 
 	ret = platform_device_add_resources(dwc3, res, ARRAY_SIZE(res));
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 850883f..e668c1f 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -33,5 +33,6 @@ struct dwc3_platform_data {
 #define DWC3_QUIRK_U2EXIT_LFPS		(1 << 2)
 #define DWC3_QUIRK_U2SSINP3OK		(1 << 3)
 #define DWC3_QUIRK_REQP1P2P3		(1 << 4)
+#define DWC3_QUIRK_DEPP1P2P3		(1 << 5)
 
 };
-- 
1.9.1

