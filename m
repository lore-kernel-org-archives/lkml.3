Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaJQJOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:14:36 -0400
Received: from mail-bl2on0124.outbound.protection.outlook.com ([65.55.169.124]:42144
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752279AbaJQJOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:14:33 -0400
X-WSS-ID: 0NDKZOF-08-TNW-02
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
Subject: [PATCH v2 13/16] usb: dwc3: add lfps filter quirk
Date: Fri, 17 Oct 2014 16:53:38 +0800
Message-ID: <1413536021-4886-14-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(31966008)(89996001)(97736003)(50986999)(99396003)(80022003)(21056001)(20776003)(47776003)(64706001)(53416004)(88136002)(102836001)(68736004)(87286001)(84676001)(46102003)(87936001)(50466002)(44976005)(85306004)(19580395003)(19580405001)(85852003)(93916002)(86362001)(229853001)(77156001)(106466001)(92566001)(36756003)(120916001)(76482002)(95666004)(2171001)(33646002)(62966002)(101416001)(50226001)(4396001)(92726001)(76176999)(104166001)(77096002)(48376002)(105586002)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0367A50BB1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD NL needs to enable lfps filter quirk.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 3 +++
 drivers/usb/dwc3/core.h          | 1 +
 drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
 drivers/usb/dwc3/platform_data.h | 1 +
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 920a8ab..a1ee586 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -386,6 +386,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	if (dwc->quirks & DWC3_QUIRK_DEPOCHANGE)
 		reg |= DWC3_GUSB3PIPECTL_DEPOCHANGE;
 
+	if (dwc->quirks & DWC3_QUIRK_LFPSFILT)
+		reg |= DWC3_GUSB3PIPECTL_LFPSFILT;
+
 	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
 
 	mdelay(100);
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 4c0200f..5bdd5f5 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -182,6 +182,7 @@
 #define DWC3_GUSB3PIPECTL_DEP1P2P3(n)	((n) << 19)
 #define DWC3_GUSB3PIPECTL_DEPOCHANGE	(1 << 18)
 #define DWC3_GUSB3PIPECTL_SUSPHY	(1 << 17)
+#define DWC3_GUSB3PIPECTL_LFPSFILT	(1 << 9)
 
 /* Global TX Fifo Size Register */
 #define DWC3_GTXFIFOSIZ_TXFDEF(n)	((n) & 0xffff)
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 0eb8b2a..d1f0901 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -154,7 +154,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 			| DWC3_QUIRK_U2SSINP3OK
 			| DWC3_QUIRK_REQP1P2P3
 			| DWC3_QUIRK_DEPP1P2P3
-			| DWC3_QUIRK_DEPOCHANGE;
+			| DWC3_QUIRK_DEPOCHANGE
+			| DWC3_QUIRK_LFPSFILT;
 	}
 
 	ret = platform_device_add_resources(dwc3, res, ARRAY_SIZE(res));
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 934c5e1..ac7860ab 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -35,5 +35,6 @@ struct dwc3_platform_data {
 #define DWC3_QUIRK_REQP1P2P3		(1 << 4)
 #define DWC3_QUIRK_DEPP1P2P3		(1 << 5)
 #define DWC3_QUIRK_DEPOCHANGE		(1 << 6)
+#define DWC3_QUIRK_LFPSFILT		(1 << 7)
 
 };
-- 
1.9.1

