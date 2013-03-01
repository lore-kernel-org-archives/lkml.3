Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3CAUYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:24:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3CATpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Zimmerman <paulz@synopsys.com>,
        Pratyush Anand <pratyush.anand@st.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 11/77] usb: dwc3: Enable usb2 LPM only when connected as usb2.0
Date: Fri,  1 Mar 2013 11:43:56 -0800
Message-Id: <20130301194353.196158672@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Anand <pratyush.anand@st.com>

commit 2b758350af19db9a5c98241cf222c2e211d7a912 upstream.

Synopsys says:
The HIRD Threshold field must be set to ‘0’ when the device core is
operating in super speed mode.

This patch implements above statement.

Acked-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2157,6 +2157,23 @@ static void dwc3_gadget_conndone_interru
 		break;
 	}
 
+	/* Enable USB2 LPM Capability */
+
+	if ((dwc->revision > DWC3_REVISION_194A)
+			&& (speed != DWC3_DCFG_SUPERSPEED)) {
+		reg = dwc3_readl(dwc->regs, DWC3_DCFG);
+		reg |= DWC3_DCFG_LPM_CAP;
+		dwc3_writel(dwc->regs, DWC3_DCFG, reg);
+
+		reg = dwc3_readl(dwc->regs, DWC3_DCTL);
+		reg &= ~(DWC3_DCTL_HIRD_THRES_MASK | DWC3_DCTL_L1_HIBER_EN);
+
+		/* TODO: This should be configurable */
+		reg |= DWC3_DCTL_HIRD_THRES(28);
+
+		dwc3_writel(dwc->regs, DWC3_DCTL, reg);
+	}
+
 	/* Recent versions support automatic phy suspend and don't need this */
 	if (dwc->revision < DWC3_REVISION_194A) {
 		/* Suspend unneeded PHY */
@@ -2463,20 +2480,8 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 			DWC3_DEVTEN_DISCONNEVTEN);
 	dwc3_writel(dwc->regs, DWC3_DEVTEN, reg);
 
-	/* Enable USB2 LPM and automatic phy suspend only on recent versions */
+	/* automatic phy suspend only on recent versions */
 	if (dwc->revision >= DWC3_REVISION_194A) {
-		reg = dwc3_readl(dwc->regs, DWC3_DCFG);
-		reg |= DWC3_DCFG_LPM_CAP;
-		dwc3_writel(dwc->regs, DWC3_DCFG, reg);
-
-		reg = dwc3_readl(dwc->regs, DWC3_DCTL);
-		reg &= ~(DWC3_DCTL_HIRD_THRES_MASK | DWC3_DCTL_L1_HIBER_EN);
-
-		/* TODO: This should be configurable */
-		reg |= DWC3_DCTL_HIRD_THRES(28);
-
-		dwc3_writel(dwc->regs, DWC3_DCTL, reg);
-
 		dwc3_gadget_usb2_phy_suspend(dwc, false);
 		dwc3_gadget_usb3_phy_suspend(dwc, false);
 	}


