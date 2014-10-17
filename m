Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaJQJQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:16:09 -0400
Received: from [65.55.169.122] ([65.55.169.122]:35955 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751293AbaJQJQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:16:04 -0400
X-WSS-ID: 0NDKZNQ-07-HNP-02
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
Subject: [PATCH v2 08/16] usb: dwc3: add u2exit lfps quirk
Date: Fri, 17 Oct 2014 16:53:33 +0800
Message-ID: <1413536021-4886-9-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(44976005)(19580395003)(19580405001)(87286001)(85306004)(120916001)(97736003)(99396003)(50226001)(4396001)(31966008)(46102003)(80022003)(104166001)(92566001)(92726001)(50466002)(20776003)(47776003)(84676001)(64706001)(48376002)(53416004)(76176999)(50986999)(62966002)(2171001)(101416001)(21056001)(88136002)(102836001)(68736004)(87936001)(85852003)(93916002)(86362001)(76482002)(89996001)(77096002)(33646002)(105586002)(229853001)(107046002)(77156001)(106466001)(36756003)(95666004);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0367A50BB1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD NL needs to enable u2exit lfps quirk.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 4 ++++
 drivers/usb/dwc3/core.h          | 1 +
 drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
 drivers/usb/dwc3/platform_data.h | 1 +
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 25db533..7322d85 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -467,6 +467,10 @@ static int dwc3_core_init(struct dwc3 *dwc)
 		reg |= DWC3_GCTL_DISSCRAMBLE;
 	else
 		reg &= ~DWC3_GCTL_DISSCRAMBLE;
+
+	if (dwc->quirks & DWC3_QUIRK_U2EXIT_LFPS)
+		reg |= DWC3_GCTL_U2EXIT_LFPS;
+
 	/*
 	 * WORKAROUND: DWC3 revisions <1.90a have a bug
 	 * where the device can fail to connect at SuperSpeed
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index d58479e..3d27f10 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -166,6 +166,7 @@
 #define DWC3_GCTL_SCALEDOWN(n)		((n) << 4)
 #define DWC3_GCTL_SCALEDOWN_MASK	DWC3_GCTL_SCALEDOWN(3)
 #define DWC3_GCTL_DISSCRAMBLE		(1 << 3)
+#define DWC3_GCTL_U2EXIT_LFPS		(1 << 2)
 #define DWC3_GCTL_GBLHIBERNATIONEN	(1 << 1)
 #define DWC3_GCTL_DSBLCLKGTNG		(1 << 0)
 
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index bbe946c..cdb9b04 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -149,7 +149,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 	if (pci->vendor == PCI_VENDOR_ID_AMD && pci->device ==
 			PCI_DEVICE_ID_AMD_NL) {
 		dwc3_pdata.has_lpm_erratum = true;
-		dwc3_pdata.quirks |= DWC3_QUIRK_AMD_NL;
+		dwc3_pdata.quirks |= DWC3_QUIRK_AMD_NL
+			| DWC3_QUIRK_U2EXIT_LFPS;
 	}
 
 	ret = platform_device_add_resources(dwc3, res, ARRAY_SIZE(res));
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 098ab04..a6463c0 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -30,5 +30,6 @@ struct dwc3_platform_data {
 
 #define DWC3_QUIRK_AMD_NL		(1 << 0)
 #define DWC3_QUIRK_DISSCRAMBLE		(1 << 1)
+#define DWC3_QUIRK_U2EXIT_LFPS		(1 << 2)
 
 };
-- 
1.9.1

