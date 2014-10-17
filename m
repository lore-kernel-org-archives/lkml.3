Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaJQJPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:15:06 -0400
Received: from mail-bn1bon0138.outbound.protection.outlook.com ([157.56.111.138]:57888
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751254AbaJQJPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:15:00 -0400
X-Greylist: delayed 915 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2014 05:15:00 EDT
X-WSS-ID: 0NDKZOA-08-TNG-02
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
Subject: [PATCH v2 12/16] usb: dwc3: add delay phy power change quirk
Date: Fri, 17 Oct 2014 16:53:37 +0800
Message-ID: <1413536021-4886-13-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(21056001)(48376002)(44976005)(19580395003)(19580405001)(53416004)(80022003)(50466002)(99396003)(76482002)(120916001)(102836001)(84676001)(31966008)(50986999)(62966002)(64706001)(104166001)(86362001)(93916002)(76176999)(20776003)(89996001)(85852003)(47776003)(2171001)(87936001)(85306004)(101416001)(87286001)(92566001)(77156001)(88136002)(4396001)(50226001)(33646002)(95666004)(92726001)(46102003)(36756003)(68736004)(229853001)(97736003)(77096002)(106466001)(105586002)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB202;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB202;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0367A50BB1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB090;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD NL needs to delay PHY power change from P0 to P1/P2/P3 when link state
changing from U0 to U1/U2/U3 respectively.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 3 +++
 drivers/usb/dwc3/core.h          | 1 +
 drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
 drivers/usb/dwc3/platform_data.h | 1 +
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index a9f1d4c..920a8ab 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -383,6 +383,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	if (dwc->quirks & DWC3_QUIRK_DEPP1P2P3)
 		reg |= DWC3_GUSB3PIPECTL_DEP1P2P3(1);
 
+	if (dwc->quirks & DWC3_QUIRK_DEPOCHANGE)
+		reg |= DWC3_GUSB3PIPECTL_DEPOCHANGE;
+
 	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
 
 	mdelay(100);
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index cf70fa6..4c0200f 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -180,6 +180,7 @@
 #define DWC3_GUSB3PIPECTL_REQP1P2P3	(1 << 24)
 #define DWC3_GUSB3PIPECTL_DEP1P2P3_MASK	DWC3_GUSB3PIPECTL_DEP1P2P3(7)
 #define DWC3_GUSB3PIPECTL_DEP1P2P3(n)	((n) << 19)
+#define DWC3_GUSB3PIPECTL_DEPOCHANGE	(1 << 18)
 #define DWC3_GUSB3PIPECTL_SUSPHY	(1 << 17)
 
 /* Global TX Fifo Size Register */
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 23ae6a7..0eb8b2a 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -153,7 +153,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 			| DWC3_QUIRK_U2EXIT_LFPS
 			| DWC3_QUIRK_U2SSINP3OK
 			| DWC3_QUIRK_REQP1P2P3
-			| DWC3_QUIRK_DEPP1P2P3;
+			| DWC3_QUIRK_DEPP1P2P3
+			| DWC3_QUIRK_DEPOCHANGE;
 	}
 
 	ret = platform_device_add_resources(dwc3, res, ARRAY_SIZE(res));
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index e668c1f..934c5e1 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -34,5 +34,6 @@ struct dwc3_platform_data {
 #define DWC3_QUIRK_U2SSINP3OK		(1 << 3)
 #define DWC3_QUIRK_REQP1P2P3		(1 << 4)
 #define DWC3_QUIRK_DEPP1P2P3		(1 << 5)
+#define DWC3_QUIRK_DEPOCHANGE		(1 << 6)
 
 };
-- 
1.9.1

