Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbaJ1L51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:57:27 -0400
Received: from mail-bl2on0122.outbound.protection.outlook.com ([65.55.169.122]:23744
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754719AbaJ1L5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:57:20 -0400
X-WSS-ID: 0NE5L7A-08-OD7-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, "Vincent Wan" <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH v3 18/19] PCI: Add quirk to prevent AMD NL USB3 DRD to bind with xHCI driver
Date: Tue, 28 Oct 2014 19:54:39 +0800
Message-ID: <1414497280-3126-19-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(19580405001)(19580395003)(50466002)(85852003)(89996001)(84676001)(86362001)(95666004)(229853001)(87286001)(50986999)(92726001)(48376002)(68736004)(88136002)(2171001)(44976005)(87936001)(21056001)(76176999)(50226001)(107046002)(4396001)(46102003)(77096002)(53416004)(93916002)(80022003)(105586002)(97736003)(106466001)(575784001)(33646002)(62966002)(85306004)(104166001)(101416001)(102836001)(120916001)(76482002)(20776003)(36756003)(92566001)(64706001)(77156001)(47776003)(31966008);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD Nolan (NL) SoC contains a DesignWare USB3 Dual-Role Device that can
be operated either as a USB Host or a USB Device.  In the AMD NL platform,
this device ([1022:7912]) has a class code of PCI_CLASS_SERIAL_USB_XHCI
(0x0c0330), which means the xhci driver will claim it.

But the dwc3 driver is a more specific driver for this device, and we'd
prefer to use it instead of xhci.  To prevent xhci from claiming the
device, change the class code to 0x0c03fe, which the PCI r3.0 spec defines
as "USB device (not host controller)".  The dwc3 driver can then claim it
based on its Vendor and Device ID.

Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Chang <jason.chang@amd.com>
Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/pci/quirks.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 90acb32..1152bef 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -379,6 +379,26 @@ static void quirk_ati_exploding_mce(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI,	PCI_DEVICE_ID_ATI_RS100,   quirk_ati_exploding_mce);
 
 /*
+ * In the AMD NL platform, this device ([1022:7912]) has a class code of
+ * PCI_CLASS_SERIAL_USB_XHCI (0x0c0330), which means the xhci driver will
+ * claim it.
+ * But the dwc3 driver is a more specific driver for this device, and we'd
+ * prefer to use it instead of xhci. To prevent xhci from claiming the
+ * device, change the class code to 0x0c03fe, which the PCI r3.0 spec
+ * defines as "USB device (not host controller)". The dwc3 driver can then
+ * claim it based on its Vendor and Device ID.
+ */
+static void quirk_amd_nl_class(struct pci_dev *pdev)
+{
+	/*
+	 * Use 'USB Device' (0x0x03fe) instead of PCI header provided
+	 */
+	pdev->class = 0x0c03fe;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_NL_USB,
+		quirk_amd_nl_class);
+
+/*
  * Let's make the southbridge information explicit instead
  * of having to worry about people probing the ACPI areas,
  * for example.. (Yes, it happens, and if you read the wrong
-- 
1.9.1

