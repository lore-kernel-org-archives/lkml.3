Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaJQJPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:15:08 -0400
Received: from mail-by2on0104.outbound.protection.outlook.com ([207.46.100.104]:38197
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752550AbaJQJPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:15:00 -0400
X-WSS-ID: 0NDKZMY-07-HMT-02
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
Subject: [PATCH v2 02/16] pci: quirks: add quirk to avoid AMD NL to bind with xhci
Date: Fri, 17 Oct 2014 16:53:27 +0800
Message-ID: <1413536021-4886-3-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(68736004)(105586002)(575784001)(93916002)(229853001)(106466001)(36756003)(4396001)(77096002)(50226001)(87286001)(84676001)(89996001)(87936001)(95666004)(107046002)(102836001)(19580405001)(77156001)(92726001)(64706001)(88136002)(76482002)(2171001)(31966008)(85852003)(20776003)(47776003)(53416004)(15395725005)(15202345003)(19580395003)(104166001)(15975445006)(33646002)(48376002)(50466002)(46102003)(80022003)(120916001)(76176999)(50986999)(99396003)(44976005)(92566001)(62966002)(21056001)(97736003)(85306004)(86362001)(101416001)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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

The dwc3 controller is the PCI-E device in AMD NL platform, but the class code
of PCI header is 0x0c0330, the same with xHC. That's because it needs to meet
the windows enviroment. The dwc3 controller acted as only host mode to bind with
windows xhci driver.
But on linux, sometimes, it would auto-bind with xhci driver as well (class code
0x0c0330) despite it uses Pid/Vid on dwc3 driver.

Heikki suggested to use the quirk to fix this issue, and the detailed discussion
is at below thread:
http://marc.info/?l=linux-usb&m=141197934712824&w=2

Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/pci/quirks.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 90acb32..3c911b7 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -378,6 +378,26 @@ static void quirk_ati_exploding_mce(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI,	PCI_DEVICE_ID_ATI_RS100,   quirk_ati_exploding_mce);
 
+/* FIXME should define in <linux/pci_ids.h> */
+#define PCI_DEVICE_ID_AMD_NL	0x7912
+
+/*
+ * AMD NL SoC 7912 PCI device is dwc3 controller, but the class code of PCI
+ * header is 0x0c0330, the same with xHC. That's because it need to meet the
+ * windows enviroment. The dwc3 controller acted as only host mode to bind with
+ * windows xhci driver. But on linux, sometimes, we auto-bind with xhci driver
+ * as well (class code 0x0c0330) despite we use Pid/Vid on dwc3 driver. So this
+ * quirk used a dummy class code to avoid to bind with xhci driver at booting
+ * phase.
+ */
+static void quirk_amd_nl_class(struct pci_dev *pdev)
+{
+	/* Use a dummy class value instead of PCI header provided */
+	pdev->class = 0x0c03fe;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_NL,
+		quirk_amd_nl_class);
+
 /*
  * Let's make the southbridge information explicit instead
  * of having to worry about people probing the ACPI areas,
-- 
1.9.1

