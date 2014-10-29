Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbaJ2OJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:09:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65119 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933855AbaJ2OJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:09:12 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>
Cc: Dinh Nguyen <dinguyen@opensource.altera.com>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, cf@rock-chips.com, lyz@rock-chips.com,
        wulf@rock-chips.com, jwerner@chromium.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 1/2] usb: dwc2: add bus suspend/resume for dwc2
Date: Wed, 29 Oct 2014 22:08:46 +0800
Message-Id: <1414591728-10106-2-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414591728-10106-1-git-send-email-kever.yang@rock-chips.com>
References: <1414591728-10106-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds suspend/resume for dwc2 hcd controller.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

Changes in v2:
- remove the clock from hcd
- adjust the delay time when resume

 drivers/usb/dwc2/hcd.c | 75 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 64 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index fa49c72..76984da 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -1473,6 +1473,30 @@ static void dwc2_port_suspend(struct dwc2_hsotg *hsotg, u16 windex)
 	}
 }
 
+static void dwc2_port_resume(struct dwc2_hsotg *hsotg)
+{
+	u32 hprt0;
+
+	/* After clear the Stop PHY clock bit, we should wait for a moment
+	 * for clock stable, but I still didn't know how long it should take.
+	 * I will update it in next version.
+	 */
+	writel(0, hsotg->regs + PCGCTL);
+	usleep_range(20000, 40000);
+
+	hprt0 = dwc2_read_hprt0(hsotg);
+	hprt0 |= HPRT0_RES;
+	writel(hprt0, hsotg->regs + HPRT0);
+	hprt0 &= ~HPRT0_SUSP;
+	/* according to USB2.0 Spec 7.1.7.7, the host most send the resume
+	 * signal for at least 20ms
+	 */
+	usleep_range(20000, 25000);
+
+	hprt0 &= ~HPRT0_RES;
+	writel(hprt0, hsotg->regs + HPRT0);
+}
+
 /* Handles hub class-specific requests */
 static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
 				u16 wvalue, u16 windex, char *buf, u16 wlength)
@@ -1518,17 +1542,7 @@ static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
 		case USB_PORT_FEAT_SUSPEND:
 			dev_dbg(hsotg->dev,
 				"ClearPortFeature USB_PORT_FEAT_SUSPEND\n");
-			writel(0, hsotg->regs + PCGCTL);
-			usleep_range(20000, 40000);
-
-			hprt0 = dwc2_read_hprt0(hsotg);
-			hprt0 |= HPRT0_RES;
-			writel(hprt0, hsotg->regs + HPRT0);
-			hprt0 &= ~HPRT0_SUSP;
-			usleep_range(100000, 150000);
-
-			hprt0 &= ~HPRT0_RES;
-			writel(hprt0, hsotg->regs + HPRT0);
+			dwc2_port_resume(hsotg);
 			break;
 
 		case USB_PORT_FEAT_POWER:
@@ -2301,6 +2315,42 @@ static void _dwc2_hcd_stop(struct usb_hcd *hcd)
 	usleep_range(1000, 3000);
 }
 
+static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
+{
+	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
+	u32 hprt0;
+
+	if (hsotg->op_state != OTG_STATE_B_HOST)
+		return 0;
+
+	if (hsotg->lx_state != DWC2_L0)
+		return 0;
+
+	hprt0 = dwc2_read_hprt0(hsotg);
+	if (hprt0 & HPRT0_CONNSTS)
+		dwc2_port_suspend(hsotg, 1);
+
+	return 0;
+}
+
+static int _dwc2_hcd_resume(struct usb_hcd *hcd)
+{
+	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
+	u32 hprt0;
+
+	if (hsotg->op_state != OTG_STATE_B_HOST)
+		return 0;
+
+	if (hsotg->lx_state != DWC2_L2)
+		return 0;
+
+	hprt0 = dwc2_read_hprt0(hsotg);
+	if ((hprt0 | HPRT0_CONNSTS) && (hprt0 | HPRT0_SUSP))
+		dwc2_port_resume(hsotg);
+
+	return 0;
+}
+
 /* Returns the current frame number */
 static int _dwc2_hcd_get_frame_number(struct usb_hcd *hcd)
 {
@@ -2671,6 +2721,9 @@ static struct hc_driver dwc2_hc_driver = {
 	.hub_status_data = _dwc2_hcd_hub_status_data,
 	.hub_control = _dwc2_hcd_hub_control,
 	.clear_tt_buffer_complete = _dwc2_hcd_clear_tt_buffer_complete,
+
+	.bus_suspend = _dwc2_hcd_suspend,
+	.bus_resume = _dwc2_hcd_resume,
 };
 
 /*
-- 
1.9.1

