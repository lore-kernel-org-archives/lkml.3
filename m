Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422847AbaJaDNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 23:13:13 -0400
Received: from mail-bn1bon0133.outbound.protection.outlook.com ([157.56.111.133]:64608
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933681AbaJaDNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 23:13:08 -0400
X-WSS-ID: 0NEAGXO-08-GMT-02
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
Subject: [PATCH v5 6/8] usb: dwc3: add support for AMD Nolan platform
Date: Fri, 31 Oct 2014 11:11:17 +0800
Message-ID: <1414725079-11490-7-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414725079-11490-1-git-send-email-ray.huang@amd.com>
References: <1414725079-11490-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(97736003)(68736004)(107046002)(77096002)(85306004)(95666004)(76176999)(53416004)(104166001)(77156001)(106466001)(20776003)(62966002)(47776003)(50466002)(48376002)(21056001)(33646002)(105586002)(64706001)(36756003)(19580395003)(19580405001)(229853001)(44976005)(89996001)(50226001)(4396001)(120916001)(87286001)(85852003)(86362001)(93916002)(92566001)(88136002)(80022003)(101416001)(31966008)(50986999)(46102003)(84676001)(76482002)(102836001)(2171001)(99396003)(92726001)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB198;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-Forefront-PRVS: 03818C953D
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for AMD Nolan (NL) FPGA and SoC platform.

Cc: Jason Chang <jason.chang@amd.com>
Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/dwc3-pci.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index ada975f..7c4faf7 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -145,6 +145,31 @@ static int dwc3_pci_probe(struct pci_dev *pci,
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
+		/*
+		 * FIXME these quirks should be removed when AMD NL
+		 * taps out
+		 */
+		dwc3_pdata.disable_scramble_quirk = true;
+		dwc3_pdata.dis_u3_susphy_quirk = true;
+		dwc3_pdata.dis_u2_susphy_quirk = true;
+	}
+
 	ret = platform_device_add_resources(dwc3, res, ARRAY_SIZE(res));
 	if (ret) {
 		dev_err(dev, "couldn't add resources to dwc3 device\n");
@@ -194,6 +219,7 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BSW), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BYT), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRFLD), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_NL_USB), },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, dwc3_pci_id_table);
-- 
1.9.1

