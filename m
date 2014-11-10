Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaKJNKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:10:08 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:41801 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaKJNKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:10:06 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>
Cc: Dinh Nguyen <dinguyen@opensource.altera.com>, romain.perier@gmail.com,
        Heiko Stuebner <heiko@sntech.de>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        lyz@rock-chips.com, wulf@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] usb: dwc2: add bus suspend/resume for dwc2
Date: Mon, 10 Nov 2014 21:09:43 +0800
Message-Id: <1415624983-22413-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hcd controller needs bus_suspend/resume, dwc2 controller make
root hub generate suspend/resume signal with hprt0 register
when work in host mode.
After the root hub enter suspend, we can make controller enter
low power state with PCGCTL register.

We also update the lx_state for hsotg state.

This patch has tested on rk3288 with suspend/resume.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
Acked-by: Paul Zimmerman <paulz@synopsys.com>
---

Changes in v3:
- remove CONFIG_PM macro for bus_suspend/resume
- add PCGCTL operation for no device connect case

Changes in v2:
- update commit message
- make dwc2 suspend/resume sourcecode work

 drivers/usb/dwc2/hcd.c | 88 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 77 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 0a0e6f0..7480078 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -1471,6 +1471,30 @@ static void dwc2_port_suspend(struct dwc2_hsotg *hsotg, u16 windex)
 	}
 }
 
+static void dwc2_port_resume(struct dwc2_hsotg *hsotg)
+{
+	u32 hprt0;
+
+	/* After clear the Stop PHY clock bit, we should wait for a moment
+	 * for PLL work stable with clock output.
+	 */
+	writel(0, hsotg->regs + PCGCTL);
+	usleep_range(2000, 4000);
+
+	hprt0 = dwc2_read_hprt0(hsotg);
+	hprt0 |= HPRT0_RES;
+	writel(hprt0, hsotg->regs + HPRT0);
+	hprt0 &= ~HPRT0_SUSP;
+	/* according to USB2.0 Spec 7.1.7.7, the host must send the resume
+	 * signal for at least 20ms
+	 */
+	usleep_range(20000, 25000);
+
+	hprt0 &= ~HPRT0_RES;
+	writel(hprt0, hsotg->regs + HPRT0);
+	hsotg->lx_state = DWC2_L0;
+}
+
 /* Handles hub class-specific requests */
 static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
 				u16 wvalue, u16 windex, char *buf, u16 wlength)
@@ -1516,17 +1540,7 @@ static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
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
@@ -2299,6 +2313,55 @@ static void _dwc2_hcd_stop(struct usb_hcd *hcd)
 	usleep_range(1000, 3000);
 }
 
+static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
+{
+	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
+	u32 hprt0;
+
+	if (!((hsotg->op_state == OTG_STATE_B_HOST) ||
+		(hsotg->op_state == OTG_STATE_A_HOST)))
+		return 0;
+
+	/* TODO: We get into suspend from 'on' state, maybe we need to do
+	 * something if we get here from DWC2_L1(LPM sleep) state one day.
+	 */
+	if (hsotg->lx_state != DWC2_L0)
+		return 0;
+
+	hprt0 = dwc2_read_hprt0(hsotg);
+	if (hprt0 & HPRT0_CONNSTS) {
+		dwc2_port_suspend(hsotg, 1);
+	} else {
+		u32 pcgctl = readl(hsotg->regs + PCGCTL);
+
+		pcgctl |= PCGCTL_STOPPCLK;
+		writel(pcgctl, hsotg->regs + PCGCTL);
+	}
+
+	return 0;
+}
+
+static int _dwc2_hcd_resume(struct usb_hcd *hcd)
+{
+	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
+	u32 hprt0;
+
+	if (!((hsotg->op_state == OTG_STATE_B_HOST) ||
+		(hsotg->op_state == OTG_STATE_A_HOST)))
+		return 0;
+
+	if (hsotg->lx_state != DWC2_L2)
+		return 0;
+
+	hprt0 = dwc2_read_hprt0(hsotg);
+	if ((hprt0 & HPRT0_CONNSTS) && (hprt0 & HPRT0_SUSP))
+		dwc2_port_resume(hsotg);
+	else
+		writel(0, hsotg->regs + PCGCTL);
+
+	return 0;
+}
+
 /* Returns the current frame number */
 static int _dwc2_hcd_get_frame_number(struct usb_hcd *hcd)
 {
@@ -2669,6 +2732,9 @@ static struct hc_driver dwc2_hc_driver = {
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

