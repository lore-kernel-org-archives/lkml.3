Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934836AbaJaDNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 23:13:44 -0400
Received: from mail-bn1on0143.outbound.protection.outlook.com ([157.56.110.143]:13568
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934093AbaJaDNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 23:13:18 -0400
X-WSS-ID: 0NEAGY1-07-7XT-02
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
Subject: [PATCH v5 8/8] usb: dwc3: point host-mode hibernation enablement not device-mode
Date: Fri, 31 Oct 2014 11:11:19 +0800
Message-ID: <1414725079-11490-9-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414725079-11490-1-git-send-email-ray.huang@amd.com>
References: <1414725079-11490-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(77156001)(101416001)(97736003)(107046002)(31966008)(229853001)(50226001)(36756003)(15975445006)(76176999)(105586002)(106466001)(102836001)(68736004)(95666004)(15395725005)(120916001)(85306004)(4396001)(33646002)(104166001)(99396003)(87286001)(47776003)(20776003)(46102003)(80022003)(86362001)(85852003)(50466002)(19580405001)(15202345003)(19580395003)(76482002)(92566001)(92726001)(48376002)(44976005)(62966002)(21056001)(77096002)(88136002)(50986999)(53416004)(93916002)(64706001)(87936001)(84676001)(89996001)(2171001)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Forefront-PRVS: 03818C953D
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the discussion of below thread, current enablement works for
host-mode, device-mode hibernation is not implemented yet.

http://marc.info/?l=linux-usb&m=141452396814414&w=2

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c   | 7 ++++++-
 drivers/usb/dwc3/gadget.c | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 8753792..a785fdd 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -512,8 +512,13 @@ static int dwc3_core_init(struct dwc3 *dwc)
 			reg &= ~DWC3_GCTL_DSBLCLKGTNG;
 		break;
 	case DWC3_GHWPARAMS1_EN_PWROPT_HIB:
-		/* enable hibernation here */
 		dwc->nr_scratch = DWC3_GHWPARAMS4_HIBER_SCRATCHBUFS(hwparams4);
+		/*
+		 * Enable hibernation here.
+		 *
+		 * Enabling this bit so that host-mode hibernation will
+		 * work, device-mode hibernation is not implemented yet.
+		 */
 		reg |= DWC3_GCTL_GBLHIBERNATIONEN;
 		break;
 	default:
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 01e22d7..398c12f 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2300,7 +2300,7 @@ static void dwc3_gadget_conndone_interrupt(struct dwc3 *dwc)
 		/*
 		 * When dwc3 revisions >= 2.40a, LPM Erratum is enabled and
 		 * DCFG.LPMCap is set, core responses with an ACK and the
-		 * BESL value in the LPM token is less than or equal to lPM
+		 * BESL value in the LPM token is less than or equal to LPM
 		 * NYET threshold.
 		 */
 		WARN_ONCE(dwc->revision < DWC3_REVISION_240A
-- 
1.9.1

