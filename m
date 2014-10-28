Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbaJ1L5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:57:00 -0400
Received: from mail-bl2on0116.outbound.protection.outlook.com ([65.55.169.116]:24113
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755346AbaJ1L44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:56:56 -0400
X-WSS-ID: 0NE5L6O-08-OCP-02
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
Subject: [PATCH v3 14/19] usb: dwc3: set SUSPHY bit for all cores
Date: Tue, 28 Oct 2014 19:54:35 +0800
Message-ID: <1414497280-3126-15-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(89996001)(31966008)(88136002)(64706001)(47776003)(4396001)(85852003)(50226001)(87286001)(33646002)(50986999)(104166001)(86362001)(93916002)(62966002)(77096002)(76482002)(101416001)(85306004)(76176999)(20776003)(92726001)(53416004)(92566001)(80022003)(46102003)(95666004)(21056001)(2171001)(97736003)(102836001)(87936001)(19580405001)(105586002)(107046002)(106466001)(50466002)(19580395003)(84676001)(48376002)(77156001)(120916001)(68736004)(44976005)(36756003)(229853001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is recommended to set USB3 and USB2 SUSPHY bits to '1' after the core
initialization is completed above the dwc3 revision 1.94a.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index e36fcd0..7b5cd76 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -374,6 +374,15 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 
 	reg = dwc3_readl(dwc->regs, DWC3_GUSB3PIPECTL(0));
 
+	/*
+	 * Above 1.94a, it is recommended to set DWC3_GUSB3PIPECTL_SUSPHY
+	 * to '0' during coreConsultant configuration. So default value
+	 * will be '0' when the core is reset. Application needs to set it
+	 * to '1' after the core initialization is completed.
+	 */
+	if (dwc->revision > DWC3_REVISION_194A)
+		reg |= DWC3_GUSB3PIPECTL_SUSPHY;
+
 	if (dwc->u2ss_inp3_quirk)
 		reg |= DWC3_GUSB3PIPECTL_U2SSINP3OK;
 
@@ -398,6 +407,21 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
 	dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), reg);
 
 	mdelay(100);
+
+	reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
+
+	/*
+	 * Above 1.94a, it is recommended to set DWC3_GUSB2PHYCFG_SUSPHY to
+	 * '0' during coreConsultant configuration. So default value will
+	 * be '0' when the core is reset. Application needs to set it to
+	 * '1' after the core initialization is completed.
+	 */
+	if (dwc->revision > DWC3_REVISION_194A)
+		reg |= DWC3_GUSB2PHYCFG_SUSPHY;
+
+	dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
+
+	mdelay(100);
 }
 
 /**
-- 
1.9.1

