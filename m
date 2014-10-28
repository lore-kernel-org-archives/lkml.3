Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbaJ1L5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:57:15 -0400
Received: from mail-bn1bon0145.outbound.protection.outlook.com ([157.56.111.145]:56672
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755621AbaJ1L5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:57:09 -0400
X-WSS-ID: 0NE5L72-07-BHB-02
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
Subject: [PATCH v3 16/19] usb: dwc3: add disable usb2 suspend phy quirk
Date: Tue, 28 Oct 2014 19:54:37 +0800
Message-ID: <1414497280-3126-17-git-send-email-ray.huang@amd.com>
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

This patch adds disable usb2 suspend phy quirk, and some special platforms
can configure that if it is needed.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 6 ++++++
 drivers/usb/dwc3/core.h          | 2 ++
 drivers/usb/dwc3/platform_data.h | 1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index aec393b..33a8f3c 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -422,6 +422,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	if (dwc->revision > DWC3_REVISION_194A)
 		reg |= DWC3_GUSB2PHYCFG_SUSPHY;
 
+	if (dwc->dis_u2_susphy_quirk)
+		reg &= ~DWC3_GUSB2PHYCFG_SUSPHY;
+
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
 
 	mdelay(100);
@@ -812,6 +815,8 @@ static int dwc3_probe(struct platform_device *pdev)
 				"snps,rx_detect_poll_quirk");
 		dwc->dis_u3_susphy_quirk = of_property_read_bool(node,
 				"snps,dis_u3_susphy_quirk");
+		dwc->dis_u2_susphy_quirk = of_property_read_bool(node,
+				"snps,dis_u2_susphy_quirk");
 
 		dwc->tx_deemph_quirk = of_property_read_bool(node,
 				"snps,tx_deemph_quirk");
@@ -835,6 +840,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->lfps_filter_quirk = pdata->lfps_filter_quirk;
 		dwc->rx_detect_poll_quirk = pdata->rx_detect_poll_quirk;
 		dwc->dis_u3_susphy_quirk = pdata->dis_u3_susphy_quirk;
+		dwc->dis_u2_susphy_quirk = pdata->dis_u2_susphy_quirk;
 
 		dwc->tx_deemph_quirk = pdata->tx_deemph_quirk;
 		if (pdata->tx_deemph)
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 686d3b9..8b94ad5 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -698,6 +698,7 @@ struct dwc3_scratchpad_array {
  * @lfps_filter_quirk: set if we enable LFPS filter quirk
  * @rx_detect_poll_quirk: set if we enable rx_detect to polling lfps quirk
  * @dis_u3_susphy_quirk: set if we disable usb3 suspend phy
+ * @dis_u2_susphy_quirk: set if we disable usb2 suspend phy
  * @tx_deemph_quirk: set if we enable Tx deemphasis quirk
  * @tx_deemph: Tx deemphasis value
  *	0	- -6dB de-emphasis
@@ -820,6 +821,7 @@ struct dwc3 {
 	unsigned		lfps_filter_quirk:1;
 	unsigned		rx_detect_poll_quirk:1;
 	unsigned		dis_u3_susphy_quirk:1;
+	unsigned		dis_u2_susphy_quirk:1;
 
 	unsigned		tx_deemph_quirk:1;
 	unsigned		tx_deemph:2;
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index c8115c7..1cfd384 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -36,6 +36,7 @@ struct dwc3_platform_data {
 	unsigned lfps_filter_quirk:1;
 	unsigned rx_detect_poll_quirk:1;
 	unsigned dis_u3_susphy_quirk:1;
+	unsigned dis_u2_susphy_quirk:1;
 
 	unsigned tx_deemph_quirk:1;
 	unsigned tx_deemph:2;
-- 
1.9.1

