Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbaJ1L6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:58:05 -0400
Received: from mail-bl2on0136.outbound.protection.outlook.com ([65.55.169.136]:54272
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755693AbaJ1L5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:57:23 -0400
X-WSS-ID: 0NE5L7H-07-BHS-02
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
Subject: [PATCH v3 19/19] usb: dwc3: add support for AMD NL platform
Date: Tue, 28 Oct 2014 19:54:40 +0800
Message-ID: <1414497280-3126-20-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(92726001)(93916002)(76482002)(86362001)(101416001)(33646002)(68736004)(87286001)(88136002)(104166001)(102836001)(62966002)(19580405001)(2171001)(89996001)(87936001)(21056001)(20776003)(50986999)(47776003)(64706001)(76176999)(85852003)(84676001)(19580395003)(77096002)(48376002)(53416004)(105586002)(106466001)(95666004)(4396001)(229853001)(107046002)(85306004)(31966008)(120916001)(44976005)(92566001)(50466002)(50226001)(77156001)(97736003)(36756003)(46102003)(80022003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0378F1E47A
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
 drivers/usb/dwc3/core.c          |  9 +++++++++
 drivers/usb/dwc3/core.h          |  2 ++
 drivers/usb/dwc3/dwc3-pci.c      | 19 +++++++++++++++++++
 drivers/usb/dwc3/platform_data.h |  1 +
 4 files changed, 31 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 33a8f3c..7ab867b 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -526,6 +526,12 @@ static int dwc3_core_init(struct dwc3 *dwc)
 		dwc->is_fpga = true;
 	}
 
+	if (dwc->amd_nl_plat && dwc->is_fpga) {
+		dwc->disable_scramble_quirk = true;
+		dwc->dis_u3_susphy_quirk = true;
+		dwc->dis_u2_susphy_quirk = true;
+	}
+
 	WARN_ONCE(dwc->disable_scramble_quirk && !dwc->is_fpga,
 			"disable_scramble cannot be used on non-FPGA builds\n");
 
@@ -817,6 +823,8 @@ static int dwc3_probe(struct platform_device *pdev)
 				"snps,dis_u3_susphy_quirk");
 		dwc->dis_u2_susphy_quirk = of_property_read_bool(node,
 				"snps,dis_u2_susphy_quirk");
+		dwc->amd_nl_plat = of_property_read_bool(node,
+				"snps,amd_nl_plat");
 
 		dwc->tx_deemph_quirk = of_property_read_bool(node,
 				"snps,tx_deemph_quirk");
@@ -841,6 +849,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->rx_detect_poll_quirk = pdata->rx_detect_poll_quirk;
 		dwc->dis_u3_susphy_quirk = pdata->dis_u3_susphy_quirk;
 		dwc->dis_u2_susphy_quirk = pdata->dis_u2_susphy_quirk;
+		dwc->amd_nl_plat = pdata->amd_nl_plat;
 
 		dwc->tx_deemph_quirk = pdata->tx_deemph_quirk;
 		if (pdata->tx_deemph)
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 8b94ad5..b08a2f9 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -699,6 +699,7 @@ struct dwc3_scratchpad_array {
  * @rx_detect_poll_quirk: set if we enable rx_detect to polling lfps quirk
  * @dis_u3_susphy_quirk: set if we disable usb3 suspend phy
  * @dis_u2_susphy_quirk: set if we disable usb2 suspend phy
+ * @amd_nl_plat: set if we use AMD NL platform
  * @tx_deemph_quirk: set if we enable Tx deemphasis quirk
  * @tx_deemph: Tx deemphasis value
  *	0	- -6dB de-emphasis
@@ -822,6 +823,7 @@ struct dwc3 {
 	unsigned		rx_detect_poll_quirk:1;
 	unsigned		dis_u3_susphy_quirk:1;
 	unsigned		dis_u2_susphy_quirk:1;
+	unsigned		amd_nl_plat:1;
 
 	unsigned		tx_deemph_quirk:1;
 	unsigned		tx_deemph:2;
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index ada975f..3af9b47 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -145,6 +145,24 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 	res[1].name	= "dwc_usb3";
 	res[1].flags	= IORESOURCE_IRQ;
 
+	if (pci->vendor == PCI_VENDOR_ID_AMD &&
+			pci->device == PCI_DEVICE_ID_AMD_NL_USB) {
+		dwc3_pdata.has_lpm_erratum = true;
+		dwc3_pdata.lpm_nyet_thres = 0xf;
+
+		dwc3_pdata.u2exit_lfps_quirk = true;
+		dwc3_pdata.u2ss_inp3_quirk = true;
+		dwc3_pdata.req_p1p2p3_quirk = true;
+		dwc3_pdata.del_p1p2p3_quirk = true;
+		dwc3_pdata.del_phy_power_chg_quirk = true;
+		dwc3_pdata.lfps_filter_quirk = true;
+		dwc3_pdata.rx_detect_poll_quirk = true;
+		dwc3_pdata.amd_nl_plat = true;
+
+		dwc3_pdata.tx_deemph_quirk = true;
+		dwc3_pdata.tx_deemph = 1;
+	}
+
 	ret = platform_device_add_resources(dwc3, res, ARRAY_SIZE(res));
 	if (ret) {
 		dev_err(dev, "couldn't add resources to dwc3 device\n");
@@ -194,6 +212,7 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BSW), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BYT), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRFLD), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_NL_USB), },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, dwc3_pci_id_table);
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 1cfd384..c2c3511 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -37,6 +37,7 @@ struct dwc3_platform_data {
 	unsigned rx_detect_poll_quirk:1;
 	unsigned dis_u3_susphy_quirk:1;
 	unsigned dis_u2_susphy_quirk:1;
+	unsigned amd_nl_plat:1;
 
 	unsigned tx_deemph_quirk:1;
 	unsigned tx_deemph:2;
-- 
1.9.1

