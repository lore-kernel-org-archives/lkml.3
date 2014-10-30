Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080AbaJ3KLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:11:46 -0400
Received: from mail-by2on0136.outbound.protection.outlook.com ([207.46.100.136]:41103
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934002AbaJ3KLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:11:43 -0400
X-WSS-ID: 0NE95NE-07-XVM-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH v4 19/20] usb: dwc3: add support for AMD Nolan platform
Date: Thu, 30 Oct 2014 18:08:44 +0800
Message-ID: <1414663725-2195-20-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(104166001)(62966002)(87936001)(50466002)(19580405001)(88136002)(44976005)(92566001)(84676001)(53416004)(92726001)(48376002)(68736004)(105586002)(77096002)(2171001)(89996001)(87286001)(101416001)(99396003)(106466001)(85852003)(19580395003)(107046002)(31966008)(95666004)(76482002)(120916001)(102836001)(97736003)(50986999)(33646002)(4396001)(50226001)(20776003)(76176999)(47776003)(64706001)(21056001)(229853001)(85306004)(36756003)(93916002)(86362001)(46102003)(80022003)(77156001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for AMD Nolan (NL) FPGA and SoC platform.

Cc: Jason Chang <jason.chang@amd.com>
Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/dwc3-pci.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index ada975f..257fb3f9e 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -145,6 +145,28 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 	res[1].name	= "dwc_usb3";
 	res[1].flags	= IORESOURCE_IRQ;
 
+	if (pci->vendor == PCI_VENDOR_ID_AMD &&
+			pci->device == PCI_DEVICE_ID_AMD_NL_USB) {
+		dwc3_pdata.has_lpm_erratum = true;
+		dwc3_pdata.lpm_nyet_threshold = 0xf;
+
+		dwc3_pdata.u2exit_lfps_quirk = true;
+		dwc3_pdata.u2ss_inp3_quirk = true;
+		dwc3_pdata.req_p1p2p3_quirk = true;
+		dwc3_pdata.del_p1p2p3_quirk = true;
+		dwc3_pdata.del_phy_power_chg_quirk = true;
+		dwc3_pdata.lfps_filter_quirk = true;
+		dwc3_pdata.rx_detect_poll_quirk = true;
+
+		dwc3_pdata.tx_de_emphasis_quirk = true;
+		dwc3_pdata.tx_de_emphasis = 1;
+
+		/* FIXME these quirks should move when AMD NL taps out */
+		dwc3_pdata.disable_scramble_quirk = true;
+		dwc3_pdata.dis_u3_susphy_quirk = true;
+		dwc3_pdata.dis_u2_susphy_quirk = true;
+	}
+
 	ret = platform_device_add_resources(dwc3, res, ARRAY_SIZE(res));
 	if (ret) {
 		dev_err(dev, "couldn't add resources to dwc3 device\n");
@@ -194,6 +216,7 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BSW), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BYT), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRFLD), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_NL_USB), },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, dwc3_pci_id_table);
-- 
1.9.1

